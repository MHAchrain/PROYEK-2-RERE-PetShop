import GroomingBookingForm from '../components/section/grooming/groomingbookingform';
import BackButton from '../components/ui/backbutton';
import SectionTitle from '../components/ui/sectiontitle';

export default function GroomingBookingPage() {
  return (
    <main className="min-h-screen grow px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20 print:block">
      <div className="mx-auto w-full max-w-7xl space-y-8">
      <BackButton
        label="Kembali ke informasi grooming"
        to="/grooming"
      />
      <header>
        <SectionTitle
            eyebrow="Booking ke Toko"
            title="Booking grooming"
            description="Isi data hewan dan pilih jadwal yang masih tersedia. Slot akan terisi setelah pembayaran berhasil."
          />
      </header>
      <GroomingBookingForm />
      </div>
    </main>
  );
}
