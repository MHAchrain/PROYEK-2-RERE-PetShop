export const SEARCH_QUERY_MAX_LENGTH = 80;

export const normalizeSearchQuery = (value = "") =>
  value
    .replace(/\s+/g, " ")
    .replace(/[\u0000-\u001F\u007F]/g, "")
    .trim()
    .slice(0, SEARCH_QUERY_MAX_LENGTH);

