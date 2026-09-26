import React, { useState, useRef, useEffect } from 'react';
import { 
  MessageCircle, 
  X, 
  Send, 
  Camera, 
  Image as ImageIcon, 
  ShoppingCart, 
  Sparkles,
  Bot
} from 'lucide-react';
import axios from '../../api/axios';
import { useCart } from '../../context/CartContext';
import { getStorageUrl } from '../../utils/appconfig';
import toast from 'react-hot-toast';
import './ChatBot.css';

export default function ChatBot() {
  const [isOpen, setIsOpen] = useState(false);
  const [inputMessage, setInputMessage] = useState('');
  const [selectedImage, setSelectedImage] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [showPhotoOptions, setShowPhotoOptions] = useState(false);
  const [addingCartId, setAddingCartId] = useState(null);

  const [messages, setMessages] = useState([
    {
      id: 1,
      sender: 'bot',
      text: 'Halo Cat Lovers! 🐾 Selamat datang di **RERe Petshop**.\n\nSaya **Asisten AI RERe Petshop**, siap membantu mencarikan produk terbaik untuk anabul kesayangan Anda:\n\n✨ **Konsultasi Teks:** Ketik usia, keluhan bulu, atau budget (misal: *"makanan adult budget 30rb"*)\n📷 **Analisis Foto:** Klik ikon kamera untuk analisis kondisi fisik kucing via Gemini Vision AI!\n\nAda yang bisa kami bantu carikan hari ini? 🐱',
      products: [],
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
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

    const currentText = inputMessage.trim();
    const currentImg = selectedImage;
    const currentImgPreview = imagePreview;

    // Reset input fields
    setInputMessage('');
    setSelectedImage(null);
    setImagePreview(null);
    setShowPhotoOptions(false);

    // Tambahkan pesan pengguna ke chat
    const userMsg = {
      id: Date.now(),
      sender: 'user',
      text: currentText,
      image: currentImgPreview,
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    };

    setMessages((prev) => [...prev, userMsg]);
    setIsLoading(true);

    try {
      const formData = new FormData();
      if (currentText) formData.append('message', currentText);
      if (currentImg) formData.append('image', currentImg);

      const response = await axios.post('/chat-ai', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });

      if (response.data && response.data.success) {
        const botMsg = {
          id: Date.now() + 1,
          sender: 'bot',
          text: response.data.ai_message || 'Berikut produk yang cocok untuk anabul Anda:',
          products: response.data.products || [],
          mode: response.data.mode,
          time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        };
        setMessages((prev) => [...prev, botMsg]);
      } else {
        throw new Error('Gagal mendapatkan balasan AI');
      }
    } catch (err) {
      console.error('Chat AI Error:', err);
      const errorMsg = {
        id: Date.now() + 1,
        sender: 'bot',
        text: 'Maaf, terjadi sedikit kendala koneksi ke AI. Silakan coba kembali sesaat lagi ya Cat Lovers 🐾',
        products: [],
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
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
        // Refresh keranjang jika ada token
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
        toast.error(err.response?.data?.message || 'Gagal menambahkan ke keranjang');
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

    // Split paragraphs
    const paragraphs = text.split('\n');

    return (
      <div className="rere-text-content">
        {paragraphs.map((para, idx) => {
          if (!para.trim()) {
            return <div key={idx} className="rere-text-spacer" />;
          }

          // Parse **bold** markdown
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

  return (
    <>
      {/* Floating Button di Pojok Kanan Bawah */}
      <button
        type="button"
        id="rere-chatbot-trigger"
        className="rere-chat-floating-btn"
        onClick={() => setIsOpen(!isOpen)}
        title="Chat dengan AI RERe Petshop"
      >
        {isOpen ? <X size={28} /> : <MessageCircle size={28} />}
        {!isOpen && <span className="rere-chat-floating-badge">AI</span>}
      </button>

      {/* Chat Window Box */}
      {isOpen && (
        <div className="rere-chat-window" id="rere-chat-window">
          {/* Header */}
          <div className="rere-chat-header">
            <div className="rere-chat-header-info">
              <div className="rere-chat-avatar">
                <Bot size={22} />
              </div>
              <div>
                <div className="rere-chat-title">🐾 AI RERe Petshop</div>
                <div className="rere-chat-status">
                  <span className="rere-chat-status-dot"></span>
                  Online • Siap Rekomendasi
                </div>
              </div>
            </div>
            <button
              type="button"
              className="rere-chat-header-close"
              onClick={() => setIsOpen(false)}
              title="Tutup Chat"
            >
              <X size={20} />
            </button>
          </div>

          {/* Area Pesan Chat */}
          <div className="rere-chat-messages">
            {messages.map((msg) => (
              <div key={msg.id} className={`rere-message-row ${msg.sender}`}>
                <div className={`rere-bubble ${msg.sender}`}>
                  {msg.image && (
                    <img
                      src={msg.image}
                      alt="Upload Anabul"
                      className="rere-bubble-image-preview"
                    />
                  )}
                  {renderFormattedMessage(msg.text)}

                  {/* Tampilkan Daftar Produk Rekomendasi */}
                  {msg.products && msg.products.length > 0 && (
                    <div className="rere-product-recommendations">
                      {msg.products.map((prod) => {
                        const imgSrc = prod.foto_base64 || getStorageUrl(prod.foto) || 'https://placehold.co/100x100?text=Produk';
                        return (
                          <div key={prod.id_produk} className="rere-product-card">
                            <img
                              src={imgSrc}
                              alt={prod.nama_produk}
                              className="rere-product-img"
                              onError={(e) => {
                                e.currentTarget.src = 'https://placehold.co/100x100?text=Produk';
                              }}
                            />
                            <div className="rere-product-info">
                              <div className="rere-product-name" title={prod.nama_produk}>
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
                              title="Tambah ke Keranjang"
                            >
                              <ShoppingCart size={13} />
                              <span>{addingCartId === prod.id_produk ? '...' : '+'}</span>
                            </button>
                          </div>
                        );
                      })}
                    </div>
                  )}
                </div>
                <span className="rere-message-time">{msg.time}</span>
              </div>
            ))}

            {/* Loading Animation Saat AI Mengetik */}
            {isLoading && (
              <div className="rere-message-row bot">
                <div className="rere-loading-dots">
                  <span className="rere-dot"></span>
                  <span className="rere-dot"></span>
                  <span className="rere-dot"></span>
                </div>
              </div>
            )}

            <div ref={messagesEndRef} />
          </div>

          {/* Thumbnail Gambar yang Dipilih Sebelum Dikirim */}
          {imagePreview && (
            <div className="rere-preview-bar">
              <div className="rere-preview-info">
                <img
                  src={imagePreview}
                  alt="Preview"
                  className="rere-preview-thumbnail"
                />
                <span className="rere-preview-text">Foto anabul siap dianalisis</span>
              </div>
              <button
                type="button"
                className="rere-preview-remove"
                onClick={removeSelectedImage}
                title="Hapus foto"
              >
                <X size={16} />
              </button>
            </div>
          )}

          {/* Popup Pilihan Kamera / Galeri */}
          {showPhotoOptions && (
            <div className="rere-photo-options-popup">
              <button
                type="button"
                className="rere-photo-option-btn"
                onClick={() => {
                  fileGalleryInputRef.current?.click();
                }}
              >
                <ImageIcon size={16} />
                Pilih dari Galeri
              </button>
              <button
                type="button"
                className="rere-photo-option-btn"
                onClick={() => {
                  fileCameraInputRef.current?.click();
                }}
              >
                <Camera size={16} />
                Ambil Foto Kamera
              </button>
            </div>
          )}

          {/* Hidden File Inputs */}
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

          {/* Form Input Pesan */}
          <form className="rere-chat-input-area" onSubmit={handleSendMessage}>
            <button
              type="button"
              className="rere-btn-camera"
              onClick={() => setShowPhotoOptions(!showPhotoOptions)}
              title="Kirim Foto Anabul (Mode AI Gemini)"
            >
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
              title="Kirim Pesan"
            >
              <Send size={16} />
            </button>
          </form>
        </div>
      )}
    </>
  );
}
