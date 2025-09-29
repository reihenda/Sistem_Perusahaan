<?php

/**
 * Test Authentication & Session
 * Buka di browser setelah login: http://127.0.0.1:8000/test_auth.php
 * ATAU letakkan di public/ dan akses: http://localhost/nama-folder/public/test_auth.php
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

// Capture request dari browser (dengan cookies)
$request = Illuminate\Http\Request::capture();
$response = $kernel->handle($request);

// Start session
session_start();

echo "<h1>Authentication Test</h1>";
echo "<hr>";

echo "<h2>Session Data:</h2>";
echo "<pre>";
print_r($_SESSION);
echo "</pre>";

echo "<h2>Cookies:</h2>";
echo "<pre>";
print_r($_COOKIE);
echo "</pre>";

echo "<h2>Auth Check:</h2>";
try {
    $user = auth()->user();
    if ($user) {
        echo "<div style='background: #d4edda; padding: 20px; border: 2px solid #28a745;'>";
        echo "<h3>✅ User Terautentikasi!</h3>";
        echo "ID: " . $user->id . "<br>";
        echo "Name: " . $user->name . "<br>";
        echo "Email: " . $user->email . "<br>";
        echo "Role: " . $user->role . "<br>";
        echo "</div>";
        
        echo "<h2>Role Check:</h2>";
        echo "isAdmin: " . ($user->isAdmin() ? 'YES' : 'NO') . "<br>";
        echo "isKeuangan: " . ($user->isKeuangan() ? 'YES' : 'NO') . "<br>";
        echo "isSuperAdmin: " . ($user->isSuperAdmin() ? 'YES' : 'NO') . "<br>";
    } else {
        echo "<div style='background: #f8d7da; padding: 20px; border: 2px solid #dc3545;'>";
        echo "<h3>❌ User TIDAK terautentikasi!</h3>";
        echo "Session mungkin bermasalah atau belum login";
        echo "</div>";
    }
} catch (Exception $e) {
    echo "<div style='background: #fff3cd; padding: 20px; border: 2px solid #ffc107;'>";
    echo "<h3>⚠️ Error saat cek auth:</h3>";
    echo $e->getMessage();
    echo "</div>";
}

echo "<h2>Test Route Access:</h2>";
echo "<a href='/invoices/select-customer' target='_blank'>Test: /invoices/select-customer</a><br>";
echo "<a href='/billings/select-customer' target='_blank'>Test: /billings/select-customer</a><br>";
echo "<a href='/data-pencatatan' target='_blank'>Test: /data-pencatatan</a><br>";

$kernel->terminate($request, $response);
