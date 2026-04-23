import { GOOGLE_CLIENT_ID } from "../utils/appconfig";

const GOOGLE_IDENTITY_SCRIPT_ID = "google-identity-services";
const GOOGLE_IDENTITY_SCRIPT_SRC = "https://accounts.google.com/gsi/client";

const loadGoogleScript = () =>
  new Promise((resolve, reject) => {
    if (typeof window === "undefined") {
      reject(new Error("Google Sign-In hanya tersedia di browser"));
      return;
    }

    if (window.google?.accounts?.oauth2) {
      resolve(window.google);
      return;
    }

    const existingScript = document.getElementById(GOOGLE_IDENTITY_SCRIPT_ID);

    if (existingScript) {
      existingScript.addEventListener("load", () => resolve(window.google), { once: true });
      existingScript.addEventListener("error", () => reject(new Error("Gagal memuat Google Identity Services")), {
        once: true,
      });
      return;
    }

    const script = document.createElement("script");
    script.id = GOOGLE_IDENTITY_SCRIPT_ID;
    script.src = GOOGLE_IDENTITY_SCRIPT_SRC;
    script.async = true;
    script.defer = true;
    script.onload = () => resolve(window.google);
    script.onerror = () => reject(new Error("Gagal memuat Google Identity Services"));
    document.head.appendChild(script);
  });

export const requestGoogleAccessToken = async () => {
  if (!GOOGLE_CLIENT_ID) {
    throw new Error("Google Client ID belum dikonfigurasi");
  }

  const google = await loadGoogleScript();

  return new Promise((resolve, reject) => {
    const tokenClient = google.accounts.oauth2.initTokenClient({
      client_id: GOOGLE_CLIENT_ID,
      scope: "openid email profile",
      prompt: "select_account",
      callback: (response) => {
        if (response?.access_token) {
          resolve(response.access_token);
          return;
        }

        reject(new Error("Google tidak mengirim access token"));
      },
      error_callback: (error) => {
        reject(new Error(error?.message || "Autentikasi Google dibatalkan"));
      },
    });

    tokenClient.requestAccessToken();
  });
};
