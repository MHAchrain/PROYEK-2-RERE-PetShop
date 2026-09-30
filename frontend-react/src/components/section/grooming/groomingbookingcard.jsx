import { CalendarDays, Clock3, PawPrint, ReceiptText } from 'lucide-react';

const statusLabels = {
    menunggu_pembayaran: 'Menunggu Pembayaran',
    terjadwal: 'Terjadwal',
    dikonfirmasi: 'Terkonfirmasi',
    selesai: 'Selesai',
    dibatalkan: 'Dibatalkan',
    batal: 'Dibatalkan',
    gagal: 'Gagal',
};

const statusClasses = {
    menunggu_pembayaran: 'bg-amber-100 text-amber-800',
    terjadwal: 'bg-sky-100 text-sky-800',
    dikonfirmasi: 'bg-sky-100 text-sky-800',
    selesai: 'bg-emerald-100 text-emerald-800',
    dibatalkan: 'bg-rose-100 text-rose-800',
    batal: 'bg-rose-100 text-rose-800',
    gagal: 'bg-gray-100 text-gray-700',
};

const formatDate = (value) => {
    if (!value) return '-';

    const [year, month, day] = String(value).split('T')[0].split('-').map(Number);
    if (!year || !month || !day) return value;

    return new Intl.DateTimeFormat('id-ID', {
        day: '2-digit',
        month: 'long',
        year: 'numeric',
    }).format(new Date(year, month - 1, day));
};

const formatPrice = (value) => {
    if (typeof value === 'number') {
        return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0,
        }).format(value);
    }

    return value || '-';
};

export default function GroomingBookingCard({ booking }) {
    const status = String(booking.status || '');
    const statusLabel = statusLabels[status] || status || 'Status tidak diketahui';
    const statusClass = statusClasses[status] || 'bg-gray-100 text-gray-700';
    const petDetails = [booking.petType, booking.petBreed, booking.petSize]
        .filter(Boolean)
        .join(' · ');

    return (
        <article className="overflow-hidden rounded-3xl border border-gray-200 bg-white shadow-sm transition hover:shadow-md">
        <header className="flex flex-col gap-4 border-b border-gray-100 px-5 py-5 sm:flex-row sm:items-center sm:justify-between sm:px-6">
            <div className="flex flex-wrap gap-x-8 gap-y-4">
            <div>
                <p className="mb-1 flex items-center gap-2 text-xs font-semibold uppercase tracking-wide text-gray-400">
                <CalendarDays size={15} /> Jadwal grooming
                </p>
                <p className="text-sm font-semibold text-gray-800">
                {formatDate(booking.date)}{booking.time ? ` · ${booking.time}` : ''}
                </p>
            </div>
            <div>
                <p className="mb-1 flex items-center gap-2 text-xs font-semibold uppercase tracking-wide text-gray-400">
                <ReceiptText size={15} /> ID Booking
                </p>
                <p className="text-sm font-bold text-gray-900">#{booking.id || '-'}</p>
            </div>
            </div>

            <span className={`inline-flex w-fit rounded-full px-3 py-1.5 text-xs font-semibold ${statusClass}`}>
            {statusLabel}
            </span>
        </header>

        <div className="flex flex-col gap-5 px-5 py-5 sm:flex-row sm:items-center sm:justify-between sm:px-6">
            <div className="flex min-w-0 items-start gap-4">
            <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary">
                <PawPrint size={25} />
            </div>
            <div className="min-w-0">
                <h3 className="text-lg font-bold text-gray-900">
                {booking.serviceName || 'Layanan Grooming'}
                </h3>
                <p className="mt-1 flex items-center gap-2 text-sm font-medium text-gray-700">
                {booking.petName || 'Hewan'}
                {petDetails ? <span className="font-normal text-gray-500">· {petDetails}</span> : null}
                </p>
                {booking.petNote && (
                <p className="mt-2 line-clamp-2 text-sm leading-relaxed text-gray-500">
                    Catatan: {booking.petNote}
                </p>
                )}
            </div>
            </div>

            <div className="shrink-0 border-t border-gray-100 pt-4 sm:border-l sm:border-t-0 sm:pl-6 sm:pt-0">
            <p className="flex items-center gap-2 text-xs font-semibold uppercase tracking-wide text-gray-400">
                <Clock3 size={14} /> Harga layanan
            </p>
            <p className="mt-1 text-lg font-bold text-gray-900">{formatPrice(booking.price)}</p>
            </div>
        </div>
        </article>
    );
}
