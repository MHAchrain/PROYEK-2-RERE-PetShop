import re
from typing import Dict, List, Any, Optional

class RuleEngine:
    def __init__(self):
        self.brands = [
            "whiskas", "royal canin", "cat choize", "catchoize", "me-o", "meo",
            "excel", "susu top", "top growth", "nico", "bolt", "lezatto", "cleo",
            "omegga", "omega", "maxi", "mister puss", "felibite", "pussbite", "amigo",
            "pro plan", "proplan", "oripet", "friskies", "sheba", "rc", "beauty",
            "kitchen flavour", "markotops", "markotop", "super cat", "ciao", "life cat",
            "lifecat", "happy cat", "smartheart", "anabul", "magnum", "taro"
        ]

        self.categories = {
            "makanan": ["makan", "makann", "mkan", "makanan", "pakan", "food", "dry food", "wet food", "kibble",
                "snack", "treat", "creamy", "tuna", "salmon", "chicken", "ayam", "ikan",
                "kaleng", "pouch", "biskuit", "daging", "donat", "kering", "basah"],
            "shampo": ["shampo", "shampoo", "sampo", "sampon", "mandi", "sabun", "kondisioner", "conditioner"],
            "obat": ["obat", "obat-obatan", "kutu", "jamur", "gatal", "scabies", "detick", "tetes kutu",
                "tetes mata", "tetes telinga", "luka", "diare", "flu", "spray", "mencret", "muntah", "pilek", "cacing"],
            "parfum": ["parfum", "pewangi", "pengharum", "wangi", "bau", "deodorant"],
            "mainan": ["main", "mainan", "toy", "toys", "bola", "laser", "tongkat", "catnip", "garukan",
                "scratch", "tunnel", "terowongan", "boneka", "kucing pintar"],
            "aksesoris": ["kalung", "baju", "baju kucing", "pakaian", "kostum", "lonceng", "klinting"],
            "pasir": ["pasir", "litter", "pasir gumpal", "tofu", "bentonite", "pasir wangi"],
            "perlengkapan": ["litter box", "box", "toilet", "bak pasir", "kandang", "tempat makan", "tempat minum",
                "serokan", "dot", "dot susu", "spetan", "tali", "tali tuntun", "gunting kuku"],
            "susu": ["susu", "top growth", "kitten milk", "milk"]
        }
        
        self.life_stages = {
            "kitten": ["kitten", "anak kucing", "bayi kucing", "kecil", "anakan", "kitik", "1 bulan", "2 bulan", "3 bulan", "4 bulan", "5 bulan", "6 bulan", "7 bulan", "8 bulan", "9 bulan", "10 bulan", "11 bulan"],
            "adult": ["adult", "dewasa", "besar", "indukan", "1 tahun", "2 tahun", "3 tahun", "4 tahun", "5 tahun", "6 tahun"],
            "senior": ["senior", "tua", "lansia", "7 tahun", "8 tahun", "9 tahun", "10 tahun", "11 tahun", "12 tahun"]
        }

        self.health_conditions = {
            "kutu": ["kutu", "fleas", "detick", "tetes kutu"],
            "jamur": ["jamur", "ringworm", "scabies", "gatal", "kulit merah", "ketombe", "kerak"],
            "bulu rontok": ["bulu rontok", "rontok", "bulu kusam", "gimbal", "hairball", "skin & coat", "coat"],
            "penggemuk / nafsu makan": ["gemuk", "berat badan", "nafsu makan", "kurus", "kurang makan", "gendut", "tambah berat"],
            "pencernaan / diare": ["diare", "mencret", "pencernaan", "sensitif", "muntah", "lambung"],
            "luka / infeksi": ["luka", "infeksi", "borok", "baret", "lecet"],
            "bau / higienis": ["bau", "apek", "pesing", "kotor"]
        }

    def parse_budget(self, text: str) -> Dict[str, Any]:
        text_lower = text.lower()

        # Pattern A: min X max Y
        m_minmax = re.search(
            r'(?:min|minimal)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?\s*(?:sampai|hingga|dan|-|,)?\s*(?:max|maks|maksimal)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?',
            text_lower
        )
        if m_minmax:
            n1 = float(m_minmax.group(1).replace(',', '.'))
            u1 = m_minmax.group(2)
            n2 = float(m_minmax.group(3).replace(',', '.'))
            u2 = m_minmax.group(4)
            if not u1 and u2 and n1 < 1000: u1 = u2
            v1 = int(n1 * 1000) if u1 in ['k', 'rb', 'ribu'] or (n1 < 1000 and not u1 and n1 < 500) else int(n1)
            v2 = int(n2 * 1000) if u2 in ['k', 'rb', 'ribu'] or (n2 < 1000 and not u2 and n2 < 500) else int(n2)
            if v1 > v2: v1, v2 = v2, v1
            return {"mode": "range", "min_price": v1, "max_price": v2, "target_price": v2, "price": v2}

        # Pattern B: antara X dan Y
        m_antara = re.search(
            r'antara\s+(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?\s*(?:dan|sampai|hingga|-)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?',
            text_lower
        )
        if m_antara:
            n1 = float(m_antara.group(1).replace(',', '.'))
            u1 = m_antara.group(2)
            n2 = float(m_antara.group(3).replace(',', '.'))
            u2 = m_antara.group(4)
            if not u1 and u2 and n1 < 1000: u1 = u2
            v1 = int(n1 * 1000) if u1 in ['k', 'rb', 'ribu'] or (n1 < 1000 and not u1 and n1 < 500) else int(n1)
            v2 = int(n2 * 1000) if u2 in ['k', 'rb', 'ribu'] or (n2 < 1000 and not u2 and n2 < 500) else int(n2)
            if v1 > v2: v1, v2 = v2, v1
            return {"mode": "range", "min_price": v1, "max_price": v2, "target_price": v2, "price": v2}

        # Pattern C: X sampai Y
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
                if v1 > v2: v1, v2 = v2, v1
                return {"mode": "range", "min_price": v1, "max_price": v2, "target_price": v2, "price": v2}

        is_min_intent = bool(re.search(r'\b(minimal|min|di atas|diatas|lebih dari|paling murah|mulai dari|start)\b', text_lower))
        is_max_intent = bool(re.search(r'\b(maksimal|budget|max|di bawah|dibawah|kurang dari|paling mahal|mentok|maks)\b', text_lower))

        val = None
        m_single_k = re.search(r'(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)\b', text_lower)
        if m_single_k:
            try:
                val = int(float(m_single_k.group(1).replace(',', '.')) * 1000)
            except ValueError:
                pass

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
            return {"mode": "max", "min_price": None, "max_price": val, "target_price": val, "price": val}

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

        # ✅ DETEKSI INTENT "MURAH" / "MAHAL"
        sort_by = None
        if re.search(r'\b(murah|termurah|paling murah|hemat|ekonomis|murah meriah)\b', text_lower):
            sort_by = 'price_asc'
        elif re.search(r'\b(mahal|termahal|paling mahal|premium|high end|high-end|kualitas terbaik|terbaik)\b', text_lower):
            sort_by = 'price_desc'

        for brand in self.brands:
            if re.search(r'\b' + re.escape(brand) + r'\b', text_lower):
                detected_brands.append(brand)
                if brand not in keywords:
                    keywords.append(brand)

        for age, age_kws in self.life_stages.items():
            for kw in age_kws:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    detected_age = age
                    if age not in keywords:
                        keywords.append(age)
                    break
            if detected_age:
                break

        for cond_name, cond_kws in self.health_conditions.items():
            for kw in cond_kws:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    if cond_name not in detected_conditions:
                        detected_conditions.append(cond_name)
                    if kw not in keywords:
                        keywords.append(kw)

        for cat, kw_list in self.categories.items():
            for kw in kw_list:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    if cat not in detected_categories:
                        detected_categories.append(cat)
                    if kw not in keywords:
                        keywords.append(kw)

        signals = {
            "mainan":       any(w in text_lower for w in ["mainan", "main", "toy", "toys", "bola", "laser", "catnip", "tunnel", "terowongan", "garukan", "scratch"]),
            "pasir":        any(w in text_lower for w in ["pasir", "litter", "tofu", "bentonite"]),
            "shampo":       any(w in text_lower for w in ["shampo", "shampoo", "sampo", "kondisioner", "conditioner", "mandi"]),
            "obat":         any(w in text_lower for w in ["obat", "kutu", "jamur", "scabies", "detick", "tetes", "luka", "cacingan", "cacing", "diare", "mencret", "pilek", "flu"]),
            "parfum":       any(w in text_lower for w in ["parfum", "pewangi", "pengharum", "wangi", "deodorant"]),
            "aksesoris":    any(w in text_lower for w in ["kalung", "baju", "kostum", "pakaian", "lonceng", "klinting"]),
            "perlengkapan": any(w in text_lower for w in ["litter box", "kandang", "serokan", "tali tuntun", "gunting kuku", "tempat makan", "tempat minum", "dot", "spetan"]),
            "susu":         any(w in text_lower for w in ["susu", "top growth", "kitten milk"]),
            "makanan":      any(w in text_lower for w in ["makan", "makanan", "pakan", "food", "dry food", "wet food", "kibble", "snack", "treat", "creamy", "kaleng", "pouch", "biskuit", "kering", "basah"]),
        }

        active_signals = [cat for cat, triggered in signals.items() if triggered]

        if active_signals:
            detected_categories = [c for c in detected_categories if c in active_signals]
            if not detected_categories:
                detected_categories = active_signals

        stop_words = {
            "saya", "mau", "ingin", "cari", "ada", "yang", "untuk", "kucing", "dong", "kak",
            "bisa", "tolong", "buat", "rekomendasi", "ini", "itu", "dan", "atau", "di", "ke",
            "budget", "harga", "ribuan", "ribu", "rb", "k", "max", "maksimal", "punya", "punyaku",
            "berapa", "apa", "saja", "mana", "terbaik", "murah", "bagus", "pas", "sampai", "sd", "s/d",
            "antara", "hingga", "min", "minimal", "rekomendasikan", "kasih", "gimana", "yaa", "ya", "pake",
            "ekor", "dua", "tiga", "empat", "lima", "satu", "2", "3", "4", "5"
        }
        words = [w for w in re.findall(r'\b[a-zA-Z]{3,}\b', text_lower) if w not in stop_words]
        for w in words:
            if w not in keywords:
                keywords.append(w)

        if not keywords:
            keywords = ["kucing", "makanan"]

        response_message = self.generate_response(
            text_lower, detected_brands, detected_categories, detected_age,
            detected_conditions, min_price, max_price, detected_price,
            price_mode, sort_by,
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
            "sort_by": sort_by,
            "keywords": keywords,
            "response": response_message
        }

    def generate_response(self, text, brands, categories, age_group, conditions,
                         min_price, max_price, price, price_mode, sort_by=None) -> str:
        greetings = ["halo", "hai", "selamat pagi", "selamat siang", "selamat sore", "selamat malam", "assalamualaikum", "hi", "p", "siang", "pagi", "sore", "malam"]
        words_count = len(text.split())
        if any(greet in text for greet in greetings) and words_count <= 2:
            return (
                "Halo Cat Lovers! 🐾 Selamat datang di **RERe Petshop**.\n\n"
                "Ada yang bisa kami bantu carikan untuk anabul kesayangan hari ini? "
                "Kakak bisa konsultasikan keluhan kutu/jamur, jenis sampo, makanan sesuai usia & budget, pasir, atau mainan kucing ya! 🐱✨"
            )

        non_cat = ["anjing", "burung", "ikan cupang", "hamster", "reptil", "kelinci", "ular"]
        if any(animal in text for animal in non_cat):
            return (
                "Mohon maaf ya Kak 🐾 Saat ini **RERe Petshop** berfokus khusus menyediakan kebutuhan nutrisi, "
                "perawatan kesehatan, dan perlengkapan untuk anabul **kucing** saja agar hasilnya maksimal! 🐱"
            )

        if re.fullmatch(r'[a-z]{6,}', text) and not any(w in text for w in ["makan", "pasir", "mainan", "obat", "kucing", "susu", "shampo", "halo", "hai"]):
            return (
                "Halo Cat Lovers! 🐾 Maaf kami kurang paham maksudnya.\n\n"
                "Coba ketik pertanyaan seperti: **'makanan kitten murah'**, **'obat kutu'**, atau **'pasir kucing 30rb'** ya! 🐱"
            )

        def format_rp(num: int) -> str:
            return f"Rp {num:,.0f}".replace(',', '.')

        explanation_blocks = []

        if "kutu" in conditions or any(w in text for w in ["kutu", "kutuan", "gatal kutu"]):
            if any(w in text for w in ["shampo", "sampo", "mandi"]):
                explanation_blocks.append("📌 **Penjelasan Solusi Kutu:**\nUntuk mengatasi anabul yang kutuan saat mandi, gunakan **Shampoo Kutu Jamur** atau sampo berformula anti-parasit. Mandikan anabul dengan air hangat, ratakan sampo hingga ke kulit leher & sela jari, diamkan 3-5 menit agar kutu lemas/mati, lalu bilas bersih dan keringkan sempurna.")
            elif any(w in text for w in ["obat", "tetes"]):
                explanation_blocks.append("📌 **Penjelasan Solusi Kutu:**\nUntuk penanganan kutu yang cepat dan tuntas, gunakan obat tetes kutu (**Detick / Obat Kutu**). Teteskan langsung pada kulit tengkuk (leher belakang) agar tidak terjilat anabul. Obat akan menyebar melalui lapisan minyak kulit dan melindungi hingga 4-5 minggu.")
            else:
                explanation_blocks.append("📌 **Penjelasan Solusi Kutu:**\nUntuk penanganan kutu yang efektif, Kakak bisa menggunakan kombinasi obat tetes kutu pada tengkuk serta rutin mandi menggunakan **Shampoo Anti Kutu & Jamur**. Pastikan juga area kandang dan alas tidur disemprot disinfektan agar telur kutu tidak menetas kembali.")

        elif "jamur" in conditions or any(w in text for w in ["jamur", "scabies", "ringworm", "gatal", "ketombe"]):
            explanation_blocks.append("📌 **Penjelasan Solusi Jamur & Gatal:**\nJamur pada kucing umumnya dipicu kelembapan tinggi. Gunakan **Shampoo Anti Kutu & Jamur** atau salep/obat luka jamur. Pastikan bulu dikeringkan 100% setelah mandi dan jemur anabul di bawah sinar matahari pagi selama 10-15 menit.")

        elif "bulu rontok" in conditions or any(w in text for w in ["bulu", "rontok", "lebat", "kusam"]):
            explanation_blocks.append("📌 **Penjelasan Masalah Bulu:**\nBulu rontok dapat diatasi dengan memberikan makanan kaya **Omega 3 & 6 (Salmon/Tuna)**, rajin menyisir bulu mati setiap hari, dan mandi menggunakan **Shampoo Conditioner** untuk menutrisi akar bulu agar lembut dan tidak mudah kusut.")

        elif "pencernaan / diare" in conditions or any(w in text for w in ["diare", "mencret", "muntah"]):
            explanation_blocks.append("📌 **Penjelasan Pencernaan & Diare:**\nJika anabul sedang diare, hindari makanan sembarangan atau susu sapi biasa. Berikan pakan yang mudah dicerna dan pastikan kebutuhan cairan terpenuhi dengan bantuan spetan minum agar tidak dehidrasi.")

        elif "penggemuk / nafsu makan" in conditions or any(w in text for w in ["gemuk", "nafsu makan", "kurus"]):
            explanation_blocks.append("📌 **Penjelasan Penggemuk & Nafsu Makan:**\nUntuk menambah berat badan anabul secara sehat, berikan dry food tinggi protein dikombinasikan dengan wet food/creamy treat aroma tuna/salmon untuk mendongkrak selera makannya.")

        elif "shampo" in categories and not conditions:
            explanation_blocks.append("📌 **Penjelasan Perawatan Mandi:**\nGunakan sampo kucing dengan pH balanced yang aman untuk kulit anabul. Tersedia varian sampo pembersih kutu-jamur maupun shampoo conditioner untuk melembutkan bulu harum sepanjang hari.")

        elif "mainan" in categories:
            explanation_blocks.append("📌 **Penjelasan Mainan Kucing:**\nMainan sangat penting untuk melatih motorik, mencegah stres, dan menyalurkan insting berburu anabul terutama bagi kucing yang tinggal di dalam ruangan (indoor).")

        elif "aksesoris" in categories:
            explanation_blocks.append("📌 **Penjelasan Aksesoris & Fashion:**\nAksesoris seperti kalung berlonceng membantu melacak keberadaan anabul di rumah, sedangkan baju kucing membuat anabul tampil lucu dan modis saat acara santai.")

        elif "pasir" in categories or any(w in text for w in ["pasir", "tofu", "litter"]):
            explanation_blocks.append("📌 **Penjelasan Pasir Kucing:**\nPasir gumpal wangi dan pasir tofu sangat higienis untuk menyerap urin seketika, mengunci bau tidak sedap, serta praktis dibersihkan dengan serokan pasir.")

        elif "perlengkapan" in categories:
            explanation_blocks.append("📌 **Penjelasan Perlengkapan Kucing:**\nPerlengkapan berkualitas seperti litter box, kandang ventilasi nyaman, dan tempat makan ergonomis akan mendukung kenyamanan harian anabul di rumah.")

        elif "susu" in categories or any(w in text for w in ["susu", "dot"]):
            explanation_blocks.append("📌 **Penjelasan Susu & Pertumbuhan:**\nSusu khusus kucing (seperti Top Growth) bebas laktosa sehingga aman dan tidak menyebabkan mencret pada kitten, sangat bagus untuk menggantikan air susu induk.")

        elif age_group == "kitten":
            explanation_blocks.append("📌 **Penjelasan Nutrisi Kitten (Anak Kucing):**\nKitten membutuhkan formula tinggi protein, kalsium, serta asam folat untuk pembentukan tulang, gigi, dan perkembangan otak yang aktif.")
        elif age_group == "adult":
            explanation_blocks.append("📌 **Penjelasan Nutrisi Adult (Kucing Dewasa):**\nKucing dewasa membutuhkan nutrisi seimbang untuk menjaga berat badan ideal, kesehatan saluran kencing (urinary), dan kilau bulu.")
        elif age_group == "senior":
            explanation_blocks.append("📌 **Penjelasan Nutrisi Senior (Kucing Tua):**\nKucing senior membutuhkan makanan rendah fosfor, tinggi serat, dan mudah dicerna untuk menjaga fungsi ginjal dan pencernaan.")

        cat_str = ', '.join([c.title() for c in categories]) if categories else "produk"
        brand_str = ', '.join([b.title() for b in brands]) if brands else ""

        # ✅ Sort note
        sort_note = ""
        if sort_by == 'price_asc':
            sort_note = " (diurutkan dari **harga termurah**)"
        elif sort_by == 'price_desc':
            sort_note = " (diurutkan dari **harga termahal**)"

        intro_katalog = []
        if price_mode == "range" and min_price and max_price:
            if brands:
                intro_katalog.append(f"katalog {cat_str} **{brand_str}** dengan kisaran harga **{format_rp(min_price)} - {format_rp(max_price)}**{sort_note}:")
            else:
                intro_katalog.append(f"katalog **{cat_str}** pilihan di rentang harga **{format_rp(min_price)} - {format_rp(max_price)}**{sort_note}:")
        elif price_mode == "max" and max_price:
            intro_katalog.append(f"katalog **{cat_str}** dengan budget di bawah **{format_rp(max_price)}**{sort_note}:")
        elif price_mode == "min" and min_price:
            intro_katalog.append(f"katalog **{cat_str}** mulai dari harga **{format_rp(min_price)}**{sort_note}:")
        else:
            if brands:
                intro_katalog.append(f"katalog {cat_str} dari merek **{brand_str}** yang tersedia di RERe Petshop{sort_note}:")
            elif categories:
                intro_katalog.append(f"katalog **{cat_str}** pilihan yang cocok untuk anabul Anda{sort_note}:")
            else:
                intro_katalog.append(f"katalog rekomendasi produk yang cocok untuk anabul Anda{sort_note}:")

        lines = ["Halo Cat Lovers! 🐾"]

        if explanation_blocks:
            lines.extend(explanation_blocks)

        lines.append(f"👇 **Rekomendasi Produk:**\nBerikut {''.join(intro_katalog)}")

        return "\n\n".join(lines)