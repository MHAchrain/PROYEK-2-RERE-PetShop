import re


def build_rule_response(result: dict, mode: str = "rule_based", extra_message: str = "") -> dict:
    """
    Helper: bangun response JSON yang konsisten dari hasil RuleEngine.
    """
    message = result["response"]
    if extra_message:
        message = extra_message + message

    return {
        "mode": mode,
        "message": message,
        "brands": result.get("brands", []),
        "keywords": result.get("keywords", []),
        "categories": result.get("categories", []),
        "conditions": result.get("conditions", []),
        "age_group": result.get("age_group"),
        "min_price": result.get("min_price"),
        "max_price": result.get("max_price"),
        "target_price": result.get("target_price"),
        "price_mode": result.get("price_mode"),
        "sort_by": result.get("sort_by"),
        "cheapest_only": result.get("cheapest_only", False),
        "expensive_only": result.get("expensive_only", False),
        "limit": result.get("limit"),
    }


def parse_ai_response(response_text: str):
    """
    Parse output Ollama.
    Format: jawaban natural + |||KEYWORD: ...
    """
    keywords = []

    # Cari penanda |||KEYWORD:
    keyword_match = re.search(r'\|\|\|KEYWORD:\s*(.+)', response_text, re.IGNORECASE)
    if keyword_match:
        kw_line = keyword_match.group(1).strip()
        kw_items = re.split(r'[\n,]+', kw_line)
        keywords = [k.strip() for k in kw_items if k.strip()]

    # Bersihkan pesan dari baris |||KEYWORD
    clean_reply = re.sub(r'\|\|\|KEYWORD:.*', '', response_text, flags=re.IGNORECASE | re.DOTALL).strip()

    # Fallback kalau nggak ada keyword
    if not keywords:
        words = [w for w in re.findall(r'\b\w{3,}\b', clean_reply.lower()) if w not in [
            "dari", "gambar", "teks", "karena", "cocok", "untuk", "kucing",
            "analisis", "rekomendasi", "keyword", "yang", "dan", "atau", "itu",
            "bisa", "kamu", "butuh", "dengan", "juga", "saja", "kalau"
        ]]
        keywords = words[:3] if words else ["kucing"]

    return {
        "reply": clean_reply,
        "keywords": keywords
    }