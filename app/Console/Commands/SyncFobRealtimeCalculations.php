<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use App\Models\RekapPengambilan;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class SyncFobRealtimeCalculations extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'fob:sync-realtime 
                            {--customer_id= : ID customer FOB spesifik yang akan disinkronkan}
                            {--all : Sinkronisasi semua customer FOB}
                            {--dry-run : Mode simulasi tanpa menyimpan perubahan}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Sinkronisasi perhitungan realtime FOB dengan total customer yang tersimpan di database';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $this->info('🚀 Memulai sinkronisasi perhitungan realtime FOB...');

        // Check options
        $customerId = $this->option('customer_id');
        $syncAll = $this->option('all');
        $dryRun = $this->option('dry-run');

        if ($dryRun) {
            $this->warn('⚠️  Mode DRY RUN - Tidak ada perubahan yang akan disimpan');
        }

        // Determine which customers to process
        if ($customerId) {
            $customers = User::where('id', $customerId)->where('role', User::ROLE_FOB)->get();
            if ($customers->isEmpty()) {
                $this->error("❌ Customer dengan ID {$customerId} tidak ditemukan atau bukan FOB");
                return Command::FAILURE;
            }
        } elseif ($syncAll) {
            $customers = User::where('role', User::ROLE_FOB)->get();
            $this->info("🔍 Ditemukan " . $customers->count() . " customer FOB");
        } else {
            $this->error('❌ Harap pilih --customer_id=ID atau --all');
            return Command::FAILURE;
        }

        $totalProcessed = 0;
        $totalUpdated = 0;
        $totalErrors = 0;

        foreach ($customers as $customer) {
            try {
                $this->info("📋 Memproses: {$customer->name} (ID: {$customer->id})");
                
                $result = $this->syncCustomerRealtimeCalculations($customer, $dryRun);
                
                if ($result['error']) {
                    $this->error("   ❌ Error: " . $result['error']);
                    $totalErrors++;
                } else {
                    if ($result['updated']) {
                        $this->info("   ✅ Updated: Selisih Rp " . number_format($result['difference'], 0));
                        $totalUpdated++;
                    } else {
                        $this->info("   ✓ Sudah sinkron");
                    }
                }
                
                $totalProcessed++;
                
            } catch (\Exception $e) {
                $this->error("   ❌ Exception: " . $e->getMessage());
                $totalErrors++;
            }
        }

        // Summary
        $this->info("\n📊 Ringkasan:");
        $this->info("   Total diproses: {$totalProcessed}");
        $this->info("   Total diupdate: {$totalUpdated}");
        $this->info("   Total error: {$totalErrors}");

        if ($dryRun) {
            $this->warn("\n⚠️  Mode DRY RUN - Untuk menjalankan perubahan sesungguhnya, hilangkan flag --dry-run");
        }

        return Command::SUCCESS;
    }

    /**
     * Sync realtime calculations for specific customer
     */
    private function syncCustomerRealtimeCalculations(User $customer, $dryRun = false)
    {
        try {
            // Hitung ulang total purchases berdasarkan semua data dengan pricing realtime
            $allRekapPengambilan = RekapPengambilan::where('customer_id', $customer->id)->get();
            
            $calculatedTotalPurchases = 0;
            $calculatedTotalVolume = 0;
            
            foreach ($allRekapPengambilan as $item) {
                $volumeSm3 = floatval($item->volume);
                $calculatedTotalVolume += $volumeSm3;
                
                // Ambil pricing berdasarkan tanggal item (sama seperti perhitungan periode)
                $itemDate = Carbon::parse($item->tanggal);
                $itemYearMonth = $itemDate->format('Y-m');
                $itemPricingInfo = $customer->getPricingForYearMonth($itemYearMonth, $itemDate);
                
                $hargaPerM3 = floatval($itemPricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                $calculatedTotalPurchases += ($volumeSm3 * $hargaPerM3);
            }
            
            // Bandingkan dengan total yang tersimpan di database
            $currentTotalPurchases = $customer->total_purchases;
            $difference = abs($calculatedTotalPurchases - $currentTotalPurchases);
            
            // Jika ada perbedaan signifikan (lebih dari 1 rupiah), update
            if ($difference > 1) {
                Log::info('Console FOB Realtime Sync: Perbedaan total purchases terdeteksi', [
                    'customer_id' => $customer->id,
                    'customer_name' => $customer->name,
                    'calculated_total' => $calculatedTotalPurchases,
                    'current_total' => $currentTotalPurchases,
                    'difference' => $difference,
                    'dry_run' => $dryRun
                ]);
                
                if (!$dryRun) {
                    // Update total_purchases dengan perhitungan realtime
                    $customer->total_purchases = $calculatedTotalPurchases;
                    $customer->save();
                    
                    Log::info('Console FOB Realtime Sync: Total purchases berhasil disinkronkan', [
                        'customer_id' => $customer->id,
                        'new_total_purchases' => $calculatedTotalPurchases
                    ]);
                }
                
                return [
                    'updated' => true,
                    'old_total' => $currentTotalPurchases,
                    'new_total' => $calculatedTotalPurchases,
                    'difference' => $difference,
                    'total_volume' => $calculatedTotalVolume,
                    'error' => null
                ];
            }
            
            return [
                'updated' => false,
                'total_purchases' => $calculatedTotalPurchases,
                'total_volume' => $calculatedTotalVolume,
                'error' => null
            ];
            
        } catch (\Exception $e) {
            Log::error('Console Error dalam syncCustomerRealtimeCalculations', [
                'customer_id' => $customer->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return [
                'updated' => false,
                'error' => $e->getMessage()
            ];
        }
    }
}
