@echo off
echo Clearing Laravel caches...

echo.
echo 1. Clearing application cache...
php artisan cache:clear

echo.
echo 2. Clearing config cache...
php artisan config:clear

echo.
echo 3. Clearing route cache...
php artisan route:clear

echo.
echo 4. Clearing view cache...
php artisan view:clear

echo.
echo 5. Regenerating autoload files...
composer dump-autoload --optimize

echo.
echo 6. Optimizing for production...
php artisan optimize

echo.
echo Cache clearing completed!
pause
