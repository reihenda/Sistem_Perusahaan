<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Pagination\Paginator;
use App\Models\MonthlyCustomerBalance;
use App\Observers\MonthlyCustomerBalanceObserver;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Menggunakan Bootstrap untuk tampilan paginasi
        Paginator::useBootstrap();
        
        // Register Observer untuk sinkronisasi monthly_balances
        MonthlyCustomerBalance::observe(MonthlyCustomerBalanceObserver::class);
    }
}
