<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class RecommendationController extends Controller
{
    /**
     * Endpoint chat AI untuk rekomendasi produk RERe Petshop.
     * Mengirim input ke AI Service (FastAPI) lalu mencari produk terkait di Database MySQL.
     */
    public function chatAI(Request $request)
    {
        // Validasi input: pesan atau gambar minimal salah satu ada
        $request->validate([
            'message' => 'nullable|string',
            'image' => 'nullable|image|max:10240', // Maksimal 10MB
        ]);

        $message = trim((string) $request->input('message', ''));
        $hasImage = $request->hasFile('image');

        if ($message === '' && !$hasImage) {
            return response()->json([
                'success' => false,
                'message' => 'Silakan masukkan pesan teks atau unggah foto kucing Anda.',
            ], 422);
        }

        $pythonServiceUrl = env('AI_SERVICE_URL', 'http://127.0.0.1:8001');

        $aiMessage = '';
        $keywords = [];
        $aiMode = 'rule_based';
        $targetPrice = null;
        $minPrice = null;
        $maxPrice = null;
        $priceMode = 'max';
        $ageGroup = null;

        try {
            if ($hasImage) {
                // Request multipart dengan gambar ke Python
                $imageFile = $request->file('image');

                $response = Http::timeout(30)
                    ->attach(
                        'image',
                        file_get_contents($imageFile->getRealPath()),
                        $imageFile->getClientOriginalName()
                    )
                    ->post("{$pythonServiceUrl}/api/chat-with-image", [
                        'message' => $message,
                    ]);
            } else {
                // Request teks saja ke Python
                $response = Http::timeout(10)
                    ->post("{$pythonServiceUrl}/api/chat", [
                        'message' => $message,
                    ]);
            }

            if ($response->successful()) {
                $data = $response->json();
                $aiMessage = $data['message'] ?? 'Berikut rekomendasi produk untuk kucing Anda:';
                $keywords = $data['keywords'] ?? [];
                $brands = $data['brands'] ?? [];
                $aiMode = $data['mode'] ?? 'rule_based';
                $minPrice = $data['min_price'] ?? null;
                $maxPrice = $data['max_price'] ?? null;
                $targetPrice = $data['target_price'] ?? $data['max_price'] ?? null;
                $priceMode = $data['price_mode'] ?? 'max';
                $ageGroup = $data['age_group'] ?? null;
                $categories = $data['categories'] ?? [];
            } else {
                Log::warning('AI Service error response', ['status' => $response->status(), 'body' => $response->body()]);
                $aiMessage = 'Berikut rekomendasi produk pilihan terbaik dari RERe Petshop untuk anabul Anda:';
                $keywords = $this->extractFallbackKeywords($message);
                $brands = [];
                $categories = [];
            }
        } catch (\Exception $e) {
            Log::error('AI Service Connection Error: ' . $e->getMessage());
            // Fallback gracefully jika AI Service Python sedang belum dinyalakan
            $aiMessage = "Halo Cat Lovers! 🐾 Berikut rekomendasi produk terbaik dari katalog RERe Petshop untuk kebutuhan anabul Anda:";
            $keywords = $this->extractFallbackKeywords($message);
            $brands = [];
            $categories = [];
        }

        // Cari Produk di Database MySQL berdasarkan Brands, Keywords, Rentang Harga, Usia & Kategori secara cerdas
        $products = $this->findMatchingProducts($keywords, $brands, $minPrice, $maxPrice, $targetPrice, $priceMode, $ageGroup, $categories);

        // Tips perawatan tambahan
        $tips = [
            'Pastikan anabul selalu minum air bersih secukupnya setiap hari.',
            'Sesuaikan porsi makan dengan usia dan berat badan kucing.',
            'Lakukan perawatan grooming dan sisir bulu secara berkala.',
        ];

        return response()->json([
            'success' => true,
            'mode' => $aiMode,
            'ai_message' => $aiMessage,
            'keywords' => $keywords,
            'min_price' => $minPrice,
            'max_price' => $maxPrice,
            'target_price' => $targetPrice,
            'price_mode' => $priceMode,
            'age_group' => $ageGroup,
            'products' => $products,
            'tips' => $tips,
        ]);
    }

    /**
     * Cari produk di MySQL yang cocok dengan kriteria secara ketat (rentang harga, kategori, dan usia).
     */
    protected function findMatchingProducts(
        array $keywords,
        array $brands = [],
        ?int $minPrice = null,
        ?int $maxPrice = null,
        ?int $targetPrice = null,
        string $priceMode = 'max',
        ?string $ageGroup = null,
        array $categories = []
    ) {
        $baseQuery = Produk::with('kategori')->where('stok', '>', 0);

        // 1. FILTER HARGA CERDAS (RANGE vs MIN vs MAX vs EXACT)
        if ($priceMode === 'range' && $minPrice !== null && $maxPrice !== null) {
            $rangeCandidates = (clone $baseQuery)->whereBetween('harga', [$minPrice, $maxPrice])->get();
            if ($rangeCandidates->isNotEmpty()) {
                $candidates = $rangeCandidates;
            } else {
                // Toleransi 10% jika produk dalam rentang persis belum tersedia
                $tolMin = (int) ($minPrice * 0.90);
                $tolMax = (int) ($maxPrice * 1.10);
                $candidates = (clone $baseQuery)->whereBetween('harga', [$tolMin, $tolMax])->get();
            }
        } elseif ($priceMode === 'min' && $minPrice !== null) {
            $candidates = (clone $baseQuery)->where('harga', '>=', $minPrice)->get();
        } elseif ($priceMode === 'max' && ($maxPrice !== null || $targetPrice !== null)) {
            $limit = $maxPrice ?? $targetPrice;
            $candidates = (clone $baseQuery)->where('harga', '<=', $limit)->get();
        } elseif ($priceMode === 'exact' && $targetPrice !== null && $targetPrice > 0) {
            // Prioritas exact price
            $exactCandidates = (clone $baseQuery)->where('harga', $targetPrice)->get();
            if ($exactCandidates->isNotEmpty()) {
                $candidates = $exactCandidates;
            } else {
                $minP = (int) ($targetPrice * 0.95);
                $maxP = (int) ($targetPrice * 1.05);
                $candidates = (clone $baseQuery)->whereBetween('harga', [$minP, $maxP])->get();
            }
        } else {
            $candidates = $baseQuery->get();
        }

        // Jika filter harga menghasilkan kosong, return kosong
        if ($candidates->isEmpty()) {
            return collect();
        }

        // 2. FILTER BRAND / MEREK SECARA KETAT (Jika user mencari brand tertentu seperti 'Cat Choize', HANYA tampilkan Cat Choize!)
        if (!empty($brands)) {
            $brandFiltered = $candidates->filter(function ($prod) use ($brands) {
                $namaLower = strtolower($prod->nama_produk ?? '');
                $deskLower = strtolower($prod->deskripsi ?? '');
                foreach ($brands as $brand) {
                    $bLower = strtolower(trim($brand));
                    if ($bLower !== '' && (str_contains($namaLower, $bLower) || str_contains($deskLower, $bLower))) {
                        return true;
                    }
                }
                return false;
            });

            if ($brandFiltered->isNotEmpty()) {
                $candidates = $brandFiltered;
            }
        }

        // 3. FILTER KATEGORI SECARA KETAT (Berdasarkan id_kategori & nama kategori)
        if (!empty($categories)) {
            $catFiltered = $candidates->filter(function ($prod) use ($categories) {
                $katId = (int) ($prod->id_kategori ?? 0);
                $katNama = strtolower($prod->kategori?->nama_kategori ?? '');
                $prodNama = strtolower($prod->nama_produk ?? '');
                $prodDesk = strtolower($prod->deskripsi ?? '');

                foreach ($categories as $cat) {
                    $catLower = strtolower($cat);
                    // Kategori 1: Makanan
                    if ($catLower === 'makanan') {
                        if ($katId === 1 || str_contains($katNama, 'makan') || str_contains($katNama, 'pakan') || str_contains($prodNama, 'food')) {
                            return true;
                        }
                    }
                    // Kategori 2: Perawatan & Obat
                    elseif ($catLower === 'perawatan' || $catLower === 'obat' || $catLower === 'vitamin & susu') {
                        if ($katId === 2 || str_contains($katNama, 'rawat') || str_contains($katNama, 'obat') || str_contains($katNama, 'shampo')) {
                            return true;
                        }
                    }
                    // Kategori 3: Mainan & Aksesoris
                    elseif ($catLower === 'mainan & aksesoris') {
                        if ($katId === 3 || str_contains($katNama, 'main') || str_contains($katNama, 'aksesoris') || str_contains($prodNama, 'kalung') || str_contains($prodNama, 'baju')) {
                            return true;
                        }
                    }
                    // Kategori 4: Perlengkapan
                    elseif ($catLower === 'perlengkapan') {
                        if ($katId === 4 || str_contains($katNama, 'lengkap') || str_contains($katNama, 'pasir') || str_contains($katNama, 'kandang')) {
                            return true;
                        }
                    } else {
                        if (str_contains($katNama, $catLower) || str_contains($prodNama, $catLower) || str_contains($prodDesk, $catLower)) {
                            return true;
                        }
                    }
                }
                return false;
            });

            $candidates = $catFiltered;
            if ($candidates->isEmpty()) {
                return collect();
            }
        }

        // 4. FILTER USIA SECARA KETAT (Jika user cari Kitten, HANYA produk Kitten. Jika cari Adult, HANYA produk Adult)
        if ($ageGroup !== null) {
            $ageFiltered = $candidates->filter(function ($prod) use ($ageGroup) {
                $namaLower = strtolower($prod->nama_produk ?? '');
                $deskLower = strtolower($prod->deskripsi ?? '');
                if ($ageGroup === 'kitten') {
                    // Wajib mengandung kitten / mother / anakan dan tidak boleh adult
                    if (str_contains($namaLower, 'adult')) {
                        return false;
                    }
                    return str_contains($namaLower, 'kitten') || str_contains($deskLower, 'kitten') || str_contains($namaLower, 'mother');
                } elseif ($ageGroup === 'adult') {
                    if (str_contains($namaLower, 'kitten') || str_contains($deskLower, 'kitten')) {
                        return false;
                    }
                    return str_contains($namaLower, 'adult') || str_contains($deskLower, 'adult');
                }
                return false;
            });

            $candidates = $ageFiltered;
            if ($candidates->isEmpty()) {
                return collect();
            }
        }

        // 5. PEMBERIAN SKOR & PENGURUTAN
        $scored = $candidates->map(function ($prod) use ($keywords, $ageGroup, $targetPrice, $priceMode) {
            $score = 10; // Base score
            $namaLower = strtolower($prod->nama_produk ?? '');
            $deskLower = strtolower($prod->deskripsi ?? '');
            $katLower = strtolower($prod->kategori?->nama_kategori ?? '');

            // Skor kecocokan kata kunci
            foreach ($keywords as $index => $kw) {
                $kwLower = strtolower(trim($kw));
                if ($kwLower === '' || $kwLower === 'kucing' || $kwLower === 'makanan') continue;

                $weight = ($index === 0) ? 10 : 5;
                if (str_contains($namaLower, $kwLower)) {
                    $score += 20 * $weight;
                }
                if (str_contains($katLower, $kwLower)) {
                    $score += 5 * $weight;
                }
                if (str_contains($deskLower, $kwLower)) {
                    $score += 5 * $weight;
                }
            }

            $prod->relevance_score = $score;
            return $prod;
        });

        // Filter produk yang nilainya positif (> 0)
        $matched = $scored->filter(fn($p) => $p->relevance_score > 0)
            ->sortByDesc('relevance_score')
            ->values()
            ->take(6);

        if ($matched->isEmpty()) {
            return $candidates->take(6)->values();
        }

        return $matched;
    }

    /**
     * Ekstraksi keyword cadangan langsung di Laravel jika python tidak dapat dihubungi.
     */
    protected function extractFallbackKeywords(string $text): array
    {
        $textLower = strtolower($text);
        $found = [];
        $commonWords = [
            'kucing', 'makanan', 'whiskas', 'royal canin', 'cat choize', 'meo', 'excel', 'bolt',
            'lezatto', 'cleo', 'omegga', 'maxi', 'mister puss', 'felibite', 'pussbite', 'amigo',
            'shampo', 'parfum', 'pasir', 'litter box', 'tofu', 'kandang', 'spetan', 'dot',
            'mainan', 'kalung', 'baju', 'obat', 'susu', 'vitamin', 'kitten', 'adult', 'dewasa'
        ];

        foreach ($commonWords as $word) {
            if (str_contains($textLower, $word)) {
                $found[] = $word;
            }
        }

        return !empty($found) ? $found : ['kucing'];
    }
}
