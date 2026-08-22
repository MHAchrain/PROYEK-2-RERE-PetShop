import React, { useState, useEffect } from 'react';
import noImage from '../../assets/no-image.png';

export default function NgrokImage({ src, alt, className, style }) {
  // Format URL helper
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

  // Inisialisasi loading langsung dari ketersediaan targetUrl (menghindari setState sinkron di effect)
  const [imgSrc, setImgSrc] = useState(null);
  const [loading, setLoading] = useState(Boolean(targetUrl));

  useEffect(() => {
    let isMounted = true;

    if (!targetUrl) {
      return;
    }

    const img = new Image();
    img.crossOrigin = 'anonymous';
    img.src = targetUrl;

    img.onload = () => {
      if (isMounted) {
        setImgSrc(targetUrl);
        setLoading(false);
      }
    };

    img.onerror = () => {
      if (isMounted) {
        setImgSrc(targetUrl);
        setLoading(false);
      }
    };

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
