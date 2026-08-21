import axios from 'axios';
import { API_BASE_URL, AUTH_SESSION_EXPIRED_EVENT } from '../utils/appconfig';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    'ngrok-skip-browser-warning': 'true', // <-- Wajib untuk bypass proteksi ngrok
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  // Memastikan header ngrok selalu terkirim di setiap request
  config.headers['ngrok-skip-browser-warning'] = 'true';

  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401 && localStorage.getItem('token')) {
      window.dispatchEvent(new CustomEvent(AUTH_SESSION_EXPIRED_EVENT));
    }

    return Promise.reject(error);
  },
);

export default api;
