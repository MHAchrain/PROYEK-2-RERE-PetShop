import { useEffect, useRef, useState } from "react";
import { ArrowDownUp, Check, ChevronDown } from "lucide-react";
import { PRODUCT_SORT_OPTIONS } from "../../utils/productsorting";

export default function ProductSortSelect({ value, onChange }) {
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef(null);
  const selectedOption = PRODUCT_SORT_OPTIONS.find((option) => option.value === value) || PRODUCT_SORT_OPTIONS[0];

  useEffect(() => {
    const closeOnOutsideClick = (event) => {
      if (!containerRef.current?.contains(event.target)) setIsOpen(false);
    };
    const closeOnEscape = (event) => {
      if (event.key === "Escape") setIsOpen(false);
    };

    document.addEventListener("mousedown", closeOnOutsideClick);
    document.addEventListener("keydown", closeOnEscape);
    return () => {
      document.removeEventListener("mousedown", closeOnOutsideClick);
      document.removeEventListener("keydown", closeOnEscape);
    };
  }, []);

  return (
    <div className="flex items-center gap-1 text-sm text-gray-600">
      <ArrowDownUp size={16} aria-hidden="true" />
      <span className="whitespace-nowrap">Urutkan:</span>
      <div className="relative" ref={containerRef}>
        <button
          type="button"
          aria-haspopup="listbox"
          aria-expanded={isOpen}
          onClick={() => setIsOpen((open) => !open)}
          className="flex min-w-44 items-center justify-between gap-5 rounded-lg border border-gray-200 bg-white py-2 pl-3 pr-3 text-left text-sm text-gray-800 outline-none transition hover:border-gray-300 focus:border-primary"
        >
          <span>{selectedOption.label}</span>
          <ChevronDown size={16} className={`shrink-0 transition-transform ${isOpen ? "rotate-180" : ""}`} aria-hidden="true" />
        </button>

        {isOpen && (
          <div
            role="listbox"
            aria-label="Urutkan produk"
            className="absolute right-0 z-30 mt-2 w-full overflow-hidden rounded-xl border border-gray-100 bg-white p-1.5 shadow-lg"
          >
            {PRODUCT_SORT_OPTIONS.map((option) => (
              <button
                key={option.value}
                type="button"
                role="option"
                aria-selected={option.value === value}
                onClick={() => {
                  onChange(option.value);
                  setIsOpen(false);
                }}
                className={`flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm transition ${
                  option.value === value ? "bg-primary/10 font-medium text-primary" : "text-gray-700 hover:bg-gray-50"
                }`}
              >
                {option.label}
                {option.value === value && <Check size={15} aria-hidden="true" />}
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
