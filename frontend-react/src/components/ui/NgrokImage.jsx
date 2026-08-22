import React, { useState, useEffect } from 'react';

export default function NgrokImage({ src, alt, className, style }) {
  const [imageBlobUrl, setImageBlobUrl] = useState(null);
  const [loading, setLoading] = useState(Boolean(src));

  useEffect(() => {
    let isMounted = true;

    if (!src) {
      return;
    }

    // Ambil gambar via fetch dengan header bypass ngrok
    fetch(src, {
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
          setImageBlobUrl(URL.createObjectURL(blob));
          setLoading(false);
        }
      })
      .catch(() => {
        if (isMounted) {
          setImageBlobUrl(src);
          setLoading(false);
        }
      });

    return () => {
      isMounted = false;
    };
  }, [src]);

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
      src={imageBlobUrl || src}
      alt={alt || 'Product image'}
      className={className}
      style={style}
    />
  );
}
