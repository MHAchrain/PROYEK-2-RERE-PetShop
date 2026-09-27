import { useState } from 'react';
import useGroomingBooking from '../../../hooks/usegroomingbooking';

const inputClassName =
  'mt-2 w-full rounded-lg border border-gray-300 bg-white px-4 py-3 text-gray-900 outline-none transition focus:border-primary focus:ring-2 focus:ring-primary/20';

function FormField({ label, name, value, onChange, required = false, ...props }) {
  return (
    <label className="block text-sm font-medium text-gray-700">
      {label}
      <input
        className={inputClassName}
        name={name}
        value={value}
        onChange={onChange}
        required={required}
        {...props}
      />
    </label>
  );
}

export default function GroomingBookingForm() {
  const {
    services,
    slots,
    selectedDate,
    setSelectedDate,
    bookingData,
    updateBookingField,
    loading,
    slotsLoading,
    error,
    submitBooking,
  } = useGroomingBooking();
  const [createdBooking, setCreatedBooking] = useState(null);

  const selectedService = services.find(
    (service) => String(service.id) === String(bookingData.serviceId),
  );

  const handleFieldChange = (event) => {
    updateBookingField(event.target.name, event.target.value);
    setCreatedBooking(null);
  };

  const handleDateChange = (event) => {
    setSelectedDate(event.target.value);
    setCreatedBooking(null);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const booking = await submitBooking();
    if (booking) setCreatedBooking(booking);
  };

  const today = new Date();
  const minimumDate = [
    today.getFullYear(),
    String(today.getMonth() + 1).padStart(2, '0'),
    String(today.getDate()).padStart(2, '0'),
  ].join('-');

  if (createdBooking) {
    return (
      <section className="mx-auto w-full max-w-3xl rounded-2xl border border-green-200 bg-green-50 p-6 md:p-8">
        <h2 className="text-2xl font-bold text-gray-900">Booking berhasil dibuat</h2>
        <p className="mt-2 text-gray-700">
          Booking <span className="font-semibold">{createdBooking.id}</span> tercatat
          dan menunggu pembayaran. Slot belum dianggap terisi sampai pembayaran
          berhasil.
        </p>
        <dl className="mt-6 grid gap-3 text-sm sm:grid-cols-2">
          <div>
            <dt className="text-gray-500">Layanan</dt>
            <dd className="font-medium text-gray-900">{createdBooking.serviceName}</dd>
          </div>
          <div>
            <dt className="text-gray-500">Jadwal</dt>
            <dd className="font-medium text-gray-900">
              {createdBooking.date} pukul {createdBooking.time}
            </dd>
          </div>
          <div>
            <dt className="text-gray-500">Hewan</dt>
            <dd className="font-medium text-gray-900">
              {createdBooking.petName} ({createdBooking.petType})
            </dd>
          </div>
          <div>
            <dt className="text-gray-500">Harga layanan</dt>
            <dd className="font-medium text-gray-900">{createdBooking.price}</dd>
          </div>
        </dl>
        <button
          type="button"
          onClick={() => setCreatedBooking(null)}
          className="mt-6 rounded-lg border border-gray-300 bg-white px-5 py-3 font-semibold text-gray-700 transition hover:bg-gray-50">
          Buat booking lain
        </button>
      </section>
    );
  }

  return (
    <form
      onSubmit={handleSubmit}
      className="mx-auto grid w-full max-w-5xl gap-8 lg:grid-cols-[minmax(0,1fr)_20rem]">
      <div className="space-y-8">
        <section className="rounded-2xl border border-gray-200 bg-white p-6 shadow-sm md:p-8">
          <h2 className="text-xl font-bold text-gray-900">Pilih layanan</h2>
          <p className="mt-1 text-sm text-gray-500">
            Pilih layanan grooming untuk hewanmu.
          </p>
          <label className="mt-5 block text-sm font-medium text-gray-700">
            Layanan grooming
            <select
              className={inputClassName}
              name="serviceId"
              value={bookingData.serviceId}
              onChange={handleFieldChange}
              required>
              <option value="">Pilih layanan</option>
              {services.map((service) => (
                <option key={service.id} value={service.id}>
                  {service.name} — {service.price}
                </option>
              ))}
            </select>
          </label>
        </section>

        <section className="rounded-2xl border border-gray-200 bg-white p-6 shadow-sm md:p-8">
          <h2 className="text-xl font-bold text-gray-900">Data hewan</h2>
          <p className="mt-1 text-sm text-gray-500">
            Isi informasi hewan yang akan dibawa ke toko.
          </p>
          <div className="mt-5 grid gap-5 sm:grid-cols-2">
            <FormField
              label="Nama hewan"
              name="petName"
              value={bookingData.petName}
              onChange={handleFieldChange}
              placeholder="Contoh: Mochi"
              required
            />
            <FormField
              label="Jenis hewan"
              name="petType"
              value={bookingData.petType}
              onChange={handleFieldChange}
              placeholder="Contoh: Kucing"
              required
            />
            <FormField
              label="Ras"
              name="petBreed"
              value={bookingData.petBreed}
              onChange={handleFieldChange}
              placeholder="Contoh: Persia"
              required
            />
            <FormField
              label="Ukuran"
              name="petSize"
              value={bookingData.petSize}
              onChange={handleFieldChange}
              placeholder="Contoh: Kecil"
              required
            />
          </div>
          <label className="mt-5 block text-sm font-medium text-gray-700">
            Catatan tambahan <span className="font-normal text-gray-400">(opsional)</span>
            <textarea
              className={`${inputClassName} min-h-24 resize-y`}
              name="petNote"
              value={bookingData.petNote}
              onChange={handleFieldChange}
              placeholder="Informasi khusus yang perlu diketahui groomer"
              rows={3}
            />
          </label>
        </section>

        <section className="rounded-2xl border border-gray-200 bg-white p-6 shadow-sm md:p-8">
          <h2 className="text-xl font-bold text-gray-900">Pilih jadwal</h2>
          <label className="mt-5 block text-sm font-medium text-gray-700">
            Tanggal grooming
            <input
              className={inputClassName}
              type="date"
              min={minimumDate}
              value={selectedDate}
              onChange={handleDateChange}
              required
            />
          </label>

          {selectedDate && (
            <div className="mt-5">
              <p className="text-sm font-medium text-gray-700">Slot waktu</p>
              {slotsLoading ? (
                <p className="mt-3 text-sm text-gray-500">Memuat slot...</p>
              ) : slots.length === 0 ? (
                <p className="mt-3 rounded-lg bg-gray-50 p-4 text-sm text-gray-500">
                  Belum ada jadwal untuk tanggal ini. Silakan pilih tanggal lain.
                </p>
              ) : (
                <div className="mt-3 grid grid-cols-2 gap-3 sm:grid-cols-4">
                  {slots.map((slot) => {
                    const isAvailable = slot.booked < slot.capacity;
                    const isSelected = bookingData.time === slot.time;

                    return (
                      <button
                        key={`${slot.date}-${slot.time}`}
                        type="button"
                        disabled={!isAvailable || slotsLoading}
                        onClick={() => {
                          updateBookingField('time', slot.time);
                          setCreatedBooking(null);
                        }}
                        aria-pressed={isSelected}
                        className={`rounded-lg border px-4 py-3 text-sm font-semibold transition ${
                          isSelected
                            ? 'border-primary bg-primary text-white'
                            : isAvailable
                              ? 'border-gray-300 bg-white text-gray-700 hover:border-primary hover:text-primary'
                              : 'cursor-not-allowed border-gray-200 bg-gray-100 text-gray-400'
                        }`}>
                        {slot.time}
                        {/* {!isAvailable && (
                          <span className="mt-1 block text-xs font-normal no-underline">
                            Penuh
                          </span>
                        )} */}
                      </button>
                    );
                  })}
                </div>
              )}
            </div>
          )}
        </section>
      </div>

      <aside className="h-fit rounded-2xl border border-gray-200 bg-white p-6 shadow-sm lg:sticky lg:top-6">
        <h2 className="text-xl font-bold text-gray-900">Ringkasan booking</h2>
        <dl className="mt-5 space-y-4 text-sm">
          <div>
            <dt className="text-gray-500">Layanan</dt>
            <dd className="mt-1 font-medium text-gray-900">
              {selectedService?.name || 'Belum dipilih'}
            </dd>
          </div>
          <div>
            <dt className="text-gray-500">Hewan</dt>
            <dd className="mt-1 font-medium text-gray-900">
              {bookingData.petName || 'Belum diisi'}
              {bookingData.petType ? ` · ${bookingData.petType}` : ''}
            </dd>
          </div>
          <div>
            <dt className="text-gray-500">Jadwal</dt>
            <dd className="mt-1 font-medium text-gray-900">
              {selectedDate || 'Pilih tanggal'}
              {bookingData.time ? ` · ${bookingData.time}` : ''}
            </dd>
          </div>
          <div className="border-t border-gray-100 pt-4">
            <dt className="text-gray-500">Total</dt>
            <dd className="mt-1 text-lg font-bold text-gray-900">
              {selectedService?.price || '—'}
            </dd>
          </div>
        </dl>

        {error && (
          <p role="alert" className="mt-4 rounded-lg bg-red-50 p-3 text-sm text-red-700">
            {error}
          </p>
        )}

        <button
          type="submit"
          disabled={loading || slotsLoading || services.length === 0}
          className="mt-6 w-full rounded-lg bg-primary px-5 py-3 font-semibold text-white transition hover:opacity-90 disabled:cursor-not-allowed disabled:opacity-50">
          {loading ? 'Memproses...' : 'Lanjutkan booking'}
        </button>
        <p className="mt-3 text-xs leading-relaxed text-gray-500">
          Slot baru dianggap terisi setelah pembayaran berhasil.
        </p>
      </aside>
    </form>
  );
}
