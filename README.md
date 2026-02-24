# 🌿 Git Workflow Guide

Repository ini menggunakan sistem branch terstruktur untuk kolaborasi tim.

---

# 📌 Branch Structure

- main → versi stabil / siap demo
- dev → penggabungan sementara fitur
- nama-branch → branch kerja masing-masing anggota

---

# 🚀 ALUR KERJA

---

## 1️⃣ Mulai Fitur Baru

Selalu mulai dari main terbaru:

git checkout main

git pull origin main

git checkout nama-branch

Contoh:

git checkout sakhi

---

## 2️⃣ Selama Pengerjaan

Setiap ada perubahan:

git add .

git commit -m "deskripsi perubahan jelas"

Push pertama kali:

git push origin nama-branch

Push berikutnya cukup:

git push

---

## 3️⃣ Jika Fitur Selesai

Merge ke dev terlebih dahulu:

git checkout dev

git pull origin dev

git merge nama-branch

git push origin dev

---

## 4️⃣ Jika Semua Fitur di Dev Stabil

Merge dev ke main:

git checkout main

git pull origin main

git merge dev

git push origin main

---

# 🔁 Update Branch Agar Tidak Ketinggalan

Jika main atau dev sudah berubah, update branch kamu:

git checkout dev/main

git pull origin dev/main

git checkout nama-branch

git merge dev/main

---

# ⚠️ Rules

- ❌ Jangan commit langsung ke main
- ❌ Jangan merge tanpa pull terbaru
- ✅ Gunakan commit message yang jelas
- ✅ Pastikan fitur sudah dites sebelum merge

---

# UTAMAKAN KALAU MAU KERJAKAN BAGIAN YANG INGIN DIKERJAKAN
- Untuk Backend
  
  cd .\backend-laravel
  
- Untuk Web

  cd .\frontend-react

- Untuk Mobile

  cd .\app_rere_petshop

---

# FOLDER PENTING
- Backend

  1️⃣ routes/api.php

    Tempat daftar endpoint API.

    Kalau mau bikin endpoint baru → daftarkan di sini.

  2️⃣ app/Http/Controllers/

    Tempat logic fitur.

    Kalau mau:
    - Tambah CRUD
    - Tambah validasi
    - Atur response JSON
    
    Semua di controller.
    
  3️⃣ app/Models/

    Representasi tabel database.

    Kalau tambah tabel baru → buat model baru.
  
  4️⃣ database/migrations/

    Struktur tabel database.

    Kalau mau:
    - Tambah kolom
    - Ubah struktur tabel
    
    Buat migration baru lalu migrate.

- Frontend

  1️⃣ src/App.jsx

    Tempat:
    - Atur routing utama
    - Layout global
    - Struktur halaman
    
    Kalau tambah page → daftarkan di sini.
    
  2️⃣ src/pages/

    Tempat file halaman.

    Contoh:
    - Login
    - Products
    - Dashboard
    
    Kalau mau tambah halaman baru → buat file di sini.
  
  3️⃣ src/components/

    Komponen reusable.

    Contoh:
    - Card
    - Navbar
    - Button
    
    Kalau UI dipakai berulang → taruh di sini.
    
  4️⃣ src/services/

    Tempat API call.

    Semua request ke backend sebaiknya dipusatkan di sini.

    Jangan campur API call langsung di banyak file tanpa struktur.
  
  5️⃣ src/assets/

    Gambar, icon, dll.

- Mobile

  lib/screens → halaman

  lib/widgets → komponen reusable

  lib/services → API call

---

# CARA RUNNING
  - Backend

    php artisan serve

  - React

    pnpm run dev
    
  - Mobile

    flutter run

---

# TAMBAHAN BACKEND

🗄 DATABASE
  
  - Jalankan migration:
  
    php artisan migrate
  
  - Rollback migration terakhir:
  
    php artisan migrate:rollback
  
  - Reset semua tabel:
  
    php artisan migrate:fresh
  
  - Reset + seed:
  
    php artisan migrate:fresh --seed

🧱 BUAT MODEL + MIGRATION
  
  - Buat model + migration sekaligus:
  
    php artisan make:model Product -m
  
  - Buat model saja:
  
    php artisan make:model Product
  
  - Buat migration saja:
  
    php artisan make:migration create_products_table

🎮 BUAT CONTROLLER
  
  - Controller biasa:
  
    php artisan make:controller ProductController
  
  - Controller untuk API:
  
    php artisan make:controller Api/ProductController
  
  - Controller dengan method CRUD otomatis:
  
    php artisan make:controller Api/ProductController --api
  
  - Controller lengkap (model + migration + resource controller):
  
    php artisan make:model Product -mcr
  
  
(m = migration, c = controller, r = resource)
