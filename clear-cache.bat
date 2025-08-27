#!/bin/bash

# Script untuk membersihkan cache Laravel
echo "Membersihkan cache Laravel..."

cd "E:\Reihan File\IT project\Laravel Project\sistem-informasi-perusahaan"

# Clear application cache
php artisan cache:clear

# Clear config cache
php artisan config:clear

# Clear route cache  
php artisan route:clear

# Clear view cache
php artisan view:clear

# Clear compiled classes
php artisan clear-compiled

# Optimize autoloader
composer dump-autoload --optimize

echo "Cache berhasil dibersihkan!"
