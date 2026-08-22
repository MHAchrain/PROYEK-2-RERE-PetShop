import React, { useState } from 'react';

export default function VisitHereModal() {
  const [showModal, setShowModal] = useState(() => {
    return !localStorage.getItem('rere_media_ready');
  });
  const [loading, setLoading] = useState(false);

  const handleIntegrasiClick = () => {
    setLoading(true);

    const iframe = document.createElement('iframe');
    iframe.name = 'ngrok_bypass_frame';
    iframe.style.display = 'none';
    document.body.appendChild(iframe);

    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'https://tunefully-plummy-iraida.ngrok-free.dev';
    form.target = 'ngrok_bypass_frame';

    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'ngrok-skip-browser-warning';
    input.value = 'true';
    form.appendChild(input);

    document.body.appendChild(form);
    form.submit();

    setTimeout(() => {
      localStorage.setItem('rere_media_ready', 'true');
      setShowModal(false);

      if (document.body.contains(form)) document.body.removeChild(form);
      if (document.body.contains(iframe)) document.body.removeChild(iframe);

      window.location.reload();
    }, 1200);
  };

  if (!showModal) return null;

  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        backgroundColor: 'rgba(24, 24, 27, 0.65)',
        backdropFilter: 'blur(4px)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: 99999,
        padding: '20px',
      }}>
      <div
        style={{
          backgroundColor: '#ffffff',
          borderRadius: '16px',
          padding: '24px 20px',
          maxWidth: '360px',
          width: '100%',
          textAlign: 'center',
          border: '1px solid #f1f5f9',
          boxShadow:
            '0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)',
        }}>
        <div style={{ fontSize: '36px', marginBottom: '8px' }}>🐾</div>

        <h3
          style={{
            fontSize: '17px',
            fontWeight: '700',
            color: '#1e293b',
            margin: '0 0 6px',
          }}>
          Sinkronisasi Katalog Produk
        </h3>

        <p
          style={{
            fontSize: '13px',
            color: '#64748b',
            lineHeight: '1.5',
            margin: '0 0 20px',
          }}>
          Hubungkan media server ReRe Petshop untuk memuat gambar produk secara
          otomatis.
        </p>

        {/* Tombol Warna Merah ReRe Petshop */}
        <button
          onClick={handleIntegrasiClick}
          disabled={loading}
          style={{
            width: '100%',
            backgroundColor: loading ? '#991b1b' : '#7f1d1d', // Merah Maroon ReRe
            color: '#ffffff',
            padding: '12px 16px',
            borderRadius: '10px',
            fontWeight: '600',
            fontSize: '13px',
            border: 'none',
            cursor: loading ? 'not-allowed' : 'pointer',
            transition: 'background-color 0.2s ease',
          }}>
          {loading ? 'Menghubungkan Server...' : 'Muat Gambar Sekarang'}
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
            padding: '4px 8px',
          }}>
          Tutup
        </button>
      </div>
    </div>
  );
}
