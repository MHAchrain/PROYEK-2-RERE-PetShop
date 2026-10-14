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
            "makanan": [
                "makan", "makann", "mkan", "makanan", "pakan", "food", "dry food",
                "wet food", "kibble", "snack", "treat", "creamy", "tuna", "salmon",
                "chicken", "ayam", "ikan", "kaleng", "pouch", "biskuit", "daging",
                "donat", "kering", "basah"
            ],
            "shampo": [
                "shampo", "shampoo", "sampo", "sampon", "mandi", "sabun",
                "kondisioner", "conditioner"
            ],
            "obat": [
                "obat", "obat-obatan", "kutu", "jamur", "gatal", "scabies", "detick",
                "tetes kutu", "tetes mata", "tetes telinga", "luka", "diare", "flu",
                "spray", "mencret", "muntah", "pilek", "cacing"
            ],
            "parfum": ["parfum", "pewangi", "pengharum", "deodorant"],
            "mainan": [
                "main", "mainan", "toy", "toys", "bola", "laser", "tongkat",
                "catnip", "garukan", "scratch", "tunnel", "terowongan", "boneka",
                "kucing pintar"
            ],
            "aksesoris": [
                "kalung", "baju", "baju kucing", "pakaian", "kostum", "lonceng",
                "klinting"
            ],
            "pasir": [
                "pasir", "litter", "pasir gumpal", "tofu", "bentonite", "pasir wangi"
            ],
            "perlengkapan": [
                "litter box", "box", "toilet", "bak pasir", "kandang", "tempat makan",
                "tempat minum", "serokan", "dot", "dot susu", "spetan", "tali",
                "tali tuntun", "gunting kuku"
            ],
            "susu": ["susu", "top growth", "kitten milk", "milk"],
            "grooming": [
                "grooming", "grooming kucing", "mandi kucing", "cukur bulu",
                "potong kuku", "bersih telinga", "perawatan kucing"
            ]
        }

        self.life_stages = {
            "kitten": [
                "kitten", "anak kucing", "bayi kucing", "kecil", "anakan", "kitik",
                "1 bulan", "2 bulan", "3 bulan", "4 bulan", "5 bulan", "6 bulan",
                "7 bulan", "8 bulan", "9 bulan", "10 bulan", "11 bulan"
            ],
            "adult": [
                "adult", "dewasa", "besar", "indukan", "1 tahun", "2 tahun",
                "3 tahun", "4 tahun", "5 tahun", "6 tahun"
            ],
            "senior": [
                "senior", "tua", "lansia", "7 tahun", "8 tahun", "9 tahun",
                "10 tahun", "11 tahun", "12 tahun"
            ]
        }

        self.health_conditions = {
            "kutu": ["kutu", "fleas", "detick", "tetes kutu"],
            "jamur": [
                "jamur", "ringworm", "scabies", "gatal", "kulit merah",
                "ketombe", "kerak"
            ],
            "bulu rontok": [
                "bulu rontok", "rontok", "bulu kusam", "gimbal", "hairball",
                "skin & coat", "coat"
            ],
            "penggemuk / nafsu makan": [
                "gemuk", "berat badan", "nafsu makan", "kurus", "kurang makan",
                "gendut", "tambah berat"
            ],
            "pencernaan / diare": [
                "diare", "mencret", "pencernaan", "sensitif", "muntah", "lambung"
            ],
            "luka / infeksi": ["luka", "infeksi", "borok", "baret", "lecet"],
            "bau / higienis": ["bau", "apek", "pesing", "kotor"]
        }

        # ============================================================
        # Basis 100 Pertanyaan dan Jawaban (RERe Petshop FAQ)
        # ============================================================
        self.faq_responses = {
            "1": "🕒 **Jam Buka Toko:** RERe Petshop buka setiap hari mulai pukul 08.00 hingga 21.00 WIB.",
            "2": "📍 **Lokasi Toko:** Store fisik kami berlokasi di pusat kota dengan area parkir yang luas dan mudah diakses.",
            "3": "💳 **Metode Pembayaran:** Kami menerima Transfer Bank (BCA, Mandiri, BNI), QRIS, E-Wallet (DANA, OVO, GoPay), serta Cash.",
            "4": "📦 **Pengiriman:** Tersedia layanan pengiriman instan (GoSend/Grab) dan ekspedisi reguler untuk luar kota.",
            "5": "🩺 **Konsultasi Kesehatan:** Untuk konsultasi umum vitamin/obat ringan bisa langsung ke tim kami, untuk kasus darurat disarankan ke dokter hewan.",
            "6": "🛒 **Cara Belanja:** Kakak bisa datang langsung ke store atau memesan secara online melalui WhatsApp dan aplikasi kami.",
            "7": "🚚 **Estimasi Kirim:** Pengiriman instan diproses dalam waktu maksimal 1 jam setelah pembayaran dikonfirmasi.",
            "8": "🛍️ **Tas Belanja:** Setiap pembelian di atas Rp 100.000 berhak mendapatkan tas belanja eksklusif RERe Petshop.",
            "9": "🔄 **Kebijakan Retur:** Produk makanan atau barang cacat dapat ditukar maksimal 2 hari setelah diterima dengan menyertakan video unboxing.",
            "10": "⭐ **Sistem Poin Member:** Setiap transaksi akan mendapatkan poin yang bisa ditukarkan dengan diskon atau hadiah menarik.",
            "11": "🐱 **Makanan Kitten:** Kitten membutuhkan makanan dengan protein tinggi (minimal 30-34%) untuk pertumbuhan optimal.",
            "12": "🐈 **Makanan Adult:** Kucing dewasa memerlukan nutrisi seimbang untuk menjaga berat badan ideal dan kesehatan organ.",
            "13": "👵 **Makanan Senior:** Kucing senior memerlukan pakan rendah fosfor dan tinggi serat untuk menjaga kesehatan ginjal.",
            "14": "🥣 **Dry Food vs Wet Food:** Dry food bagus untuk kesehatan gigi, sementara wet food sangat baik untuk menjaga hidrasi cairan tubuh.",
            "15": "🍼 **Susu Kucing:** Jangan beri susu sapi biasa karena mengandung laktosa yang menyebabkan diare; gunakan susu khusus kucing seperti Top Growth.",
            "16": "💧 **Kebutuhan Air Minum:** Selalu sediakan air bersih dan ganti setiap hari, atau gunakan pet fountain agar kucing lebih rajin minum.",
            "17": "🐟 **Makanan Rasa Ikan:** Varian tuna dan salmon sangat digemari karena kandungan Omega 3 & 6 yang menyehatkan bulu.",
            "18": "🍗 **Makanan Rasa Ayam:** Ayam memberikan sumber energi tinggi dan sangat disukai oleh kucing dengan selera makan pemilih (picky eater).",
            "19": "🍪 **Snack / Treat:** Berikan treat secukupnya sebagai reward saat latihan atau bentuk bonding dengan anabul.",
            "20": "⚖️ **Takaran Makan:** Berikan pakan sesuai takaran di kemasan berdasarkan berat badan agar kucing tidak obesitas.",
            "21": "🧴 **Manfaat Shampo Kutu:** Shampo khusus kutu membantu membunuh parasit dan meredakan gatal pada kulit anabul.",
            "22": "🛁 **Frekuensi Mandi:** Kucing cukup dimandikan 1 bulan sekali atau saat kotor, karena kucing bisa membersihkan dirinya sendiri.",
            "23": "🫧 **Cara Mandi Aman:** Gunakan air hangat suam-suam kuku dan pastikan air tidak masuk ke dalam telinga kucing.",
            "24": "🌬️ **Pengeringan Bulu:** Bulu harus dikeringkan 100% menggunakan handuk dan hair dryer hangat agar tidak memicu jamur.",
            "25": "✂️ **Potong Kuku:** Potong kuku kucing secara rutin di bagian ujungnya saja agar tidak melukai pembuluh darah.",
            "26": "👂 **Pembersihan Telinga:** Bersihkan kotoran telinga luar menggunakan cotton bud khusus hewan dan cairan pembersih telinga.",
            "27": "🌸 **Parfum Kucing:** Gunakan parfum khusus hewan yang bebas alkohol dan aman jika terjilat oleh kucing.",
            "28": "🧶 **Sikat Bulu Mati:** Sisir bulu kucing setiap hari untuk mengurangi bulu rontok yang tertelan (hairball).",
            "29": "✨ **Grooming Profesional:** RERe Petshop menyediakan layanan grooming lengkap dari reguler hingga medis.",
            "30": "🧼 **Sanitasi Alat Mandi:** Semua peralatan grooming kami selalu disterilisasi sebelum digunakan ke anabul berikutnya.",
            "31": "🦠 **Penyebab Jamur:** Jamur pada kucing disebabkan oleh kelembapan kulit dan kontak dengan lingkungan kotor.",
            "32": "🌿 **Pengobatan Jamur:** Gunakan salep jamur khusus hewan atau semprotan anti-jamur secara rutin setiap hari.",
            "33": "☀️ **Penjemuran Kucing:** Jemur kucing di bawah sinar matahari pagi selama 10 menit untuk membantu membasmi spora jamur.",
            "34": "🦟 **Bahaya Kutu:** Kutu dapat menyebabkan anemia pada kitten dan menularkan cacing pita jika tertelan.",
            "35": "💧 **Obat Tetes Kutu:** Detick atau obat tetes tengkuk sangat efektif membasmi kutu hingga tuntas dalam beberapa hari.",
            "36": "🩹 **Penanganan Luka:** Bersihkan luka luar dengan antiseptik non-alkohol lalu oleskan salep luka khusus hewan.",
            "37": "🤢 **Atasi Diare:** Hentikan makanan berlemak, berikan pakan khusus pencernaan sensitif dan air elektrolit.",
            "38": "🤧 **Kucing Flu / Pilek:** Jauhkan dari udara dingin, berikan vitamin penambah imunitas dan uap air hangat.",
            "39": "🐛 **Obat Cacing:** Berikan obat cacing secara rutin setiap 3 bulan sekali sesuai dengan berat badan kucing.",
            "40": "🩺 **Vaksinasi:** Pastikan kucing mendapatkan vaksin dasar lengkap (FVRCP) untuk mencegah penyakit mematikan.",
            "41": "🏜️ **Pasir Gumpal Wangi:** Pasir jenis bentonite sangat praktis karena langsung menggumpal saat terkena cairan pipis.",
            "42": "🌱 **Pasir Tofu (Soy):** Pasir tofu terbuat dari ampas tahu, ramah lingkungan, dan aman jika tidak sengaja tertelan.",
            "43": "🧹 **Membersihkan Litter Box:** Bersihkan kotoran padat dan gumpalan pasir setiap hari agar litter box tetap higienis.",
            "44": "🔄 **Ganti Total Pasir:** Ganti seluruh pasir dan cuci bersih litter box minimal 2 minggu sekali.",
            "45": "🏠 **Lokasi Litter Box:** Letakkan litter box di tempat yang tenang, mudah diakses, dan jauh dari mangkuk makan.",
            "46": "🎾 **Manfaat Mainan:** Mainan melatih ketangkasan fisik dan mencegah kucing mengalami stres di dalam ruangan.",
            "47": "🌿 **Catnip Alami:** Catnip aman untuk kucing, memberikan efek rileks, gembira, dan merangsang keaktifan bermain.",
            "48": "🧗 **Cat Tree / Garukan:** Sediakan tiang garukan agar kucing tidak mencakar sofa atau perabot rumah tangga.",
            "49": "⚽ **Bola Kerincing:** Mainan bola berlonceng sangat disukai kucing karena memancing insting berburu mereka.",
            "50": "🪄 **Tongkat Bulu:** Mainan tongkat bulu melatih refleks melompat dan mempererat ikatan dengan pemiliknya.",
            "51": "🏷️ **Kalung Lonceng:** Kalung berlonceng membantu Anda mengetahui posisi kucing saat berjalan di dalam rumah.",
            "52": "👔 **Baju Kucing:** Pakaikan baju khusus kucing yang adem dan tidak membatasi gerak tubuh mereka.",
            "53": "🦺 **Tali Tuntun (Harness):** Gunakan harness khusus kucing jika ingin mengajak jalan-jalan di luar ruangan dengan aman.",
            "54": "🏡 **Kandang Ventilasi:** Kandang kucing harus memiliki sirkulasi udara yang baik dan luas yang cukup untuk bergerak.",
            "55": "🍼 **Botol Susu Kitten:** Gunakan dot khusus dengan lubang kecil untuk menyusui bayi kucing terlantar.",
            "56": "🥄 **Spetan Obat:** Spetan (alat suntik tanpa jarum) sangat membantu untuk menyuapi vitamin atau obat cair.",
            "57": "🥣 **Tempat Makan Ergonomis:** Gunakan mangkuk makan dengan sudut miring agar leher kucing tidak pegal saat makan.",
            "58": "🌊 **Tempat Minum Luas:** Kucing menyukai mangkuk air yang lebar agar kumisnya tidak menyentuh dinding wadah.",
            "59": "🎒 **Tas Carrier / Pet Cargo:** Gunakan pet cargo yang kokoh dan berlubang udara untuk membawa kucing bepergian.",
            "60": "🛏️ **Bantalan Tidur:** Sediakan tempat tidur empuk yang hangat agar kucing merasa aman dan nyaman.",
            "61": "🐱 **Kucing Ras Persia:** Membutuhkan perawatan bulu ekstra setiap hari dan makanan khusus bulu lebat.",
            "62": "🐾 **Kucing Ras Domestic (Kampung):** Kucing lokal sangat kuat, aktif, dan cukup diberi pakan berkualitas standar.",
            "63": "🐈‍⬛ **Kucing Ras Main Coon:** Membutuhkan pakan porsi besar dengan nutrisi sendi dan tulang yang kuat.",
            "64": "🐯 **Kucing Ras Bengal:** Kucing aktif berenergi tinggi yang membutuhkan mainan interaktif menantang.",
            "65": "🧶 **Kucing Ras British Shorthair:** Rentan obesitas, butuh makanan penunjang berat badan sehat dan rendah lemak.",
            "66": "💤 **Waktu Tidur Kucing:** Kucing normal tidur selama 12 hingga 16 jam sehari untuk memulihkan energi.",
            "67": "🧼 **Kebiasaan Grooming Mandiri:** Kucing menghabiskan 30-50% waktunya dalam sehari untuk menjilati dan merawat bulunya.",
            "68": "👅 **Struktur Lidah:** Permukaan lidah kucing kasar seperti duri berfungsi untuk membersihkan bulu dan daging dari tulang.",
            "69": "👁️ **Penglihatan Malam:** Kucing memiliki tapetum lucidum yang membuat mata mereka bisa melihat sangat jelas di tempat gelap.",
            "70": "👂 **Pendengaran Tajam:** Pendengaran kucing jauh lebih sensitif dibandingkan manusia dan anjing.",
            "71": "🐟 **Alergi Makanan:** Beberapa kucing alergi terhadap protein tertentu (seperti gandum/ayam), tandanya kulit gatal atau muntah.",
            "72": "💧 **Pentingnya Hidrasi:** Kucing kurang suka minum air diam, solusinya berikan wet food atau air mengalir.",
            "73": "☀️ **Berjemur Pagi:** Berjemur membantu sintesis vitamin D dan membunuh bakteri di bulu kucing.",
            "74": "🪴 **Tanaman Aman:** Pastikan tanaman hias di rumah tidak beracun bagi kucing (hindari lili dan sirih gading beracun).",
            "75": "🧹 **Menghilangkan Bau Pesing:** Gunakan cairan pembersih enzimatis khusus hewan untuk menghilangkan bau pipis secara tuntas.",
            "76": "🎁 **Promo Bulanan:** RERe Petshop rutin memberikan promo diskon spesial di tanggal kembar setiap bulannya.",
            "77": "📦 **Grosir / Reseller:** Kami melayani pembelian grosir pakan dan pasir dengan harga khusus untuk reseller.",
            "78": "🤝 **Program Donasi Kucing:** Sebagian keuntungan RERe Petshop disalurkan untuk shelter kucing jalanan terlantar.",
            "79": "📱 **Kontak Layanan Pelanggan:** Anda bisa menghubungi admin kami via WhatsApp resmi yang tertera di bio.",
            "80": "📝 **Saran & Masukan:** Kami sangat terbuka terhadap kritik dan saran demi peningkatan kualitas pelayanan petshop.",
            "81": "🥩 **Kandungan Taurin:** Taurin adalah asam amino esensial wajib dalam makanan kucing untuk kesehatan jantung & mata.",
            "82": "⚖️ **Cek Berat Badan:** Timbang berat badan anabul secara berkala minimal 1 bulan sekali.",
            "83": "🌾 **Grain-Free Food:** Pakan tanpa biji-bijian sangat bagus untuk kucing yang memiliki pencernaan sangat sensitif.",
            "84": "🧊 **Air Es / Dingin:** Sebaiknya berikan air suhu ruang, hindari air terlalu dingin agar perut kucing tidak kembung.",
            "85": "🥚 **Kuning Telur Rebus:** Kuning telur rebus sesekali sangat bagus untuk melebatkan dan mengkilapkan bulu kucing.",
            "86": "🍗 **Bahaya Tulang Ayam:** Jangan pernah beri tulang ayam mentah/rebus karena bisa melukai saluran pencernaan.",
            "87": "🍫 **Bahaya Cokelat:** Cokelat, bawang, dan kopi sangat beracun bagi kucing dan wajib dijauhkan.",
            "88": "📦 **Penyimpanan Dry Food:** Simpan dry food di wadah kedap udara agar kerenyahan dan aromanya tetap terjaga.",
            "89": "🥫 **Penyimpanan Wet Food:** Pouch/kaleng terbuka harus segera dimasukkan ke kulkas dan habiskan dalam 24 jam.",
            "90": "🌿 **Rumput Gandum (Cat Grass):** Berikan cat grass sesekali untuk membantu pencernaan dan melancarkan buang bulu (hairball).",
            "91": "🐾 **Jumlah Kotak Pasir:** Rumus ideal jumlah litter box di rumah adalah: jumlah kucing ditambah satu buah.",
            "92": "🚪 **Akses Keluar Rumah:** Kucing indoor lebih aman dari parasit luar, kecelakaan jalan raya, dan penularan penyakit.",
            "93": "🧼 **Cuci Wadah Makan:** Cuci mangkuk makan dan minum kucing setiap hari menggunakan sabun cuci piring bersih.",
            "94": "📸 **Komunitas Cat Lovers:** Ikuti event gathering dan kontes kucing yang disponsori oleh RERe Petshop.",
            "95": "🏷️ **Label Harga Jelas:** Semua produk di RERe Petshop tertera label harga resmi yang transparan dan jujur.",
            "96": "🚗 **Parkir Gratis:** Nikmati fasilitas parkir yang luas, aman, dan bebas biaya bagi pengunjung store.",
            "97": "💡 **Penerangan Toko:** Suasana store didesain nyaman dan terang agar Anda leluasa memilih kebutuhan anabul.",
            "98": "🛍️ **Keranjang Belanja:** Tersedia keranjang dorong dan keranjang tangan untuk memudahkan Anda membawa produk pilihan.",
            "99": "📋 **Katalog Digital:** Anda bisa meminta katalog produk lengkap berbentuk PDF melalui admin WhatsApp kami.",
            "100": "🌟 **Komitmen Kami:** RERe Petshop berkomitmen untuk selalu menyediakan produk berkualitas tinggi demi kebahagiaan anabul kesayangan Anda!"
        }

    # ================================================================
    # HELPER
    # ================================================================
    def _normalize_number(self, num_str: str, unit: Optional[str],
                          other_unit: Optional[str] = None) -> int:
        """Konversi string angka + unit menjadi integer rupiah."""
        num_str = num_str.replace(',', '.')
        try:
            num = float(num_str)
        except ValueError:
            return 0

        if unit in ('k', 'rb', 'ribu'):
            return int(num * 1000)
        if not unit and other_unit and num < 500:
            return int(num * 1000)
        return int(num)

    # ================================================================
    # PARSE BUDGET
    # ================================================================
    def parse_budget(self, text: str) -> Dict[str, Any]:
        text_lower = text.lower()
        empty = {
            "mode": None, "min_price": None, "max_price": None,
            "target_price": None, "price": None
        }

        # ---- Pola 1: "min X sampai max Y" ----
        m_minmax = re.search(
            r'(?:min|minimal)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?'
            r'\s*(?:sampai|hingga|dan|-|,)?\s*'
            r'(?:max|maks|maksimal)\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?',
            text_lower
        )
        if m_minmax:
            v1 = self._normalize_number(m_minmax.group(1), m_minmax.group(2), m_minmax.group(4))
            v2 = self._normalize_number(m_minmax.group(3), m_minmax.group(4), m_minmax.group(2))
            if v1 > v2:
                v1, v2 = v2, v1
            return {"mode": "range", "min_price": v1, "max_price": v2,
                    "target_price": v2, "price": v2}

        # ---- Pola 2: "antara X dan Y" ----
        m_antara = re.search(
            r'antara\s+(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?'
            r'\s*(?:dan|sampai|hingga|-)\s*'
            r'(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?',
            text_lower
        )
        if m_antara:
            v1 = self._normalize_number(m_antara.group(1), m_antara.group(2), m_antara.group(4))
            v2 = self._normalize_number(m_antara.group(3), m_antara.group(4), m_antara.group(2))
            if v1 > v2:
                v1, v2 = v2, v1
            return {"mode": "range", "min_price": v1, "max_price": v2,
                    "target_price": v2, "price": v2}

        # ---- Pola 3: "X sampai Y" ----
        m_range = re.search(
            r'(?:harga|budget|kisaran|rentang)?\s*(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?'
            r'\s*(?:sampai|hingga|s\/d|sd|ke|-|–)\s*'
            r'(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)?',
            text_lower
        )
        if m_range:
            raw1, u1 = m_range.group(1), m_range.group(2)
            raw2, u2 = m_range.group(3), m_range.group(4)
            clean1 = raw1.replace('.', '').replace(',', '')
            clean2 = raw2.replace('.', '').replace(',', '')
            if clean1.isdigit() and int(clean1) >= 1000:
                v1 = int(clean1)
            else:
                v1 = self._normalize_number(raw1, u1, u2)
            if clean2.isdigit() and int(clean2) >= 1000:
                v2 = int(clean2)
            else:
                v2 = self._normalize_number(raw2, u2, u1)
            if v1 >= 1000 and v2 >= 1000:
                if v1 > v2:
                    v1, v2 = v2, v1
                return {"mode": "range", "min_price": v1, "max_price": v2,
                        "target_price": v2, "price": v2}

        # ---- Deteksi intent min/max ----
        is_min_intent = bool(re.search(
            r'\b(minimal|min|di atas|diatas|lebih dari|paling murah|mulai dari|start)\b',
            text_lower
        ))
        is_max_intent = bool(re.search(
            r'\b(maksimal|budget|max|di bawah|dibawah|kurang dari|paling mahal|mentok|maks)\b',
            text_lower
        ))

        # ---- Single value dengan "k/rb/ribu" ----
        val = None
        m_single_k = re.search(
            r'(?:rp\.?\s*)?(\d+(?:[\.,]\d+)?)\s*(k|rb|ribu)\b',
            text_lower
        )
        if m_single_k:
            try:
                val = int(float(m_single_k.group(1).replace(',', '.')) * 1000)
            except ValueError:
                val = None

        # ---- Single value full number ----
        if val is None:
            m_single_full = re.search(
                r'(?:rp\.?\s*)?(\d{1,3}(?:\.\d{3})+|\d{4,7})\b',
                text_lower
            )
            if m_single_full:
                clean = m_single_full.group(1).replace('.', '')
                if clean.isdigit() and int(clean) >= 1000:
                    val = int(clean)

        if val is None:
            return empty

        if is_min_intent:
            return {"mode": "min", "min_price": val, "max_price": None,
                    "target_price": val, "price": val}
        return {"mode": "max", "min_price": None, "max_price": val,
                "target_price": val, "price": val}

    # ================================================================
    # EXTRACT KEYWORDS
    # ================================================================
    def extract_keywords(self, text: str) -> Dict[str, Any]:
        text_lower = text.lower()

        detected_brands: List[str] = []
        detected_categories: List[str] = []
        detected_conditions: List[str] = []
        detected_age: Optional[str] = None
        keywords: List[str] = []

        price_info = self.parse_budget(text)
        detected_price = price_info.get("target_price")
        min_price = price_info.get("min_price")
        max_price = price_info.get("max_price")
        price_mode = price_info.get("mode")

        # ---- Sort intent & limit ----
        sort_by = None
        cheapest_only = False
        expensive_only = False
        limit: Optional[int] = None

        # "Paling murah" / "termurah" → 1 produk termurah
        if re.search(r'\b(paling murah|termurah|termurahh|yg paling murah|yang paling murah)\b', text_lower):
            cheapest_only = True
            limit = 1
        # "Murah" biasa → 5 produk termurah
        elif re.search(r'\b(murah|hemat|ekonomis|murah meriah)\b', text_lower):
            cheapest_only = True
            limit = 5
        # "Paling mahal" / "termahal" → 1 produk termahal
        elif re.search(r'\b(paling mahal|termahal|termahall|yg paling mahal|yang paling mahal)\b', text_lower):
            expensive_only = True
            limit = 1
        # "Mahal" / "premium" → 5 produk termahal
        elif re.search(r'\b(mahal|premium|high end|high-end|kualitas terbaik|terbaik)\b', text_lower):
            expensive_only = True
            limit = 5

        # ---- Brands (word boundary) ----
        for brand in self.brands:
            if re.search(r'\b' + re.escape(brand) + r'\b', text_lower):
                detected_brands.append(brand)
                if brand not in keywords:
                    keywords.append(brand)

        # ---- Life stage ----
        for age, age_kws in self.life_stages.items():
            for kw in age_kws:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    detected_age = age
                    if age not in keywords:
                        keywords.append(age)
                    break
            if detected_age:
                break

        # ---- Health conditions ----
        for cond_name, cond_kws in self.health_conditions.items():
            for kw in cond_kws:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    if cond_name not in detected_conditions:
                        detected_conditions.append(cond_name)
                    if kw not in keywords:
                        keywords.append(kw)

        # ---- Categories ----
        is_pasir_context = any(w in text_lower for w in ["pasir", "litter", "tofu", "bentonite"])
        for cat, kw_list in self.categories.items():
            for kw in kw_list:
                if re.search(r'\b' + re.escape(kw) + r'\b', text_lower):
                    if cat == "parfum" and kw == "wangi" and is_pasir_context:
                        continue
                    if cat not in detected_categories:
                        detected_categories.append(cat)
                    if kw not in keywords:
                        keywords.append(kw)

        # ---- Signals (penguat kategori) ----
        signals = {
            "mainan": any(w in text_lower for w in [
                "mainan", "main", "toy", "toys", "bola", "laser", "catnip",
                "tunnel", "terowongan", "garukan", "scratch", "anti stress",
                "anti stres", "stres", "stress"
            ]),
            "pasir": any(w in text_lower for w in ["pasir", "litter", "tofu", "bentonite"]),
            "shampo": any(w in text_lower for w in [
                "shampo", "shampoo", "sampo", "kondisioner", "conditioner", "mandi"
            ]),
            "obat": any(w in text_lower for w in [
                "obat", "kutu", "jamur", "scabies", "detick", "tetes", "luka",
                "cacingan", "cacing", "diare", "mencret", "pilek", "flu"
            ]),
            "parfum": any(w in text_lower for w in [
                "parfum", "pewangi", "pengharum", "deodorant"
            ]),
            "aksesoris": any(w in text_lower for w in [
                "kalung", "baju", "kostum", "pakaian", "lonceng", "klinting"
            ]),
            "perlengkapan": any(w in text_lower for w in [
                "litter box", "kandang", "serokan", "tali tuntun", "gunting kuku",
                "tempat makan", "tempat minum", "dot", "spetan"
            ]),
            "susu": any(w in text_lower for w in ["susu", "top growth", "kitten milk"]),
            "makanan": any(w in text_lower for w in [
                "makan", "makanan", "pakan", "food", "dry food", "wet food",
                "kibble", "snack", "treat", "creamy", "kaleng", "pouch",
                "biskuit", "kering", "basah"
            ]),
            "grooming": any(w in text_lower for w in [
                "grooming", "cukur", "potong kuku", "bersih telinga",
                "mandi kucing", "perawatan"
            ]),
        }
        active_signals = [cat for cat, triggered in signals.items() if triggered]

        if active_signals:
            filtered = [c for c in detected_categories if c in active_signals]
            if filtered:
                detected_categories = filtered
            else:
                detected_categories = active_signals

        # ---- Stopwords ----
        stop_words = {
            "saya", "mau", "ingin", "cari", "ada", "yang", "untuk", "kucing",
            "dong", "kak", "bisa", "tolong", "buat", "rekomendasi", "ini",
            "itu", "dan", "atau", "di", "ke", "budget", "harga", "ribuan",
            "ribu", "rb", "k", "max", "maksimal", "punya", "punyaku",
            "berapa", "apa", "saja", "mana", "terbaik", "murah", "bagus",
            "pas", "sampai", "sd", "s/d", "antara", "hingga", "min",
            "minimal", "rekomendasikan", "kasih", "gimana", "yaa", "ya",
            "pake", "ekor", "dua", "tiga", "empat", "lima", "satu",
            "2", "3", "4", "5", "terenak", "enak", "wangi", "harum",
            "oke", "mantap", "anti", "stress", "stres"
        }
        words = [
            w for w in re.findall(r'\b[a-zA-Z]{3,}\b', text_lower)
            if w not in stop_words
        ]
        for w in words:
            if w not in keywords:
                keywords.append(w)

        if not keywords:
            keywords = ["kucing", "makanan"]

        response_message = self.generate_response(
            text_lower, detected_brands, detected_categories, detected_age,
            detected_conditions, min_price, max_price, detected_price,
            price_mode, sort_by, cheapest_only, expensive_only, limit
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
            "cheapest_only": cheapest_only,
            "expensive_only": expensive_only,
            "limit": limit,
            "keywords": keywords,
            "response": response_message
        }

    # ================================================================
    # GENERATE RESPONSE
    # ================================================================
    def generate_response(
        self, text, brands, categories, age_group, conditions,
        min_price, max_price, price, price_mode, sort_by=None,
        cheapest_only=False, expensive_only=False, limit=None
    ) -> str:
        # ---- FAQ by number (1-100) ----
        m_faq_num = re.search(r'\b(?:faq|nomer|no|pertanyaan)?\s*(\d{1,3})\b', text)
        if m_faq_num:
            num_str = m_faq_num.group(1)
            if num_str in self.faq_responses:
                return self.faq_responses[num_str]

        # ---- FAQ umum ----
        if any(w in text for w in ["buka jam", "jam berapa", "operasional", "tutup jam"]):
            return self.faq_responses["1"]
        if any(w in text for w in ["lokasi", "alamat", "dimana toko", "store dimana"]):
            return self.faq_responses["2"]
        if any(w in text for w in ["bayar pakai", "transfer", "qris", "gopay", "ovo", "metode pembayaran"]):
            return self.faq_responses["3"]
        if any(w in text for w in ["ongkir", "ongkos kirim", "kirim keluar kota", "kurir"]):
            return self.faq_responses["4"]
        if any(w in text for w in ["konsultasi", "dokter", "sakit parah"]):
            return self.faq_responses["5"]

        # ---- Greetings ----
        greetings = [
            "halo", "hai", "selamat pagi", "selamat siang", "selamat sore",
            "selamat malam", "assalamualaikum", "hi", "p", "siang", "pagi",
            "sore", "malam"
        ]
        words_count = len(text.split())
        if any(greet in text for greet in greetings) and words_count <= 2:
            return (
                "Halo Cat Lovers! 🐾 Selamat datang di **RERe Petshop**.\n\n"
                "Ada yang bisa kami bantu carikan untuk anabul kesayangan hari ini? "
                "Kakak bisa konsultasikan keluhan kutu/jamur, jenis sampo, makanan sesuai usia & budget, pasir, atau mainan kucing ya! 🐱✨"
            )

        # ---- Hewan non-kucing ----
        non_cat = ["anjing", "burung", "ikan cupang", "hamster", "reptil", "kelinci", "ular"]
        if any(animal in text for animal in non_cat):
            return (
                "Mohon maaf ya Kak 🐾 Saat ini **RERe Petshop** berfokus khusus menyediakan kebutuhan nutrisi, "
                "perawatan kesehatan, dan perlengkapan untuk anabul **kucing** saja agar hasilnya maksimal! 🐱"
            )

        # ---- Input tidak dikenali ----
        if re.fullmatch(r'[a-z]{6,}', text) and not any(
            w in text for w in [
                "makan", "pasir", "mainan", "obat", "kucing", "susu",
                "shampo", "halo", "hai", "grooming"
            ]
        ):
            return (
                "Halo Cat Lovers! 🐾 Maaf kami kurang paham maksudnya.\n\n"
                "Coba ketik pertanyaan seperti: **'makanan kitten murah'**, **'obat kutu'**, atau **'pasir kucing 30rb'** ya! 🐱"
            )

        def format_rp(num: int) -> str:
            return f"Rp {num:,.0f}".replace(',', '.')

        explanation_blocks: List[str] = []

        # ---- Penjelasan kontekstual ----
        if "grooming" in categories or any(
            w in text for w in ["grooming", "cukur", "potong kuku", "mandi kucing", "bersih telinga"]
        ):
            explanation_blocks.append(
                "📌 **Layanan Grooming RERe Petshop:**\n\n"
                "✂️ **Grooming Reguler** — Rp 50.000 – Rp 100.000\n"
                "Mandi bersih, pengeringan, potong kuku, dan pembersihan telinga.\n\n"
                "🧴 **Grooming Kutu/Jamur** — Rp 75.000 – Rp 150.000\n"
                "Pakai sampo medis khusus untuk atasi kutu, jamur, atau masalah kulit.\n\n"
                "✨ **Grooming Lengkap/Spesial** — Rp 150.000 – Rp 300.000+\n"
                "Cukur bulu (trimming/gimbal), penanganan khusus, atau homecare.\n\n"
                "Mau booking grooming? Langsung aja ke halaman **Grooming** ya Kak! 🐱✂️"
            )

        elif "kutu" in conditions or any(w in text for w in ["kutu", "kutuan", "gatal kutu"]):
            if any(w in text for w in ["shampo", "sampo", "mandi"]):
                explanation_blocks.append(
                    "📌 **Penjelasan Solusi Kutu:**\n"
                    "Untuk mengatasi anabul yang kutuan saat mandi, gunakan **Shampoo Kutu Jamur** "
                    "atau sampo berformula anti-parasit. Mandikan anabul dengan air hangat, ratakan "
                    "sampo hingga ke kulit leher & sela jari, diamkan 3-5 menit agar kutu lemas/mati, "
                    "lalu bilas bersih dan keringkan sempurna."
                )
            elif any(w in text for w in ["obat", "tetes"]):
                explanation_blocks.append(
                    "📌 **Penjelasan Solusi Kutu:**\n"
                    "Untuk penanganan kutu yang cepat dan tuntas, gunakan obat tetes kutu "
                    "(**Detick / Obat Kutu**). Teteskan langsung pada kulit tengkuk (leher belakang) "
                    "agar tidak terjilat anabul. Obat akan menyebar melalui lapisan minyak kulit "
                    "dan melindungi hingga 4-5 minggu."
                )
            else:
                explanation_blocks.append(
                    "📌 **Penjelasan Solusi Kutu:**\n"
                    "Untuk penanganan kutu yang efektif, Kakak bisa menggunakan kombinasi obat tetes "
                    "kutu pada tengkuk serta rutin mandi menggunakan **Shampoo Anti Kutu & Jamur**. "
                    "Pastikan juga area kandang dan alas tidur disemprot disinfektan agar telur kutu "
                    "tidak menetas kembali."
                )

        elif "jamur" in conditions or any(
            w in text for w in ["jamur", "scabies", "ringworm", "gatal", "ketombe"]
        ):
            explanation_blocks.append(
                "📌 **Penjelasan Solusi Jamur & Gatal:**\n"
                "Jamur pada kucing umumnya dipicu kelembapan tinggi. Gunakan **Shampoo Anti Kutu & Jamur** "
                "atau salep/obat luka jamur. Pastikan bulu dikeringkan 100% setelah mandi dan jemur "
                "anabul di bawah sinar matahari pagi selama 10-15 menit."
            )

        elif "bulu rontok" in conditions or any(
            w in text for w in ["bulu", "rontok", "lebat", "kusam"]
        ):
            explanation_blocks.append(
                "📌 **Penjelasan Masalah Bulu:**\n"
                "Bulu rontok dapat diatasi dengan memberikan makanan kaya **Omega 3 & 6 (Salmon/Tuna)**, "
                "rajin menyisir bulu mati setiap hari, dan mandi menggunakan **Shampoo Conditioner** "
                "untuk menutrisi akar bulu agar lembut dan tidak mudah kusut."
            )

        elif "pencernaan / diare" in conditions or any(
            w in text for w in ["diare", "mencret", "muntah"]
        ):
            explanation_blocks.append(
                "📌 **Penjelasan Pencernaan & Diare:**\n"
                "Jika anabul sedang diare, hindari makanan sembarangan atau susu sapi biasa. "
                "Berikan pakan yang mudah dicerna dan pastikan kebutuhan cairan terpenuhi "
                "dengan bantuan spetan minum agar tidak dehidrasi."
            )

        elif "penggemuk / nafsu makan" in conditions or any(
            w in text for w in ["gemuk", "nafsu makan", "kurus"]
        ):
            explanation_blocks.append(
                "📌 **Penjelasan Penggemuk & Nafsu Makan:**\n"
                "Untuk menambah berat badan anabul secara sehat, berikan dry food tinggi protein "
                "dikombinasikan dengan wet food/creamy treat aroma tuna/salmon untuk mendongkrak "
                "selera makannya."
            )

        elif "shampo" in categories and not conditions:
            explanation_blocks.append(
                "📌 **Penjelasan Perawatan Mandi:**\n"
                "Gunakan sampo kucing dengan pH balanced yang aman untuk kulit anabul. "
                "Tersedia varian sampo pembersih kutu-jamur maupun shampoo conditioner "
                "untuk melembutkan bulu harum sepanjang hari."
            )

        elif "mainan" in categories:
            explanation_blocks.append(
                "📌 **Penjelasan Mainan Kucing:**\n"
                "Mainan sangat penting untuk melatih motorik, mencegah stres, dan menyalurkan "
                "insting berburu anabul terutama bagi kucing yang tinggal di dalam ruangan (indoor)."
            )

        elif "aksesoris" in categories:
            explanation_blocks.append(
                "📌 **Penjelasan Aksesoris & Fashion:**\n"
                "Aksesoris seperti kalung berlonceng membantu melacak keberadaan anabul di rumah, "
                "sedangkan baju kucing membuat anabul tampil lucu dan modis saat acara santai."
            )

        elif "pasir" in categories or any(w in text for w in ["pasir", "tofu", "litter"]):
            explanation_blocks.append(
                "📌 **Penjelasan Pasir Kucing:**\n"
                "Pasir gumpal wangi dan pasir tofu sangat higienis untuk menyerap urin seketika, "
                "mengunci bau tidak sedap, serta praktis dibersihkan dengan serokan pasir."
            )

        elif "perlengkapan" in categories:
            explanation_blocks.append(
                "📌 **Penjelasan Perlengkapan Kucing:**\n"
                "Perlengkapan berkualitas seperti litter box, kandang ventilasi nyaman, dan "
                "tempat makan ergonomis akan mendukung kenyamanan harian anabul di rumah."
            )

        elif "susu" in categories or any(w in text for w in ["susu", "dot"]):
            explanation_blocks.append(
                "📌 **Penjelasan Susu & Pertumbuhan:**\n"
                "Susu khusus kucing (seperti Top Growth) bebas laktosa sehingga aman dan "
                "tidak menyebabkan mencret pada kitten, sangat bagus untuk menggantikan "
                "air susu induk."
            )

        elif age_group == "kitten":
            explanation_blocks.append(
                "📌 **Penjelasan Nutrisi Kitten (Anak Kucing):**\n"
                "Kitten membutuhkan formula tinggi protein, kalsium, serta asam folat untuk "
                "pembentukan tulang, gigi, dan perkembangan otak yang aktif."
            )
        elif age_group == "adult":
            explanation_blocks.append(
                "📌 **Penjelasan Nutrisi Adult (Kucing Dewasa):**\n"
                "Kucing dewasa membutuhkan nutrisi seimbang untuk menjaga berat badan ideal, "
                "kesehatan saluran kencing (urinary), dan kilau bulu."
            )
        elif age_group == "senior":
            explanation_blocks.append(
                "📌 **Penjelasan Nutrisi Senior (Kucing Tua):**\n"
                "Kucing senior membutuhkan makanan rendah fosfor, tinggi serat, dan mudah "
                "dicerna untuk menjaga fungsi ginjal dan pencernaan."
            )

        # ---- Bangun intro katalog ----
        cat_str = ', '.join([c.title() for c in categories]) if categories else "produk"
        brand_str = ', '.join([b.title() for b in brands]) if brands else ""

        # Prioritas: cheapest_only / expensive_only dulu
        if cheapest_only and limit == 1:
            intro_katalog = f"produk **{cat_str}** paling murah yang tersedia di RERe Petshop:"
        elif cheapest_only and limit and limit > 1:
            intro_katalog = f"{limit} produk **{cat_str}** termurah pilihan di RERe Petshop:"
        elif expensive_only and limit == 1:
            intro_katalog = f"produk **{cat_str}** paling mahal/premium di RERe Petshop:"
        elif expensive_only and limit and limit > 1:
            intro_katalog = f"{limit} produk **{cat_str}** premium pilihan di RERe Petshop:"
        elif price_mode == "range" and min_price and max_price:
            if brands:
                intro_katalog = (
                    f"katalog {cat_str} **{brand_str}** dengan kisaran harga "
                    f"**{format_rp(min_price)} - {format_rp(max_price)}**:"
                )
            else:
                intro_katalog = (
                    f"katalog **{cat_str}** pilihan di rentang harga "
                    f"**{format_rp(min_price)} - {format_rp(max_price)}**:"
                )
        elif price_mode == "max" and max_price:
            intro_katalog = (
                f"katalog **{cat_str}** dengan budget di bawah "
                f"**{format_rp(max_price)}**:"
            )
        elif price_mode == "min" and min_price:
            intro_katalog = (
                f"katalog **{cat_str}** mulai dari harga "
                f"**{format_rp(min_price)}**:"
            )
        else:
            if brands:
                intro_katalog = (
                    f"katalog {cat_str} dari merek **{brand_str}** yang tersedia "
                    f"di RERe Petshop:"
                )
            elif categories:
                intro_katalog = (
                    f"katalog **{cat_str}** pilihan yang cocok untuk anabul Anda:"
                )
            else:
                intro_katalog = (
                    f"katalog rekomendasi produk yang cocok untuk anabul Anda:"
                )

        # ---- Gabungkan response ----
        lines = ["Halo Cat Lovers! 🐾"]
        if explanation_blocks:
            lines.extend(explanation_blocks)
        lines.append(f"👇 **Rekomendasi Produk:**\nBerikut {intro_katalog}")
        return "\n\n".join(lines)

    # ================================================================
    # UTIL: SORT & LIMIT PRODUK (untuk dipakai di layer query)
    # ================================================================
    @staticmethod
    def apply_sorting_and_limit(
        products: List[Dict[str, Any]],
        cheapest_only: bool = False,
        expensive_only: bool = False,
        limit: Optional[int] = None,
        sort_by: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Terapkan sorting & limit ke list produk.
        Dipakai di layer pemanggil setelah fetch dari DB.
        """
        if not products:
            return products

        if cheapest_only:
            products = sorted(products, key=lambda p: p.get('harga', 0))
        elif expensive_only:
            products = sorted(products, key=lambda p: p.get('harga', 0), reverse=True)
        elif sort_by == 'price_asc':
            products = sorted(products, key=lambda p: p.get('harga', 0))
        elif sort_by == 'price_desc':
            products = sorted(products, key=lambda p: p.get('harga', 0), reverse=True)

        if limit:
            products = products[:limit]

        return products

    # ================================================================
    # UTIL: FORMAT PRODUK LIST (Markdown)
    # ================================================================
    @staticmethod
    def format_product_list(products: List[Dict[str, Any]]) -> str:
        """Format daftar produk jadi bullet list Markdown yang rapi."""
        if not products:
            return "_Belum ada produk yang cocok._"

        lines = []
        for i, p in enumerate(products, 1):
            nama = p.get('nama', 'Produk').strip()
            harga = p.get('harga', 0)
            harga_str = f"Rp {harga:,.0f}".replace(',', '.')
            lines.append(f"{i}. **{nama}** — {harga_str}")

        return "\n".join(lines)