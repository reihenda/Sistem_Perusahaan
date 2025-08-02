# Sistem Real-time Balance untuk Customer

## 📋 Deskripsi
Sistem ini menyimpan perhitungan saldo dan transaksi customer secara real-time ke database untuk memudahkan query dan pembuatan fitur lainnya.

## 🚀 Setup dan Installation

### 1. Jalankan Migration
```bash
php artisan migrate
```

### 2. Initialize System untuk Customer Existing
```bash
# Initialize semua customer
php artisan balance:initialize-realtime --all

# Initialize customer tertentu
php artisan balance:initialize-realtime --customer_id=123

# Dry run untuk melihat apa yang akan dilakukan
php artisan balance:initialize-realtime --all --dry-run
```

### 3. Sync Data (jika diperlukan)
```bash
# Sync semua customer
php artisan balance:sync-realtime --all

# Sync dari bulan tertentu
php artisan balance:sync-realtime --all --from-month=2024-01

# Force recalculate (hapus data existing dan hitung ulang)
php artisan balance:sync-realtime --all --force
```

## 📊 Struktur Tabel Baru

### 1. `monthly_customer_balances`
Menyimpan saldo bulanan per customer:
- `customer_id`: ID customer
- `year_month`: Periode (format: 2024-01)
- `opening_balance`: Saldo awal bulan
- `total_deposits`: Total deposit bulan ini
- `total_purchases`: Total pembelian bulan ini
- `closing_balance`: Saldo akhir bulan
- `total_volume_sm3`: Total volume Sm³ bulan ini
- `calculation_details`: Detail perhitungan (JSON)
- `last_calculated_at`: Terakhir dihitung

### 2. `transaction_calculations` 
Menyimpan detail perhitungan setiap transaksi:
- `customer_id`: ID customer
- `data_pencatatan_id`: ID data pencatatan
- `year_month`: Periode transaksi
- `transaction_date`: Tanggal transaksi
- `volume_flow_meter`: Volume flow meter
- `koreksi_meter`: Koreksi meter yang digunakan
- `volume_sm3`: Volume Sm³ hasil perhitungan
- `harga_per_m3`: Harga per m³ yang digunakan
- `total_harga`: Total harga transaksi
- `pricing_used`: Pricing yang digunakan (JSON)
- `calculated_at`: Waktu perhitungan

### 3. Kolom Baru di `users`
- `balance_last_updated_at`: Terakhir update balance
- `use_realtime_calculation`: Flag untuk menggunakan sistem real-time

## 🔄 Cara Kerja Sistem

### Automatic Updates
Sistem akan otomatis update ketika:
1. **Data Pencatatan berubah** (create/update/delete)
2. **Deposit berubah** (add/remove/modify)
3. **Pricing berubah** (harga, koreksi meter, dll)

### Observer Pattern
- `DataPencatatanObserver`: Monitor perubahan data pencatatan
- `UserObserver`: Monitor perubahan pricing dan deposit

### Service Class
- `RealtimeBalanceService`: Handle semua logic perhitungan real-time

## 📖 Cara Menggunakan

### 1. Query Balance Bulanan
```php
use App\Models\MonthlyCustomerBalance;

// Get balance untuk customer dan periode tertentu
$balance = MonthlyCustomerBalance::where('customer_id', 123)
    ->where('year_month', '2024-08')
    ->first();

echo "Saldo: " . number_format($balance->closing_balance, 2);
```

### 2. Query Transaction Details
```php
use App\Models\TransactionCalculation;

// Get semua transaksi customer untuk bulan tertentu
$transactions = TransactionCalculation::where('customer_id', 123)
    ->where('year_month', '2024-08')
    ->orderBy('transaction_date')
    ->get();

foreach ($transactions as $transaction) {
    echo "Volume: {$transaction->volume_sm3} Sm³, Harga: Rp " . number_format($transaction->total_harga, 2);
}
```

### 3. Get Total Volume per Customer
```php
// Total volume customer untuk periode tertentu
$totals = TransactionCalculation::getTotalsForCustomerPeriod(123, '2024-08');
echo "Total Volume: {$totals->total_volume_sm3} Sm³";
echo "Total Purchases: Rp " . number_format($totals->total_purchases, 2);
```

### 4. Menggunakan Service
```php
use App\Services\RealtimeBalanceService;

$service = app(RealtimeBalanceService::class);

// Update balance untuk customer
$service->updateCustomerBalance(123);

// Get balance untuk periode
$balance = $service->getBalanceForPeriod(123, '2024-08');

// Get transaction calculations
$transactions = $service->getTransactionCalculationsForPeriod(123, '2024-08');
```

## 🛠️ Maintenance Commands

### Sync Data Berkala
Untuk memastikan data selalu sinkron, jalankan command ini secara berkala:
```bash
# Daily sync (via cron job)
php artisan balance:sync-realtime --all

# Weekly full recalculation
php artisan balance:sync-realtime --all --force
```

### Monitor Performance
```bash
# Check berapa data yang tersimpan
php artisan tinker
>>> App\Models\MonthlyCustomerBalance::count()
>>> App\Models\TransactionCalculation::count()
```

## ⚠️ Important Notes

1. **Backward Compatibility**: Sistem lama tetap berfungsi sebagai fallback
2. **Performance**: Data di-cache di database untuk query yang cepat
3. **Consistency**: Observer memastikan data selalu konsisten
4. **Flag Control**: Gunakan `use_realtime_calculation` untuk mengontrol per customer

## 🐛 Troubleshooting

### Data Tidak Sinkron
```bash
# Force recalculate specific customer
php artisan balance:sync-realtime --customer_id=123 --force

# Check log untuk error
tail -f storage/logs/laravel.log | grep "RealtimeBalance"
```

### Performance Issues
```bash
# Check index di database
SHOW INDEX FROM monthly_customer_balances;
SHOW INDEX FROM transaction_calculations;
```

### Disable Real-time untuk Customer Tertentu
```php
$customer = User::find(123);
$customer->update(['use_realtime_calculation' => false]);
```

## 📈 Benefits

1. **Query Performance**: Data sudah dihitung dan tersimpan
2. **Konsistensi**: Tidak ada perbedaan perhitungan
3. **Audit Trail**: Semua perhitungan tersimpan dengan detail
4. **Scalability**: Mudah untuk membuat fitur reporting/analytics
5. **Real-time**: Update otomatis ketika ada perubahan data

---

*Sistem ini dirancang untuk mendukung fitur-fitur masa depan yang membutuhkan data balance dari database.*
