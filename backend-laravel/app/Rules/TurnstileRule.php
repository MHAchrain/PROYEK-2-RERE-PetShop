<?php

namespace App\Rules;

use Closure;
use App\Services\TurnstileService;
use Illuminate\Contracts\Validation\ValidationRule;

class TurnstileRule implements ValidationRule
{
    protected ?string $remoteIp;
    protected TurnstileService $service;

    public function __construct(?string $remoteIp = null)
    {
        $this->remoteIp = $remoteIp;
        $this->service = app(TurnstileService::class);
    }

    /**
     * Run the validation rule.
     *
     * @param  \Closure(string, ?string=): \Illuminate\Translation\PotentiallyTranslatedString  $fail
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        $token = is_string($value) ? $value : null;

        $result = $this->service->verify($token, $this->remoteIp);

        if (! $result['success']) {
            $fail($result['message']);
        }
    }
}
