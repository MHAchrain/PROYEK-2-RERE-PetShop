<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
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
        $maxDailyQuota = 10;

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

        // Ambil ringkasan produk katalog agar Gemini bisa merekomendasikan produk riil di database
        $katalogProduk = Produk::with('kategori')
            ->where('stok', '>', 0)
            ->limit(30)
            ->get(['id_produk', 'nama_produk', 'harga', 'stok', 'id_kategori'])
            ->map(function ($item) {
                return "- [ID: {$item->id_produk}] {$item->nama_produk} (Rp " . number_format($item->harga, 0, ',', '.') . ") Kategori: " . ($item->kategori->nama_kategori ?? 'Umum');
            })
            ->implode("\n");

        $systemPrompt = "Kamu adalah ARPET (Asisten RERe Petshop), asisten virtual ramah, cerdas, penyayang kucing & anjing di toko hewan RERe Petshop Tangerang.
Tugasmu adalah menjawab pertanyaan seputar perawatan hewan peliharaan, makanan, vitamin, grooming, dan memberikan rekomendasi produk terbaik.

Berikut sebagian katalog produk tersedia di RERe Petshop:
{$katalogProduk}

Aturan Respons:
1. Bersikaplah ramah dan gunakan sapaan 'Cat Lovers' atau sebutan anabul.
2. Jawab pertanyaan pengguna secara informatif, solutif, dan hangat.
3. Jika merekomendasikan produk dari katalog di atas, sebutkan nama produknya secara jelas dan akhiri dengan tag JSON di baris terakhir dengan format:
[RECOMMENDED_IDS: 1, 2, 3] (sesuai ID produk yang relevan, atau kosongkan jika hanya konsultasi).";

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

            $userQuery = $message ?: 'Tolong analisis foto anabul saya ini dan berikan saran atau rekomendasi produk yang cocok.';
            $parts[] = ['text' => $userQuery];
            $contents[] = ['role' => 'user', 'parts' => $parts];

            $modelName = config('services.gemini.model', 'gemini-3.8-flash');
            $endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{$modelName}:generateContent?key={$apiKey}";

            $response = Http::timeout(45)->post($endpoint, [
                'systemInstruction' => [
                    'parts' => [
                        ['text' => $systemPrompt]
                    ]
                ],
                'contents' => $contents,
                'generationConfig' => [
                    'temperature' => 0.7,
                    'maxOutputTokens' => 800,
                ]
            ]);

            if (!$response->successful()) {
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
            $rawText = $geminiData['candidates'][0]['content']['parts'][0]['text'] ?? 'Maaf, ARPET tidak dapat memproses jawaban saat ini.';

            // Parse RECOMMENDED_IDS jika ada
            $recommendedIds = [];
            if (preg_match('/\[RECOMMENDED_IDS:\s*([0-9,\s]+)\]/i', $rawText, $matches)) {
                $ids = explode(',', $matches[1]);
                $recommendedIds = array_map('intval', array_map('trim', $ids));
                // Bersihkan tag dari teks yang ditampilkan ke user
                $rawText = trim(str_replace($matches[0], '', $rawText));
            }

            $matchedProducts = [];
            if (!empty($recommendedIds)) {
                $matchedProducts = Produk::with('kategori')
                    ->whereIn('id_produk', $recommendedIds)
                    ->where('stok', '>', 0)
                    ->get();
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

