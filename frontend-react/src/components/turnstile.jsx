import { useEffect, useRef, useImperativeHandle, forwardRef } from 'react';
import { TURNSTILE_SITE_KEY } from '../utils/appconfig';

/**
 * Cloudflare Turnstile CAPTCHA component for React 19.
 * Mendukung explicit rendering, reset otomatis, dan cleanup widget saat unmount.
 */
const Turnstile = forwardRef(function Turnstile(
  {
    siteKey = TURNSTILE_SITE_KEY,
    onVerify,
    onExpire,
    onError,
    action = 'auth',
    theme = 'auto',
    size = 'normal',
    className = '',
  },
  ref
) {
  const containerRef = useRef(null);
  const widgetIdRef = useRef(null);
  const callbacksRef = useRef({ onVerify, onExpire, onError });

  // Update callbacks ref tanpa memicu re-render
  useEffect(() => {
    callbacksRef.current = { onVerify, onExpire, onError };
  }, [onVerify, onExpire, onError]);

  // Expose reset dan remove method ke parent via ref
  useImperativeHandle(ref, () => ({
    reset: () => {
      if (widgetIdRef.current !== null && window.turnstile) {
        try {
          window.turnstile.reset(widgetIdRef.current);
        } catch (e) {
          console.warn('[Turnstile] Gagal me-reset widget:', e);
        }
      }
    },
    remove: () => {
      if (widgetIdRef.current !== null && window.turnstile) {
        try {
          window.turnstile.remove(widgetIdRef.current);
          widgetIdRef.current = null;
        } catch (e) {
          console.warn('[Turnstile] Gagal me-remove widget:', e);
        }
      }
    },
  }));

  useEffect(() => {
    let isCancelled = false;

    // Pastikan siteKey tersedia
    if (!siteKey) {
      console.error('[Turnstile] VITE_TURNSTILE_SITE_KEY tidak ditemukan di environment.');
      return;
    }

    const renderWidget = () => {
      if (isCancelled || !containerRef.current || !window.turnstile) return;

      // Hapus widget lama jika sudah ada
      if (widgetIdRef.current !== null) {
        try {
          window.turnstile.remove(widgetIdRef.current);
        } catch (_) {}
        widgetIdRef.current = null;
      }

      try {
        widgetIdRef.current = window.turnstile.render(containerRef.current, {
          sitekey: siteKey,
          action,
          theme,
          size,
          callback: (token) => {
            if (!isCancelled && callbacksRef.current.onVerify) {
              callbacksRef.current.onVerify(token);
            }
          },
          'expired-callback': () => {
            if (!isCancelled && callbacksRef.current.onExpire) {
              callbacksRef.current.onExpire();
            }
          },
          'error-callback': (errorCode) => {
            if (!isCancelled && callbacksRef.current.onError) {
              callbacksRef.current.onError(errorCode);
            }
          },
        });
      } catch (err) {
        console.error('[Turnstile] Gagal me-render widget:', err);
      }
    };

    // Muat script Cloudflare Turnstile jika belum ada di DOM
    const scriptId = 'cf-turnstile-script';
    let script = document.getElementById(scriptId);

    if (!script) {
      script = document.createElement('script');
      script.id = scriptId;
      script.src = 'https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit';
      script.async = true;
      script.defer = true;
      script.onload = () => {
        if (window.turnstile) {
          renderWidget();
        }
      };
      document.head.appendChild(script);
    } else if (window.turnstile) {
      renderWidget();
    } else {
      script.addEventListener('load', renderWidget);
    }

    return () => {
      isCancelled = true;
      if (widgetIdRef.current !== null && window.turnstile) {
        try {
          window.turnstile.remove(widgetIdRef.current);
        } catch (_) {}
        widgetIdRef.current = null;
      }
    };
  }, [siteKey, action, theme, size]);

  return (
    <div className={`turnstile-wrapper my-2 flex justify-center ${className}`}>
      <div ref={containerRef} />
    </div>
  );
});

export default Turnstile;
