import React from 'react';
import ReactDOM from 'react-dom/client';

// Lazy-load Midtrans Snap saat user mulai berinteraksi atau langsung di halaman pembayaran/grooming
function ensureMidtransSnap() {
  if (document.querySelector('script[src*="midtrans.com/snap/snap.js"]')) return;
  const s = document.createElement('script');
  s.src = 'https://app.sandbox.midtrans.com/snap/snap.js';
  s.setAttribute('data-client-key', 'Mid-client-kbF8O_OJSIc1ljLp');
  s.async = true;
  document.head.appendChild(s);
}
if (/\/(checkout|payment|orders|grooming)/.test(window.location.pathname)) {
  ensureMidtransSnap();
} else {
  window.addEventListener('pointerdown', ensureMidtransSnap, { once: true, passive: true });
}
import App from './App';
import './styles/index.css';
import { BrowserRouter } from 'react-router-dom';
import { AuthProvider } from './context/authcontext';
import { CartProvider } from './context/cartcontext';
import { GoogleOAuthProvider } from '@react-oauth/google'; // ⬅️ TAMBAHKAN

ReactDOM.createRoot(document.getElementById('root')).render(
  <GoogleOAuthProvider clientId="876505123972-275fabovfuu6pal978bnu7g3gb9kp50t.apps.googleusercontent.com">
    <BrowserRouter>
      <AuthProvider>
        <CartProvider>
          <App />
        </CartProvider>
      </AuthProvider>
    </BrowserRouter>
  </GoogleOAuthProvider>,
);
