<x-filament-widgets::widget>
    <x-filament::section class="h-full" style="background: #ffffff; border-color: #2d2d4e;">
       <div 
    x-data="{
        time: '',
        date: '',
        update() {
            const now = new Date();
            this.time = now.toLocaleTimeString('id-ID');
            this.date = now.toLocaleDateString('id-ID', {
                weekday: 'long',
                day: 'numeric',
                month: 'long',
                year: 'numeric'
            });
        }
    }"
    x-init="update(); setInterval(() => update(), 1000)"
    class="flex flex-col items-center justify-center text-center py-6 h-full"
>

    <!-- Tanggal -->
    <p x-text="date"
       style="font-size:10px; font-weight:700; letter-spacing:0.15em; color:#EF9F27;">
    </p>

    <!-- Jam -->
    <h1 x-text="time"
        style="font-size:42px; font-weight:900; color:#560b0b; font-family:monospace;">
    </h1>

    <!-- Status -->
    <div style="margin-top:16px;">
        <span>System Live</span>
    </div>
</div>
        </div>

        <script>
            function updateClock() {
                const now = new Date();
                const h = String(now.getHours()).padStart(2, '0');
                const m = String(now.getMinutes()).padStart(2, '0');
                const s = String(now.getSeconds()).padStart(2, '0');
                document.getElementById('digital-clock').textContent = `${h}:${m}:${s}`;

                const opts = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' };
                document.getElementById('current-date').textContent =
                    now.toLocaleDateString('id-ID', opts);
            }
            setInterval(updateClock, 1000);
            updateClock();
        </script>
    </x-filament::section>
</x-filament-widgets::widget>