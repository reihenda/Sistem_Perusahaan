<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;


class User extends Authenticatable
{
    use HasFactory, Notifiable;

    // Konstanta untuk role
    const ROLE_ADMIN = 'admin';
    const ROLE_SUPER_ADMIN = 'superadmin';
    const ROLE_CUSTOMER = 'customer';
    const ROLE_FOB = 'fob';
    const ROLE_DEMO = 'demo';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        // Tambahkan kolom baru
        'total_deposit',
        'total_purchases',
        'deposit_history',
        'monthly_balances',
        'harga_per_meter_kubik',
        'tekanan_keluar',
        'suhu',
        'koreksi_meter',
        'pricing_history'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'harga_per_meter_kubik' => 'decimal:2',
        'tekanan_keluar' => 'decimal:3',
        'suhu' => 'decimal:2',
        'koreksi_meter' => 'decimal:14',
        'total_deposit' => 'decimal:2',
        'total_purchases' => 'decimal:2',
        'deposit_history' => 'array',
        'monthly_balances' => 'array',
        'pricing_history' => 'array'
    ];

    /**
     * Helper function to ensure data is always an array
     */
    private function ensureArray($data)
    {
        if (is_string($data)) {
            return json_decode($data, true) ?? [];
        }

        if (is_array($data)) {
            return $data;
        }

        return [];
    }

    public function getTotalVolumeSm3($startDate = null, $endDate = null)
    {
        $query = $this->dataPencatatan();

        // Filter berdasarkan tanggal jika diperlukan
        if ($startDate || $endDate) {
            $query = $query->whereHas('dataPencatatan', function ($q) use ($startDate, $endDate) {
                // Logika filter tanggal
                if ($startDate && $endDate) {
                    $q->whereBetween('created_at', [$startDate, $endDate]);
                } elseif ($startDate) {
                    $q->where('created_at', '>=', $startDate);
                } elseif ($endDate) {
                    $q->where('created_at', '<=', $endDate);
                }
            });
        }

        // Ambil data pencatatan
        $dataPencatatan = $query->get();

        // Hitung total volume SM3
        $totalVolumeSm3 = 0;
        foreach ($dataPencatatan as $item) {
            $dataInput = $this->ensureArray($item->data_input);

            $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);

            // Gunakan koreksi meter dari pricing history jika ada
            $koreksiMeter = $this->getKoreksiMeterForDate($item->created_at);
            $volumeSm3 = $volumeFlowMeter * $koreksiMeter;

            $totalVolumeSm3 += $volumeSm3;
        }

        return $totalVolumeSm3;
    }

    // Metode untuk menambah riwayat pricing
    public function addPricingHistory($hargaPerMeterKubik, $tekananKeluar, $suhu, $koreksiMeter, $customDate = null)
    {
        try {
            DB::beginTransaction();

            // Debug - Log input parameters
            \Log::info('addPricingHistory called', [
                'user_id' => $this->id,
                'role' => $this->role,
                'harga_input' => $hargaPerMeterKubik,
                'harga_input_type' => gettype($hargaPerMeterKubik),
                'tekanan_input' => $tekananKeluar,
                'suhu_input' => $suhu,
                'koreksi_input' => $koreksiMeter,
                'date' => $customDate ? $customDate->format('Y-m-d H:i:s') : 'now'
            ]);

            // Ensure all values are numeric and properly formatted
            $hargaPerMeterKubik = floatval(str_replace(',', '.', $hargaPerMeterKubik));
            $tekananKeluar = floatval(str_replace(',', '.', $tekananKeluar));
            $suhu = floatval(str_replace(',', '.', $suhu));
            $koreksiMeter = floatval(str_replace(',', '.', $koreksiMeter));

            // Log the converted values
            \Log::info('Converted pricing values', [
                'harga_converted' => $hargaPerMeterKubik,
                'tekanan_converted' => $tekananKeluar,
                'suhu_converted' => $suhu,
                'koreksi_converted' => $koreksiMeter
            ]);

            $pricingDate = $customDate ?: now();
            $yearMonth = $pricingDate->format('Y-m');

            // Prepare pricing entry
            $pricingEntry = [
                'date' => $pricingDate->format('Y-m-d H:i:s'),
                'year_month' => $yearMonth,
                'harga_per_meter_kubik' => round($hargaPerMeterKubik, 2),
                'tekanan_keluar' => round($tekananKeluar, 3),
                'suhu' => round($suhu, 2),
                'koreksi_meter' => round($koreksiMeter, 8)
            ];

            // Get current pricing history
            $pricingHistory = $this->ensureArray($this->pricing_history);

            // Debug - Log current pricing history
            \Log::info('Current pricing history', ['history' => $pricingHistory]);

            // Cek apakah sudah ada entri untuk bulan dan tahun yang sama
            $existingIndex = null;
            foreach ($pricingHistory as $index => $entry) {
                if (isset($entry['year_month']) && $entry['year_month'] === $yearMonth) {
                    $existingIndex = $index;
                    break;
                }
            }

            // Update jika sudah ada, tambahkan jika belum
            if ($existingIndex !== null) {
                \Log::info('Updating existing pricing entry', ['index' => $existingIndex]);
                $pricingHistory[$existingIndex] = $pricingEntry;
            } else {
                \Log::info('Adding new pricing entry');
                $pricingHistory[] = $pricingEntry;
            }

            // Update pricing history - tambahkan flag untuk memastikan tidak ada perubahan format
            $this->setAttribute('pricing_history', $pricingHistory);

            // Update current values untuk bulan berjalan
            $currentMonth = now()->format('Y-m');
            if ($yearMonth === $currentMonth) {
                \Log::info('Updating current month values');
                $this->setAttribute('harga_per_meter_kubik', $hargaPerMeterKubik);
                $this->setAttribute('tekanan_keluar', $tekananKeluar);
                $this->setAttribute('suhu', $suhu);
                $this->setAttribute('koreksi_meter', $koreksiMeter);
            }
            
            // Debug - Log before save
            \Log::info('Before saving user', [
                'user_id' => $this->id,
                'new_pricing_history' => $this->pricing_history,
                'new_harga' => $this->harga_per_meter_kubik
            ]);

            // Save the user
            $result = $this->save();

            // Debug - Log save result
            \Log::info('Save result', [
                'result' => $result ? 'success' : 'failed',
                'user_id' => $this->id
            ]);

            DB::commit();

            return $result;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in addPricingHistory', [
                'user_id' => $this->id,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            return false;
        }
    }
    
    /**
     * Metode untuk menambah riwayat pricing dengan periode khusus (rentang tanggal)
     */
    public function addCustomPeriodPricing($hargaPerMeterKubik, $tekananKeluar, $suhu, $koreksiMeter, $startDate, $endDate)
    {
        try {
            DB::beginTransaction();

            // Debug - Log input parameters
            \Log::info('addCustomPeriodPricing called', [
                'user_id' => $this->id,
                'role' => $this->role,
                'harga_input' => $hargaPerMeterKubik,
                'tekanan_input' => $tekananKeluar,
                'suhu_input' => $suhu,
                'koreksi_input' => $koreksiMeter,
                'start_date' => $startDate->format('Y-m-d H:i:s'),
                'end_date' => $endDate->format('Y-m-d H:i:s')
            ]);

            // Ensure all values are numeric and properly formatted
            $hargaPerMeterKubik = floatval(str_replace(',', '.', $hargaPerMeterKubik));
            $tekananKeluar = floatval(str_replace(',', '.', $tekananKeluar));
            $suhu = floatval(str_replace(',', '.', $suhu));
            $koreksiMeter = floatval(str_replace(',', '.', $koreksiMeter));

            // Prepare custom period pricing entry
            $pricingEntry = [
                'type' => 'custom_period',
                'start_date' => $startDate->format('Y-m-d H:i:s'),
                'end_date' => $endDate->format('Y-m-d H:i:s'),
                'harga_per_meter_kubik' => round($hargaPerMeterKubik, 2),
                'tekanan_keluar' => round($tekananKeluar, 3),
                'suhu' => round($suhu, 2),
                'koreksi_meter' => round($koreksiMeter, 8)
            ];

            // Get current custom period pricing history
            $pricingHistory = $this->ensureArray($this->pricing_history);
            
            // Cari apakah sudah ada periode yang overlap dengan periode baru
            $overlappingIndex = null;
            foreach ($pricingHistory as $index => $entry) {
                if (isset($entry['type']) && $entry['type'] === 'custom_period') {
                    $entryStartDate = Carbon::parse($entry['start_date']);
                    $entryEndDate = Carbon::parse($entry['end_date']);
                    
                    // Cek apakah rentang tanggal overlap
                    if (($startDate <= $entryEndDate) && ($endDate >= $entryStartDate)) {
                        $overlappingIndex = $index;
                        break;
                    }
                }
            }

            // Update jika sudah ada periode yang overlap, tambahkan jika belum
            if ($overlappingIndex !== null) {
                \Log::info('Updating existing custom period pricing entry', ['index' => $overlappingIndex]);
                $pricingHistory[$overlappingIndex] = $pricingEntry;
            } else {
                \Log::info('Adding new custom period pricing entry');
                $pricingHistory[] = $pricingEntry;
            }

            // Update pricing history
            $this->setAttribute('pricing_history', $pricingHistory);

            // Save the user
            $result = $this->save();

            // Debug - Log save result
            \Log::info('Save result', [
                'result' => $result ? 'success' : 'failed',
                'user_id' => $this->id
            ]);

            DB::commit();

            return $result;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in addCustomPeriodPricing', [
                'user_id' => $this->id,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            return false;
        }
    }
    public function addPricingHistoryfob($hargaPerMeterKubik, $customDate = null)
    {
        try {
            DB::beginTransaction();

            // Debug - Log input parameters
            \Log::info('addPricingHistory called', [
                'user_id' => $this->id,
                'role' => $this->role,
                'harga_input' => $hargaPerMeterKubik,
                'harga_input_type' => gettype($hargaPerMeterKubik),

                'date' => $customDate ? $customDate->format('Y-m-d H:i:s') : 'now'
            ]);

            // Ensure all values are numeric and properly formatted
            $hargaPerMeterKubik = floatval(str_replace(',', '.', $hargaPerMeterKubik));


            // Log the converted values
            \Log::info('Converted pricing values', [
                'harga_converted' => $hargaPerMeterKubik,

            ]);

            $pricingDate = $customDate ?: now();
            $yearMonth = $pricingDate->format('Y-m');

            // Prepare pricing entry
            $pricingEntry = [
                'date' => $pricingDate->format('Y-m-d H:i:s'),
                'year_month' => $yearMonth,
                'harga_per_meter_kubik' => round($hargaPerMeterKubik, 2),

            ];

            // Get current pricing history
            $pricingHistory = $this->ensureArray($this->pricing_history);

            // Debug - Log current pricing history
            \Log::info('Current pricing history', ['history' => $pricingHistory]);

            // Cek apakah sudah ada entri untuk bulan dan tahun yang sama
            $existingIndex = null;
            foreach ($pricingHistory as $index => $entry) {
                if (isset($entry['year_month']) && $entry['year_month'] === $yearMonth) {
                    $existingIndex = $index;
                    break;
                }
            }

            // Update jika sudah ada, tambahkan jika belum
            if ($existingIndex !== null) {
                \Log::info('Updating existing pricing entry', ['index' => $existingIndex]);
                $pricingHistory[$existingIndex] = $pricingEntry;
            } else {
                \Log::info('Adding new pricing entry');
                $pricingHistory[] = $pricingEntry;
            }

            // Update pricing history - tambahkan flag untuk memastikan tidak ada perubahan format
            $this->setAttribute('pricing_history', $pricingHistory);

            // Update current values untuk bulan berjalan
            $currentMonth = now()->format('Y-m');
            if ($yearMonth === $currentMonth) {
                \Log::info('Updating current month values');
                $this->setAttribute('harga_per_meter_kubik', $hargaPerMeterKubik);
            }

            // Debug - Log before save
            \Log::info('Before saving user', [
                'user_id' => $this->id,
                'new_pricing_history' => $this->pricing_history,
                'new_harga' => $this->harga_per_meter_kubik
            ]);

            // Save the user
            $result = $this->save();

            // Debug - Log save result
            \Log::info('Save result', [
                'result' => $result ? 'success' : 'failed',
                'user_id' => $this->id
            ]);

            DB::commit();

            return $result;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in addPricingHistory', [
                'user_id' => $this->id,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            return false;
        }
    }

    // Mendapatkan data pricing untuk bulan dan tahun tertentu
    public function getPricingForYearMonth($yearMonth, $specificDate = null)
    {
        $pricingHistory = $this->ensureArray($this->pricing_history);
        $specificDateTime = null;
        
        if ($specificDate) {
            // Jika ada tanggal spesifik, konversi ke objek Carbon
            $specificDateTime = $specificDate instanceof Carbon ? $specificDate : Carbon::parse($specificDate);
            
            // Log untuk debugging
            \Log::debug('getPricingForYearMonth dengan tanggal spesifik', [
                'user_id' => $this->id,
                'yearMonth' => $yearMonth,
                'specificDate' => $specificDateTime->format('Y-m-d H:i:s'),
                'pricingHistory_count' => count($pricingHistory)
            ]);
        }
        
        // Periksa terlebih dahulu apakah ada periode khusus yang mencakup tanggal spesifik
        if ($specificDateTime) {
            foreach ($pricingHistory as $entry) {
                if (isset($entry['type']) && $entry['type'] === 'custom_period') {
                    $startDate = Carbon::parse($entry['start_date']);
                    $endDate = Carbon::parse($entry['end_date']);
                    
                    // Jika tanggal spesifik berada dalam rentang periode khusus
                    if ($specificDateTime->between($startDate, $endDate)) {
                        \Log::debug('Menemukan periode khusus yang cocok', [
                            'start_date' => $startDate->format('Y-m-d'),
                            'end_date' => $endDate->format('Y-m-d'),
                            'harga_per_meter_kubik' => $entry['harga_per_meter_kubik'],
                            'koreksi_meter' => $entry['koreksi_meter']
                        ]);
                        return $entry;
                    }
                }
            }
        }

        // Jika tidak ada periode khusus yang cocok, cari berdasarkan year_month
        foreach ($pricingHistory as $entry) {
            if (isset($entry['year_month']) && $entry['year_month'] === $yearMonth) {
                \Log::debug('Menemukan pricing bulanan yang cocok', [
                    'year_month' => $yearMonth,
                    'harga_per_meter_kubik' => $entry['harga_per_meter_kubik'],
                    'koreksi_meter' => $entry['koreksi_meter']
                ]);
                return $entry;
            }
        }

        // Jika tidak ditemukan, kembalikan data pricing terakhir
        $defaultPricing = [
            'harga_per_meter_kubik' => $this->harga_per_meter_kubik,
            'tekanan_keluar' => $this->tekanan_keluar,
            'suhu' => $this->suhu,
            'koreksi_meter' => $this->koreksi_meter
        ];
        
        \Log::debug('Menggunakan default pricing', [
            'year_month' => $yearMonth,
            'harga_per_meter_kubik' => $defaultPricing['harga_per_meter_kubik'],
            'koreksi_meter' => $defaultPricing['koreksi_meter']
        ]);
        
        return $defaultPricing;
    }

    // Mendapatkan koreksi meter untuk tanggal tertentu
    public function getKoreksiMeterForDate($date)
    {
        $carbonDate = $date instanceof Carbon ? $date : Carbon::parse($date);
        $yearMonth = $carbonDate->format('Y-m');

        $pricingData = $this->getPricingForYearMonth($yearMonth, $carbonDate);
        return floatval($pricingData['koreksi_meter'] ?? $this->koreksi_meter);
    }

    // Mendapatkan harga per meter kubik untuk tanggal tertentu
    public function getHargaPerMeterKubikForDate($date)
    {
        $carbonDate = $date instanceof Carbon ? $date : Carbon::parse($date);
        $yearMonth = $carbonDate->format('Y-m');

        $pricingData = $this->getPricingForYearMonth($yearMonth, $carbonDate);
        return floatval($pricingData['harga_per_meter_kubik'] ?? $this->harga_per_meter_kubik);
    }

    /**
     * Relationship with Data Pencatatan
     */
    public function dataPencatatan()
    {
        return $this->hasMany(DataPencatatan::class, 'customer_id');
    }

    /**
     * Add deposit with optional custom date
     *
     * @param float $amount Deposit amount
     * @param string|null $description Deposit description
     * @param Carbon|null $customDate Custom deposit date (optional)
     * @return bool
     */
    public function addDeposit($amount, $description = null, $customDate = null)
    {
        try {
            DB::beginTransaction();
            $depositDate = $customDate ? $customDate : now();

            // Ensure amount is numeric
            $amount = floatval($amount);

            // Prepare deposit entry
            $depositEntry = [
                'date' => $depositDate->format('Y-m-d H:i:s'),
                'amount' => round($amount, 2),
                'description' => $description
            ];

            // Get current deposit history and ensure it's an array
            $depositHistory = $this->ensureArray($this->deposit_history);

            // Add new deposit to history
            $depositHistory[] = $depositEntry;

            // Update user's total deposit
            $this->total_deposit += $amount;

            // Update deposit history
            $this->deposit_history = $depositHistory;

            // Save the user
            $this->save();
            
            // Update monthly balances immediately starting from deposit month
            $depositMonth = $depositDate->format('Y-m');
            $this->updateMonthlyBalances($depositMonth);

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            return false;
        }
    }

    public function removeDeposit($index)
    {
        try {
            DB::beginTransaction();

            // Get current deposit history
            $depositHistory = $this->ensureArray($this->deposit_history);

            // Validate index
            if (!isset($depositHistory[$index])) {
                return false;
            }
            
            // Capture deposit date before removing it
            $depositDate = null;
            if (isset($depositHistory[$index]['date'])) {
                $depositDate = Carbon::parse($depositHistory[$index]['date']);
            }

            // Subtract the amount from total deposit
            $this->total_deposit -= floatval($depositHistory[$index]['amount']);

            // Remove the specific deposit entry
            array_splice($depositHistory, $index, 1);

            // Update deposit history
            $this->deposit_history = $depositHistory;

            // Save the user
            $this->save();
            
            // Update monthly balances if we have the deposit date
            if ($depositDate) {
                $depositMonth = $depositDate->format('Y-m');
                $this->updateMonthlyBalances($depositMonth);
            } else {
                // If date is unknown, update from earliest known date
                $this->updateMonthlyBalances();
            }

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            return false;
        }
    }

    public function recordPurchase($amount)
    {
        try {
            DB::beginTransaction();

            // Ensure amount is numeric
            $amount = floatval($amount);

            // Update total purchases
            $this->total_purchases += $amount;

            // Save the user
            $this->save();
            
            // Update monthly balances immediately for current month
            $currentMonth = now()->format('Y-m');
            $this->updateMonthlyBalances($currentMonth);

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            return false;
        }
    }

    public function getCurrentBalance()
    {
        return floatval($this->total_deposit) - floatval($this->total_purchases);
    }

    /**
     * Update saldo bulanan pengguna
     *
     * @param string|null $startMonth Format Y-m
     * @return bool
     */
    public function updateMonthlyBalances($startMonth = null)
    {
        try {
            DB::beginTransaction();

            // Log awal proses update
            \Log::info('Memulai updateMonthlyBalances', [
                'user_id' => $this->id,
                'name' => $this->name,
                'startMonth' => $startMonth
            ]);

            // Jika tidak ada $startMonth, gunakan bulan pertama dari data
            if (!$startMonth) {
                $firstRecord = $this->dataPencatatan()->orderBy('created_at')->first();
                if (!$firstRecord) {
                    DB::commit();
                    \Log::info('Tidak ada data pencatatan', ['user_id' => $this->id]);
                    return true; // Tidak ada data, tidak perlu update
                }

                $dataInput = $this->ensureArray($firstRecord->data_input);
                if (empty($dataInput) || empty($dataInput['pembacaan_awal']['waktu'])) {
                    DB::commit();
                    \Log::info('Data pencatatan tidak lengkap', ['user_id' => $this->id]);
                    return true; // Data tidak lengkap, tidak perlu update
                }

                $startMonth = Carbon::parse($dataInput['pembacaan_awal']['waktu'])->format('Y-m');
                \Log::info('Menggunakan bulan awal dari data pertama', ['startMonth' => $startMonth]);
            }

            // Ambil saldo bulanan yang sudah ada atau inisialisasi array kosong
            $monthlyBalances = $this->monthly_balances ?: [];

            // Ambil semua deposit
            $deposits = $this->ensureArray($this->deposit_history);

            // Ambil semua data pencatatan, urutkan berdasarkan tanggal
            $records = $this->dataPencatatan()->get();

            // Mulai dari bulan awal yang ditentukan, hitung saldo untuk setiap bulan
            $startDate = Carbon::createFromFormat('Y-m', $startMonth)->startOfMonth();
            $endDate = Carbon::now()->endOfMonth();

            // Temukan saldo awal untuk bulan mulai
            $runningBalance = 0;
            $prevMonth = Carbon::createFromFormat('Y-m', $startMonth)->subMonth()->format('Y-m');

            // Gunakan saldo bulan sebelumnya sebagai saldo awal jika ada
            if (isset($monthlyBalances[$prevMonth])) {
                $runningBalance = floatval($monthlyBalances[$prevMonth]);
                \Log::info('Menggunakan saldo bulan sebelumnya', [
                    'prevMonth' => $prevMonth,
                    'runningBalance' => $runningBalance
                ]);
            } else {
                // Jika tidak ada saldo bulan sebelumnya, hitung dari awal
                // Hitung total deposit dan pembelian sebelum bulan mulai
                $prevDeposits = 0;
                $prevPurchases = 0;

                // Hitung deposit sebelum bulan mulai
                foreach ($deposits as $deposit) {
                    if (isset($deposit['date'])) {
                        $depositDate = Carbon::parse($deposit['date']);
                        if ($depositDate < $startDate) {
                            $prevDeposits += floatval($deposit['amount'] ?? 0);
                        }
                    }
                }

                // Hitung pembelian sebelum bulan mulai
                foreach ($records as $record) {
                    $dataInput = $this->ensureArray($record->data_input);

                    if (empty($dataInput) || empty($dataInput['pembacaan_awal']['waktu'])) {
                        continue;
                    }

                    $recordDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                    if ($recordDate < $startDate) {
                        // Untuk perhitungan yang lebih akurat, gunakan harga_final dari record
                        // Ini akan memastikan konsistensi dengan saldo total
                        $itemPurchase = floatval($record->harga_final ?? 0);
                        
                        // Fallback ke perhitungan manual jika harga_final tidak tersedia atau nol
                        if ($itemPurchase <= 0) {
                            $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
                            $recordYearMonth = $recordDate->format('Y-m');
                            
                            // PERBAIKAN: Gunakan tanggal spesifik untuk mendapatkan pricing yang tepat
                            $pricingInfo = $this->getPricingForYearMonth($recordYearMonth, $recordDate);
                            
                            $koreksiMeter = floatval($pricingInfo['koreksi_meter'] ?? $this->koreksi_meter);
                            $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $this->harga_per_meter_kubik);

                            $volumeSm3 = $volumeFlowMeter * $koreksiMeter;
                            $itemPurchase = $volumeSm3 * $hargaPerM3;
                        }
                        
                        $prevPurchases += $itemPurchase;
                        
                        \Log::debug('Perhitungan item pembelian sebelumnya', [
                            'record_id' => $record->id,
                            'date' => $recordDate->format('Y-m-d H:i:s'),
                            'harga_final' => $record->harga_final,
                            'calculated_purchase' => $itemPurchase
                        ]);
                    }
                }

                $runningBalance = $prevDeposits - $prevPurchases;
                \Log::info('Menghitung saldo awal', [
                    'prevDeposits' => $prevDeposits,
                    'prevPurchases' => $prevPurchases,
                    'runningBalance' => $runningBalance
                ]);

                // Simpan saldo untuk bulan sebelumnya
                $monthlyBalances[$prevMonth] = $runningBalance;
            }

            // Hitung saldo untuk setiap bulan mulai dari startMonth
            $currentDate = $startDate->copy();

            while ($currentDate <= $endDate) {
                $currentYM = $currentDate->format('Y-m');
                \Log::info('Menghitung saldo untuk bulan', ['currentYM' => $currentYM]);

                // Hitung deposit bulan ini
                $monthDeposit = 0;
                foreach ($deposits as $deposit) {
                    if (isset($deposit['date'])) {
                        $depositDate = Carbon::parse($deposit['date']);
                        if ($depositDate->format('Y-m') === $currentYM) {
                            $depositAmount = floatval($deposit['amount'] ?? 0);
                            $monthDeposit += $depositAmount;
                            \Log::debug('Deposit bulan ini', [
                                'date' => $depositDate->format('Y-m-d'),
                                'amount' => $depositAmount
                            ]);
                        }
                    }
                }

                // Hitung pembelian bulan ini
                $monthPurchase = 0;
                foreach ($records as $record) {
                    $dataInput = $this->ensureArray($record->data_input);

                    if (empty($dataInput) || empty($dataInput['pembacaan_awal']['waktu'])) {
                        continue;
                    }

                    $recordDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                    if ($recordDate->format('Y-m') === $currentYM) {
                        // Untuk perhitungan yang lebih akurat, gunakan harga_final dari record
                        // Ini akan memastikan konsistensi dengan saldo total
                        $itemPurchase = floatval($record->harga_final ?? 0);
                        
                        // Fallback ke perhitungan manual jika harga_final tidak tersedia atau nol
                        if ($itemPurchase <= 0) {
                            $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
                            
                            // PERBAIKAN: Gunakan tanggal spesifik untuk mendapatkan pricing yang tepat
                            $pricingInfo = $this->getPricingForYearMonth($currentYM, $recordDate);
                            
                            $koreksiMeter = floatval($pricingInfo['koreksi_meter'] ?? $this->koreksi_meter);
                            $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $this->harga_per_meter_kubik);

                            $volumeSm3 = $volumeFlowMeter * $koreksiMeter;
                            $itemPurchase = $volumeSm3 * $hargaPerM3;
                        }
                        
                        $monthPurchase += $itemPurchase;
                        
                        \Log::debug('Perhitungan item pembelian bulan ini', [
                            'record_id' => $record->id,
                            'date' => $recordDate->format('Y-m-d H:i:s'),
                            'harga_final' => $record->harga_final,
                            'calculated_purchase' => $itemPurchase,
                            'is_periode_khusus' => isset($pricingInfo) && isset($pricingInfo['type']) && $pricingInfo['type'] === 'custom_period'
                        ]);
                    }
                }

                // Update running balance
                $runningBalance += $monthDeposit - $monthPurchase;

                // Simpan saldo bulan ini
                $monthlyBalances[$currentYM] = $runningBalance;
                \Log::info('Saldo bulan ini', [
                    'bulan' => $currentYM,
                    'deposit' => $monthDeposit,
                    'purchase' => $monthPurchase,
                    'balance' => $runningBalance
                ]);

                // Pindah ke bulan berikutnya
                $currentDate->addMonth();
            }

            // Kunci tambahan untuk memastikan saldo total sesuai dengan perhitungan real-time
            // Mencatat saldo untuk bulan berjalan (untuk halaman detail customer)
            $currentMonth = now()->format('Y-m');
            if (isset($monthlyBalances[$currentMonth])) {
                \Log::info('Saldo bulan berjalan', [
                    'month' => $currentMonth,
                    'balance' => $monthlyBalances[$currentMonth],
                    'total_deposit' => $this->total_deposit,
                    'total_purchases' => $this->total_purchases,
                    'saldo_total' => $this->total_deposit - $this->total_purchases
                ]);
            }

            // Simpan saldo bulanan yang sudah diupdate
            $this->monthly_balances = $monthlyBalances;
            $result = $this->save();

            DB::commit();
            \Log::info('Berhasil update monthly_balances', [
                'user_id' => $this->id,
                'success' => $result
            ]);
            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in updateMonthlyBalances: ' . $e->getMessage(), [
                'user_id' => $this->id,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            return false;
        }
    }

    public function isAdmin()
    {
        return $this->role === self::ROLE_ADMIN;
    }

    /**
     * Check if user is super admin
     */
    public function isSuperAdmin()
    {
        return $this->role === self::ROLE_SUPER_ADMIN;
    }

    /**
     * Check if user is customer
     */
    public function isCustomer()
    {
        return $this->role === self::ROLE_CUSTOMER;
    }

    // Fungsi untuk bisa menampilkan data FOB di dashboard
    public function isCustomerOrFOB()
    {
        return $this->role === self::ROLE_CUSTOMER || $this->role === self::ROLE_FOB;
    }

    /**
     * Check if user is demo
     */
    public function isDemo()
    {
        return $this->role === self::ROLE_DEMO;
    }

    /**
     * Check if user is FOB
     */
    public function isFOB()
    {
        return $this->role === self::ROLE_FOB;
    }
}
