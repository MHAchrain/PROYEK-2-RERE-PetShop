<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GeminiController extends Controller
{
    /**
     * Chat menggunakan Google Gemini API via Backend Laravel
     * Dibatasi kuota harian per user (misal 10 chat / hari).
     */
    public function chatGemini(Request $request)
    {
        $request->validate([
            'message' => 'nullable|string',
            'image' => 'nullable|image|max:10240',
        ]);

        $user = $request->user();
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Silakan login terlebih dahulu untuk menggunakan Arpet Gemini.',
            ], 401);
        }

        $userId = $user->id;
        $today = now()->toDateString();
        $cacheKey = "gemini_daily_usage:{$userId}:{$today}";
        $maxDailyQuota = 15;

        $currentUsage = (int) Cache::get($cacheKey, 0);

        if ($currentUsage >= $maxDailyQuota) {
            return response()->json([
                'success' => false,
                'message' => "Kuota harian Arpet Gemini Anda telah habis ({$maxDailyQuota}/{$maxDailyQuota} hari ini). Anda dapat menggunakan mode 'Arpet Local' tanpa batas!",
                'usage' => [
                    'used' => $currentUsage,
                    'limit' => $maxDailyQuota,
                    'remaining' => 0,
                ],
            ], 429);
        }

        $message = trim((string) $request->input('message', ''));
        $hasImage = $request->hasFile('image');

        if ($message === '' && !$hasImage) {
            return response()->json([
                'success' => false,
                'message' => 'Silakan masukkan pesan teks atau unggah foto anabul Anda.',
            ], 422);
        }

        $apiKey = config('services.gemini.api_key');
        if (empty($apiKey)) {
            Log::error('GEMINI_API_KEY belum diisi di file .env');
            return response()->json([
                'success' => false,
                'message' => 'Layanan Gemini belum dikonfigurasi oleh administrator (API Key missing).',
            ], 500);
        }

        // Ambil produk yang relevan dengan pertanyaan user terlebih dahulu, lalu lengkapi dengan produk lain
        $keywords = collect(preg_split('/\s+/', strtolower($message)))
            ->map(fn ($w) => trim($w, ".,?!\"'()"))
            ->filter(fn ($w) => strlen($w) >= 3)
            ->values();

        $matchedProducts = collect();
        if ($keywords->isNotEmpty()) {
            $matchedProducts = Produk::with('kategori')
                ->where('stok', '>', 0)
                ->where(function ($q) use ($keywords) {
                    foreach ($keywords as $word) {
                        $q->orWhere('nama_produk', 'like', "%{$word}%")
                          ->orWhere('deskripsi', 'like', "%{$word}%")
                          ->orWhereHas('kategori', function ($kq) use ($word) {
                              $kq->where('nama_kategori', 'like', "%{$word}%");
                          });
                    }
                })
                ->limit(25)
                ->get(['id_produk', 'nama_produk', 'harga', 'stok', 'id_kategori']);
        }

        $otherProducts = Produk::with('kategori')
            ->where('stok', '>', 0)
            ->when($matchedProducts->isNotEmpty(), function ($q) use ($matchedProducts) {
                $q->whereNotIn('id_produk', $matchedProducts->pluck('id_produk'));
            })
            ->limit(25)
            ->get(['id_produk', 'nama_produk', 'harga', 'stok', 'id_kategori']);

        $katalogProduk = $matchedProducts->concat($otherProducts)
            ->map(function ($item) {
                return "- [ID: {$item->id_produk}] {$item->nama_produk} (Rp " . number_format($item->harga, 0, ',', '.') . ") Kategori: " . ($item->kategori->nama_kategori ?? 'Umum');
            })
            ->implode("\n");

        $systemPrompt = "Kamu adalah ARPET (Asisten RERe Petshop), asisten virtual ramah, praktis, dan cerdas di toko hewan RERe Petshop Tangerang.
Tugasmu adalah memberikan konsultasi perawatan anabul dan rekomendasi produk terbaik.
Info Layanan Toko: RERe Petshop MENYEDIAKAN jasa Grooming anabul (bisa langsung booking lewat menu Grooming di website).

Berikut sebagian katalog produk tersedia di RERe Petshop:
{$katalogProduk}

PANDUAN FORMAT JAWABAN:
1. Ringkas & Rapih (Format List): Jawab singkat dan rapih menggunakan 2-3 poin list dengan tanda • (jangan paragraf panjang).
2. Akurat & Pintar Melipir: Jawab sesuai kebutuhan user. Jika produk persis yang dicari (misal vitamin bulu) tidak ada di katalog, rekomendasikan alternatif terdekat yang masih satu tujuan/kategori (misal Shampoo Conditioner, obat bulu, atau suplemen lain yang ada di katalog) dan jelaskan singkat kegunaannya. JANGAN rekomendasikan barang yang melenceng jauh (misal ditanya vitamin jangan beri kandang).
3. Tanpa Tanda Bintang Markdown: JANGAN gunakan tanda ** atau * untuk menebalkan teks. Tulis teks polos yang rapi.
4. Sapaan Singkat: Awali dengan 'Halo Cat Lovers! 🐾'.
5. Produk Wajib Relevan: Wajib pilih 1-3 produk dari katalog di atas (atau alternatif terdekatnya yang masih relevan) dan sertakan ID-nya di tag rekomendasi. JANGAN pernah menulis kode ID seperti (ID: 2) di teks jawaban.
6. Baris Terakhir: Wajib akhiri teks dengan tag rekomendasi format:
[RECOMMENDED_IDS: 1, 2] (isi dengan ID produk/alternatif yang kamu sebutkan; kosongkan [RECOMMENDED_IDS:] hanya jika pertanyaan murni konsultasi tanpa produk).";

        try {
            $contents = [];
            $parts = [];

            if ($hasImage) {
                $imageFile = $request->file('image');
                $mimeType = $imageFile->getMimeType();
                $base64Data = base64_encode(file_get_contents($imageFile->getRealPath()));

                $parts[] = [
                    'inline_data' => [
                        'mime_type' => $mimeType,
                        'data' => $base64Data,
                    ],
                ];
            }

            $userQuery = $hasImage
                ? ($message
                    ? "ANALISIS FOTO INI: {$message}. Jelaskan singkat kondisi yang terlihat di foto dan rekomendasikan 1-3 produk paling sesuai dari katalog beserta [RECOMMENDED_IDS: ...]."
                    : "ANALISIS FOTO INI: Jelaskan singkat kondisi anabul atau produk yang terlihat di foto, lalu rekomendasikan 1-3 produk paling sesuai dari katalog beserta [RECOMMENDED_IDS: ...].")
                : $message;
            $parts[] = ['text' => $userQuery];
            $contents[] = ['role' => 'user', 'parts' => $parts];

            $modelName = config('services.gemini.model', 'gemini-3.1-flash-lite');
            $payload = [
                'systemInstruction' => [
                    'parts' => [
                        ['text' => $systemPrompt]
                    ]
                ],
                'contents' => $contents,
                'generationConfig' => [
                    'temperature' => 0.2,
                    'maxOutputTokens' => 600,
                ]
            ];

            $candidateModels = array_values(array_unique([
                'gemini-3.1-flash-lite',
                'gemini-3.6-flash',
                $modelName,
                'gemini-3.8-flash',
            ]));

            $response = null;
            foreach ($candidateModels as $candidate) {
                $modelName = $candidate;
                $endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{$modelName}:generateContent?key={$apiKey}";
                try {
                    $response = Http::timeout(20)->post($endpoint, $payload);
                    if ($response->successful()) {
                        break;
                    }
                    if (!in_array($response->status(), [400, 404, 429, 503], true)) {
                        break;
                    }
                } catch (\Throwable $timeoutEx) {
                    Log::warning("Gemini timeout on {$modelName}: " . $timeoutEx->getMessage());
                    $response = null;
                }
            }

            if (!$response || !$response->successful()) {
                Log::error('Gemini API Error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                    'model_used' => $modelName,
                    'endpoint' => $endpoint,
                ]);
                return response()->json([
                    'success' => false,
                    'message' => '🐾 Maaf, Google Gemini API sedang sibuk atau mengalami kendala. Silakan coba sesaat lagi.',
                ], 502);
            }

            $geminiData = $response->json();
            $partsResp = $geminiData['candidates'][0]['content']['parts'] ?? [];
            $rawText = '';
            foreach ($partsResp as $p) {
                if (empty($p['thought']) && !empty($p['text'])) {
                    $rawText .= $p['text'];
                }
            }
            if (trim($rawText) === '') {
                $rawText = 'Maaf, ARPET tidak dapat memproses jawaban saat ini.';
            }

            // Parse RECOMMENDED_IDS jika ada
            $recommendedIds = [];
            if (preg_match('/\[RECOMMENDED_IDS:\s*([0-9,\s]*)\]/i', $rawText, $matches)) {
                $ids = array_filter(array_map('trim', explode(',', $matches[1])), fn($v) => $v !== '');
                $recommendedIds = array_map('intval', $ids);
                // Bersihkan tag dari teks yang ditampilkan ke user
                $rawText = trim(str_replace($matches[0], '', $rawText));
            }

            $matchedProducts = collect();
            if (!empty($recommendedIds)) {
                DB::reconnect();
                $matchedProducts = Produk::with('kategori')
                    ->whereIn('id_produk', $recommendedIds)
                    ->where('stok', '>', 0)
                    ->get()
                    ->sortBy(fn($p) => array_search((int)$p->id_produk, $recommendedIds, true))
                    ->values();
            }

            // Fallback jika analisis gambar belum menghasilkan kartu produk dari tag
            if ($matchedProducts->isEmpty() && $hasImage) {
                DB::reconnect();
                $searchText = strtolower($rawText . ' ' . $message);
                $ignoreWords = ['kucing', 'anabul', 'hewan', 'untuk', 'yang', 'dari', 'dengan', 'ukuran', 'warna', 'kecil', 'besar', 'pack', 'gram', 'liter'];
                $matchedProducts = Produk::with('kategori')
                    ->where('stok', '>', 0)
                    ->get()
                    ->map(function ($p) use ($searchText, $ignoreWords) {
                        $nama = strtolower($p->nama_produk ?? '');
                        $score = 0;
                        foreach (preg_split('/\s+/', $nama) as $word) {
                            $word = trim($word, ".,()[]");
                            if (strlen($word) >= 4 && !in_array($word, $ignoreWords, true) && str_contains($searchText, $word)) {
                                $score++;
                            }
                        }
                        $p->_match_score = $score;
                        return $p;
                    })
                    ->filter(fn($p) => $p->_match_score > 0)
                    ->sortByDesc('_match_score')
                    ->take(3)
                    ->values();
            }

            // Update kuota harian user (simpan sampai tengah malam)
            $newUsage = $currentUsage + 1;
            $secondsUntilMidnight = now()->diffInSeconds(now()->endOfDay());
            Cache::put($cacheKey, $newUsage, $secondsUntilMidnight);

            return response()->json([
                'success' => true,
                'mode' => 'gemini_cloud',
                'ai_message' => $rawText,
                'products' => $matchedProducts,
                'usage' => [
                    'used' => $newUsage,
                    'limit' => $maxDailyQuota,
                    'remaining' => max(0, $maxDailyQuota - $newUsage),
                ],
            ]);

        } catch (\Exception $e) {
            Log::error('Gemini Exception: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem saat menghubungi Gemini: ' . $e->getMessage(),
            ], 500);
        }
    }
}

