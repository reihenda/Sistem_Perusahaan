@echo off
echo ===============================================
echo FORCE CLEAR CACHE - Laravel & OpCache
echo ===============================================

cd /d "E:\Reihan File\IT project\Laravel Project\sistem-informasi-perusahaan"

echo.
echo [1/8] Clearing application cache...
php artisan cache:clear

echo.
echo [2/8] Clearing config cache...
php artisan config:clear

echo.
echo [3/8] Clearing route cache...
php artisan route:clear

echo.
echo [4/8] Clearing view cache...
php artisan view:clear

echo.
echo [5/8] Clearing compiled classes...
php artisan clear-compiled

echo.
echo [6/8] Optimizing autoloader...
composer dump-autoload --optimize

echo.
echo [7/8] Clearing bootstrap cache...
del /f /q "bootstrap\cache\*.php" 2>nul

echo.
echo [8/8] Attempting to clear OPcache...
php -r "if (function_exists('opcache_reset')) { opcache_reset(); echo 'OPcache cleared successfully'; } else { echo 'OPcache not available'; }"

echo.
echo ===============================================
echo CACHE CLEARED! Please restart your web server
echo ===============================================
echo.
echo Next steps:
echo 1. Restart Apache/Nginx/PHP-FPM
echo 2. Or restart 'php artisan serve' if using built-in server
echo 3. Refresh the browser page
echo ===============================================

pause
