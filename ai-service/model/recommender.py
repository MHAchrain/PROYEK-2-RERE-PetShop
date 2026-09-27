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
        Mendeteksi nominal dan intensi harga dari teks secara cerdas:
        - Rentang harga: "20000 sampai 40000", "20rb - 40rb", "20k-40k", "antara 20rb dan 40rb" -> mode: range
        - Plafon budget: "maksimal 50rb", "budget 50rb", "di bawah 30rb", "max 25k" -> mode: max
        - Batas bawah: "minimal 20rb", "di atas 30k", "mulai dari 20rb" -> mode: min
        - Harga pas: "harga 20000", "20rb", "yang 20k", "pas 20.000" -> mode: exact
        """
        text_lower = text.lower()

        # 1. Pattern A: min X max Y (contoh: min 20k max 40k)
        m_minmax = re.search(
            r'(?:min|minimal)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?\s*(?:sampai|hingga|dan|-|,)?\s*(?:max|maks|maksimal)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?',
            text_lower
        )
        if m_minmax:
            n1 = float(m_minmax.group(1).replace(',', '.'))
            u1 = m_minmax.group(2)
            n2 = float(m_minmax.group(3).replace(',', '.'))
            u2 = m_minmax.group(4)
            if not u1 and u2 and n1 < 1000:
                u1 = u2
            v1 = int(n1 * 1000) if u1 in ['k', 'rb', 'ribu'] or (n1 < 1000 and not u1 and n1 < 500) else int(n1)
            v2 = int(n2 * 1000) if u2 in ['k', 'rb', 'ribu'] or (n2 < 1000 and not u2 and n2 < 500) else int(n2)
            if v1 > v2:
                v1, v2 = v2, v1
            return {"mode": "range", "min_price": v1, "max_price": v2, "target_price": v2, "price": v2}

        # 2. Pattern B: antara X dan/sampai Y (contoh: antara 20.000 dan 40.000)
        m_antara = re.search(
            r'antara\s+(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?\s*(?:dan|sampai|hingga|-)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?',
            text_lower
        )
        if m_antara:
            n1 = float(m_antara.group(1).replace(',', '.'))
            u1 = m_antara.group(2)
            n2 = float(m_antara.group(3).replace(',', '.'))
            u2 = m_antara.group(4)
            if not u1 and u2 and n1 < 1000:
                u1 = u2
            v1 = int(n1 * 1000) if u1 in ['k', 'rb', 'ribu'] or (n1 < 1000 and not u1 and n1 < 500) else int(n1)
            v2 = int(n2 * 1000) if u2 in ['k', 'rb', 'ribu'] or (n2 < 1000 and not u2 and n2 < 500) else int(n2)
            if v1 > v2:
                v1, v2 = v2, v1
            return {"mode": "range", "min_price": v1, "max_price": v2, "target_price": v2, "price": v2}

        # 3. Pattern C: X (sampai|sd|s/d|hingga|ke|-) Y (contoh: harga 20000 sampai 40000, 20rb - 40rb, 20k-40k)
        m_range = re.search(
            r'(?:harga|budget|kisaran|rentang)?\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?\s*(?:sampai|hingga|s\/d|sd|ke|-|–)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?',
            text_lower
        )
        if m_range:
            n1_str = m_range.group(1).replace(',', '.')
            u1 = m_range.group(2)
            n2_str = m_range.group(3).replace(',', '.')
            u2 = m_range.group(4)

            clean1 = m_range.group(1).replace('.', '')
            clean2 = m_range.group(3).replace('.', '')

            if clean1.isdigit() and int(clean1) >= 1000:
                v1 = int(clean1)
            else:
                try:
                    v1_f = float(n1_str)
                    v1 = int(v1_f * 1000) if u1 or (u2 and v1_f < 1000) else int(v1_f)
                except ValueError:
                    v1 = None

            if clean2.isdigit() and int(clean2) >= 1000:
                v2 = int(clean2)
            else:
                try:
                    v2_f = float(n2_str)
                    v2 = int(v2_f * 1000) if u2 or (u1 and v2_f < 1000) else int(v2_f)
                except ValueError:
                    v2 = None

            if v1 is not None and v2 is not None and v1 >= 1000 and v2 >= 1000:
                if v1 > v2:
                    v1, v2 = v2, v1
                return {"mode": "range", "min_price": v1, "max_price": v2, "target_price": v2, "price": v2}

        # 4. Pattern Intensi Minimal / Di Atas
        is_min_intent = bool(re.search(r'\b(minimal|min|di atas|diatas|lebih dari|paling murah|mulai dari|start)\b', text_lower))
        # Pattern Intensi Maksimal / Plafon
        is_max_intent = bool(re.search(r'\b(maksimal|budget|max|di bawah|dibawah|kurang dari|paling mahal|mentok|maks)\b', text_lower))

        # 5. Deteksi Single Price
        val = None
        # Format k / rb / ribu (contoh: 20k, 25rb, 30 ribu)
        m_single_k = re.search(r'(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)\b', text_lower)
        if m_single_k:
            try:
                val = int(float(m_single_k.group(1).replace(',', '.')) * 1000)
            except ValueError:
                pass

        # Format ribuan lengkap (contoh: 20.000, 20000)
        if val is None:
            m_single_full = re.search(r'(?:rp\.?\s*)?(\d{1,3}(?:\.\d{3})+|\d{4,7})\b', text_lower)
            if m_single_full:
                clean = m_single_full.group(1).replace('.', '')
                if clean.isdigit() and int(clean) >= 1000:
                    val = int(clean)

        if val is None:
            return {"mode": None, "min_price": None, "max_price": None, "target_price": None, "price": None}

        if is_min_intent:
            return {"mode": "min", "min_price": val, "max_price": None, "target_price": val, "price": val}
        elif is_max_intent:
            return {"mode": "max", "min_price": None, "max_price": val, "target_price": val, "price": val}
        else:
            return {"mode": "exact", "min_price": None, "max_price": None, "target_price": val, "price": val}

    def extract_keywords(self, text: str) -> Dict[str, Any]:
        text_lower = text.lower()
        
        detected_brands = []
        detected_categories = []
        detected_conditions = []
        detected_age = None
        price_info = self.parse_budget(text)
        detected_price = price_info.get("target_price")
        min_price = price_info.get("min_price")
        max_price = price_info.get("max_price")
        price_mode = price_info.get("mode")
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
            "berapa", "apa", "saja", "mana", "terbaik", "murah", "bagus", "pas", "sampai", "sd", "s/d",
            "antara", "hingga", "min", "minimal", "rekomendasikan", "kasih"
        }
        words = [w for w in re.findall(r'\b[a-zA-Z]{3,}\b', text_lower) if w not in stop_words]
        for w in words:
            if w not in keywords:
                keywords.append(w)

        if not keywords:
            keywords = ["kucing", "makanan"]

        # Susun balasan teks yang cerdas, ramah, dan komunikatif layaknya pet consultant ahli
        response_message = self.generate_response(
            text_lower,
            detected_brands,
            detected_categories,
            detected_age,
            detected_conditions,
            min_price,
            max_price,
            detected_price,
            price_mode
        )

        return {
            "brands": detected_brands,
            "categories": detected_categories,
            "conditions": detected_conditions,
            "age_group": detected_age,
            "min_price": min_price,
            "max_price": max_price,
            "target_price": detected_price,
            "price_mode": price_mode,
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
        min_price: Optional[int],
        max_price: Optional[int],
        price: Optional[int],
        price_mode: Optional[str]
    ) -> str:
        # 1. Sapaan umum ramah
        greetings = ["halo", "hai", "selamat pagi", "selamat siang", "selamat sore", "selamat malam", "assalamualaikum", "hi", "p", "siang", "pagi", "sore", "malam"]
        words_count = len(text.split())
        if any(greet in text for greet in greetings) and words_count <= 2:
            return (
                "Halo Cat Lovers! 🐾 Selamat datang di **RERe Petshop**.\n\n"
                "Ada yang bisa kami bantu carikan untuk anabul kesayangan hari ini? "
                "Kakak bisa sebutkan usia kucing, jenis makanan, keluhan bulu/kesehatan, atau rentang budget yang diinginkan ya! 🐱✨"
            )

        # 2. Pertanyaan di luar kucing
        non_cat = ["anjing", "burung", "ikan cupang", "hamster", "reptil", "kelinci", "ular"]
        if any(animal in text for animal in non_cat):
            return (
                "Mohon maaf ya Kak 🐾 Saat ini **RERe Petshop** berfokus khusus menyediakan kebutuhan nutrisi, "
                "perawatan, dan perlengkapan untuk anabul **kucing** saja agar perawatannya maksimal! 🐱"
            )

        # Format harga dalam Rupiah
        def format_rp(num: int) -> str:
            return f"Rp {num:,.0f}".replace(',', '.')

        # 3. Bangun pembuka pesan yang natural dan engaging
        intro_phrases = []
        
        # Penjelasan Kategori & Merek
        cat_str = ', '.join([c.title() for c in categories]) if categories else "produk"
        brand_str = ', '.join([b.title() for b in brands]) if brands else ""

        # Kondisi Spesifik Price Framing
        if price_mode == "range" and min_price and max_price:
            if brands:
                intro_phrases.append(f"pilihan {cat_str} merek **{brand_str}** dengan kisaran harga **{format_rp(min_price)} - {format_rp(max_price)}**")
            elif categories:
                intro_phrases.append(f"rekomendasi **{cat_str}** pilihan dengan kisaran harga **{format_rp(min_price)} - {format_rp(max_price)}**")
            else:
                intro_phrases.append(f"rekomendasi produk pilihan di rentang harga **{format_rp(min_price)} - {format_rp(max_price)}**")
        elif price_mode == "max" and max_price:
            if brands:
                intro_phrases.append(f"pilihan {cat_str} **{brand_str}** hemat dengan budget di bawah **{format_rp(max_price)}**")
            elif categories:
                intro_phrases.append(f"rekomendasi **{cat_str}** terbaik dengan budget maksimal **{format_rp(max_price)}**")
            else:
                intro_phrases.append(f"rekomendasi produk terbaik dengan budget maksimal **{format_rp(max_price)}**")
        elif price_mode == "min" and min_price:
            intro_phrases.append(f"pilihan {cat_str} berkualitas mulai dari harga **{format_rp(min_price)}**")
        elif price_mode == "exact" and price:
            intro_phrases.append(f"pilihan {cat_str} pas di harga sekitar **{format_rp(price)}**")
        else:
            if brands:
                intro_phrases.append(f"varian {cat_str} dari merek **{brand_str}**")
            elif categories:
                is_food_related = any(c in ["makanan", "vitamin & susu"] for c in categories)
                adj = "bernutrisi" if is_food_related else "terbaik"
                intro_phrases.append(f"rekomendasi **{cat_str}** {adj}")
            else:
                intro_phrases.append("rekomendasi produk pilihan terbaik dari katalog RERe Petshop")

        # Insight Tambahan Berdasarkan Kebutuhan & Usia
        insights = []
        if age_group == "kitten":
            insights.append("💡 *Khusus untuk si Kitten (anak kucing) yang butuh protein & kalsium tinggi untuk masa pertumbuhan aktif.*")
        elif age_group == "adult":
            insights.append("💡 *Diformulasikan khusus untuk kucing dewasa agar selalu aktif, fit, dan bulunya tetap sehat berkilau.*")
        elif age_group == "senior":
            insights.append("💡 *Kaya nutrisi mudah cerna untuk mendukung daya tahan tubuh kucing senior.*")

        if conditions:
            if "bulu rontok / lebat" in conditions:
                insights.append("✨ *Dilengkapi kandungan Omega 3 & 6 untuk mengurangi bulu rontok dan membuat bulu makin lebat halus.*")
            if "penggemuk / nafsu makan" in conditions:
                insights.append("✨ *Tinggi protein lezat untuk mendongkrak nafsu makan dan menambah berat badan anabul secara sehat.*")
            if "pencernaan / diare" in conditions:
                insights.append("✨ *Aman untuk pencernaan sensitif dan membantu memulihkan kesehatan usus anabul.*")
            if "kutu & jamur" in conditions:
                insights.append("✨ *Formula efektif untuk membasmi parasit, jamur, dan meredakan rasa gatal pada kulit anabul.*")

        # Susun Pesan Akhir
        lines = [
            "Halo Cat Lovers! 🐾",
            f"Berikut {''.join(intro_phrases)} yang cocok untuk anabul kesayangan Anda:"
        ]
        
        if insights:
            lines.extend(insights)

        lines.append("Klik tombol keranjang 🛒 **+** pada produk untuk langsung memesan ya Kak! 🐱✨")

        return "\n\n".join(lines)

