import React, { useState } from 'react';
import noImage from '../../assets/no-image.png';

const NGROK_BASE_URL = 'https://tunefully-plummy-iraida.ngrok-free.dev';

export default function NgrokImage({ src, alt, className, style }) {
  const [hasError, setHasError] = useState(false);

  // Format URL + tambahkan bypass query parameter Ngrok
  const getProcessedUrl = (url) => {
    if (!url) return null;
    if (url.startsWith('data:') || url.startsWith('blob:')) return url;

    let fullUrl = url;

    // Ubah localhost / 127.0.0.1 menjadi domain ngrok
    if (url.includes('localhost') || url.includes('127.0.0.1')) {
      const pathIndex = url.indexOf('/storage/');
      if (pathIndex !== -1) {
        fullUrl = `${NGROK_BASE_URL}${url.substring(pathIndex)}`;
      }
    } else if (url.startsWith('http://') || url.startsWith('https://')) {
      if (url.includes('/storage/')) {
        const pathIndex = url.indexOf('/storage/');
        fullUrl = `${NGROK_BASE_URL}${url.substring(pathIndex)}`;
      }
    } else {
      // Path relatif
      const cleanPath = url.startsWith('/') ? url : `/${url}`;
      if (!cleanPath.startsWith('/storage/')) {
        fullUrl = `${NGROK_BASE_URL}/storage${cleanPath}`;
      } else {
        fullUrl = `${NGROK_BASE_URL}${cleanPath}`;
      }
    }

    // Tambahkan query bypass ngrok agar lolos peringatan tanpa fetch CORS
    const separator = fullUrl.includes('?') ? '&' : '?';
    return `${fullUrl}${separator}ngrok-skip-browser-warning=69420`;
  };

  const finalSrc = getProcessedUrl(src);

  if (hasError || !finalSrc) {
    return (
      <img
        src={noImage}
        alt={alt || 'produk'}
        className={className}
        style={style}
      />
    );
  }

  return (
    <img
      src={finalSrc}
      alt={alt || 'produk'}
      loading="lazy"
      onError={() => setHasError(true)}
      className={className}
      style={style}
    />
  );
}
