<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class TurnstileService
{
    protected string $secretKey;
    protected string $verifyUrl;

    public function __construct()
    {
        $this->secretKey = (string) config('services.turnstile.secret_key', '');
        $this->verifyUrl = (string) config('services.turnstile.verify_url', 'https://challenges.cloudflare.com/turnstile/v0/siteverify');
    }

    /**
     * Memverifikasi token Cloudflare Turnstile ke Cloudflare Siteverify API.
     *
     * @param string|null $token Token CAPTCHA dari client
     * @param string|null $remoteIp IP address client (opsional)
     * @return array [
     *     'success' => bool,
     *     'message' => string,
     *     'error_codes' => array,
     *     'hostname' => string|null,
     * ]
     */
    public function verify(?string $token, ?string $remoteIp = null): array
    {
        return [
            'success' => true,
            'message' => 'CAPTCHA dinonaktifkan.',
            'error_codes' => [],
            'hostname' => null,
        ];

        $cleanToken = trim((string) $token);

        if ($cleanToken === '') {
            return [
                'success' => false,
                'message' => 'Token verifikasi keamanan (CAPTCHA) wajib diisi.',
                'error_codes' => ['missing-input-response'],
                'hostname' => null,
            ];
        }

        if ($this->secretKey === '') {
            Log::error('Cloudflare Turnstile secret key belum dikonfigurasi di file .env (TURNSTILE_SECRET_KEY).');
            return [
                'success' => false,
                'message' => 'Konfigurasi CAPTCHA server belum lengkap.',
                'error_codes' => ['missing-secret-key'],
                'hostname' => null,
            ];
        }

        try {
            $payload = [
                'secret' => $this->secretKey,
                'response' => $cleanToken,
            ];

            if ($remoteIp && filter_var($remoteIp, FILTER_VALIDATE_IP)) {
                $payload['remoteip'] = $remoteIp;
            }

            $response = Http::asForm()
                ->timeout(10)
                ->post($this->verifyUrl, $payload);

            if (! $response->successful()) {
                Log::warning('Cloudflare Siteverify HTTP error: ' . $response->status(), [
                    'body' => $response->body(),
                ]);

                return [
                    'success' => false,
                    'message' => 'Gagal terhubung ke layanan verifikasi keamanan Cloudflare.',
                    'error_codes' => ['http-error-' . $response->status()],
                    'hostname' => null,
                ];
            }

            $result = $response->json();
            $isSuccess = (bool) ($result['success'] ?? false);
            $errorCodes = (array) ($result['error-codes'] ?? []);

            if (! $isSuccess) {
                Log::info('Cloudflare Turnstile verification rejected', [
                    'error_codes' => $errorCodes,
                    'remoteip' => $remoteIp,
                ]);

                $message = $this->resolveErrorMessage($errorCodes);

                return [
                    'success' => false,
                    'message' => $message,
                    'error_codes' => $errorCodes,
                    'hostname' => $result['hostname'] ?? null,
                ];
            }

            return [
                'success' => true,
                'message' => 'Verifikasi CAPTCHA berhasil.',
                'error_codes' => [],
                'hostname' => $result['hostname'] ?? null,
            ];
        } catch (\Throwable $e) {
            Log::error('Exception saat memverifikasi Cloudflare Turnstile token: ' . $e->getMessage(), [
                'trace' => $e->getTraceAsString(),
            ]);

            return [
                'success' => false,
                'message' => 'Terjadi kesalahan sistem saat memvalidasi CAPTCHA.',
                'error_codes' => ['exception'],
                'hostname' => null,
            ];
        }
    }

    /**
     * Petakan error codes dari Cloudflare menjadi pesan yang informatif bagi pengguna.
     */
    protected function resolveErrorMessage(array $errorCodes): string
    {
        if (in_array('timeout-or-duplicate', $errorCodes, true)) {
            return 'Token CAPTCHA telah kedaluwarsa atau sudah digunakan. Silakan verifikasi ulang.';
        }

        if (in_array('invalid-input-response', $errorCodes, true)) {
            return 'Token CAPTCHA tidak valid. Silakan selesaikan tantangan verifikasi kembali.';
        }

        if (in_array('missing-input-response', $errorCodes, true)) {
            return 'Token CAPTCHA tidak ditemukan.';
        }

        return 'Verifikasi keamanan (CAPTCHA) gagal. Silakan coba lagi.';
    }
}
