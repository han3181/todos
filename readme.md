HAHA iya iya, maaf Bagas 😅 auto markdown-nya kepencet tadi. Nih gue kasih ulang versi **polosan** tanpa markdown, tinggal copy langsung buat README:

---

# Aplikasi Todo List - Flutter + Laravel + Riverpod

Aplikasi Todo List ini terdiri dari dua bagian:

- todos_mobile → Aplikasi mobile menggunakan Flutter
- backend_todos → Backend REST API menggunakan Laravel dan MySQL

Fitur Utama (Aplikasi Mobile):

- Tambah, edit, dan hapus todo
- Tandai todo sebagai selesai
- Tandai sebagai prioritas
- Kategori dan tanggal jatuh tempo
- Validasi form input
- Warna dan UI dinamis tergantung status
- Disambungkan dengan REST API Laravel

---

### Framework dan Teknologi yang Digunakan:

Backend (backend_todos):

- Laravel
- MySQL

Frontend (todos_mobile):

- Flutter
- Riverpod (State Management)
- intl (format tanggal)
- Dio atau http (untuk komunikasi REST API)

---

Cara Menjalankan Proyek

1. Setup Backend (Laravel):

- Masuk ke folder backend_todos:

```bash
  cd backend_todos
```

- Install dependency:

```bash
  composer install
```

- Copy dan edit environment file:

```bash
  cp .env.example .env
  php artisan key\:generate
```

- Atur koneksi database di .env:

```env
  DB\_DATABASE=todos\_db
  DB\_USERNAME=root
  DB\_PASSWORD=your\_password
```

- Jalankan migrasi:

```bash
  php artisan migrate
```

- Jalankan server Laravel:

```bash
  php artisan serve
```

Akses API akan tersedia di: [http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)

2. Setup Frontend (Flutter):

- Masuk ke folder todos_mobile:

```bash
  cd todos_mobile
```

- Install dependency:

```bash
  flutter pub get
```

- Pastikan base URL API di dalam kode sudah benar, misalnya:

```dart
  final baseUrl = "[http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)";
```

Catatan: Kalau pakai emulator Android fisik, ganti 127.0.0.1 ke IP lokal PC seperti 192.168.1.100

- Jalankan aplikasi Flutter:

```bash
  flutter run
```

---

#### truktur Folder (Singkat)

todos_mobile:

- lib/model → Model TodoItem
- lib/provider → Provider dengan Riverpod
- lib/ui/page → Halaman utama
- lib/ui/widget → Widget form todo
- main.dart → Entry point aplikasi

backend_todos (Laravel):

- app/
- routes/api.php → route API Laravel
- database/migrations → struktur tabel todo
- .env → konfigurasi database

---

#### Dependency Penting

Flutter:

- flutter_riverpod
- intl
- dio (atau http)

Laravel:

- laravel/framework
- mysql

---

#### Tentang Developer:

Nama: Raihan Arifin Budi

No. Absen: 25

---
