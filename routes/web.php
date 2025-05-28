<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\DataPencatatanController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\FobController;
use App\Http\Controllers\RekapPengambilanController;
use App\Http\Controllers\NomorPolisiController;
use App\Http\Controllers\UkuranController;
use App\Http\Controllers\InvoiceController;
use App\Http\Controllers\BillingController;
use App\Http\Controllers\KeuanganController;
use App\Http\Controllers\KasController;
use App\Http\Controllers\BankController;
use App\Http\Controllers\FinancialAccountController;
use App\Http\Controllers\TransactionDescriptionController;
use App\Http\Controllers\ExcelImportController;


// Rute Autentikasi
Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

// Rute untuk SuperAdmin
Route::middleware(['auth', 'role:superadmin'])->group(function () {
    Route::get('/superadmin/dashboard', [DashboardController::class, 'superadminDashboard'])
        ->name('superadmin.dashboard');
});

// Rute untuk Admin
Route::middleware(['auth', 'role:admin,superadmin'])->group(function () {
    // Rute untuk Lembur Operator GTM
    Route::get('/operator-gtm', [App\Http\Controllers\OperatorGtmController::class, 'index'])->name('operator-gtm.index');
    Route::get('/operator-gtm/create', [App\Http\Controllers\OperatorGtmController::class, 'create'])->name('operator-gtm.create');
    Route::post('/operator-gtm', [App\Http\Controllers\OperatorGtmController::class, 'store'])->name('operator-gtm.store');
    Route::get('/operator-gtm/{operatorGtm}', [App\Http\Controllers\OperatorGtmController::class, 'show'])->name('operator-gtm.show');
    Route::get('/operator-gtm/{operatorGtm}/edit', [App\Http\Controllers\OperatorGtmController::class, 'edit'])->name('operator-gtm.edit');
    Route::put('/operator-gtm/{operatorGtm}', [App\Http\Controllers\OperatorGtmController::class, 'update'])->name('operator-gtm.update');
    Route::delete('/operator-gtm/{operatorGtm}', [App\Http\Controllers\OperatorGtmController::class, 'destroy'])->name('operator-gtm.destroy');
    Route::get('/operator-gtm/{operatorGtm}/create-lembur', [App\Http\Controllers\OperatorGtmController::class, 'createLembur'])->name('operator-gtm.create-lembur');
    Route::post('/operator-gtm/{operatorGtm}/lembur', [App\Http\Controllers\OperatorGtmController::class, 'storeLembur'])->name('operator-gtm.store-lembur');
    Route::get('/operator-gtm-lembur/{lembur}/edit', [App\Http\Controllers\OperatorGtmController::class, 'editLembur'])->name('operator-gtm.edit-lembur');
    Route::put('/operator-gtm-lembur/{lembur}', [App\Http\Controllers\OperatorGtmController::class, 'updateLembur'])->name('operator-gtm.update-lembur');
    Route::delete('/operator-gtm-lembur/{lembur}', [App\Http\Controllers\OperatorGtmController::class, 'destroyLembur'])->name('operator-gtm.destroy-lembur');

    Route::get('/admin/dashboard', [DashboardController::class, 'adminDashboard'])
        ->name('admin.dashboard');

    // Rute untuk kelola user
    Route::get('/kelola-user', [UserController::class, 'index'])->name('user.index');
    Route::post('/tambah-user', [AuthController::class, 'tambahUser'])->name('tambah.user');
    Route::get('/edit-user/{user}', [UserController::class, 'edit'])->name('user.edit');
    Route::put('/update-user/{user}', [UserController::class, 'update'])->name('user.update');
    Route::delete('/delete-user/{user}', [UserController::class, 'destroy'])->name('user.destroy');

    // Rute untuk Keuangan
    Route::get('/keuangan', [KeuanganController::class, 'index'])->name('keuangan.index');

    // Rute untuk Financial Accounts
    Route::get('/keuangan/accounts', [FinancialAccountController::class, 'index'])->name('keuangan.accounts.index');
    Route::get('/keuangan/accounts/create', [FinancialAccountController::class, 'create'])->name('keuangan.accounts.create');
    Route::post('/keuangan/accounts', [FinancialAccountController::class, 'store'])->name('keuangan.accounts.store');
    Route::get('/keuangan/accounts/{account}/edit', [FinancialAccountController::class, 'edit'])->name('keuangan.accounts.edit');
    Route::put('/keuangan/accounts/{account}', [FinancialAccountController::class, 'update'])->name('keuangan.accounts.update');
    Route::delete('/keuangan/accounts/{account}', [FinancialAccountController::class, 'destroy'])->name('keuangan.accounts.destroy');

    // Rute untuk Transaction Descriptions
    Route::get('/keuangan/descriptions', [TransactionDescriptionController::class, 'index'])->name('keuangan.descriptions.index');
    Route::get('/keuangan/descriptions/create', [TransactionDescriptionController::class, 'create'])->name('keuangan.descriptions.create');
    Route::post('/keuangan/descriptions', [TransactionDescriptionController::class, 'store'])->name('keuangan.descriptions.store');
    Route::get('/keuangan/descriptions/{description}/edit', [TransactionDescriptionController::class, 'edit'])->name('keuangan.descriptions.edit');
    Route::put('/keuangan/descriptions/{description}', [TransactionDescriptionController::class, 'update'])->name('keuangan.descriptions.update');
    Route::delete('/keuangan/descriptions/{description}', [TransactionDescriptionController::class, 'destroy'])->name('keuangan.descriptions.destroy');
    Route::get('/api/descriptions/category', [TransactionDescriptionController::class, 'getByCategory'])->name('keuangan.descriptions.by-category');

    // Rute untuk Kas
    Route::get('/keuangan/kas', [KasController::class, 'index'])->name('keuangan.kas.index');
    Route::get('/keuangan/kas/create', [KasController::class, 'create'])->name('keuangan.kas.create');
    Route::post('/keuangan/kas', [KasController::class, 'store'])->name('keuangan.kas.store');
    Route::get('/keuangan/kas/{transaction}/edit', [KasController::class, 'edit'])->name('keuangan.kas.edit');
    Route::put('/keuangan/kas/{transaction}', [KasController::class, 'update'])->name('keuangan.kas.update');
    Route::delete('/keuangan/kas/{transaction}', [KasController::class, 'destroy'])->name('keuangan.kas.destroy');

    // Rute untuk Bank
    Route::get('/keuangan/bank', [BankController::class, 'index'])->name('keuangan.bank.index');
    Route::get('/keuangan/bank/create', [BankController::class, 'create'])->name('keuangan.bank.create');
    Route::post('/keuangan/bank', [BankController::class, 'store'])->name('keuangan.bank.store');
    Route::get('/keuangan/bank/{transaction}/edit', [BankController::class, 'edit'])->name('keuangan.bank.edit');
    Route::put('/keuangan/bank/{transaction}', [BankController::class, 'update'])->name('keuangan.bank.update');
    Route::delete('/keuangan/bank/{transaction}', [BankController::class, 'destroy'])->name('keuangan.bank.destroy');

    // Rute untuk Rekap Penjualan
    Route::get('/rekap-penjualan', [App\Http\Controllers\Rekap\RekapPenjualanController::class, 'index'])
        ->name('rekap.penjualan.index');
    Route::get('/rekap-penjualan/cetak', [App\Http\Controllers\Rekap\RekapPenjualanController::class, 'cetakRekapPenjualan'])
        ->name('rekap.penjualan.cetak');

    // Rute untuk data pencatatan
    Route::get('/data-pencatatan', [DataPencatatanController::class, 'index'])
        ->name('data-pencatatan.index');
    Route::get('/data-pencatatan/create', [DataPencatatanController::class, 'create'])
        ->name('data-pencatatan.create');
    Route::post('/data-pencatatan', [DataPencatatanController::class, 'store'])
        ->name('data-pencatatan.store');
    Route::get('/data-pencatatan/{dataPencatatan}', [DataPencatatanController::class, 'show'])
        ->name('data-pencatatan.show');
    Route::get('/data-pencatatan/{dataPencatatan}/edit', [DataPencatatanController::class, 'edit'])
        ->name('data-pencatatan.edit');
    Route::put('/data-pencatatan/{dataPencatatan}', [DataPencatatanController::class, 'update'])
        ->name('data-pencatatan.update');
    Route::delete('/data-pencatatan/{dataPencatatan}', [DataPencatatanController::class, 'destroy'])
        ->name('data-pencatatan.destroy');
    Route::get('/data-pencatatan/customer/{customer}', [DataPencatatanController::class, 'customerDetail'])
        ->name('data-pencatatan.customer-detail');
    Route::post('/user/customer/{customer}/update-pricing', [UserController::class, 'updateCustomerPricing'])
        ->name('user.update-pricing');
    Route::post('/user/customer/{customer}/update-pricing-khusus', [UserController::class, 'updateCustomerPricingKhusus'])
        ->name('user.update-pricing-khusus');
    Route::get('/data-pencatatan/customer/{customer}/details', [DataPencatatanController::class, 'getCustomerDetails'])
        ->name('data-pencatatan.customer-details');
    Route::post('/customer/{userId}/add-deposit', [UserController::class, 'addDeposit'])
        ->name('customer.add-deposit');
    Route::delete('/customers/{userId}/remove-deposit', [UserController::class, 'removeDeposit'])
        ->name('customer.remove-deposit');
    Route::post('/data-pencatatan/{customer}/filter', [DataPencatatanController::class, 'filterByDateRange'])
        ->name('data-pencatatan.filter');
    Route::post('/data-pencatatan/{customer}/import-excel', [ExcelImportController::class, 'importExcel'])
        ->name('data-pencatatan.import-excel');
    Route::get('/data-pencatatan/template-excel', [ExcelImportController::class, 'downloadTemplateExcel'])
        ->name('data-pencatatan.template-excel');
    Route::get('/data-pencatatan/get-latest-reading', [DataPencatatanController::class, 'getLatestReading'])
        ->name('data-pencatatan.get-latest-reading');
    Route::get('/data-pencatatan/create/{customerId}', [DataPencatatanController::class, 'createWithCustomer'])
        ->name('data-pencatatan.create-with-customer');

    // Rute untuk Rekap Pengambilan
    Route::get('/rekap-pengambilan', [RekapPengambilanController::class, 'index'])
        ->name('rekap-pengambilan.index');
    Route::get('/rekap-pengambilan/create', [RekapPengambilanController::class, 'create'])
        ->name('rekap-pengambilan.create');
    Route::post('/rekap-pengambilan', [RekapPengambilanController::class, 'store'])
        ->name('rekap-pengambilan.store');
    Route::get('/rekap-pengambilan/{rekapPengambilan}', [RekapPengambilanController::class, 'show'])
        ->name('rekap-pengambilan.show');
    Route::get('/rekap-pengambilan/{rekapPengambilan}/edit', [RekapPengambilanController::class, 'edit'])
        ->name('rekap-pengambilan.edit');
    Route::put('/rekap-pengambilan/{rekapPengambilan}', [RekapPengambilanController::class, 'update'])
        ->name('rekap-pengambilan.update');
    Route::delete('/rekap-pengambilan/{rekapPengambilan}', [RekapPengambilanController::class, 'destroy'])
        ->name('rekap-pengambilan.destroy');

    // Rute untuk mengelola nomor polisi
    Route::resource('nomor-polisi', NomorPolisiController::class);
    // Make sure the route name matches what's being used in the view
    Route::get('/api/nomor-polisi/get-all', [NomorPolisiController::class, 'getAll'])->name('nomor-polisi.getAll');

    // Rute untuk mengelola ukuran
    Route::get('/api/ukuran/get-all', [UkuranController::class, 'getAll'])->name('ukuran.getAll');
    Route::post('/api/ukuran', [UkuranController::class, 'store'])->name('ukuran.store');

    // Route baru untuk filter berdasarkan bulan dan tahun
    Route::post('/data-pencatatan/{customer}/filter-month-year', [DataPencatatanController::class, 'filterByMonthYear'])
        ->name('data-pencatatan.filter-month-year');

    // Route baru untuk mendapatkan riwayat pricing
    Route::get('/customer/{customer}/pricing-history', [UserController::class, 'getPricingHistory'])
        ->name('customer.pricing-history');

    // Route untuk cetak billing dalam bentuk PDF
    Route::get('/customer/{customer}/print-billing', [DataPencatatanController::class, 'printBilling'])
        ->name('data-pencatatan.print-billing');

    // Route untuk cetak invoice dalam bentuk PDF
    Route::get('/customer/{customer}/print-invoice', [DataPencatatanController::class, 'printInvoice'])
        ->name('data-pencatatan.print-invoice');
        
    // Route untuk sinkronisasi saldo
    Route::get('/sync-balance/{customer}', [UserController::class, 'syncBalance'])
        ->name('sync.balance');

    // Rute untuk FOB
    Route::get('/data-pencatatan/fob/create', [FobController::class, 'create'])
        ->name('data-pencatatan.fob.create');
    Route::get('/data-pencatatan/fob/create/{fobId}', [FobController::class, 'createWithFob'])
        ->name('data-pencatatan.fob.create-with-fob');
    Route::get('/data-pencatatan/fob/{customer}', [FobController::class, 'fobDetail'])
        ->name('data-pencatatan.fob-detail');
    Route::post('/data-pencatatan/fob', [FobController::class, 'store'])
        ->name('data-pencatatan.fob.store');
    Route::post('/data-pencatatan/fob/{customer}/filter-month-year', [FobController::class, 'filterByMonthYear'])
        ->name('data-pencatatan.fob.filter-month-year');
    Route::get('/data-pencatatan/fob/{customer}/sync', [FobController::class, 'syncData'])
        ->name('data-pencatatan.fob.sync-data');
    Route::get('/data-pencatatan/fob/{fob}/debug', function (App\Models\User $fob) {
        return view('data-pencatatan.fob.fob-debug', compact('fob'));
    })->name('fob.debug');
    Route::post('/fob/{fobId}/update-pricing', [UserController::class, 'updateFobPricing'])
        ->name('fob.update-pricing');

    // Rute untuk Invoice dan Billing
    Route::get('/invoices', [InvoiceController::class, 'index'])->name('invoices.index');
    Route::get('/invoices/select-customer', [InvoiceController::class, 'selectCustomer'])->name('invoices.select-customer');
    Route::get('/invoices/create/{customer}', [InvoiceController::class, 'create'])->name('invoices.create');
    Route::post('/invoices/{customer}', [InvoiceController::class, 'store'])->name('invoices.store');
    Route::get('/invoices/{invoice}', [InvoiceController::class, 'show'])->name('invoices.show');
    Route::get('/invoices/{invoice}/edit', [InvoiceController::class, 'edit'])->name('invoices.edit');
    Route::put('/invoices/{invoice}', [InvoiceController::class, 'update'])->name('invoices.update');
    Route::delete('/invoices/{invoice}', [InvoiceController::class, 'destroy'])->name('invoices.destroy');

    Route::get('/billings', [BillingController::class, 'index'])->name('billings.index');
    Route::get('/billings/select-customer', [BillingController::class, 'selectCustomer'])->name('billings.select-customer');
    Route::get('/billings/create/{customer}', [BillingController::class, 'create'])->name('billings.create');
    Route::post('/billings/{customer}', [BillingController::class, 'store'])->name('billings.store');
    Route::get('/billings/{billing}', [BillingController::class, 'show'])->name('billings.show');
    Route::get('/billings/{billing}/edit', [BillingController::class, 'edit'])->name('billings.edit');
    Route::put('/billings/{billing}', [BillingController::class, 'update'])->name('billings.update');
    Route::delete('/billings/{billing}', [BillingController::class, 'destroy'])->name('billings.destroy');
});

// Rute untuk Customer
Route::middleware(['auth', 'role:customer'])->group(function () {
    Route::get('/customer/dashboard', [DashboardController::class, 'customerDashboard'])
        ->name('customer.dashboard');

    // Route untuk filter dashboard
    Route::get('/customer/filter', [DashboardController::class, 'customerDashboard'])
        ->name('customer.filter');

    // Modifikasi route ini agar bisa menerima parameter filter
    Route::get('/data-saya', [DataPencatatanController::class, 'indexCustomer'])
        ->name('customer.data');

    // Proses pembayaran
    Route::post('/proses-pembayaran/{dataPencatatan}', [DataPencatatanController::class, 'prosesPembayaran'])
        ->name('customer.proses-pembayaran');

    // Lihat invoice dan billing untuk customer
    Route::get('/customer/invoices', [InvoiceController::class, 'customerInvoices'])->name('customer.invoices');
    Route::get('/customer/billings', [BillingController::class, 'customerBillings'])->name('customer.billings');
});

// Rute untuk Demo
Route::middleware(['auth', 'role:demo'])->group(function () {
    // Demo Admin
    Route::get('/demo/admin', [App\Http\Controllers\Demo\DemoController::class, 'demoAdmin'])
        ->name('demo.admin');

    // Demo Customer
    Route::get('/demo/customer', [App\Http\Controllers\Demo\DemoController::class, 'demoCustomer'])
        ->name('demo.customer');

    // Filter Demo
    Route::post('/demo/filter', [App\Http\Controllers\Demo\DemoController::class, 'filterByMonthYear'])
        ->name('demo.filter');

    // Create data pencatatan (Demo)
    Route::get('/demo/create', [App\Http\Controllers\Demo\DemoController::class, 'create'])
        ->name('demo.create');

    // Store data pencatatan (Demo)
    Route::post('/demo/store', [App\Http\Controllers\Demo\DemoController::class, 'store'])
        ->name('demo.store');

    // Update pricing (Demo)
    Route::post('/demo/pricing', [App\Http\Controllers\Demo\DemoController::class, 'updatePricing'])
        ->name('demo.update-pricing');

    // Add deposit (Demo)
    Route::post('/demo/deposit', [App\Http\Controllers\Demo\DemoController::class, 'addDeposit'])
        ->name('demo.deposit');

    // Remove deposit (Demo)
    Route::delete('/demo/deposit/{index}', [App\Http\Controllers\Demo\DemoController::class, 'removeDeposit'])
        ->name('demo.remove-deposit');
});

// Rute default setelah login
Route::get('/', function () {
    return redirect('/login');
});
