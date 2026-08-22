import React, { useState, useEffect, useRef } from 'react';
import noImage from '../../assets/no-image.png';

// Cache in-memory agar gambar tidak di-fetch berulang kali saat re-render
const imageCache = new Map();

export default function NgrokImage({ src, alt, className, style }) {
  const formatUrl = (url) => {
    if (!url) return null;
    if (
      url.startsWith('http://') ||
      url.startsWith('https://') ||
      url.startsWith('data:') ||
      url.startsWith('blob:')
    ) {
      return url;
    }
    const cleanPath = url.startsWith('/') ? url.slice(1) : url;
    return `https://tunefully-plummy-iraida.ngrok-free.dev/${cleanPath}`;
  };

  const targetUrl = formatUrl(src);
  const [imgSrc, setImgSrc] = useState(() =>
    targetUrl ? imageCache.get(targetUrl) || null : null,
  );
  const [loading, setLoading] = useState(
    () => Boolean(targetUrl) && !imageCache.has(targetUrl),
  );
  const objectUrlRef = useRef(null);

  useEffect(() => {
    let isMounted = true;

    // Jika URL kosong atau sudah ada di cache, abaikan fetch
    if (!targetUrl || imageCache.has(targetUrl)) {
      return;
    }

    fetch(targetUrl, {
      headers: {
        'ngrok-skip-browser-warning': 'true',
      },
    })
      .then((res) => {
        if (!res.ok) throw new Error('Gagal memuat gambar');
        return res.blob();
      })
      .then((blob) => {
        if (!isMounted) return;
        const objectUrl = URL.createObjectURL(blob);
        objectUrlRef.current = objectUrl;
        imageCache.set(targetUrl, objectUrl);
        setImgSrc(objectUrl);
        setLoading(false);
      })
      .catch(() => {
        if (isMounted) {
          setImgSrc(null);
          setLoading(false);
        }
      });

    return () => {
      isMounted = false;
    };
  }, [targetUrl]);

  if (loading) {
    return (
      <div
        className={`w-full h-full animate-pulse bg-slate-100 flex items-center justify-center ${className || ''}`}
        style={style}
      />
    );
  }

  return (
    <img
      src={imgSrc || noImage}
      alt={alt || 'produk'}
      loading="lazy"
      onError={(e) => {
        e.currentTarget.onerror = null;
        e.currentTarget.src = noImage;
      }}
      className={className}
      style={style}
    />
  );
}
