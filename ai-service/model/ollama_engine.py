import ollama


class OllamaEngine:
    def __init__(self, model_name: str = "llama3.2:3b"):
        self.model_name = model_name

    def chat(self, user_message: str, history: list = None) -> dict:
        history = history or []

        system_prompt = (
            "Kamu asisten AI RERe Petshop, toko produk khusus kucing.\n"
            "\n"
            "ATURAN TOPIK (PALING PENTING):\n"
            "Kamu HANYA boleh jawab pertanyaan tentang kucing: produk kucing, "
            "kesehatan kucing, makanan kucing, grooming, aksesoris kucing.\n"
            "\n"
            "Kalau user tanya di LUAR topik kucing (politik, tokoh, berita, agama, "
            "matematika, sejarah, dll):\n"
            "- JANGAN jawab pertanyaan itu.\n"
            "- JANGAN bilang 'saya tidak bisa membantu' atau 'saya tidak dapat membantu'.\n"
            "- JANGAN jelasin alasan panjang.\n"
            "- LANGSUNG balas dengan kalimat ini (PERSIS, jangan diubah):\n"
            "  'Maaf, saya cuma bisa bantu soal produk dan perawatan kucing ya. "
            "Ada yang bisa saya bantu soal anabul Anda? 🐾'\n"
            "- Setelah kalimat itu, JANGAN tambah apapun lagi.\n"
            "\n"
            "ATURAN JAWABAN (kalau on-topic):\n"
            "1. JANGAN pakai [ANALISIS], [REKOMENDASI], [KEYWORD].\n"
            "2. JANGAN pakai tanda kurung siku [ ].\n"
            "3. Penjelasan MAKSIMAL 2 baris.\n"
            "4. Lalu kasih list 2-3 produk. Format: '- Nama Produk = alasan singkat'\n"
            "5. Total jawaban MAKSIMAL 5 baris. JANGAN 1 paragraf panjang.\n"
            "6. Fokus produk kucing aja.\n"
            "7. SELESAIKAN kalimat sampai titik terakhir. JANGAN kepotong di tengah."
            "\n"
            "ATURAN KEYWORD:\n"
            "- Tulis 3-5 keyword SPESIFIK di akhir.\n"
            "- JANGAN tulis kata umum: 'kucing', 'anabul', 'perawatan', 'kesehatan'.\n"
            "- Format: |||KEYWORD: <kata1, kata2, kata3>\n"
            "- Kalau off-topic (nolak), tulis: |||KEYWORD: -\n"
            "\n"
            "Contoh BENAR (on-topic):\n"
            "User: 'apa itu grooming?'\n"
            "Jawab:\n"
            "Grooming itu perawatan rutin bulu kucing, 2-4 minggu sekali.\n"
            "\n"
            "Produk yang cocok:\n"
            "- Shampoo kucing = buat mandi\n"
            "- Sisir bulu = biar nggak kusut\n"
            "- Parfum kucing = bikin wangi\n"
            "\n"
            "|||KEYWORD: shampoo kucing, sisir bulu, parfum kucing\n"
            "\n"
            "Contoh BENAR (off-topic):\n"
            "User: 'siapa prabowo?'\n"
            "Jawab:\n"
            "Maaf, saya cuma bisa bantu soal produk dan perawatan kucing ya. "
            "Ada yang bisa saya bantu soal anabul Anda? 🐾\n"
            "\n"
            "|||KEYWORD: -"
        )

        messages = [{"role": "system", "content": system_prompt}]
        messages.extend(history)
        messages.append({"role": "user", "content": user_message})

        try:
            response = ollama.chat(
                model=self.model_name,
                messages=messages,
                options={
                    'num_predict': 150,
                    'temperature': 0.5,
                    'top_p': 0.9,
                },
                keep_alive='30m',
            )
            return {"success": True, "reply": response["message"]["content"]}
        except Exception as e:
            return {"success": False, "reply": "", "error": str(e)}