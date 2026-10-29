import React, { useState, useRef, useEffect } from 'react';
import {
  MessageCircle,
  X,
  Send,
  Camera,
  Image as ImageIcon,
  ShoppingCart,
  Sparkles,
  Bot,
  ChevronDown,
  Check,
  ShieldAlert,
} from 'lucide-react';
import axios from '../../api/axios';
import { useCart } from '../../context/cartcontext';
import { useAuth } from '../../context/authcontext';
import { getStorageUrl } from '../../utils/appconfig';
import toast from 'react-hot-toast';
import TypewriterText from './TypeWriterText';
import './ChatBot.css';

export default function ChatBot() {
  const [isOpen, setIsOpen] = useState(false);
  const [inputMessage, setInputMessage] = useState('');
  const [selectedImage, setSelectedImage] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [loadingSeconds, setLoadingSeconds] = useState(0);
  const [showPhotoOptions, setShowPhotoOptions] = useState(false);
  const [addingCartId, setAddingCartId] = useState(null);
  const { user } = useAuth();
  const [selectedModel, setSelectedModel] = useState('local'); // 'local' | 'gemini'
  const [showModelMenu, setShowModelMenu] = useState(false);
  const [showLoginModal, setShowLoginModal] = useState(false);
  const [geminiUsage, setGeminiUsage] = useState(null);

  // ← track typing selesai per message ID
  const [typedMessages, setTypedMessages] = useState({});

  const [messages, setMessages] = useState([
    {
      id: 1,
      sender: 'bot',
      text: 'Halo Cat Lovers! 🐾 \n\nSelamat datang di **RERe Petshop**.\n\nSaya **(ARPET) Asisten RERe Petshop**, siap membantu mencarikan produk terbaik untuk anabul kesayangan Anda \n\nAda yang bisa kami bantu carikan hari ini? ',
      products: [],
      time: new Date().toLocaleTimeString([], {
        hour: '2-digit',
        minute: '2-digit',
      }),
      skipTyping: true,
    },
  ]);

  const messagesEndRef = useRef(null);
  const fileGalleryInputRef = useRef(null);
  const fileCameraInputRef = useRef(null);
  const { setCart } = useCart();

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    let timer;
    if (isLoading) {
      setLoadingSeconds(0);
      const startTime = Date.now();
      timer = setInterval(() => {
        setLoadingSeconds(((Date.now() - startTime) / 1000).toFixed(1));
      }, 100);
    } else {
      setLoadingSeconds(0);
    }
    return () => clearInterval(timer);
  }, [isLoading]);

  useEffect(() => {
    if (isOpen) {
      scrollToBottom();
    }
  }, [messages, isOpen, isLoading]);

  const handleImageChange = (e) => {
    const file = e.target.files?.[0];
    if (file) {
      if (!file.type.startsWith('image/')) {
        toast.error('File harus berupa gambar');
        return;
      }
      setSelectedImage(file);
      setImagePreview(URL.createObjectURL(file));
      setShowPhotoOptions(false);
    }
  };

  const removeSelectedImage = () => {
    setSelectedImage(null);
    if (imagePreview) {
      URL.revokeObjectURL(imagePreview);
      setImagePreview(null);
    }
  };

  const handleSendMessage = async (e) => {
    e?.preventDefault();

    if (!inputMessage.trim() && !selectedImage) {
      return;
    }

    // Cek login untuk mode Gemini
    if (selectedModel === 'gemini') {
      const token = localStorage.getItem('token');
      if (!token) {
        setShowLoginModal(true);
        return;
      }
    }

    const currentText = inputMessage.trim();
    const currentImg = selectedImage;
    const currentImgPreview = imagePreview;

    setInputMessage('');
    setSelectedImage(null);
    setImagePreview(null);
    setShowPhotoOptions(false);

    const userMsg = {
      id: Date.now(),
      sender: 'user',
      text: currentText,
      image: currentImgPreview,
      time: new Date().toLocaleTimeString([], {
        hour: '2-digit',
        minute: '2-digit',
      }),
    };

    setMessages((prev) => [...prev, userMsg]);
    setIsLoading(true);

    const startTime = performance.now();

    try {
      const formData = new FormData();
      if (currentText) formData.append('message', currentText);
      if (currentImg) formData.append('image', currentImg);

      const endpoint = selectedModel === 'gemini' ? '/chat-gemini' : '/chat-ai';
      const response = await axios.post(endpoint, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });

      const endTime = performance.now();
      const loadSeconds = ((endTime - startTime) / 1000).toFixed(1);

      if (response.data && response.data.success) {
        if (response.data.usage) {
          setGeminiUsage(response.data.usage);
        }
        const botMsg = {
          id: Date.now() + 1,
          sender: 'bot',
          text:
            response.data.ai_message ||
            'Berikut produk yang cocok untuk anabul Anda:',
          products: response.data.products || [],
          cta: response.data.cta || null, // ← BARU
          mode: response.data.mode,
          loadTime: `${loadSeconds}s`,
          time: new Date().toLocaleTimeString([], {
            hour: '2-digit',
            minute: '2-digit',
          }),
        };
        setMessages((prev) => [...prev, botMsg]);
      } else {
        throw new Error('Gagal mendapatkan balasan AI');
      }
    } catch (err) {
      console.error('Chat AI Error:', err);
      let errorText = 'Maaf, terjadi sedikit kendala koneksi ke AI. Silakan coba kembali sesaat lagi ya Cat Lovers 🐾';
      if (err.response?.status === 429) {
        errorText = err.response?.data?.message || 'Kuota harian Arpet Gemini Anda telah mencapai batas maksimal (10/10). Silakan beralih ke mode Arpet Local!';
      } else if (err.response?.status === 401) {
        setShowLoginModal(true);
        errorText = 'Silakan login terlebih dahulu untuk menggunakan Arpet Gemini.';
      } else if (err.response?.data?.message) {
        errorText = err.response.data.message;
      }
      const errorMsg = {
        id: Date.now() + 1,
        sender: 'bot',
        text: errorText,
        products: [],
        time: new Date().toLocaleTimeString([], {
          hour: '2-digit',
          minute: '2-digit',
        }),
      };
      setMessages((prev) => [...prev, errorMsg]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleAddToCart = async (product) => {
    try {
      setAddingCartId(product.id_produk);
      const res = await axios.post('/cart/add', {
        id_produk: product.id_produk,
        qty: 1,
      });

      if (res.data && res.data.success) {
        toast.success(`${product.nama_produk} dimasukkan ke keranjang! 🛒`);
        try {
          const cartRes = await axios.get('/cart');
          if (cartRes.data && cartRes.data.data) {
            setCart(cartRes.data.data);
          }
        } catch {
          // Token mungkin belum login
        }
      }
    } catch (err) {
      console.error(err);
      if (err.response?.status === 401) {
        toast.error('Silakan login terlebih dahulu untuk menambah keranjang');
      } else {
        toast.error(
          err.response?.data?.message || 'Gagal menambahkan ke keranjang',
        );
      }
    } finally {
      setAddingCartId(null);
    }
  };

  const formatRupiah = (val) => {
    return new Intl.NumberFormat('id-ID', {
      style: 'currency',
      currency: 'IDR',
      minimumFractionDigits: 0,
    }).format(val || 0);
  };

  const renderFormattedMessage = (text) => {
    if (!text) return null;

    const paragraphs = text.split('\n');

    return (
      <div className="rere-text-content">
        {paragraphs.map((para, idx) => {
          if (!para.trim()) {
            return <div key={idx} className="rere-text-spacer" />;
          }

          const parts = para.split(/(\*\*.*?\*\*)/g);
          return (
            <p key={idx} className="rere-text-line">
              {parts.map((part, pIdx) => {
                if (part.startsWith('**') && part.endsWith('**')) {
                  const content = part.slice(2, -2);
                  return (
                    <strong key={pIdx} className="rere-text-bold">
                      {content}
                    </strong>
                  );
                }
                return part;
              })}
            </p>
          );
        })}
      </div>
    );
  };

  // ← callback saat typing selesai
  const handleTypingComplete = (msgId) => {
    setTypedMessages((prev) => ({ ...prev, [msgId]: true }));
  };

  return (
    <>
      <button
        type="button"
        id="rere-chatbot-trigger"
        className="rere-chat-floating-btn"
        onClick={() => setIsOpen(!isOpen)}
        title="Chat dengan AI RERe Petshop">
        {isOpen ? <X size={28} /> : <MessageCircle size={28} />}
        {!isOpen && <span className="rere-chat-floating-badge">ARPET</span>}
      </button>

      {isOpen && (
        <div className="rere-chat-window" id="rere-chat-window">
          <div className="rere-chat-header">
            <div className="rere-chat-header-info">
              <div className="rere-chat-avatar">
                <Bot size={22} />
              </div>
              <div>
                <div className="rere-chat-title">ARPET</div>
                <div className="rere-chat-status">
                  <span className="rere-chat-status-dot"></span>
                  Online
                </div>
              </div>
            </div>
            <button
              type="button"
              className="rere-chat-header-close"
              onClick={() => setIsOpen(false)}
              title="Tutup Chat">
              <X size={20} />
            </button>
          </div>

          <div className="rere-chat-messages">
            {messages.map((msg) => {
              const isBot = msg.sender === 'bot';
              const shouldType =
                isBot && !msg.skipTyping && !typedMessages[msg.id];
              const typingDone = msg.skipTyping || typedMessages[msg.id];

              return (
                <div key={msg.id} className={`rere-message-row ${msg.sender}`}>
                  <div className={`rere-bubble ${msg.sender}`}>
                    {msg.image && (
                      <img
                        src={msg.image}
                        alt="Upload Anabul"
                        className="rere-bubble-image-preview"
                      />
                    )}

                    {shouldType ? (
                      <div className="rere-text-content">
                        <p className="rere-text-line">
                          <TypewriterText
                            text={msg.text}
                            speed={15}
                            onComplete={() => handleTypingComplete(msg.id)}
                          />
                        </p>
                      </div>
                    ) : (
                      renderFormattedMessage(msg.text)
                    )}

                    {/* CTA Button — muncul setelah typing selesai */}
                    {msg.cta && typingDone && (
                      <a href={msg.cta.url} className="rere-cta-button">
                        {msg.cta.text} →
                      </a>
                    )}

                    {msg.products && msg.products.length > 0 && typingDone && (
                      <div className="rere-product-recommendations">
                        {msg.products.map((prod) => {
                          const imgSrc =
                            prod.foto_base64 ||
                            getStorageUrl(prod.foto) ||
                            'https://placehold.co/100x100?text=Produk';
                          return (
                            <div
                              key={prod.id_produk}
                              className="rere-product-card">
                              <img
                                src={imgSrc}
                                alt={prod.nama_produk}
                                className="rere-product-img"
                                onError={(e) => {
                                  e.currentTarget.src =
                                    'https://placehold.co/100x100?text=Produk';
                                }}
                              />
                              <div className="rere-product-info">
                                <div
                                  className="rere-product-name"
                                  title={prod.nama_produk}>
                                  {prod.nama_produk}
                                </div>
                                <div className="rere-product-price">
                                  {formatRupiah(prod.harga)}
                                </div>
                              </div>
                              <button
                                type="button"
                                className="rere-btn-add-cart"
                                disabled={addingCartId === prod.id_produk}
                                onClick={() => handleAddToCart(prod)}
                                title="Tambah ke Keranjang">
                                <ShoppingCart size={13} />
                                <span>
                                  {addingCartId === prod.id_produk
                                    ? '...'
                                    : '+'}
                                </span>
                              </button>
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>
                  <div className="rere-message-meta">
                    <span className="rere-message-time">{msg.time}</span>
                    {msg.loadTime && (
                      <span className="rere-message-duration">
                        · {msg.loadTime}
                      </span>
                    )}
                  </div>
                </div>
              );
            })}

            {isLoading && (
              <div className="rere-message-row bot">
                <div className="rere-loading-wrapper">
                  <div className="rere-loading-dots">
                    <span className="rere-dot"></span>
                    <span className="rere-dot"></span>
                    <span className="rere-dot"></span>
                  </div>
                  <span className="rere-loading-timer">{loadingSeconds}s</span>
                </div>
              </div>
            )}

            <div ref={messagesEndRef} />
          </div>

          {imagePreview && (
            <div className="rere-preview-bar">
              <div className="rere-preview-info">
                <img
                  src={imagePreview}
                  alt="Preview"
                  className="rere-preview-thumbnail"
                />
                <span className="rere-preview-text">
                  Foto anabul siap dianalisis
                </span>
              </div>
              <button
                type="button"
                className="rere-preview-remove"
                onClick={removeSelectedImage}
                title="Hapus foto">
                <X size={16} />
              </button>
            </div>
          )}

          {showPhotoOptions && (
            <div className="rere-photo-options-popup">
              <button
                type="button"
                className="rere-photo-option-btn"
                onClick={() => {
                  fileGalleryInputRef.current?.click();
                }}>
                <ImageIcon size={16} />
                Pilih dari Galeri
              </button>
              <button
                type="button"
                className="rere-photo-option-btn"
                onClick={() => {
                  fileCameraInputRef.current?.click();
                }}>
                <Camera size={16} />
                Ambil Foto Kamera
              </button>
            </div>
          )}

          <input
            type="file"
            ref={fileGalleryInputRef}
            accept="image/*"
            style={{ display: 'none' }}
            onChange={handleImageChange}
          />
          <input
            type="file"
            ref={fileCameraInputRef}
            accept="image/*"
            capture="environment"
            style={{ display: 'none' }}
            onChange={handleImageChange}
          />

          {/* Modal Popup Pilihan Model (Tema Gelap Persis Screenshot) */}
          {showModelMenu && (
            <div className="rere-model-picker-overlay" onClick={() => setShowModelMenu(false)}>
              <div className="rere-model-picker-card" onClick={(e) => e.stopPropagation()}>
                <div className="rere-model-picker-header">Model</div>
                
                {/* Opsi 1: Gemini */}
                <div
                  className={`rere-model-row ${selectedModel === 'gemini' ? 'selected' : ''}`}
                  onClick={() => {
                    const token = localStorage.getItem('token');
                    if (!token) {
                      setShowModelMenu(false);
                      setShowLoginModal(true);
                    } else {
                      setSelectedModel('gemini');
                      setShowModelMenu(false);
                    }
                  }}>
                  <div className="rere-model-title-group">
                    <span className="rere-model-title">Gemini 2.5 Flash</span>
                    <span className="rere-model-badge-quota">Wajib Login</span>
                  </div>
                  {selectedModel === 'gemini' && (
                    <span className="rere-model-checkmark">&#10003;</span>
                  )}
                </div>

                {/* Opsi 2: Local (Ollama) */}
                <div
                  className={`rere-model-row ${selectedModel === 'local' ? 'selected' : ''}`}
                  onClick={() => {
                    setSelectedModel('local');
                    setShowModelMenu(false);
                  }}>
                  <div className="rere-model-title-group">
                    <span className="rere-model-title">Arpet Local (Ollama)</span>
                    <span className="rere-model-badge-free">Bebas Akses</span>
                  </div>
                  {selectedModel === 'local' && (
                    <span className="rere-model-checkmark">&#10003;</span>
                  )}
                </div>
              </div>
            </div>
          )}

          {/* Modal Popup Silakan Login */}
          {showLoginModal && (
            <div className="rere-login-modal-overlay">
              <div className="rere-login-modal-card">
                <div className="rere-login-modal-icon">
                  <ShieldAlert size={28} />
                </div>
                <h4 className="rere-login-modal-title">Silakan Login</h4>
                <p className="rere-login-modal-desc">
                  Mode <b>Gemini Flash</b> memerlukan login akun untuk membatasi kuota gratis (maks. 10x per hari). Kamu tetap bisa memakai <b>Arpet Local</b> secara bebas tanpa login!
                </p>
                <div className="rere-login-modal-actions">
                  <button
                    type="button"
                    className="rere-btn-login-cancel"
                    onClick={() => {
                      setShowLoginModal(false);
                      setSelectedModel('local');
                    }}>
                    Pakai Local
                  </button>
                  <a href="/auth" className="rere-btn-login-confirm">
                    Login Sekarang
                  </a>
                </div>
              </div>
            </div>
          )}

          {/* Wrapper Bawah: Bar Model Selector Dropdown + Form Chat */}
          <div className="rere-chat-bottom-wrapper">
            <div className="rere-model-selector-bar">
              <button
                type="button"
                className="rere-model-dropdown-trigger"
                onClick={() => setShowModelMenu(!showModelMenu)}>
                <span className="rere-model-current-name">
                  {selectedModel === 'gemini' ? 'Gemini 2.5 Flash' : 'Arpet Local (Ollama)'}
                </span>
                <span className="rere-model-current-sub">
                  {selectedModel === 'gemini'
                    ? (geminiUsage ? `Sisa: ${geminiUsage.remaining}/10` : 'Wajib Login (10x/hari)')
                    : 'Bebas Kuota'}
                </span>
                <ChevronDown size={14} className="rere-model-chevron" />
              </button>
            </div>

            <form className="rere-chat-input-area" onSubmit={handleSendMessage}>
              <button
                type="button"
                className="rere-btn-camera"
                onClick={() => setShowPhotoOptions(!showPhotoOptions)}
                title="Kirim Foto Anabul">
                <Camera size={19} />
              </button>

              <input
                type="text"
                className="rere-chat-input"
                placeholder="Tanya produk / anabul..."
                value={inputMessage}
                onChange={(e) => setInputMessage(e.target.value)}
                disabled={isLoading}
              />

              <button
                type="submit"
                className="rere-btn-send"
                disabled={isLoading || (!inputMessage.trim() && !selectedImage)}
                title="Kirim Pesan">
                <Send size={16} />
              </button>
            </form>
          </div>
        </div>
      )}
    </>
  );
}
