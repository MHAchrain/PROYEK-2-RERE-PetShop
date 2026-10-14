import { CalendarHeart } from 'lucide-react';
import { Link } from 'react-router-dom';
import useGroomingHistory from '../hooks/usegroominghistory';
import GroomingBookingCard from '../components/section/grooming/groomingbookingcard';
import Button from '../components/ui/button';
import SectionTitle from '../components/ui/sectiontitle';
import Skeleton from '../components/ui/skeleton';

export default function GroomingHistoryPage() {
    const {
        bookings,
        filteredBookings,
        activeTab,
        setActiveTab,
        tabs,
        isLoading,
        error,
    } = useGroomingHistory();

    return (
        <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
        <div className="mx-auto w-full max-w-7xl space-y-6 md:space-y-8">
            <div className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
            <div>
                {isLoading ? (
                <Skeleton className="h-16 w-full max-w-lg bg-gray-200" />
                ) : (
                <SectionTitle
                    eyebrow="Grooming"
                    title="Riwayat Booking"
                    description="Pantau jadwal dan status booking grooming anabul kamu."
                />
                )}
            </div>

            <div className="flex items-center gap-3">
                <div className="rounded-2xl border border-gray-200 bg-white px-4 py-3 text-sm text-gray-600 shadow-sm">
                <span className="font-semibold text-gray-900">{bookings.length}</span>{' '}
                booking tercatat
                </div>
            </div>
            </div>

            <section className="rounded-[28px] border border-gray-200 bg-white p-3 shadow-sm sm:p-4">
            <div className="mb-3 px-2">
                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">
                Filter Booking
                </p>
                <p className="mt-1 text-sm text-gray-500">
                Pilih status untuk memfilter riwayat grooming.
                </p>
            </div>

            <div className="grid grid-cols-2 gap-2 sm:grid-cols-3 lg:grid-cols-5">
                {tabs.map((tab) => (
                <button
                    key={tab.id}
                    type="button"
                    aria-pressed={activeTab === tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`w-full rounded-2xl px-4 py-3 text-center text-sm transition-all ${
                    activeTab === tab.id
                        ? 'bg-primary font-semibold text-white shadow-lg shadow-primary/20'
                        : 'bg-gray-50 font-medium text-gray-500 hover:bg-gray-100 hover:text-gray-800'
                    }`}>
                    <span className="block leading-tight">{tab.label}</span>
                </button>
                ))}
            </div>
            </section>

            <section className="rounded-[28px] border border-gray-200 bg-white p-4 shadow-sm sm:p-5 md:p-6">
            {isLoading ? (
                <div className="space-y-4">
                {[1, 2, 3].map((item) => (
                    <Skeleton key={item} className="h-56 w-full rounded-3xl bg-gray-100" />
                ))}
                </div>
            ) : error ? (
                <div role="alert" className="rounded-2xl bg-red-50 px-5 py-8 text-center text-sm text-red-700">
                {error}
                </div>
            ) : filteredBookings.length === 0 ? (
                <div className="flex flex-col items-center justify-center rounded-[28px] border border-dashed border-gray-200 bg-gray-50/70 px-6 py-16 text-center">
                <div className="mb-5 flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-primary">
                    <CalendarHeart size={32} />
                </div>
                <h2 className="text-xl font-bold text-gray-800">
                    {activeTab === 'semua' ? 'Belum ada booking grooming' : 'Belum ada booking di status ini'}
                </h2>
                <p className="mt-2 max-w-md text-sm leading-relaxed text-gray-500">
                    Booking grooming kamu akan muncul di sini setelah dibuat.
                </p>
                {activeTab === 'semua' && (
                <Button
                    to="/grooming/booking"
                    variant="primary"
                    size="md"
                    label="Buat booking"
                    className="mt-5"
                />
                )}
                </div>
            ) : (
                <div className="space-y-4 md:space-y-5">
                {filteredBookings.map((booking) => (
                    <GroomingBookingCard key={booking.id} booking={booking} />
                ))}
                </div>
            )}
            </section>
        </div>
        </div>
    );
}
