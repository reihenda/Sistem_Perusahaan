# Test Script untuk Fallback Harga Gagas

## Quick Test Commands

### 1. Test Structure Files
```bash
# Cek apakah file controller sudah benar
php artisan route:list | grep rekap.pembelian

# Cek apakah model bisa diakses
php artisan tinker
>>> use App\Models\HargaGagas;
>>> HargaGagas::all();
>>> exit
```

### 2. Test Fallback Logic di Tinker
```bash
php artisan tinker

# Test model HargaGagas
use App\Models\HargaGagas;
use Carbon\Carbon;

# Buat data test
HargaGagas::create([
    'harga_usd' => 10.50,
    'rate_konversi_idr' => 15000,
    'kalori' => 1050,
    'periode_tahun' => 2024,
    'periode_bulan' => 6
]);

# Test method fallback
use App\Http\Controllers\Rekap\RekapPembelianController;
$controller = new RekapPembelianController(app(\App\Services\CurrencyService::class));

# Test private method via reflection (untuk testing)
$reflection = new \ReflectionClass($controller);
$method = $reflection->getMethod('getHargaGagasWithFallback');
$method->setAccessible(true);

$result = $method->invoke($controller, 2024, 7); // Juli 2024 (tidak ada data)
dd($result);

exit
```

### 3. Test Via Browser
1. **Setup Data**: Buat harga gagas untuk Juni 2024
2. **Access Fallback**: Buka rekap pembelian Juli 2024
3. **Check Warning**: Pastikan muncul warning fallback
4. **Test Copy**: Coba fitur copy di kelola harga gagas

### 4. Test Routes
```bash
# Test apakah route sudah terdaftar
php artisan route:list | grep copy-from-previous
```

## Expected Results

### ✅ Normal Case (Ada Data)
- URL: `/rekap-pembelian?tahun=2024&bulan=6`
- Result: Data normal, tidak ada warning

### ✅ Fallback Case (Tidak Ada Data)
- URL: `/rekap-pembelian?tahun=2024&bulan=7`
- Result: 
  - Warning: "Data harga gagas untuk Juli 2024 belum diatur. Menggunakan data dari Juni 2024"
  - Data pembelian menggunakan harga gagas Juni 2024

### ✅ Copy Feature
- URL: `/rekap-pembelian/kelola-harga-gagas?tahun=2024&bulan=7`
- Result:
  - Info box: "Data Periode Sebelumnya Tersedia - Juni 2024"
  - Tombol: "Salin dari Juni 2024"
  - Click: Form terisi otomatis dengan data Juni

## Debug Commands

### Jika Ada Error
```bash
# Clear cache
php artisan cache:clear
php artisan config:clear
php artisan view:clear

# Check logs
tail -f storage/logs/laravel.log
```

### Check Database
```sql
-- Cek table harga_gagas
SELECT * FROM harga_gagas ORDER BY periode_tahun DESC, periode_bulan DESC;

-- Cek table rekap_pengambilan
SELECT COUNT(*) as total, 
       YEAR(tanggal) as tahun, 
       MONTH(tanggal) as bulan 
FROM rekap_pengambilan 
GROUP BY YEAR(tanggal), MONTH(tanggal) 
ORDER BY tahun DESC, bulan DESC;
```

## Common Issues & Solutions

### Issue: "Class not found"
```bash
composer dump-autoload
```

### Issue: "Route not found"
```bash
php artisan route:cache
```

### Issue: "Method not found"
Check controller method names dalam route registration

### Issue: "View not found"  
Check blade file paths dan pastikan tidak ada typo

### Issue: "Undefined variable"
Check compact() variables di controller

## Test Data Setup

Untuk testing yang komprehensif, buat data berikut:

```sql
-- Data harga gagas test
INSERT INTO harga_gagas (harga_usd, rate_konversi_idr, kalori, periode_tahun, periode_bulan, created_at, updated_at) VALUES
(10.50, 15000, 1050, 2024, 6, NOW(), NOW()),
(11.00, 15200, 1060, 2024, 8, NOW(), NOW());

-- Data rekap pengambilan test
INSERT INTO rekap_pengambilan (customer_id, tanggal, volume, created_at, updated_at) VALUES
(1, '2024-06-15', 1000, NOW(), NOW()),
(1, '2024-07-15', 1200, NOW(), NOW()),
(1, '2024-08-15', 1100, NOW(), NOW());
```

Dengan data di atas:
- Juni 2024: Ada harga gagas (normal)
- Juli 2024: Tidak ada harga gagas → fallback ke Juni
- Agustus 2024: Ada harga gagas (normal)

