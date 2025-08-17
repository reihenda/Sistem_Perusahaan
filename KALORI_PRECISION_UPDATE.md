# UPDATE PRESISI KALORI - DOKUMENTASI PERUBAHAN

## Summary
Sistem telah diperbarui untuk mendukung input nilai kalori dengan presisi hingga 12 angka di belakang koma pada halaman Kelola Harga Gagas.

## Perubahan Yang Dilakukan

### 1. Database Migration (✅ SELESAI)
**File:** `database/migrations/2025_08_17_000001_modify_kalori_precision_in_harga_gagas_table.php`
- Mengubah tipe data kolom `kalori` dari `DECIMAL(10,2)` ke `DECIMAL(20,12)`
- Mendukung presisi hingga 12 angka di belakang koma
- Dapat menyimpan nilai dari 0.000000000001 hingga 99999999.999999999999

### 2. Model HargaGagas (✅ SELESAI)
**File:** `app/Models/HargaGagas.php`
- Casting `kalori` diubah dari `decimal:2` ke `decimal:12`
- Model sekarang akan menangani dan menampilkan nilai kalori dengan presisi tinggi

### 3. Controller Validation (✅ SELESAI)
**File:** `app/Http/Controllers/Rekap/RekapPembelianController.php`
- Validation rule untuk kalori diperbaharui:
  - `min:0.000000000001` (nilai minimum yang sangat kecil)
  - `regex:/^\d+(\.\d{1,12})?$/` (format maksimal 12 angka desimal)
- Pesan error yang informatif untuk user

### 4. Blade Template (✅ SELESAI)
**File:** `resources/views/rekap/pembelian/kelola-harga-gagas.blade.php`

#### Input Field:
- `step="0.000000000001"` - Memungkinkan input presisi tinggi
- `min="0.000000000001"` - Nilai minimum yang valid
- `placeholder="Contoh: 23.123456789012"` - Contoh format input
- Help text yang informatif tentang presisi

#### Display Format:
- History table: Menggunakan `rtrim()` untuk menghilangkan trailing zeros
- Tooltips: Format kalori dengan presisi penuh
- Calculation details: Menampilkan kalori dengan format yang tepat

#### JavaScript Enhancement:
- Format display angka dengan presisi tinggi dalam preview
- Validasi JavaScript yang mendukung presisi 12 desimal
- Error messages yang informatif

## Cara Menggunakan

### 1. Jalankan Migration
```bash
php artisan migrate
```

### 2. Input Nilai Kalori
- Buka halaman Kelola Harga Gagas
- Masukkan nilai kalori dengan presisi hingga 12 angka desimal
- Contoh valid: `23.123456789012`, `45.1`, `67.000000000001`

### 3. Fitur yang Tersedia
- **Input dengan presisi tinggi:** Mendukung input hingga 12 angka desimal
- **Validasi real-time:** Browser akan memvalidasi format input
- **Preview calculation:** Hitung preview dengan presisi tinggi
- **Smart display:** Trailing zeros dihilangkan untuk tampilan yang bersih
- **Copy from previous:** Data kalori presisi tinggi dapat disalin dari periode sebelumnya

## Format Display

### Input Format
- Browser akan menerima input seperti: `23.123456789012`
- Validasi memastikan maksimal 12 angka di belakang koma

### Display Format
- **History Table:** `23.123456789012` (trailing zeros dihilangkan)
- **Calculation Details:** Presisi penuh untuk akurasi perhitungan
- **Tooltips:** Menampilkan format lengkap dengan keterangan presisi tinggi

## Backward Compatibility
- Data lama dengan presisi 2 desimal tetap kompatibel
- Sistem akan menampilkan data lama dengan format yang sesuai
- Tidak ada data yang hilang atau rusak

## Testing Checklist

### ✅ Harus Ditest:
1. **Migration:** Pastikan kolom kalori berubah ke DECIMAL(20,12)
2. **Input Test:** 
   - Coba input: `23.123456789012`
   - Coba input: `45.1`
   - Coba input: `67.000000000001`
3. **Validation Test:**
   - Input dengan 13 angka desimal (harus error)
   - Input negatif (harus error)
   - Input kosong (harus error)
4. **Display Test:**
   - History table menampilkan format yang benar
   - Calculation preview bekerja dengan presisi tinggi
   - Copy from previous berfungsi dengan data presisi tinggi
5. **Calculation Test:**
   - Perhitungan MMBTU akurat dengan kalori presisi tinggi
   - Total pembelian dihitung dengan benar

## Peringatan

### ⚠️ Penting:
1. **Backup Database:** Lakukan backup sebelum menjalankan migration
2. **Test di Environment Development:** Test semua fitur sebelum deploy ke production
3. **Browser Compatibility:** Pastikan browser mendukung input number dengan step kecil
4. **Performance:** Monitor performa query dengan presisi tinggi

## Troubleshooting

### Jika Migration Gagal:
```bash
# Rollback jika ada masalah
php artisan migrate:rollback --step=1

# Coba jalankan ulang
php artisan migrate
```

### Jika Input Tidak Menerima Presisi Tinggi:
1. Clear browser cache
2. Pastikan JavaScript tidak ada error
3. Check validasi di browser developer tools

### Jika Display Tidak Sesuai:
1. Hard refresh browser (Ctrl+F5)
2. Check console errors
3. Pastikan file blade sudah ter-update

## Kontribusi
Dokumentasi ini dibuat pada: {{ date('Y-m-d H:i:s') }}
Update terakhir: Implementasi presisi kalori 12 angka desimal
