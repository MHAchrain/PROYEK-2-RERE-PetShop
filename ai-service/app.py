import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

from routers import chat_ollama, chat_rule


load_dotenv()

app = FastAPI(title="RERe PetShop AI Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "RERe PetShop AI Service",
        "modes": {
            "mode_1_teks_ollama": "/api/chat",
            "mode_2_teks_rule": "/api/chat-rule",
        },
       "ollama_model": "llama3.2:3b"
    }


# Daftarkan router
app.include_router(chat_ollama.router)   # Mode 1
app.include_router(chat_rule.router)     # Mode 2


if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8001))
    uvicorn.run("app:app", host="0.0.0.0", port=port, reload=True)