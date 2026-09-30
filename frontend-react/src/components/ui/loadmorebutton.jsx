import Button from './button';

export default function LoadMoreButton({
  onClick,
  isLoading,
  isShowingAll,
  totalData,
  threshold = 8,
}) {
  // Kalau data sedikit (di bawah batas), tombol tidak perlu muncul.
  if (totalData <= threshold) return null;

  return (
    <div className="flex w-full justify-center">
      <Button
        variant="ghost"
        size="lg"
        onClick={onClick}
        loading={isLoading}
        label={isShowingAll ? 'Tampilkan Lebih Sedikit' : 'Lihat Semua'}
        className="mt-4 min-w-50 shadow-lg"
      />
    </div>
  );
}
