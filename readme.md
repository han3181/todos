
# ✅ Aplikasi Todo List - Flutter + Laravel + Riverpod

Aplikasi Todo List ini terdiri dari dua bagian utama:

- 📱 `todos_mobile` → Aplikasi mobile dengan Flutter
- 🖥️ `backend_todos` → REST API menggunakan Laravel dan MySQL

---

## 🎥 Demo Aplikasi

[![Tonton Demo](https://han3181.github.io/todos/index.html)

> Klik gambar di atas untuk melihat demo aplikasi Todo List!

---

## 🚀 Fitur Utama (Mobile)

- Tambah, edit, dan hapus todo
- Tandai todo sebagai selesai
- Tandai sebagai prioritas
- Kategori dan tanggal jatuh tempo
- Validasi form input
- Warna dan UI dinamis tergantung status
- Terhubung ke backend Laravel via REST API

---

## 🛠️ Teknologi yang Digunakan

### Backend (`backend_todos`)
- Laravel
- MySQL

### Frontend (`todos_mobile`)
- Flutter
- Riverpod (state management)
- `intl` (format tanggal)
- `dio` atau `http` (untuk API)

---

## ⚙️ Cara Menjalankan Proyek

### 1. Setup Backend (Laravel)

```bash
cd backend_todos
composer install
cp .env.example .env
php artisan key:generate
````

Edit `.env` dan sesuaikan koneksi DB:

```env
DB_DATABASE=todos_db
DB_USERNAME=root
DB_PASSWORD=your_password
```

Lanjut migrasi dan jalankan server:

```bash
php artisan migrate
php artisan serve
```

API akan tersedia di: [http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)

---

### 2. Setup Frontend (Flutter)

```bash
cd todos_mobile
flutter pub get
```

Edit base URL di Flutter, misalnya:

```dart
final baseUrl = "http://192.168.1.100:8000/api"; // Ganti IP sesuai dengan IP lokal PC
```

Jalankan aplikasi:

```bash
flutter run
```

---

## 📁 Struktur Folder (Singkat)

### `todos_mobile`

* `lib/model` → Model TodoItem
* `lib/provider` → Riverpod provider
* `lib/ui/page` → Halaman utama
* `lib/ui/widget` → Widget form todo
* `main.dart` → Entry point

### `backend_todos`

* `app/`
* `routes/api.php` → Routing API Laravel
* `database/migrations/` → Struktur tabel
* `.env` → Konfigurasi DB

---

## 📦 Dependency Penting

### Flutter:

* `flutter_riverpod`
* `intl`
* `dio` atau `http`

### Laravel:

* `laravel/framework`
* `mysql`

---

## 👤 Tentang Developer

* Nama: Raihan Arifin Budi
* No. Absen: 25

---

