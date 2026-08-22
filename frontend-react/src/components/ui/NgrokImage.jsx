import React, { useState, useEffect } from 'react';
import noImage from '../../assets/no-image.png';

export default function NgrokImage({ src, alt, className, style }) {
  const [imageBlobUrl, setImageBlobUrl] = useState(null);
  const [loading, setLoading] = useState(Boolean(src));

  // Otomatis lengkapi path jika backend hanya mengembalikan path relatif
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

  const finalUrl = formatUrl(src);

  useEffect(() => {
    let isMounted = true;

    if (!finalUrl) {
      return;
    }

    // Ambil file gambar dengan header bypass Ngrok
    fetch(finalUrl, {
      headers: {
        'ngrok-skip-browser-warning': 'true',
      },
    })
      .then((res) => {
        if (!res.ok) throw new Error('Gagal memuat gambar');
        return res.blob();
      })
      .then((blob) => {
        if (isMounted) {
          const blobUrl = URL.createObjectURL(blob);
          setImageBlobUrl(blobUrl);
          setLoading(false);
        }
      })
      .catch(() => {
        if (isMounted) {
          setImageBlobUrl(finalUrl);
          setLoading(false);
        }
      });

    return () => {
      isMounted = false;
      if (imageBlobUrl && imageBlobUrl.startsWith('blob:')) {
        URL.revokeObjectURL(imageBlobUrl);
      }
    };
  }, [finalUrl]);

  if (loading) {
    return (
      <div
        className={`animate-pulse bg-slate-200 ${className || ''}`}
        style={style}
      />
    );
  }

  return (
    <img
      src={imageBlobUrl || noImage}
      alt={alt || 'Product image'}
      loading="lazy"
      onError={(event) => {
        event.currentTarget.onerror = null;
        event.currentTarget.src = noImage;
      }}
      className={className}
      style={style}
    />
  );
}
