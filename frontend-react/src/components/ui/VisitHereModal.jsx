import React, { useState } from 'react';

export default function VisitHereModal() {
  const [showModal, setShowModal] = useState(() => {
    return !localStorage.getItem('rere_media_ready');
  });
  const [loading, setLoading] = useState(false);

  const handleIntegrasiClick = () => {
    setLoading(true);

    // 1. Buat iframe tersembunyi
    const iframe = document.createElement('iframe');
    iframe.name = 'ngrok_bypass_frame';
    iframe.style.display = 'none';
    document.body.appendChild(iframe);

    // 2. Buat & submit form POST bypass langsung ke Ngrok
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'https://tunefully-plummy-iraida.ngrok-free.dev';
    form.target = 'ngrok_bypass_frame';

    // Input bypass bawaan sistem Ngrok
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'ngrok-skip-browser-warning';
    input.value = 'true';
    form.appendChild(input);

    document.body.appendChild(form);
    form.submit();

    // 3. Simpan status & reload konten tanpa redirect ke luar
    setTimeout(() => {
      localStorage.setItem('rere_media_ready', 'true');
      setShowModal(false);

      // Bersihkan elemen form & iframe
      document.body.removeChild(form);
      document.body.removeChild(iframe);

      window.location.reload();
    }, 1200);
  };

  if (!showModal) return null;

  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        backgroundColor: 'rgba(15, 23, 42, 0.75)',
        backdropFilter: 'blur(5px)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: 99999,
        padding: '20px',
      }}>
      <div
        style={{
          backgroundColor: '#ffffff',
          borderRadius: '20px',
          padding: '28px 24px',
          maxWidth: '380px',
          width: '100%',
          textAlign: 'center',
          boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.25)',
        }}>
        <div style={{ fontSize: '42px', marginBottom: '10px' }}>🖼️</div>

        <h3
          style={{
            fontSize: '18px',
            fontWeight: '800',
            color: '#0f172a',
            margin: '0 0 8px',
          }}>
          Muat Gambar Katalog
        </h3>

        <p
          style={{
            fontSize: '13px',
            color: '#64748b',
            lineHeight: '1.5',
            margin: '0 0 20px',
          }}>
          Klik tombol di bawah ini untuk langsung menghubungkan dan memuat
          seluruh foto produk.
        </p>

        <button
          onClick={handleIntegrasiClick}
          disabled={loading}
          style={{
            width: '100%',
            backgroundColor: loading ? '#93c5fd' : '#2563eb',
            color: '#ffffff',
            padding: '13px 18px',
            borderRadius: '12px',
            fontWeight: '700',
            fontSize: '14px',
            border: 'none',
            cursor: loading ? 'not-allowed' : 'pointer',
            boxShadow: '0 10px 15px -3px rgba(37, 99, 235, 0.3)',
          }}>
          {loading
            ? '⏳ Memproses Server...'
            : '🚀 Visit Here (Tampilkan Gambar)'}
        </button>

        <button
          onClick={() => setShowModal(false)}
          style={{
            marginTop: '12px',
            background: 'none',
            border: 'none',
            color: '#94a3b8',
            fontSize: '12px',
            cursor: 'pointer',
          }}>
          Nanti saja
        </button>
      </div>
    </div>
  );
}
