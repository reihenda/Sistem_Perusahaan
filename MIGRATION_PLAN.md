# MIGRATION TO PURE MVC ARCHITECTURE

## PHASE 1: BACKUP CURRENT SYSTEM
```bash
# Create backup folder
mkdir -p storage/backups/removed_components

# Backup observers
cp -r app/Observers storage/backups/removed_components/
cp -r app/Services storage/backups/removed_components/
cp app/Providers/RealtimeBalanceServiceProvider.php storage/backups/removed_components/

# Backup models
cp app/Models/MonthlyCustomerBalance.php storage/backups/removed_components/
cp app/Models/TransactionCalculation.php storage/backups/removed_components/

# Backup commands (except Excel)
cp app/Console/Commands/InitializeRealtimeBalance.php storage/backups/removed_components/
cp app/Console/Commands/SyncRealtimeBalance.php storage/backups/removed_components/
cp app/Console/Commands/SyncMonthlyBalancesToUsers.php storage/backups/removed_components/
```

## PHASE 2: ENHANCED USER MODEL METHODS

```php
// app/Models/User.php - Add these methods:

/**
 * REAL-TIME BALANCE CALCULATION (Pure Model)
 */
public function calculateRealTimeBalance($yearMonth = null) 
{
    $yearMonth = $yearMonth ?? now()->format('Y-m');
    
    // Calculate total deposits up to period
    $totalDeposits = $this->calculateTotalDepositsUntil($yearMonth);
    
    // Calculate total purchases up to period  
    $totalPurchases = $this->calculateTotalPurchasesUntil($yearMonth);
    
    return $totalDeposits - $totalPurchases;
}

/**
 * AUTO-UPDATE BALANCE WHEN DATA CHANGES
 */
protected static function boot()
{
    parent::boot();
    
    static::updated(function ($user) {
        if ($user->isDirty(['deposit_history', 'pricing_history'])) {
            $user->refreshTotalBalances();
        }
    });
}

/**
 * REFRESH ALL BALANCE CALCULATIONS
 */
public function refreshTotalBalances()
{
    // Recalculate total_deposits from deposit_history
    $depositHistory = $this->ensureArray($this->deposit_history);
    $this->total_deposit = collect($depositHistory)->sum('amount');
    
    // Recalculate total_purchases from data_pencatatan
    $this->total_purchases = $this->dataPencatatan()
        ->get()
        ->sum(function ($item) {
            return $this->calculateItemPrice($item);
        });
    
    // Update monthly_balances JSON field
    $this->monthly_balances = $this->generateMonthlyBalances();
    
    $this->save();
}

/**
 * GENERATE MONTHLY BALANCES (Pure calculation)
 */
private function generateMonthlyBalances()
{
    $balances = [];
    $runningBalance = 0;
    
    // Get all months with activity
    $months = $this->getMonthsWithActivity();
    
    foreach ($months as $yearMonth) {
        $monthDeposits = $this->getDepositsForMonth($yearMonth);
        $monthPurchases = $this->getPurchasesForMonth($yearMonth);
        
        $runningBalance = $runningBalance + $monthDeposits - $monthPurchases;
        $balances[$yearMonth] = $runningBalance;
    }
    
    return $balances;
}
```

## PHASE 3: ENHANCED CONTROLLER METHODS

```php
// app/Http/Controllers/DataPencatatanController.php

/**
 * AUTO-UPDATE BALANCE AFTER CRUD OPERATIONS
 */
public function store(Request $request)
{
    // ... existing store logic ...
    
    // Auto-update customer balance
    $customer = User::find($request->customer_id);
    $customer->refreshTotalBalances();
    
    return redirect()->route('data-pencatatan.customer-detail', $customer->id)
        ->with('success', 'Data berhasil disimpan dan saldo diperbarui');
}

public function update(Request $request, DataPencatatan $dataPencatatan) 
{
    // ... existing update logic ...
    
    // Auto-update customer balance
    $customer = $dataPencatatan->customer;
    $customer->refreshTotalBalances();
    
    return redirect()->route('data-pencatatan.customer-detail', $customer->id)
        ->with('success', 'Data berhasil diupdate dan saldo diperbarui');
}

public function destroy(DataPencatatan $dataPencatatan)
{
    $customer = $dataPencatatan->customer;
    
    // ... existing destroy logic ...
    
    // Auto-update customer balance
    $customer->refreshTotalBalances();
    
    return redirect()->route('data-pencatatan.customer-detail', $customer->id)
        ->with('success', 'Data berhasil dihapus dan saldo diperbarui');
}
```

## PHASE 4: REMOVE UNNECESSARY COMPONENTS

```bash
# Remove observers
rm -rf app/Observers/

# Remove services  
rm -rf app/Services/

# Remove service provider
rm app/Providers/RealtimeBalanceServiceProvider.php

# Remove unnecessary models
rm app/Models/MonthlyCustomerBalance.php
rm app/Models/TransactionCalculation.php

# Remove unnecessary commands (keep Excel ones)
rm app/Console/Commands/InitializeRealtimeBalance.php
rm app/Console/Commands/SyncRealtimeBalance.php
rm app/Console/Commands/SyncMonthlyBalancesToUsers.php
rm app/Console/Commands/TestRealtimeBalanceSystem.php

# Remove unnecessary routes
rm routes/realtime_balance.php

# Remove unnecessary controller
rm app/Http/Controllers/RealtimeBalanceController.php
```

## PHASE 5: UPDATE CONFIGURATIONS

```php
// bootstrap/providers.php - Remove RealtimeBalanceServiceProvider
return [
    App\Providers\AppServiceProvider::class,
    // App\Providers\RealtimeBalanceServiceProvider::class, // REMOVED
];

// app/Providers/AppServiceProvider.php - Remove observer registration
public function boot(): void
{
    Paginator::useBootstrap();
    
    // MonthlyCustomerBalance::observe(MonthlyCustomerBalanceObserver::class); // REMOVED
}

// app/Console/Kernel.php - Keep only Excel processing
protected function schedule(Schedule $schedule): void
{
    // Keep this for Excel processing
    $schedule->command('queue:process-kas')
             ->everyMinute()
             ->withoutOverlapping()
             ->runInBackground();
}
```

## PHASE 6: DATABASE CLEANUP

```sql
-- Optional: Drop unnecessary tables (BACKUP FIRST!)
-- DROP TABLE monthly_customer_balances;
-- DROP TABLE transaction_calculations;

-- Or keep tables but don't use them in code
```

## EXPECTED BENEFITS:

### PERFORMANCE:
- ❌ No more Observer overhead
- ❌ No more Service layer calls  
- ❌ No more complex database relationships
- ✅ Simple, direct Model calculations
- ✅ Faster page loads
- ✅ Reduced memory usage

### MAINTAINABILITY:
- ✅ Pure MVC - easy to understand
- ✅ All logic in familiar places (Model & Controller)
- ✅ No hidden Observer magic
- ✅ Debuggable flow: Controller → Model → View

### RELIABILITY:
- ✅ No race conditions between Observers and Commands
- ✅ Predictable execution flow
- ✅ No event cascading issues

## TESTING PLAN:

1. **Backup current system** ✓
2. **Implement enhanced Model methods** 
3. **Update Controller methods**
4. **Test basic functionality** (CRUD operations)
5. **Test balance calculations** (customer-detail, fob-detail views)
6. **Remove components step by step**
7. **Final testing and optimization**

## ROLLBACK PLAN:

If issues arise, restore from storage/backups/removed_components/
