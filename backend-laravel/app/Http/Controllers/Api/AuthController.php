<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use App\Models\User;
use App\Services\TurnstileService;
use Google\Client as GoogleClient;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    private const RESET_CODE_TTL_MINUTES = 10;
    private const RESET_CODE_MAX_ATTEMPTS = 5;
    private const RESET_CODE_RESEND_COOLDOWN_SECONDS = 60;
    private const RESET_CODE_LOCKOUT_MINUTES = 5;

    protected function resetCodeKey(string $email): string
    {
        return "password_reset_code:{$email}";
    }

    protected function resetAttemptKey(string $email): string
    {
        return "password_reset_attempts:{$email}";
    }

    protected function resetVerifiedKey(string $email): string
    {
        return "password_reset_verified:{$email}";
    }

    protected function resetCooldownKey(string $email): string
    {
        return "password_reset_cooldown:{$email}";
    }

    protected function resetLockoutKey(string $email): string
    {
        return "password_reset_lockout:{$email}";
    }

    protected function clearResetState(string $email): void
    {
        Cache::forget($this->resetCodeKey($email));
        Cache::forget($this->resetAttemptKey($email));
        Cache::forget($this->resetVerifiedKey($email));
        Cache::forget($this->resetCooldownKey($email));
    }

    protected function buildAuthPayload(User $user): array
    {
        $pelanggan = $user->pelanggan_id
            ? Pelanggan::find($user->pelanggan_id)
            : Pelanggan::where('email', $user->email)->first();

        if ($pelanggan && $user->pelanggan_id !== $pelanggan->id_pelanggan) {
            $user->pelanggan_id = $pelanggan->id_pelanggan;
            $user->save();
        }

        return [
            'user' => $user,
            'pelanggan' => $pelanggan,
        ];
    }

    /**
     * Tentukan apakah request harus memvalidasi Cloudflare Turnstile CAPTCHA.
     * Web browser (React) wajib divalidasi CAPTCHA.
     * Mobile client (Flutter Android) dikecualikan sampai widget CAPTCHA mobile diimplementasikan.
     */
    protected function shouldValidateTurnstile(Request $request): bool
    {
        $userAgent = strtolower((string) $request->header('User-Agent'));
        $clientPlatform = strtolower((string) $request->header('X-Client-Platform', ''));
        $inputPlatform = strtolower((string) $request->input('platform', ''));

        // 1. Identifikasi Mobile Client (Flutter / Dart / Dio / header mobile)
        $isMobileClient = $clientPlatform === 'mobile' ||
            $inputPlatform === 'mobile' ||
            str_contains($userAgent, 'dart') ||
            str_contains($userAgent, 'dio') ||
            str_contains($userAgent, 'flutter') ||
            str_contains($userAgent, 'okhttp');

        if ($isMobileClient) {
            // Jika mobile menyertakan turnstile_token secara eksplisit, tetap verifikasi.
            // Jika tidak, jangan wajibkan CAPTCHA pada mobile.
            return $request->filled('turnstile_token') || $request->filled('cf-turnstile-response');
        }

        // 2. Jika request menyertakan token Turnstile (dari form Web), wajib divalidasi
        if ($request->has('turnstile_token') || $request->has('cf-turnstile-response')) {
            return true;
        }

        // 3. Request dari browser web (React frontend) wajib divalidasi
        $isWeb = $clientPlatform === 'web' ||
            $inputPlatform === 'web' ||
            $request->headers->has('Origin') ||
            $request->headers->has('Sec-Fetch-Mode') ||
            (str_contains($userAgent, 'mozilla') && !$isMobileClient);

        return $isWeb;
    }

    /**
     * Lakukan validasi Cloudflare Turnstile CAPTCHA sebelum autentikasi diproses.
     */
    protected function validateTurnstile(Request $request): ?\Illuminate\Http\JsonResponse
    {
        if (!$this->shouldValidateTurnstile($request)) {
            return null;
        }

        $token = $request->input('turnstile_token') ?? $request->input('cf-turnstile-response');

        $result = app(TurnstileService::class)->verify($token, $request->ip());

        if (!$result['success']) {
            return response()->json([
                'success' => false,
                'message' => $result['message'],
                'errors' => [
                    'turnstile_token' => [$result['message']],
                ],
            ], 422);
        }

        return null;
    }

    /**
     * Generate 5 digit Number CAPTCHA khusus aplikasi mobile (gaya Mobile JKN).
     */
    public function getCaptcha(): \Illuminate\Http\JsonResponse
    {
        $code = (string) mt_rand(10000, 99999);
        $key = (string) Str::uuid();

        Cache::put("mobile_captcha:{$key}", $code, now()->addMinutes(5));

        return response()->json([
            'success' => true,
            'message' => 'Captcha berhasil dibuat',
            'key' => $key,
            'code' => $code,
        ]);
    }

    /**
     * Validasi Number CAPTCHA khusus aplikasi mobile (gaya Mobile JKN).
     */
    protected function validateMobileCaptcha(Request $request): ?\Illuminate\Http\JsonResponse
    {
        $userAgent = strtolower((string) $request->header('User-Agent'));
        $clientPlatform = strtolower((string) $request->header('X-Client-Platform', ''));
        $inputPlatform = strtolower((string) $request->input('platform', ''));

        $isMobileClient = $clientPlatform === 'mobile'
            || $inputPlatform === 'mobile'
            || str_contains($userAgent, 'dart')
            || str_contains($userAgent, 'dio')
            || str_contains($userAgent, 'flutter')
            || str_contains($userAgent, 'okhttp')
            || $request->has('captcha_key');

        if (! $isMobileClient) {
            return null;
        }

        $captchaKey = $request->input('captcha_key');
        $captchaCode = $request->input('captcha_code');

        if (empty($captchaKey) || empty($captchaCode)) {
            return response()->json([
                'success' => false,
                'message' => 'Kode captcha angka wajib diisi.',
                'errors' => [
                    'captcha_code' => ['Kode captcha angka wajib diisi.'],
                ],
            ], 422);
        }

        $cachedCode = Cache::get("mobile_captcha:{$captchaKey}");

        if (! $cachedCode || $cachedCode !== trim((string) $captchaCode)) {
            return response()->json([
                'success' => false,
                'message' => 'Kode captcha salah atau kedaluwarsa. Silakan muat ulang captcha.',
                'errors' => [
                    'captcha_code' => ['Kode captcha angka tidak valid atau telah kedaluwarsa.'],
                ],
            ], 422);
        }

        // Hapus kode setelah sukses divalidasi (one-time use)
        Cache::forget("mobile_captcha:{$captchaKey}");

        return null;
    }

    public function register(Request $request)
    {
        // 1. Validasi Turnstile CAPTCHA sebelum proses registrasi
        if ($captchaError = $this->validateTurnstile($request)) {
            return $captchaError;
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email|unique:pelanggan,email',
            'password' => 'required|string|min:6',
            'no_hp' => 'nullable|string|max:20',
            'alamat' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $pelanggan = Pelanggan::create([
            'nama' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'no_hp' => $request->no_hp,
            'alamat' => $request->alamat,
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'customer',
            'pelanggan_id' => $pelanggan->id_pelanggan,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Register berhasil',
            'data' => $this->buildAuthPayload($user),
        ], 201);
    }

    public function login(Request $request)
    {
        // 1. Validasi Turnstile CAPTCHA (khusus web)
        if ($captchaError = $this->validateTurnstile($request)) {
            return $captchaError;
        }

        // 2. Validasi Number CAPTCHA (khusus mobile gaya Mobile JKN)
        if ($mobileCaptchaError = $this->validateMobileCaptcha($request)) {
            return $mobileCaptchaError;
        }

        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        if (!Auth::attempt([
            'email' => $request->email,
            'password' => $request->password,
        ])) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah',
            ], 401);
        }

        $user = User::where('email', $request->email)->first();

        if ($user->role !== 'customer') {
            return response()->json([
                'success' => false,
                'message' => 'Akun ini bukan customer',
            ], 403);
        }
        $user->tokens()->delete();
        $token = $user->createToken('customer_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'token' => $token,
            'data' => $this->buildAuthPayload($user),
        ]);
    }

    public function me(Request $request)
    {
        return response()->json([
            'success' => true,
            'data' => $this->buildAuthPayload($request->user()),
        ]);
    }

    public function sendResetCode(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Email tidak ditemukan',
                'errors' => $validator->errors(),
            ], 422);
        }

        $email = $request->email;
        $user = User::where('email', $email)->first();

        if (!$user || $user->role !== 'customer') {
            return response()->json([
                'success' => false,
                'message' => 'Akun customer tidak ditemukan',
            ], 404);
        }

        $lockoutExpiresAt = Cache::get($this->resetLockoutKey($email));

        if ($lockoutExpiresAt && now()->lt($lockoutExpiresAt)) {
            $minutesLeft = max(1, (int) ceil(now()->diffInSeconds($lockoutExpiresAt) / 60));

            return response()->json([
                'success' => false,
                'message' => "Terlalu banyak percobaan salah. Coba lagi dalam {$minutesLeft} menit.",
                'minutes_left' => $minutesLeft,
            ], 429);
        }

        $cooldownExpiresAt = Cache::get($this->resetCooldownKey($email));

        if ($cooldownExpiresAt && now()->lt($cooldownExpiresAt)) {
            $secondsLeft = max(1, now()->diffInSeconds($cooldownExpiresAt));

            return response()->json([
                'success' => false,
                'message' => "Tunggu {$secondsLeft} detik sebelum mengirim ulang kode reset",
                'seconds_left' => $secondsLeft,
            ], 429);
        }

        $code = (string) random_int(100000, 999999);
        $expiresAt = now()->addMinutes(self::RESET_CODE_TTL_MINUTES);

        Cache::put($this->resetCodeKey($email), $code, $expiresAt);
        Cache::put($this->resetAttemptKey($email), 0, $expiresAt);
        Cache::forget($this->resetVerifiedKey($email));
        Cache::put(
            $this->resetCooldownKey($email),
            now()->addSeconds(self::RESET_CODE_RESEND_COOLDOWN_SECONDS),
            now()->addSeconds(self::RESET_CODE_RESEND_COOLDOWN_SECONDS)
        );

        Mail::raw(
            "Kode reset password ReRe PetShop Anda adalah: {$code}. Kode ini berlaku " . self::RESET_CODE_TTL_MINUTES . ' menit.',
            function ($message) use ($email) {
                $message->to($email)->subject('Kode Reset Password ReRe PetShop');
            }
        );

        return response()->json([
            'success' => true,
            'message' => 'Kode reset berhasil dikirim ke email Anda',
        ]);
    }

    public function verifyResetCode(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
            'code' => 'required|string|size:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau kode reset tidak valid',
                'errors' => $validator->errors(),
            ], 422);
        }

        $email = $request->email;
        $cachedCode = Cache::get($this->resetCodeKey($email));

        if (!$cachedCode) {
            return response()->json([
                'success' => false,
                'message' => 'Kode reset sudah kedaluwarsa. Silakan kirim ulang kode baru.',
            ], 422);
        }

        $attempts = (int) Cache::get($this->resetAttemptKey($email), 0);

        if ($attempts >= self::RESET_CODE_MAX_ATTEMPTS) {
            $this->clearResetState($email);
            Cache::put(
                $this->resetLockoutKey($email),
                now()->addMinutes(self::RESET_CODE_LOCKOUT_MINUTES),
                now()->addMinutes(self::RESET_CODE_LOCKOUT_MINUTES)
            );

            return response()->json([
                'success' => false,
                'message' => 'Terlalu banyak percobaan. Coba lagi 5 menit lagi.',
            ], 429);
        }

        if ($cachedCode !== $request->code) {
            $attempts++;
            $remainingAttempts = max(0, self::RESET_CODE_MAX_ATTEMPTS - $attempts);
            Cache::put(
                $this->resetAttemptKey($email),
                $attempts,
                now()->addMinutes(self::RESET_CODE_TTL_MINUTES)
            );

            if ($remainingAttempts === 0) {
                $this->clearResetState($email);
                Cache::put(
                    $this->resetLockoutKey($email),
                    now()->addMinutes(self::RESET_CODE_LOCKOUT_MINUTES),
                    now()->addMinutes(self::RESET_CODE_LOCKOUT_MINUTES)
                );

                return response()->json([
                    'success' => false,
                    'message' => 'Kode salah 5 kali. Coba lagi 5 menit lagi.',
                    'remaining_attempts' => 0,
                    'minutes_left' => self::RESET_CODE_LOCKOUT_MINUTES,
                ], 429);
            }

            return response()->json([
                'success' => false,
                'message' => "Kode reset salah. Sisa percobaan: {$remainingAttempts}",
                'remaining_attempts' => $remainingAttempts,
            ], 422);
        }

        Cache::put(
            $this->resetVerifiedKey($email),
            true,
            now()->addMinutes(self::RESET_CODE_TTL_MINUTES)
        );
        Cache::forget($this->resetAttemptKey($email));

        return response()->json([
            'success' => true,
            'message' => 'Kode reset berhasil diverifikasi',
        ]);
    }

    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
            'code' => 'required|string|size:6',
            'password' => 'required|string|min:6|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $email = $request->email;
        $cachedCode = Cache::get($this->resetCodeKey($email));
        $isVerified = Cache::get($this->resetVerifiedKey($email), false);

        if (!$cachedCode || $cachedCode !== $request->code) {
            return response()->json([
                'success' => false,
                'message' => 'Kode reset tidak valid atau sudah kedaluwarsa',
            ], 422);
        }

        if (!$isVerified) {
            return response()->json([
                'success' => false,
                'message' => 'Konfirmasi kode reset dulu sebelum mengganti password',
            ], 422);
        }

        $hash = Hash::make($request->password);

        $user = User::where('email', $email)->first();
        $pelanggan = Pelanggan::where('email', $email)->first();

        if ($user) {
            $user->password = $hash;
            $user->tokens()->delete();
            $user->save();
        }

        if ($pelanggan) {
            $pelanggan->password = $hash;
            $pelanggan->save();
        }

        $this->clearResetState($email);

        return response()->json([
            'success' => true,
            'message' => 'Password berhasil direset. Silakan login dengan password baru.',
        ]);
    }

    // ⬇️ 3 METHOD GOOGLE OAUTH (LENGKAP) ⬇️

    public function redirectToGoogle()
    {
        /** @var \Laravel\Socialite\Two\AbstractProvider $driver */
        $driver = Socialite::driver('google');
        return $driver->stateless()->redirect();
    }

    public function handleGoogleCallback()
    {
        try {
            /** @var \Laravel\Socialite\Two\AbstractProvider $driver */
            $driver = Socialite::driver('google');
            $googleUser = $driver->stateless()->user();

            $user = User::where('email', $googleUser->getEmail())->first();

            if (!$user) {
                $pelanggan = Pelanggan::create([
                    'nama' => $googleUser->getName(),
                    'email' => $googleUser->getEmail(),
                    'password' => Hash::make(Str::random(16)),
                ]);

                $user = User::create([
                    'name' => $googleUser->getName(),
                    'email' => $googleUser->getEmail(),
                    'password' => Hash::make(Str::random(16)),
                    'google_id' => $googleUser->getId(),
                    'email_verified_at' => now(),
                    'role' => 'customer',
                    'pelanggan_id' => $pelanggan->id_pelanggan,
                ]);
            } else {
                if (!$user->google_id) {
                    $user->google_id = $googleUser->getId();
                }

                // Jika user sudah ada tapi belum punya data pelanggan di tabel pelanggan
                $pelanggan = $user->pelanggan_id
                    ? Pelanggan::find($user->pelanggan_id)
                    : Pelanggan::where('email', $user->email)->first();

                if (!$pelanggan) {
                    $pelanggan = Pelanggan::create([
                        'nama' => $user->name,
                        'email' => $user->email,
                        'password' => $user->password,
                    ]);
                }

                if ($user->pelanggan_id !== $pelanggan->id_pelanggan) {
                    $user->pelanggan_id = $pelanggan->id_pelanggan;
                }
                $user->save();
            }

            Auth::login($user);
            $token = $user->createToken('customer_token')->plainTextToken;

            return redirect("http://localhost:5173/auth/callback?token={$token}&user=" . json_encode([
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
            ]));
        } catch (\Exception $e) {
            return '<pre>
ERROR: ' . $e->getMessage() . '

LINE: ' . $e->getLine() . '

FILE: ' . $e->getFile() . '
</pre>';
        }
    }

    public function googleLogin(Request $request)
    {
        \Log::info('Google Login dipanggil');

        $validator = Validator::make($request->all(), [
            'token' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Token Google tidak valid',
            ], 422);
        }

        try {
            // 🔥 PAKAI SOCIALITE userFromToken (LEBIH SIMPLE)
            $googleUser = Socialite::driver('google')->stateless()->userFromToken($request->token);

            $user = User::where('email', $googleUser->getEmail())->first();

            if (!$user) {
                $pelanggan = Pelanggan::create([
                    'nama' => $googleUser->getName(),
                    'email' => $googleUser->getEmail(),
                    'password' => Hash::make(Str::random(16)),
                ]);

                $user = User::create([
                    'name' => $googleUser->getName(),
                    'email' => $googleUser->getEmail(),
                    'password' => Hash::make(Str::random(16)),
                    'google_id' => $googleUser->getId(),
                    'email_verified_at' => now(),
                    'role' => 'customer',
                    'pelanggan_id' => $pelanggan->id_pelanggan,
                ]);
            } else {
                if (!$user->google_id) {
                    $user->google_id = $googleUser->getId();
                }

                $pelanggan = $user->pelanggan_id
                    ? Pelanggan::find($user->pelanggan_id)
                    : Pelanggan::where('email', $user->email)->first();

                if (!$pelanggan) {
                    $pelanggan = Pelanggan::create([
                        'nama' => $user->name,
                        'email' => $user->email,
                        'password' => $user->password,
                    ]);
                }

                if ($user->pelanggan_id !== $pelanggan->id_pelanggan) {
                    $user->pelanggan_id = $pelanggan->id_pelanggan;
                }
                $user->save();
            }

            $user->tokens()->delete();
            $token = $user->createToken('customer_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Login Google berhasil',
                'token' => $token,
                'data' => $this->buildAuthPayload($user),
            ]);
        } catch (\Exception $e) {
            \Log::error('Google Login Error: ' . $e->getMessage());
            \Log::error('Line: ' . $e->getLine());
            \Log::error('File: ' . $e->getFile());

            return response()->json([
                'success' => false,
                'message' => 'Login Google gagal: ' . $e->getMessage(),
            ], 500);
        }
    }

    // ⬆️ SAMPAI SINI ⬆️
}
