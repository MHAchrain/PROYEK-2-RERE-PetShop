import React from 'react';
import noImage from '../../assets/no-image.png';

export default function ProductGallery({ images, selectedImage, onSelect }) {
  const imageList =
    Array.isArray(images) && images.length > 0 ? images : [noImage];
  const activeImage = selectedImage || imageList[0] || noImage;

  return (
    <div className="flex flex-col-reverse gap-4 sm:flex-row">
      {/* Thumbnail List */}
      {imageList.length > 1 && (
        <div className="flex gap-2 overflow-x-auto sm:flex-col sm:overflow-visible">
          {imageList.map((img, i) => (
            <button
              key={i}
              type="button"
              onClick={() => onSelect(img)}
              className={`relative h-16 w-16 shrink-0 overflow-hidden rounded-xl border-2 transition ${
                activeImage === img
                  ? 'border-primary'
                  : 'border-gray-200 hover:border-gray-300'
              }`}>
              <img
                src={img || noImage}
                alt={`Thumbnail ${i + 1}`}
                loading="lazy"
                onError={(e) => {
                  e.currentTarget.onerror = null;
                  e.currentTarget.src = noImage;
                }}
                className="h-full w-full object-cover"
              />
            </button>
          ))}
        </div>
      )}

      {/* Main Image */}
      <div className="relative aspect-square flex-1 overflow-hidden rounded-3xl border border-gray-100 bg-gray-50 shadow-sm">
        <img
          src={activeImage}
          alt="Foto produk"
          loading="lazy"
          onError={(e) => {
            e.currentTarget.onerror = null;
            e.currentTarget.src = noImage;
          }}
          className="h-full w-full object-cover"
        />
      </div>
    </div>
  );
}
