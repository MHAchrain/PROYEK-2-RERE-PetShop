import re
from typing import Dict, List, Any, Optional

class RuleEngine:
    def __init__(self):
        # Merek / Brand Populer & Katalog Produk Kucing
        self.brands = [
            "whiskas", "royal canin", "cat choize", "catchoize", "me-o", "meo",
            "excel", "susu top", "top growth", "nico", "bolt", "lezatto", "cleo",
            "omegga", "omega", "maxi", "mister puss", "felibite", "pussbite", "amigo",
            "pro plan", "proplan", "oripet", "friskies", "sheba", "rc", "beauty",
            "kitchen flavour", "markotops", "markot", "super cat", "ciao", "life cat",
            "lifecat", "happy cat", "smartheart", "anabul", "magnum", "taro"
        ]

        # Kategori & keywords spesifik sesuai katalog produk
        self.categories = {
            "makanan": [
                "makan", "makann", "mkan", "makanan", "pakan", "food", "dry food", "wet food", "kibble",
                "snack", "treat", "creamy", "tuna", "salmon", "chicken", "ayam", "ikan",
                "kaleng", "pouch", "biskuit", "daging", "donat", "kering", "basah"
            ],
            "perawatan": [
                "shampo", "shampoo", "sisir", "sabun", "grooming", "parfum", "gunting kuku",
                "spetan", "dot", "dot susu", "tali tuntun", "tali"
            ],
            "perlengkapan": [
                "pasir", "litter", "litter box", "box", "toilet", "tofu", "kandang", "tempat makan", "serokan"
            ],
            "mainan & aksesoris": [
                "main", "mainan", "toy", "bola", "laser", "tongkat", "catnip", "garukan",
                "scratch", "tunnel", "terowongan", "boneka", "kalung", "baju", "baju kucing",
                "pakaian", "kostum", "kucing pintar"
            ],
            "vitamin & susu": [
                "vitamin", "nutrisi", "suplemen", "gemuk", "bulu", "nafsu makan", "minyak ikan",
                "fish oil", "immune", "booster", "lebat", "daya tahan", "susu", "kitten milk"
            ],
            "obat": [
                "obat", "obat-obatan", "kutu", "cacing", "jamur", "tetes mata", "tetes telinga",
                "luka", "diare", "flu", "spray", "mencret", "muntah", "pilek"
            ]
        }
        
        # Usia & keywords
        self.life_stages = {
            "kitten": ["kitten", "anak kucing", "bayi kucing", "kecil", "anakan", "kitik", "1 bulan", "2 bulan", "3 bulan", "4 bulan", "5 bulan", "6 bulan", "7 bulan", "8 bulan", "9 bulan", "10 bulan", "11 bulan"],
            "adult": ["adult", "dewasa", "besar", "indukan", "1 tahun", "2 tahun", "3 tahun", "4 tahun", "5 tahun", "6 tahun"],
            "senior": ["senior", "tua", "lansia", "7 tahun", "8 tahun", "9 tahun", "10 tahun", "11 tahun", "12 tahun"]
        }

        # Kebutuhan / Kondisi spesifik
        self.health_conditions = {
            "bulu rontok / lebat": ["bulu", "rontok", "lebat", "kusam", "gimbal", "hairball", "skin & coat", "coat"],
            "penggemuk / nafsu makan": ["gemuk", "berat badan", "nafsu makan", "kurus", "kurang makan", "gendut", "tambah berat"],
            "pencernaan / diare": ["diare", "mencret", "pencernaan", "sensitif", "muntah", "lambung"],
            "kutu & jamur": ["kutu", "jamur", "gatal", "scabies", "ketombe", "kulit merah"]
        }

    def parse_budget(self, text: str) -> Dict[str, Any]:
        """
        Mendeteksi nominal dan intensi harga dari teks:
        - "harga 20000", "harga 20rb", "yang 20k", "pas 20.000" -> exact: 20000 (mencari tepat di harga itu atau rentang sangat dekat)
        - "maksimal 50rb", "budget 50rb", "di bawah 30rb", "kurang dari 40k", "max 25.000" -> max: 50000 (maksimal/plafon)
        """
        text_lower = text.lower()
        
        # 1. Cek apakah ada indikasi "maksimal / budget / di bawah"
        is_max_intent = bool(re.search(r'\b(maksimal|budget|max|di bawah|dibawah|kurang dari|paling mahal|mentok|maks)\b', text_lower))
        is_exact_intent = bool(re.search(r'\b(harga|pas|tepat|yang harga|yg harga|sekitar)\b', text_lower)) and not is_max_intent

        val = None

        # Format Xrb / Xk / X ribu (contoh: 20rb, 20k, 20 ribu)
        pattern_k = r'(?:budget|harga|di bawah|dibawah|maksimal|max|kurang dari|pas)?\s*(\d+(?:[\.,]\d+)?)\s*(?:rb|k|ribu)\b'
        match_k = re.search(pattern_k, text_lower)
        if match_k:
            num_str = match_k.group(1).replace(',', '.')
            try:
                num = float(num_str)
                val = int(num * 1000)
            except ValueError:
                pass

        # Format nominal lengkap (contoh: 20.000, Rp 20000, 20000)
        if val is None:
            pattern_full = r'(?:budget|harga|rp\.?|di bawah|dibawah|maksimal|max|pas)?\s*(\d{1,3}(?:\.\d{3})+|\d{4,7})\b'
            match_full = re.search(pattern_full, text_lower)
            if match_full:
                clean_str = match_full.group(1).replace('.', '')
                try:
                    parsed_int = int(clean_str)
                    if parsed_int >= 1000:
                        val = parsed_int
                except ValueError:
                    pass

        if val is None:
            return {"price": None, "mode": None}

        # Jika ada kata maksimal / budget / di bawah -> max
        # Jika hanya nominal (seperti 'makanan 25000', '25k', 'harga 25000') -> EXACT
        mode = "max" if is_max_intent else "exact"
        return {"price": val, "mode": mode}

    def extract_keywords(self, text: str) -> Dict[str, Any]:
        text_lower = text.lower()
        
        detected_brands = []
        detected_categories = []
        detected_conditions = []
        detected_age = None
        price_info = self.parse_budget(text)
        detected_price = price_info["price"]
        price_mode = price_info["mode"]
        keywords = []

        # 1. Deteksi Brand/Merek spesifik (Prioritas Utama)
        for brand in self.brands:
            if re.search(r'\b' + re.escape(brand) + r'\b', text_lower):
                detected_brands.append(brand)
                if brand not in keywords:
                    keywords.append(brand)

        # 2. Deteksi fase usia
        for age, age_kws in self.life_stages.items():
            for kw in age_kws:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    detected_age = age
                    if age not in keywords:
                        keywords.append(age)
                    break
            if detected_age:
                break

        # 3. Deteksi kondisi / kebutuhan kesehatan
        for cond_name, cond_kws in self.health_conditions.items():
            for kw in cond_kws:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    if cond_name not in detected_conditions:
                        detected_conditions.append(cond_name)
                    if kw not in keywords:
                        keywords.append(kw)

        # 4. Deteksi kategori kebutuhan
        for cat, kw_list in self.categories.items():
            for kw in kw_list:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    if cat not in detected_categories:
                        detected_categories.append(cat)
                    if kw not in keywords:
                        keywords.append(kw)

        # 5. Ambil kata kunci unik tambahan dari input user
        stop_words = {
            "saya", "mau", "ingin", "cari", "ada", "yang", "untuk", "kucing", "dong", "kak",
            "bisa", "tolong", "buat", "rekomendasi", "ini", "itu", "dan", "atau", "di", "ke",
            "budget", "harga", "ribuan", "ribu", "rb", "k", "max", "maksimal", "punya", "punyaku",
            "berapa", "apa", "saja", "mana", "terbaik", "murah", "bagus", "pas"
        }
        words = [w for w in re.findall(r'\b[a-zA-Z]{3,}\b', text_lower) if w not in stop_words]
        for w in words:
            if w not in keywords:
                keywords.append(w)

        if not keywords:
            keywords = ["kucing", "makanan"]

        # Susun balasan teks yang cerdas & informatif
        response_message = self.generate_response(
            text_lower,
            detected_brands,
            detected_categories,
            detected_age,
            detected_conditions,
            detected_price,
            price_mode
        )

        return {
            "brands": detected_brands,
            "categories": detected_categories,
            "conditions": detected_conditions,
            "age_group": detected_age,
            "target_price": detected_price,
            "price_mode": price_mode,
            "max_price": detected_price,
            "keywords": keywords,
            "response": response_message
        }

    def generate_response(
        self,
        text: str,
        brands: List[str],
        categories: List[str],
        age_group: Optional[str],
        conditions: List[str],
        price: Optional[int],
        price_mode: Optional[str]
    ) -> str:
        # Cek sapaan umum murni
        greetings = ["halo", "hai", "selamat pagi", "selamat siang", "selamat sore", "selamat malam", "assalamualaikum", "hi", "p"]
        words_count = len(text.split())
        if any(greet in text for greet in greetings) and words_count <= 2:
            return "Halo Cat Lovers! 🐾 Selamat datang di RERe Petshop. Ada yang bisa kami bantu carikan untuk anabul kesayangan Anda hari ini? Anda bisa sebutkan usia kucing, masalah bulu/kesehatan, atau budget tertentu! 🐱✨"

        # Cek topik di luar kucing
        non_cat = ["anjing", "burung", "ikan cupang", "hamster", "reptil", "kelinci", "ular"]
        if any(animal in text for animal in non_cat):
            return "Mohon maaf Cat Lovers, RERe Petshop saat ini berfokus khusus menyediakan perlengkapan dan kebutuhan nutrisi untuk anabul kucing saja 🐾"

        parts = []
        parts.append("Halo Cat Lovers! 🐾")
        
        detail_msg = []
        if age_group:
            age_label = "Kitten (Anak Kucing)" if age_group == "kitten" else ("Dewasa (Adult)" if age_group == "adult" else "Senior (Lansia)")
            detail_msg.append(f"usia **{age_label}**")
        
        if conditions:
            detail_msg.append(f"kebutuhan **{', '.join(conditions)}**")

        if categories:
            detail_msg.append(f"kategori **{', '.join(categories).title()}**")

        if brands:
            detail_msg.append(f"merek **{', '.join([b.title() for b in brands])}**")

        if price:
            if price_mode == "exact":
                detail_msg.append(f"harga pas **Rp {price:,.0f}**".replace(',', '.'))
            else:
                detail_msg.append(f"budget maksimal **Rp {price:,.0f}**".replace(',', '.'))

        if detail_msg:
            parts.append(f"Berdasarkan kriteria anabul ({' • '.join(detail_msg)}), berikut produk rekomendasi terbaik untuk Anda:")
        else:
            parts.append("Berikut rekomendasi produk terbaik dari RERe Petshop untuk kebutuhan anabul Anda:")

        parts.append("Klik tombol keranjang 🛒 pada produk untuk langsung memesan ya Cat Lovers! 🐱✨")

        return "\n".join(parts)

