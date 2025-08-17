Setelah saya implementasikan fitur "Rekap Pembelian" dan "Kelola Harga Gagas", berikut adalah langkah-langkah yang perlu Anda lakukan:

## Langkah-langkah Setup:

### 1. Jalankan Migration
```bash
php artisan migrate
```

### 2. Clear Cache (opsional)
```bash
php artisan cache:clear
php artisan config:clear
php artisan view:clear
```

## Fitur yang Telah Ditambahkan:

### 1. **Menu Rekap Pembelian**
- Ditambahkan di sidebar dengan icon shopping cart
- Tersedia untuk role Admin

### 2. **Halaman Rekap Pembelian** 
- **Path**: `/rekap-pembelian`
- **Tampilan seperti rekap penjualan** dengan perubahan:
  - "Total Pemakaian" → "Total Pengambilan" (diambil dari `rekap_pengambilan`)
  - "Total Penjualan" → "Total Pembelian" (dihitung berdasarkan harga gagas)
- **Filter**: Tahun dan Bulan
- **Grafik**: Pengambilan dan Pembelian (tahunan & bulanan)
- **Tabel**: Data per customer

### 3. **Halaman Kelola Harga Gagas**
- **Path**: `/rekap-pembelian/kelola-harga-gagas`
- **Button**: Tersedia di halaman rekap pembelian
- **Fitur**:
  - Input harga USD
  - Input kalori untuk konversi MMBTU
  - **Rate USD ke IDR realtime** (menggunakan API)
  - Opsi manual override rate
  - Perhitungan otomatis
  - Preview perhitungan

### 4. **API Currency Service**
- **Realtime conversion** USD ke IDR
- **Multiple fallback APIs**:
  - Primary: exchangerate-api.com
  - Fallback: fixer.io, open.er-api.com
  - Manual fallback rate
- **Caching**: 1 jam untuk menghindari rate limit
- **Refresh button**: Force update rate

### 5. **Database**
- **Tabel baru**: `harga_gagas`
  - `harga_usd`: Harga dalam USD
  - `rate_konversi_idr`: Rate konversi USD ke IDR
  - `kalori`: Nilai kalori untuk konversi ke MMBTU
  - `periode_tahun`, `periode_bulan`: Periode berlaku

## Rumus Perhitungan:

1. **Total MMBTU** = Total Volume SM³ ÷ Kalori
2. **Harga IDR per MMBTU** = Harga USD × Rate Konversi IDR  
3. **Total Pembelian** = Total MMBTU × Harga IDR per MMBTU

## Relasi Data:

- **Total Pengambilan**: Diambil dari tabel `rekap_pengambilan` (field: `volume`)
- **Total Pembelian**: Dihitung berdasarkan data `harga_gagas` dan volume pengambilan
- **Customer Data**: Menggunakan relasi User → RekapPengambilan

## Kontrol Akses:

- **Role yang dapat mengakses**: Admin, SuperAdmin
- **Tidak tersedia untuk**: Customer, Demo

## API Endpoints Baru:

- `GET /rekap-pembelian` - Halaman utama
- `GET /rekap-pembelian/kelola-harga-gagas` - Kelola harga gagas
- `POST /rekap-pembelian/update-harga-gagas` - Update harga gagas
- `GET /rekap-pembelian/get-current-rate` - Get rate USD ke IDR realtime

Silakan coba akses halaman `/rekap-pembelian` setelah menjalankan migration!
