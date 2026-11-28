import React from 'react';
import ReactDOM from 'react-dom/client';

// Lazy-load Midtrans Snap setelah render awal agar tidak membebani initial load
setTimeout(() => {
  if (!document.querySelector('script[src*="midtrans.com/snap/snap.js"]')) {
    const s = document.createElement('script');
    s.src = 'https://app.sandbox.midtrans.com/snap/snap.js';
    s.setAttribute('data-client-key', 'Mid-client-kbF8O_OJSIc1ljLp');
    s.async = true;
    document.head.appendChild(s);
  }
}, 3500);
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
