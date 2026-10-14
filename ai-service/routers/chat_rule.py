from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from model.recommender import RuleEngine
from model.helpers import build_rule_response


router = APIRouter(prefix="/api", tags=["Mode 2 - Rule Based"])
rule_engine = RuleEngine()


class RuleChatRequest(BaseModel):
    message: str


@router.post("/chat-rule")
def chat_rule(request: RuleChatRequest):
    """
    Mode 2: TEKS -> Rule-Based (GRATIS, Cepat, Tanpa kuota API)
    """
    if not request.message or not request.message.strip():
        raise HTTPException(status_code=400, detail="Pesan tidak boleh kosong")

    result = rule_engine.extract_keywords(request.message)
    return build_rule_response(result, mode="rule_based")