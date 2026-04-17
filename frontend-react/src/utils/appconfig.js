const trimTrailingSlash = (value = "") => value.replace(/\/+$/, "");

const apiOrigin = trimTrailingSlash(
  import.meta.env.VITE_API_URL || "http://127.0.0.1:8000"
);

export const API_BASE_URL = `${apiOrigin}/api`;
export const STORAGE_BASE_URL = `${apiOrigin}/storage`;

export const getStorageUrl = (path) => {
  if (!path) return "";
  if (/^https?:\/\//i.test(path)) return path;
  return `${STORAGE_BASE_URL}/${String(path).replace(/^\/+/, "")}`;
};

export const AUTH_SESSION_EXPIRED_EVENT = "auth:session-expired";
