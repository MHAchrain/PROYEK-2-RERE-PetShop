from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from model.ollama_engine import OllamaEngine
from model.recommender import RuleEngine
from model.helpers import build_rule_response, parse_ai_response


router = APIRouter(prefix="/api", tags=["Mode 1 - Ollama"])
ollama_engine = OllamaEngine(model_name="llama3.2:3b")
rule_engine = RuleEngine()   # fallback kalau Ollama mati


class OllamaChatRequest(BaseModel):
    message: str
    history: list = []


@router.post("/chat")
def chat_ollama(request: OllamaChatRequest):
    """
    Mode 1: TEKS -> Ollama (GRATIS, Lokal, Tanpa kuota API)
    """
    if not request.message or not request.message.strip():
        raise HTTPException(status_code=400, detail="Pesan tidak boleh kosong")

    result = ollama_engine.chat(request.message, history=request.history)

    # Fallback ke Rule-Based kalau Ollama error
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

    parsed = parse_ai_response(result["reply"])
    return {
        "mode": "ollama",
        "message": parsed["reply"],
        "keywords": parsed["keywords"]
    }