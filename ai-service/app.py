import os
import io
import re
from typing import Optional
from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from PIL import Image
from google import genai
from google.genai import types

from model.recommender import RuleEngine

# Load Environment Variables
load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")

# Initialize FastAPI
app = FastAPI(title="RERe PetShop AI Service", version="1.0.0")

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Rule Engine
rule_engine = RuleEngine()

# Initialize Gemini Client if API Key is available
gemini_client = None
if GEMINI_API_KEY and GEMINI_API_KEY != "your_api_key_here":
    gemini_client = genai.Client(api_key=GEMINI_API_KEY)

SYSTEM_INSTRUCTION = (
    "Kamu asisten AI RERe Petshop, toko produk khusus kucing. Fokus produk kucing.\n"
    "Dari gambar: deteksi usia (kitten/adult/senior), kondisi bulu (sehat/rontok/kusam/lebat), dan ukuran kucing.\n"
    "Dari teks: tangkap pertanyaan atau kebutuhan user.\n"
    "Kasih rekomendasi produk yang tepat untuk kucing tersebut.\n"
    "Tolak dengan sopan pertanyaan di luar topik kucing.\n\n"
    "Format jawaban WAJIB mengikuti struktur ini:\n"
    "[ANALISIS]\n"
    "Dari gambar: [usia, kondisi bulu, ukuran]\n"
    "Dari teks: [kebutuhan user]\n\n"
    "[REKOMENDASI]\n"
    "- [Nama Produk/Kategori Produk] -> cocok karena [alasan singkat]\n"
    "- [Nama Produk/Kategori Produk] -> cocok karena [alasan singkat]\n\n"
    "[KEYWORD]\n"
    "keyword1, keyword2, keyword3"
)


class TextChatRequest(BaseModel):
    message: str


def parse_gemini_response(response_text: str):
    """
    Ekstrak teks analisis, rekomendasi, dan keywords dari format standar Gemini.
    """
    keywords = []
    
    # Cari bagian [KEYWORD]
    keyword_match = re.search(r'\[KEYWORD\]\s*(.+)', response_text, re.DOTALL | re.IGNORECASE)
    if keyword_match:
        kw_line = keyword_match.group(1).strip()
        # Ambil baris pertama atau pisahkan berdasarkan koma / baris baru
        kw_items = re.split(r'[\n,]+', kw_line)
        keywords = [k.strip() for k in kw_items if k.strip() and not k.strip().startswith('[')]
    
    if not keywords:
        # Fallback keywords jika tidak terdeteksi
        words = [w for w in re.findall(r'\b\w{3,}\b', response_text.lower()) if w not in [
            "dari", "gambar", "teks", "karena", "cocok", "untuk", "kucing", "analisis", "rekomendasi", "keyword"
        ]]
        keywords = words[:3] if words else ["kucing", "makanan"]

    return {
        "reply": response_text.strip(),
        "keywords": keywords
    }


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "RERe PetShop AI Service",
        "gemini_configured": bool(gemini_client)
    }


@app.post("/api/chat")
def chat_text(request: TextChatRequest):
    """
    Mode 1: Mode TEKS -> Rule-Based (GRATIS, Cepat, Tanpa kuota API)
    """
    if not request.message or not request.message.strip():
        raise HTTPException(status_code=400, detail="Pesan tidak boleh kosong")

    result = rule_engine.extract_keywords(request.message)

    return {
        "mode": "rule_based",
        "message": result["response"],
        "brands": result["brands"],
        "keywords": result["keywords"],
        "categories": result["categories"],
        "conditions": result["conditions"],
        "age_group": result["age_group"],
        "min_price": result.get("min_price"),
        "max_price": result.get("max_price"),
        "target_price": result.get("target_price"),
        "price_mode": result.get("price_mode")
    }


@app.post("/api/chat-with-image")
async def chat_with_image(
    message: Optional[str] = Form(""),
    image: Optional[UploadFile] = File(None)
):
    """
    Mode 2: Mode GAMBAR -> Gemini API Vision
    Jika tidak ada gambar, otomatis fallback ke Rule-Based.
    """
    user_prompt = (message or "").strip()

    # Jika TIDAK ADA gambar -> Langsung gunakan Rule-Based
    if image is None or not image.filename:
        if not user_prompt:
            raise HTTPException(status_code=400, detail="Mohon kirimkan pesan teks atau foto anabul")
        
        result = rule_engine.extract_keywords(user_prompt)
        return {
            "mode": "rule_based",
            "message": result["response"],
            "brands": result["brands"],
            "keywords": result["keywords"],
            "categories": result["categories"],
            "conditions": result["conditions"],
            "age_group": result["age_group"],
            "min_price": result.get("min_price"),
            "max_price": result.get("max_price"),
            "target_price": result.get("target_price"),
            "price_mode": result.get("price_mode")
        }

    # Jika ADA gambar -> Gunakan Gemini API Vision
    global gemini_client
    if not gemini_client:
        # Coba inisialisasi ulang jika env baru saja diisi
        load_dotenv()
        key = os.getenv("GEMINI_API_KEY", "")
        if key and key != "your_api_key_here":
            gemini_client = genai.Client(api_key=key)

    if not gemini_client:
        # Fallback jika API key belum diisi pengguna
        result = rule_engine.extract_keywords(user_prompt if user_prompt else "kucing")
        return {
            "mode": "rule_based_fallback",
            "message": (
                "🐾 Gambar anabul berhasil diterima!\n\n"
                "(Catatan: Gemini API Key belum dikonfigurasi di ai-service/.env, beralih ke Rule-Based).\n\n"
                + result["response"]
            ),
            "keywords": result["keywords"],
            "categories": result["categories"],
            "age_group": result["age_group"]
        }

    try:
        # Baca data gambar
        contents = await image.read()
        pil_image = Image.open(io.BytesIO(contents))

        prompt = user_prompt if user_prompt else "Analisis foto kucing ini dan berikan rekomendasi produk yang cocok."

        # Panggil Gemini API menggunakan google-genai SDK v1.2.0
        response = gemini_client.models.generate_content(
            model='gemini-2.5-flash',
            contents=[pil_image, prompt],
            config=types.GenerateContentConfig(
                system_instruction=SYSTEM_INSTRUCTION,
                temperature=0.7,
            )
        )

        response_text = response.text or ""
        parsed = parse_gemini_response(response_text)

        return {
            "mode": "gemini_vision",
            "message": parsed["reply"],
            "keywords": parsed["keywords"]
        }

    except Exception as e:
        # Error handling & fallback aman
        result = rule_engine.extract_keywords(user_prompt if user_prompt else "kucing")
        return {
            "mode": "gemini_error_fallback",
            "message": (
                f"🐾 Maaf, terjadi kendala saat memproses gambar dengan AI: {str(e)}\n\n"
                "Berikut rekomendasi berdasarkan katalog produk kami:\n"
                + result["response"]
            ),
            "keywords": result["keywords"],
            "categories": result["categories"],
            "age_group": result["age_group"]
        }


if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8001))
    uvicorn.run("app:app", host="0.0.0.0", port=port, reload=True)
