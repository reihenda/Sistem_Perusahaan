<?php

/**
 * Test script untuk mengecek route Laravel
 * Jalankan dengan: php test_routes.php
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

$response = $kernel->handle(
    $request = Illuminate\Http\Request::create('/invoices/select-customer', 'GET')
);

echo "==============================================\n";
echo "TEST ROUTE: /invoices/select-customer\n";
echo "==============================================\n\n";

echo "Status Code: " . $response->getStatusCode() . "\n";
echo "Content Type: " . $response->headers->get('Content-Type') . "\n\n";

if ($response->getStatusCode() === 404) {
    echo "❌ ERROR 404 - Route tidak ditemukan!\n\n";
    echo "Kemungkinan penyebab:\n";
    echo "1. Route tidak terdaftar\n";
    echo "2. Middleware memblokir akses\n";
    echo "3. Controller method tidak ada\n";
} else if ($response->getStatusCode() === 302) {
    echo "⚠️  REDIRECT - Kemungkinan ke halaman login\n";
    echo "Redirect ke: " . $response->headers->get('Location') . "\n\n";
    echo "Ini normal karena route memerlukan autentikasi\n";
} else if ($response->getStatusCode() === 200) {
    echo "✅ SUCCESS - Route dapat diakses!\n";
} else {
    echo "⚠️  Status Code: " . $response->getStatusCode() . "\n";
}

echo "\n==============================================\n";
echo "Daftar Route yang Terdaftar (Invoice):\n";
echo "==============================================\n";

$routes = app('router')->getRoutes();

foreach ($routes as $route) {
    $uri = $route->uri();
    if (strpos($uri, 'invoice') !== false) {
        echo sprintf(
            "%-10s %-50s %s\n",
            implode('|', $route->methods()),
            $uri,
            $route->getName() ?? 'unnamed'
        );
    }
}

echo "\n==============================================\n";
echo "Middleware yang Terdaftar:\n";
echo "==============================================\n";

$middlewareAliases = app('router')->getMiddleware();
foreach ($middlewareAliases as $alias => $class) {
    echo "$alias => $class\n";
}

$kernel->terminate($request, $response);
