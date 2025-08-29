# FOB Billing Implementation - Changelog

## Perubahan yang Dibuat

### 1. BillingController.php
**File**: `app/Http/Controllers/BillingController.php`
**Method**: `selectCustomer()`

**Perubahan**:
- Mengubah query untuk mengambil customer reguler dan FOB
- Customer reguler ditampilkan terlebih dahulu, kemudian FOB
- Menggabungkan kedua collection menggunakan `concat()`

```php
// SEBELUM
$customers = User::where('role', 'customer')
    ->orderBy('name')
    ->get();

// SESUDAH  
$regularCustomers = User::where('role', 'customer')
    ->orderBy('name')
    ->get();
    
$fobCustomers = User::where('role', 'fob')
    ->orderBy('name')
    ->get();
    
$customers = $regularCustomers->concat($fobCustomers);
```

### 2. select-customer.blade.php
**File**: `resources/views/billings/select-customer.blade.php`

**Perubahan**:
- Menambah kolom "Jenis" untuk menampilkan badge jenis customer
- Badge biru untuk Customer reguler, badge hijau untuk FOB
- Update colspan pada empty state dari 4 ke 5

**Tampilan Badge**:
```html
@if($customer->role === 'customer')
    <span class="badge badge-primary">Customer</span>
@elseif($customer->role === 'fob')
    <span class="badge badge-success">FOB</span>
@endif
```

### 3. create.blade.php
**File**: `resources/views/billings/create.blade.php`

**Perubahan**:
- Update page title untuk menampilkan jenis customer
- Menambah badge di header card untuk identifikasi jenis customer

## Fitur yang Ditambahkan

1. **FOB Customer Billing**: Customer dengan role `fob` sekarang dapat membuat billing
2. **Visual Identification**: Badge dan label untuk membedakan customer reguler dan FOB
3. **Proper Ordering**: Customer reguler ditampilkan terlebih dahulu, kemudian FOB
4. **Consistent Logic**: Logika billing tetap sama untuk kedua jenis customer

## Catatan Teknis

- Logika perhitungan billing tetap menggunakan method yang sudah ada di model User
- Customer FOB sudah menggunakan `koreksi_meter = 1.0` secara otomatis melalui `getPricingForYearMonth()`
- Tidak ada perubahan pada database schema atau model relationships
- Test case disediakan untuk memverifikasi fungsionalitas

## Testing

File test: `tests/Feature/FobBillingTest.php`

Test cases yang disediakan:
1. `fob_customers_appear_in_billing_select_list()` - Memverifikasi FOB muncul di list
2. `fob_customer_can_create_billing()` - Memverifikasi FOB bisa membuat billing  
3. `regular_customers_appear_first_in_billing_list()` - Memverifikasi urutan tampilan

## Cara Menjalankan Test

```bash
php artisan test --filter FobBillingTest
```

Atau untuk test spesifik:

```bash
php artisan test --filter "fob_customers_appear_in_billing_select_list"
```
