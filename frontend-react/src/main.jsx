import React from 'react';
import ReactDOM from 'react-dom/client';
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
