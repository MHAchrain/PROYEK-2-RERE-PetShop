import React, { useState } from 'react';
import noImage from '../../assets/no-image.png';

const NGROK_BASE_URL = 'https://tunefully-plummy-iraida.ngrok-free.dev';

export default function NgrokImage({ src, alt, className, style }) {
  const [hasError, setHasError] = useState(false);

  const getCleanUrl = (url) => {
    if (!url) return null;
    if (url.startsWith('data:') || url.startsWith('blob:')) return url;

    // Pastikan path storage diarahkan ke domain ngrok
    if (url.includes('localhost') || url.includes('127.0.0.1')) {
      const pathIndex = url.indexOf('/storage/');
      if (pathIndex !== -1)
        return `${NGROK_BASE_URL}${url.substring(pathIndex)}`;
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      if (url.includes('/storage/')) {
        const pathIndex = url.indexOf('/storage/');
        return `${NGROK_BASE_URL}${url.substring(pathIndex)}`;
      }
      return url;
    }

    const cleanPath = url.startsWith('/') ? url : `/${url}`;
    if (!cleanPath.startsWith('/storage/')) {
      return `${NGROK_BASE_URL}/storage${cleanPath}`;
    }
    return `${NGROK_BASE_URL}${cleanPath}`;
  };

  const finalSrc = getCleanUrl(src);

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
