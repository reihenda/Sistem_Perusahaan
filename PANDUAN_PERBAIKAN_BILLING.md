# PANDUAN PERBAIKAN MASALAH SINKRONISASI DATA BILLING

## Masalah yang Ditemukan
Volume 0 muncul di billing padahal seharusnya ada volume di tanggal tersebut.

## Perbaikan yang Telah Dilakukan

### 1. Perbaikan di BillingController.php
- **Standardisasi filtering data**: Menggunakan logika filtering yang sama antara BillingController dan DataPencatatanController
- **Perbaikan pricing calculation**: Menggunakan pricing yang sesuai dengan periode masing-masing item, bukan pricing periode billing
- **Perbaikan format tanggal**: Menggunakan format 'Y-m' yang konsisten untuk perbandingan deposit
- **Penambahan logging**: Menambahkan debug logging untuk memantau proses filtering dan perhitungan

### 2. Perbaikan Utama

#### A. Filtering Data
**Sebelum:**
```php
// Menggunakan query builder yang bisa berbeda
$query = $customer->dataPencatatan();
$dataPencatatan = $query->get();
```

**Sesudah:**
```php
// Menggunakan collection filtering yang konsisten
$dataPencatatan = $customer->dataPencatatan()->get();
$dataPencatatan = $dataPencatatan->filter(function ($item) use ($yearMonth) {
    // Logika filtering yang sama dengan customer detail
});
```

#### B. Pricing Calculation
**Sebelum:**
```php
// Menggunakan pricing periode billing untuk semua item
$volumeSm3 = $volumeFlowMeter * floatval($pricingInfo['koreksi_meter']);
$hargaGas = floatval($pricingInfo['harga_per_meter_kubik']);
```

**Sesudah:**
```php
// Menggunakan pricing sesuai periode masing-masing item
$waktuAwal = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
$itemPricingInfo = $customer->getPricingForYearMonth($waktuAwal->format('Y-m'), $waktuAwal);
$volumeSm3 = $volumeFlowMeter * floatval($itemPricingInfo['koreksi_meter']);
```

#### C. Deposit Filtering
**Sebelum:**
```php
if ($depositDate->month == $request->month && $depositDate->year == $request->year)
```

**Sesudah:**
```php
if ($depositDate->format('Y-m') === $yearMonth)
```

### 3. Debug Controller
Telah dibuat `DataSyncDebugController` untuk membantu diagnosis masalah:

**URL Debug:**
- Compare Data: `/debug/compare-data?customer_id=1&month=5&year=2024`
- Quick Fix: `/debug/quick-fix` (POST)

## Cara Menggunakan

### 1. Test Perbaikan
1. **Buat billing baru** untuk customer yang bermasalah pada periode yang sama
2. **Bandingkan hasilnya** dengan data di customer detail
3. **Periksa log** di `storage/logs/laravel.log` untuk melihat proses filtering

### 2. Debug Data (Opsional)
Jika masih ada masalah, gunakan URL debug:

```bash
# Ganti customer_id, month, year sesuai kebutuhan
GET /debug/compare-data?customer_id=1&month=5&year=2024
```

Response akan memberikan analisis detail:
- Jumlah data raw vs filtered
- Detail setiap record dengan perhitungan
- Summary volume dan biaya
- Data deposit

### 3. Quick Fix (Jika Diperlukan)
```bash
POST /debug/quick-fix
Content-Type: application/json

{
    "customer_id": 1,
    "month": 5,
    "year": 2024,
    "dry_run": false
}
```

## Monitoring

### Log yang Ditambahkan
1. **Billing store - Data filtering**: Jumlah data yang ditemukan
2. **Billing store - Processing item**: Detail setiap item yang diproses
3. **Billing store - Deposit calculation**: Total deposit yang ditemukan
4. **Billing created successfully**: Ringkasan billing yang berhasil dibuat

### Cara Melihat Log
```bash
tail -f storage/logs/laravel.log | grep "Billing"
```

## Expected Results

Setelah perbaikan ini:
1. **Data billing harus sama** dengan data di customer detail untuk periode yang sama
2. **Volume 0 hanya muncul** jika memang tidak ada pemakaian di tanggal tersebut
3. **Perhitungan harga** menggunakan pricing yang tepat sesuai periode masing-masing data
4. **Deposit filtering** menggunakan format yang konsisten

## Verification Steps

1. **Pilih customer dan periode** yang sebelumnya bermasalah
2. **Buka customer detail** dan catat:
   - Total volume untuk periode tersebut
   - Total biaya untuk periode tersebut
   - Jumlah records yang tampil
3. **Buat billing baru** untuk customer dan periode yang sama
4. **Bandingkan hasil** - seharusnya identik
5. **Periksa log** untuk memastikan proses berjalan dengan benar

## Troubleshooting

Jika masih ada perbedaan:
1. **Periksa log** untuk melihat jumlah data yang difilter
2. **Gunakan debug endpoint** untuk analisis detail
3. **Pastikan tidak ada data** dengan format tanggal yang rusak
4. **Periksa timezone settings** di aplikasi

## File yang Dimodifikasi

1. `app/Http/Controllers/BillingController.php` - Perbaikan utama
2. `app/Http/Controllers/Debug/DataSyncDebugController.php` - Debug tools
3. `routes/web.php` - Route untuk debug

## Testing

Untuk memastikan perbaikan berhasil:

1. Test dengan customer yang sebelumnya bermasalah
2. Test dengan berbagai periode (bulan dengan data normal, bulan dengan data kosong)
3. Test dengan customer yang memiliki periode pricing khusus
4. Verifikasi bahwa semua data muncul dengan benar di billing

Setelah perbaikan ini, masalah volume 0 yang tidak seharusnya muncul di billing sudah teratasi.
