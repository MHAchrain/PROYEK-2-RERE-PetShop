<x-filament-widgets::widget>
    <x-filament::section class="h-full">
        <style>
            .rere-clock-card {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                min-height: 120px;
                height: 100%;
                user-select: none;
                font-family: inherit;
            }
            .rere-clock-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            /* Badge "Waktu Nyata" (merah) */
            .rere-clock-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 3px 10px;
                border-radius: 9999px;
                font-size: 11px;
                font-weight: 700;
                letter-spacing: 0.05em;
                text-transform: uppercase;
                background-color: rgba(239, 68, 68, 0.12);
                color: #b91c1c;
                border: 1px solid rgba(239, 68, 68, 0.35);
            }
            .dark .rere-clock-badge {
                background-color: rgba(248, 113, 113, 0.2);
                color: #fecaca;
                border-color: rgba(248, 113, 113, 0.45);
            }

            /* Titik berdenyut */
            .rere-clock-pulse {
                width: 7px;
                height: 7px;
                border-radius: 9999px;
                background-color: #ef4444;
                box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7);
                animation: rerePulse 2s infinite;
            }
            @keyframes rerePulse {
                0% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7); }
                70% { box-shadow: 0 0 0 8px rgba(239, 68, 68, 0); }
                100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); }
            }

            /* Brand */
            .rere-clock-brand {
                font-size: 11px;
                font-weight: 700;
                color: #dc2626;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }
            .dark .rere-clock-brand {
                color: #fca5a5;
            }

            /* Kotak jam: gradien merah, angka putih -> terbaca di terang & gelap */
            .rere-clock-body {
                display: flex;
                align-items: baseline;
                justify-content: center;
                gap: 4px;
                padding: 12px 16px;
                background: linear-gradient(135deg, #ef4444 0%, #dc2626 50%, #b91c1c 100%);
                border: 1px solid rgba(255, 255, 255, 0.25);
                border-radius: 14px;
                margin-bottom: 10px;
                box-shadow: 0 8px 20px -8px rgba(220, 38, 38, 0.6);
            }
            .dark .rere-clock-body {
                background: linear-gradient(135deg, #dc2626 0%, #b91c1c 50%, #7f1d1d 100%);
                border-color: rgba(255, 255, 255, 0.15);
                box-shadow: 0 8px 22px -8px rgba(239, 68, 68, 0.45);
            }
            .rere-clock-digits {
                font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
                font-size: 34px;
                font-weight: 900;
                letter-spacing: 0.04em;
                color: #ffffff;
                line-height: 1;
                text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
            }
            .rere-clock-colon {
                font-size: 30px;
                font-weight: 800;
                color: #fecaca;
                margin: 0 2px;
                transition: opacity 0.2s ease;
            }
            .rere-clock-seconds {
                font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
                font-size: 15px;
                font-weight: 800;
                color: #ffffff;
                background: rgba(255, 255, 255, 0.2);
                border: 1px solid rgba(255, 255, 255, 0.35);
                padding: 2px 7px;
                border-radius: 6px;
                margin-left: 6px;
                transform: translateY(-4px);
            }

            /* Footer */
            .rere-clock-footer {
                display: flex;
                align-items: center;
                justify-content: space-between;
                font-size: 12px;
                color: #475569;
            }
            .dark .rere-clock-footer {
                color: #cbd5e1;
            }
            .rere-clock-date {
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: 600;
            }
            .rere-clock-date svg {
                color: #dc2626;
            }
            .dark .rere-clock-date svg {
                color: #fca5a5;
            }
            .rere-clock-tz {
                font-size: 10px;
                font-weight: 700;
                letter-spacing: 0.05em;
                padding: 2px 8px;
                border-radius: 9999px;
                background-color: rgba(220, 38, 38, 0.12);
                color: #991b1b;
                border: 1px solid rgba(220, 38, 38, 0.35);
            }
            .dark .rere-clock-tz {
                background-color: rgba(248, 113, 113, 0.2);
                color: #fecaca;
                border-color: rgba(248, 113, 113, 0.45);
            }
        </style>

        <div
            x-data="{
                hours: '00',
                minutes: '00',
                seconds: '00',
                date: '',
                colonOpacity: 1,
                update() {
                    const now = new Date();
                    this.hours = String(now.getHours()).padStart(2, '0');
                    this.minutes = String(now.getMinutes()).padStart(2, '0');
                    this.seconds = String(now.getSeconds()).padStart(2, '0');
                    this.colonOpacity = this.colonOpacity === 1 ? 0.3 : 1;
                    this.date = now.toLocaleDateString('id-ID', {
                        weekday: 'long',
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric'
                    });
                }
            }"
            x-init="
                update();
                setInterval(() => update(), 1000);
            "
            class="rere-clock-card"
        >
            {{-- Header --}}
            <div class="rere-clock-header">
                <span class="rere-clock-badge">
                    <span class="rere-clock-pulse"></span>
                    <span>Waktu Nyata</span>
                </span>
                <span class="rere-clock-brand">
                    🐾 Rere Petshop
                </span>
            </div>

            {{-- Body Display Jam --}}
            <div class="rere-clock-body">
                <span class="rere-clock-digits" x-text="hours"></span>
                <span class="rere-clock-colon" :style="'opacity: ' + colonOpacity">:</span>
                <span class="rere-clock-digits" x-text="minutes"></span>
                <span class="rere-clock-seconds" x-text="seconds"></span>
            </div>

            {{-- Footer Tanggal & Timezone --}}
            <div class="rere-clock-footer">
                <div class="rere-clock-date">
                    <svg style="width: 13px; height: 13px; flex-shrink: 0;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                    </svg>
                    <span x-text="date"></span>
                </div>
                <span class="rere-clock-tz">WIB (GMT+7)</span>
            </div>
        </div>
    </x-filament::section>
</x-filament-widgets::widget>