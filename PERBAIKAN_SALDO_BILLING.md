# PERBAIKAN MASALAH SALDO BULAN LALU TIDAK SINKRON

## Masalah yang Ditemukan
**Saldo bulan lalu di billing tidak sama** dengan saldo bulan lalu di customer detail. Di billing muncul saldo minus padahal di customer detail seharusnya Rp 0.

## Root Cause Analysis
Terdapat **perbedaan metode perhitungan saldo** antara:

1. **Customer Detail**: Menggunakan sistem `monthly_balances` dari database
2. **Billing (sebelum perbaikan)**: Menghitung manual semua deposit dan pembelian sebelum periode

### Perbedaan Metode:

**Customer Detail:**
```php
// Menggunakan monthly_balances dari database
$prevMonthBalance = isset($monthlyBalances[$prevYearMonth]) ?
    floatval($monthlyBalances[$prevYearMonth]) : 0;
```

**Billing (sebelum perbaikan):**
```php
// Manual calculation - menjumlahkan semua data historis
$prevMonthBalance = $prevTotalDeposits - $prevTotalPurchases;
```

## Perbaikan yang Diterapkan

### 1. Standardisasi Metode Perhitungan Saldo

**Sebelum:**
```php
// Billing menggunakan perhitungan manual
foreach ($depositHistory as $deposit) {
    if ($depositDate < Carbon::createFromDate($year, $month, 1)) {
        $prevTotalDeposits += floatval($deposit['amount'] ?? 0);
    }
}
$prevMonthBalance = $prevTotalDeposits - $prevTotalPurchases;
```

**Sesudah:**
```php
// Billing menggunakan sistem monthly_balances yang sama
$customer->updateMonthlyBalances($prevMonthYear);
$customer = User::findOrFail($customer->id); // Reload
$monthlyBalances = $customer->monthly_balances ?: [];
$prevMonthBalance = isset($monthlyBalances[$prevMonthYear]) ?
    floatval($monthlyBalances[$prevMonthYear]) : 0;
```

### 2. Enhanced Logging untuk Monitoring

**Logging baru yang ditambahkan:**
- Metode perhitungan yang digunakan
- Nilai saldo dari monthly_balances
- Status ketersediaan monthly_balances data
- Perbandingan dengan metode manual (untuk debugging)

### 3. Debug Tools untuk Analisis Saldo

**Endpoint baru untuk menganalisis perbedaan saldo:**
```
GET /debug/compare-balance?customer_id=X&month=Y&year=Z
```

**Response memberikan perbandingan detail:**
```json
{
    \"customer_info\": {
        \"id\": 1,
        \"name\": \"Customer Name\",
        \"total_deposit\": 5000000,
        \"total_purchases\": 3000000
    },
    \"monthly_balances_system\": {
        \"prev_month_balance\": 0,
        \"current_month_balance\": 500000
    },
    \"manual_calculation\": {
        \"prev_deposits\": 4500000,
        \"prev_purchases\": 4500000,
        \"prev_balance_manual\": 0
    },
    \"discrepancies\": []
}
```

## Cara Menggunakan

### 1. Test Perbaikan Langsung
1. **Pilih customer** yang sebelumnya bermasalah dengan saldo
2. **Buat billing baru** untuk periode yang sama
3. **Verifikasi saldo bulan lalu** - seharusnya sama dengan customer detail

### 2. Analisis Saldo dengan Debug Tools
```bash
# Bandingkan perhitungan saldo antara billing dan customer detail
GET /debug/compare-balance?customer_id=1&month=5&year=2024
```

### 3. Monitor Logging
```bash
# Monitor saldo calculations
tail -f storage/logs/laravel.log | grep \"Balance calculation\"

# Monitor monthly balances updates
tail -f storage/logs/laravel.log | grep \"monthly_balances\"
```

## Expected Results

### ✅ Setelah Perbaikan:
1. **Saldo bulan lalu di billing = Saldo bulan lalu di customer detail**
2. **Konsistensi perhitungan** menggunakan sistem yang sama
3. **No more discrepancies** antara kedua tampilan
4. **Automatic sync** ketika ada perubahan data

### 📊 Contoh Hasil:

**Sebelum Perbaikan:**
```
Customer Detail: Saldo Bulan Lalu = Rp 0
Billing:         Saldo Bulan Lalu = Rp -500,000  ❌ BERBEDA
```

**Setelah Perbaikan:**
```
Customer Detail: Saldo Bulan Lalu = Rp 0
Billing:         Saldo Bulan Lalu = Rp 0         ✅ SAMA
```

## Troubleshooting

### Jika Masih Ada Perbedaan:

1. **Periksa monthly_balances data:**
   ```bash
   GET /debug/compare-balance?customer_id=X&month=Y&year=Z
   ```

2. **Cek log untuk melihat proses update:**
   ```bash
   tail -f storage/logs/laravel.log | grep \"updateMonthlyBalances\"
   ```

3. **Manual refresh monthly balances:**
   - Buka customer detail dengan parameter `?refresh=true`
   - Atau panggil `$customer->updateMonthlyBalances()` di controller

### Kemungkinan Penyebab Masalah:

1. **Monthly balances belum terupdate** - jalankan refresh
2. **Data corrupt di monthly_balances** - perlu recalculation
3. **Timezone issues** - periksa format tanggal
4. **Missing pricing data** - periksa periode pricing khusus

## Prevention

### Automatic Updates:
- Monthly balances akan terupdate otomatis saat:
  - Menambah/edit/hapus data pencatatan
  - Menambah/hapus deposit
  - Mengubah pricing

### Manual Refresh:
- Gunakan parameter `?refresh=true` di URL customer detail
- Atau gunakan tombol \"Selaraskan Data\" di interface

## File yang Dimodifikasi

1. `BillingController.php` - Perbaikan metode perhitungan saldo
2. `DataSyncDebugController.php` - Debug tools untuk analisis saldo
3. `routes/web.php` - Route untuk debug balance

## Quality Assurance

- ✅ Konsistensi antara billing dan customer detail
- ✅ Menggunakan single source of truth (monthly_balances)
- ✅ Automatic updates saat ada perubahan data
- ✅ Debug tools untuk troubleshooting
- ✅ Enhanced logging untuk monitoring

**Masalah saldo bulan lalu yang tidak sinkron sekarang sudah teratasi dengan standarisasi metode perhitungan.**

## Cara Test Spesifik untuk Masalah Anda

1. **Identify customer bermasalah:**
   - Catat ID customer yang saldo bulan lalunya bermasalah
   - Catat periode billing yang bermasalah

2. **Gunakan debug endpoint:**
   ```bash
   GET /debug/compare-balance?customer_id=[ID]&month=[MONTH]&year=[YEAR]
   ```

3. **Lihat response untuk:**
   - `discrepancies` array - akan menunjukkan jenis masalah
   - `monthly_balances_system.prev_month_balance` vs `manual_calculation.prev_balance_manual`
   - Jika ada perbedaan, cek `monthly_balances_data` apakah lengkap

4. **Create billing baru** dan verifikasi hasilnya sama dengan customer detail
