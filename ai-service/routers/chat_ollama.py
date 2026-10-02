from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from model.ollama_engine import OllamaEngine
from model.recommender import RuleEngine
from model.helpers import build_rule_response, parse_ai_response


router = APIRouter(prefix="/api", tags=["Mode 1 - Ollama"])
ollama_engine = OllamaEngine(model_name="llama3.2:3b")
rule_engine = RuleEngine()

OFF_TOPIC_KEYWORDS = [
    'politik', 'presiden', 'prabowo', 'jokowi', 'anies', 'ganjar',
    'partai', 'pemilu', 'agama', 'islam', 'kristen', 'hindu', 'buddha',
    'matematika', 'fisika', 'kimia', 'sejarah', 'pancasila', 'pahlawan',
]

GROOMING_KEYWORDS = ['grooming', 'perawatan bulu', 'mandi kucing', 'salon kucing']

REFUSAL_PHRASES = [
    "tidak bisa membantu", "tidak dapat membantu", "saya tidak bisa",
    "saya tidak dapat", "maaf, saya tidak", "tidak bisa menjawab",
]

OFF_TOPIC_REPLY = (
    "Maaf, saya cuma bisa bantu soal produk dan perawatan kucing ya. "
    "Ada yang bisa saya bantu soal anabul Anda? 🐾"
)


class OllamaChatRequest(BaseModel):
    message: str
    history: list = []


@router.post("/chat")
def chat_ollama(request: OllamaChatRequest):
    if not request.message or not request.message.strip():
        raise HTTPException(status_code=400, detail="Pesan tidak boleh kosong")

    message_lower = request.message.lower()

    # ── Cek off-topic (skip Ollama) ──
    if any(kata in message_lower for kata in OFF_TOPIC_KEYWORDS):
        return {
            "mode": "off_topic",
            "message": OFF_TOPIC_REPLY,
            "keywords": [],
        }

    # ── Cek topik grooming → arahkan ke halaman booking ──
    if any(kata in message_lower for kata in GROOMING_KEYWORDS):
        return {
            "mode": "special",
            "message": (
                "Grooming itu perawatan rutin bulu dan kulit kucing, "
                "biar tetap bersih, sehat, dan nggak kusut. "
                "Biasanya dilakukan 2-4 minggu sekali.\n\n"
                "Untuk booking layanan grooming di RERe Petshop, "
                "kamu bisa klik tombol di bawah ini ya. "
                "Pilih paket, isi data anabul, lalu pilih jadwal kunjungan."
            ),
            "keywords": [],
            "cta": {
                "text": "Booking Grooming",
                "url": "https://rerepetshop.biz.id/grooming",
            },
        }

    # ── Panggil Ollama ──
    result = ollama_engine.chat(request.message, history=request.history)

    if not result["success"]:
        rule_result = rule_engine.extract_keywords(request.message)
        return build_rule_response(
            rule_result,
            mode="ollama_error_fallback",
            extra_message=(
                f"🐾 Ollama tidak dapat dihubungi ({result.get('error', 'unknown')}).\n"
                "Beralih ke Rule-Based:\n\n"
            )
        )

    reply = result["reply"]
    reply_lower = reply.lower()

    is_refusal = any(phrase in reply_lower for phrase in REFUSAL_PHRASES)
    has_cat_topic = any(
        kata in reply_lower
        for kata in ['kucing', 'anabul', 'bulu', 'grooming', 'shampoo', 'vitamin', 'makanan']
    )

    if is_refusal and not has_cat_topic:
        return {
            "mode": "off_topic",
            "message": OFF_TOPIC_REPLY,
            "keywords": [],
        }

    parsed = parse_ai_response(reply)
    return {
        "mode": "ollama",
        "message": parsed["reply"],
        "keywords": parsed["keywords"],
    }