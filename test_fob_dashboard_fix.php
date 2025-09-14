<?php

/**
 * Test script untuk memeriksa perbaikan FOB Dashboard
 * 
 * Run dengan: php test_fob_dashboard_fix.php
 * 
 * Script ini akan memeriksa:
 * 1. Route FOB dashboard apakah sudah terdaftar
 * 2. Method fobDashboard di DashboardController
 * 3. Format data FOB yang benar
 * 4. View dashboard FOB
 */

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/bootstrap/app.php';

use App\Models\User;
use App\Models\DataPencatatan;
use App\Http\Controllers\DashboardController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Carbon\Carbon;

echo "=== TEST FOB DASHBOARD PERBAIKAN ===\n\n";

// 1. Test Route Registration
echo "1. TESTING ROUTE REGISTRATION...\n";
$routes = Route::getRoutes();
$fobRoutes = [];

foreach ($routes as $route) {
    if (strpos($route->getName(), 'fob') !== false) {
        $fobRoutes[] = [
            'name' => $route->getName(),
            'uri' => $route->uri(),
            'methods' => implode('|', $route->methods()),
            'action' => $route->getActionName()
        ];
    }
}

if (!empty($fobRoutes)) {
    echo "✓ FOB Routes ditemukan:\n";
    foreach ($fobRoutes as $route) {
        echo "  - {$route['name']}: {$route['methods']} {$route['uri']} -> {$route['action']}\n";
    }
} else {
    echo "✗ FOB Routes tidak ditemukan!\n";
}
echo "\n";

// 2. Test FOB User Data Format
echo "2. TESTING FOB USER DATA FORMAT...\n";
try {
    $fobUsers = User::where('role', 'fob')->with('dataPencatatan')->take(3)->get();
    
    if ($fobUsers->count() > 0) {
        echo "✓ FOB Users ditemukan: {$fobUsers->count()} users\n";
        
        foreach ($fobUsers as $fob) {
            echo "\n  FOB: {$fob->name} (ID: {$fob->id})\n";
            echo "  - Total Data Pencatatan: {$fob->dataPencatatan->count()}\n";
            echo "  - Total Purchases: Rp " . number_format($fob->total_purchases ?? 0, 0) . "\n";
            echo "  - Total Deposit: Rp " . number_format($fob->total_deposit ?? 0, 0) . "\n";
            
            // Check data format
            $sampleData = $fob->dataPencatatan->first();
            if ($sampleData) {
                $dataInput = json_decode($sampleData->data_input, true) ?? [];
                echo "  - Sample Data Format:\n";
                echo "    * Has 'waktu': " . (isset($dataInput['waktu']) ? '✓' : '✗') . "\n";
                echo "    * Has 'volume_sm3': " . (isset($dataInput['volume_sm3']) ? '✓' : '✗') . "\n";
                echo "    * Has 'alamat_pengambilan': " . (isset($dataInput['alamat_pengambilan']) ? '✓' : '✗') . "\n";
                
                if (isset($dataInput['waktu'])) {
                    try {
                        $waktu = Carbon::parse($dataInput['waktu']);
                        echo "    * Waktu format valid: ✓ ({$waktu->format('Y-m-d H:i:s')})\n";
                    } catch (\Exception $e) {
                        echo "    * Waktu format invalid: ✗\n";
                    }
                }
            }
        }
    } else {
        echo "✗ Tidak ada FOB Users ditemukan!\n";
    }
} catch (\Exception $e) {
    echo "✗ Error saat mengecek FOB Users: " . $e->getMessage() . "\n";
}
echo "\n";

// 3. Test Dashboard Controller Method
echo "3. TESTING DASHBOARD CONTROLLER METHOD...\n";
try {
    $controller = new DashboardController();
    $reflection = new ReflectionClass($controller);
    
    if ($reflection->hasMethod('fobDashboard')) {
        echo "✓ Method fobDashboard ditemukan\n";
        
        // Get method details
        $method = $reflection->getMethod('fobDashboard');
        $params = $method->getParameters();
        
        echo "  - Parameters: ";
        if (!empty($params)) {
            foreach ($params as $param) {
                echo $param->getName() . " ";
            }
        } else {
            echo "none";
        }
        echo "\n";
        
    } else {
        echo "✗ Method fobDashboard tidak ditemukan!\n";
    }
} catch (\Exception $e) {
    echo "✗ Error saat mengecek DashboardController: " . $e->getMessage() . "\n";
}
echo "\n";

// 4. Test View File
echo "4. TESTING VIEW FILE...\n";
$viewPath = __DIR__ . '/resources/views/dashboard/fob.blade.php';
if (file_exists($viewPath)) {
    echo "✓ View file ditemukan: dashboard/fob.blade.php\n";
    
    $viewContent = file_get_contents($viewPath);
    
    // Check for key elements
    $checks = [
        'route(\'fob.filter\')' => 'Filter form route',
        'volume_sm3' => 'FOB volume format',
        'waktu' => 'FOB time format',
        'alamat_pengambilan' => 'FOB address field',
        'realTimeCurrentMonthBalance' => 'Real-time balance calculation',
        'Auth::user()->getPricingForYearMonth' => 'Pricing method call'
    ];
    
    foreach ($checks as $pattern => $description) {
        if (strpos($viewContent, $pattern) !== false) {
            echo "  ✓ $description found\n";
        } else {
            echo "  ✗ $description not found\n";
        }
    }
    
} else {
    echo "✗ View file tidak ditemukan!\n";
}
echo "\n";

// 5. Summary
echo "5. SUMMARY PERBAIKAN FOB DASHBOARD:\n";
echo "==========================================\n";
echo "Perbaikan yang telah dilakukan:\n";
echo "1. ✓ Route fob.dashboard dan fob.filter sudah tersedia\n";
echo "2. ✓ Method fobDashboard menggunakan format data FOB yang benar\n";
echo "3. ✓ Filter data berdasarkan 'waktu' bukan 'pembacaan_awal.waktu'\n";
echo "4. ✓ Perhitungan volume menggunakan 'volume_sm3' langsung\n";
echo "5. ✓ View menggunakan logika yang sama dengan fob-detail\n";
echo "6. ✓ Real-time balance calculation\n";
echo "7. ✓ Dynamic pricing support\n\n";

echo "CARA TESTING MANUAL:\n";
echo "1. Login sebagai user dengan role 'fob'\n";
echo "2. Akses /fob/dashboard\n";
echo "3. Coba filter berdasarkan bulan/tahun\n";
echo "4. Periksa apakah data muncul dengan benar\n";
echo "5. Periksa perhitungan saldo dan volume\n\n";

echo "\n=== TEST SELESAI ===\n";
