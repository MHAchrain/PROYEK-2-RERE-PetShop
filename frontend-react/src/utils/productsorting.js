export const PRODUCT_SORT_OPTIONS = [
  { value: "recommended", label: "Rekomendasi" },
  { value: "newest", label: "Terbaru" },
  { value: "best-selling", label: "Terlaris" },
  { value: "price-asc", label: "Harga terendah" },
  { value: "price-desc", label: "Harga tertinggi" },
];

export const sortProducts = (products = [], sortBy = "recommended") => {
  const items = [...products];
  if (sortBy === "price-asc") return items.sort((a, b) => Number(a.harga || 0) - Number(b.harga || 0));
  if (sortBy === "price-desc") return items.sort((a, b) => Number(b.harga || 0) - Number(a.harga || 0));
  if (sortBy === "newest") return items.sort((a, b) =>
    new Date(b.created_at || b.createdAt || 0).getTime() - new Date(a.created_at || a.createdAt || 0).getTime()
    || Number(b.id_produk || 0) - Number(a.id_produk || 0));
  if (sortBy === "best-selling") return items.sort((a, b) =>
    Number(b.total_terjual ?? b.terjual ?? b.sold ?? 0) - Number(a.total_terjual ?? a.terjual ?? a.sold ?? 0));
  return items;
};
