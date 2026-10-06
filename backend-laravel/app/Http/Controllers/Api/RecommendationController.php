<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class RecommendationController extends Controller
{
    public function chatAI(Request $request)
    {
        $request->validate([
            'message' => 'nullable|string',
            'image' => 'nullable|image|max:10240',
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
        $aiMode = 'error';
        $targetPrice = null;
        $minPrice = null;
        $maxPrice = null;
        $priceMode = 'max';
        $ageGroup = null;
        $brands = [];
        $categories = [];
        $sortBy = null;
        $cheapestOnly = false;
        $expensiveOnly = false;
        $limit = null;
        $cta = null;   // ← BARU

        try {
            if ($hasImage) {
                $imageFile = $request->file('image');
                $response = Http::timeout(90)
                    ->attach('image', file_get_contents($imageFile->getRealPath()), $imageFile->getClientOriginalName())
                    ->post("{$pythonServiceUrl}/api/chat-with-image", ['message' => $message]);
            } else {
                $response = Http::timeout(90)
                    ->post("{$pythonServiceUrl}/api/chat", ['message' => $message]);
            }

            if ($response->successful()) {
                $data = $response->json();
                $aiMessage    = $data['message']       ?? 'Berikut rekomendasi untuk anabul Anda:';
                $keywords     = $data['keywords']      ?? [];
                $brands       = $data['brands']        ?? [];
                $aiMode       = $data['mode']          ?? 'error';
                $minPrice     = $data['min_price']     ?? null;
                $maxPrice     = $data['max_price']     ?? null;
                $targetPrice  = $data['target_price']  ?? $data['max_price'] ?? null;
                $priceMode    = $data['price_mode']    ?? 'max';
                $ageGroup     = $data['age_group']     ?? null;
                $categories   = $data['categories']    ?? [];
                $sortBy       = $data['sort_by']       ?? null;
                $cheapestOnly = $data['cheapest_only'] ?? false;
                $expensiveOnly = $data['expensive_only'] ?? false;
                $limit        = $data['limit']         ?? null;
                $cta          = $data['cta']           ?? null;   // ← BARU
            } else {
                Log::warning('AI Service error response', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                $aiMessage = '🐾 Maaf, layanan AI kami sedang sibuk. Silakan coba lagi dalam beberapa saat.';
                $aiMode = 'error';
            }
        } catch (\Exception $e) {
            Log::error('AI Service Connection Error: ' . $e->getMessage());
            $aiMessage = '🐾 Maaf, layanan AI kami sedang sibuk. Silakan coba lagi dalam beberapa saat.';
            $aiMode = 'error';
        }

        // ✅ Cuma cari produk kalau AI-nya sukses
        // Mode "special" (grooming CTA) & "off_topic" nggak perlu produk
        $successModes = ['ollama', 'gemini_vision', 'rule_based'];
        $products = in_array($aiMode, $successModes)
            ? $this->findMatchingProducts(
                $keywords, $brands, $minPrice, $maxPrice, $targetPrice,
                $priceMode, $ageGroup, $categories, $sortBy,
                $cheapestOnly, $expensiveOnly, $limit
            )
            : collect();

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
            'sort_by' => $sortBy,
            'products' => $products,
            'cta' => $cta,   // ← BARU
            'tips' => $tips,
        ]);
    }

    protected function findMatchingProducts(
        array $keywords, array $brands = [], ?int $minPrice = null,
        ?int $maxPrice = null, ?int $targetPrice = null, string $priceMode = 'max',
        ?string $ageGroup = null, array $categories = [], ?string $sortBy = null,
        bool $cheapestOnly = false, bool $expensiveOnly = false, ?int $limit = null
    ) {
        $allProducts = Produk::with('kategori')->where('stok', '>', 0)->get();

        if ($allProducts->isEmpty()) return collect();

        // ── STEP 1: FILTER BRAND ──────────────────────────────
        $pool = $allProducts;
        if (!empty($brands)) {
            $brandHit = $pool->filter(function ($prod) use ($brands) {
                $nama = strtolower($prod->nama_produk ?? '');
                $desk = strtolower($prod->deskripsi ?? '');
                foreach ($brands as $b) {
                    $bl = strtolower(trim($b));
                    if ($bl !== '' && (str_contains($nama, $bl) || str_contains($desk, $bl))) return true;
                }
                return false;
            });
            if ($brandHit->isNotEmpty()) $pool = $brandHit;
        }

        // ── STEP 2: FILTER KATEGORI ───────────────────────────
        $inCat = function ($prod, string $cat) {
            $katId = (int)($prod->id_kategori ?? 0);
            $nama  = strtolower($prod->nama_produk ?? '');
            $desk  = strtolower($prod->deskripsi ?? '');

            switch ($cat) {
                case 'makanan':
                    return $katId === 1
                        && !str_contains($nama, 'susu')
                        && !str_contains($nama, 'top growth')
                        && !str_contains($nama, 'dot');

                case 'shampo':
                    return str_contains($nama, 'shampoo') || str_contains($nama, 'sampo')
                        || str_contains($desk, 'shampoo') || str_contains($desk, 'sampo');

                case 'obat':
                    return $katId === 2
                        && !str_contains($nama, 'shampoo')
                        && !str_contains($nama, 'sampo')
                        && !str_contains($nama, 'parfum')
                        && (
                            str_contains($nama, 'obat') || str_contains($nama, 'detick')
                            || str_contains($nama, 'tetes') || str_contains($desk, 'kutu')
                            || str_contains($desk, 'jamur') || str_contains($desk, 'luka')
                            || str_contains($desk, 'scabies') || str_contains($desk, 'cacing')
                            || str_contains($desk, 'antiparasit')
                        );

                case 'parfum':
                    return str_contains($nama, 'parfum') || str_contains($desk, 'parfum')
                        || str_contains($nama, 'pewangi') || str_contains($desk, 'pewangi');

                case 'mainan':
                    return $katId === 3
                        && !str_contains($nama, 'baju')
                        && !str_contains($nama, 'kalung');

                case 'aksesoris':
                    return $katId === 3
                        && (str_contains($nama, 'baju') || str_contains($nama, 'kalung')
                            || str_contains($desk, 'kalung') || str_contains($desk, 'klinting'));

                case 'pasir':
                    return $katId === 4
                        && (
                            str_contains($nama, 'pasir')
                            || str_contains($nama, 'tofu')
                            || str_contains($nama, 'litter')
                            || preg_match('/\bps\s/i', $nama)
                        );

                case 'perlengkapan':
                    return $katId === 4
                        && !str_contains($nama, 'pasir')
                        && !str_contains($nama, 'tofu')
                        && !str_contains($nama, 'litter')
                        && !preg_match('/\bps\s/i', $nama);

                case 'susu':
                    return str_contains($nama, 'susu') || str_contains($nama, 'top growth')
                        || str_contains($desk, 'kitten milk') || str_contains($desk, 'susu kitten');

                default:
                    return str_contains($nama, $cat) || str_contains($desk, $cat);
            }
        };

        if (!empty($categories)) {
            $catHit = $pool->filter(function ($prod) use ($categories, $inCat) {
                foreach ($categories as $cat) {
                    if ($inCat($prod, strtolower(trim($cat)))) return true;
                }
                return false;
            });

            if ($catHit->isNotEmpty()) {
                $pool = $catHit;
            } else {
                return collect();
            }
        }

        // ── STEP 3: FILTER HARGA ──────────────────────────────
        if ($priceMode === 'range' && $minPrice !== null && $maxPrice !== null) {
            $pf = $pool->filter(fn($p) => $p->harga >= $minPrice && $p->harga <= $maxPrice);
            if ($pf->isEmpty()) {
                $pf = $pool->filter(fn($p) => $p->harga >= (int)($minPrice * 0.80) && $p->harga <= (int)($maxPrice * 1.20));
            }
            if ($pf->isNotEmpty()) $pool = $pf;

        } elseif ($priceMode === 'min' && $minPrice !== null) {
            $pf = $pool->filter(fn($p) => $p->harga >= $minPrice);
            if ($pf->isNotEmpty()) $pool = $pf;

        } elseif (in_array($priceMode, ['max', 'exact']) && ($maxPrice !== null || $targetPrice !== null)) {
            $limitPrice = $maxPrice ?? $targetPrice;
            $pf = $pool->filter(fn($p) => $p->harga <= $limitPrice);
            if ($pf->isNotEmpty()) $pool = $pf;
        }

        // ── STEP 4: FILTER USIA ───────────────────────────────
        $ageRelevant = !empty(array_intersect($categories, ['makanan', 'susu']));
        if ($ageGroup !== null && ($ageRelevant || empty($categories))) {
            $ageHit = $pool->filter(function ($prod) use ($ageGroup) {
                $nama = strtolower($prod->nama_produk ?? '');
                $desk = strtolower($prod->deskripsi ?? '');
                if ($ageGroup === 'kitten') {
                    if (str_contains($nama, 'adult')) return false;
                    return str_contains($nama, 'kitten') || str_contains($desk, 'kitten') || str_contains($nama, 'mother');
                } elseif ($ageGroup === 'adult') {
                    if (str_contains($nama, 'kitten') || str_contains($desk, 'kitten')) return false;
                    return str_contains($nama, 'adult') || str_contains($desk, 'adult');
                }
                return false;
            });
            if ($ageHit->isNotEmpty()) $pool = $ageHit;
            elseif ($ageRelevant) return collect();
        }

        // ── STEP 5: SCORING ───────────────────────────────────
        $stopwords = [
            'kucing', 'anabul', 'hewan', 'perawatan', 'kesehatan',
            'produk', 'toko', 'petshop', 'yang', 'dan', 'atau',
            'untuk', 'dengan', 'saya', 'aku', 'ini', 'itu', 'makanan',
        ];

        $scored = $pool->map(function ($prod) use ($keywords, $stopwords) {
            $score = 0;
            $nama  = strtolower($prod->nama_produk ?? '');
            $desk  = strtolower($prod->deskripsi ?? '');
            $kat   = strtolower($prod->kategori?->nama_kategori ?? '');

            foreach ($keywords as $i => $kw) {
                $kl = strtolower(trim($kw));
                if ($kl === '' || in_array($kl, $stopwords)) continue;

                $kataKata = preg_split('/\s+/', $kl);
                $matchCount = 0;
                foreach ($kataKata as $kata) {
                    if (strlen($kata) < 3) continue;
                    if (str_contains($nama, $kata)) $matchCount += 2;
                    if (str_contains($desk, $kata)) $matchCount += 1;
                    if (str_contains($kat, $kata))  $matchCount += 1;
                }

                $w = ($i === 0) ? 3 : 1;
                $score += $matchCount * $w * 5;
            }

            $prod->relevance_score = $score;
            return $prod;
        });

        // ── STEP 6: THRESHOLD + SORTING + LIMIT ───────────────
        $take = $limit ?? 4;
        $threshold = 15;

        $filtered = $scored->filter(fn($p) => $p->relevance_score >= $threshold);

        if ($filtered->isEmpty()) {
            return collect();
        }

        if ($cheapestOnly) {
            $result = $filtered->sortBy('harga')->values()->take($take);
        } elseif ($expensiveOnly) {
            $result = $filtered->sortByDesc('harga')->values()->take($take);
        } elseif ($sortBy === 'price_asc') {
            $result = $filtered->sortBy('harga')->values()->take($take);
        } elseif ($sortBy === 'price_desc') {
            $result = $filtered->sortByDesc('harga')->values()->take($take);
        } else {
            $result = $filtered->sortByDesc('relevance_score')->values()->take($take);
        }

        return $result;
    }

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