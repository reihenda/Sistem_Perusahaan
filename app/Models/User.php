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

            // Ensure all values are numeric and properly formatted
            $hargaPerMeterKubik = floatval(str_replace(',', '.', $hargaPerMeterKubik));
            $tekananKeluar = floatval(str_replace(',', '.', $tekananKeluar));
            $suhu = floatval(str_replace(',', '.', $suhu));
            $koreksiMeter = floatval(str_replace(',', '.', $koreksiMeter));

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
                $pricingHistory[$existingIndex] = $pricingEntry;
            } else {
                $pricingHistory[] = $pricingEntry;
            }

            // Update pricing history
            $this->setAttribute('pricing_history', $pricingHistory);

            // Update current values untuk bulan berjalan
            $currentMonth = now()->format('Y-m');
            if ($yearMonth === $currentMonth) {
                $this->setAttribute('harga_per_meter_kubik', $hargaPerMeterKubik);
                $this->setAttribute('tekanan_keluar', $tekananKeluar);
                $this->setAttribute('suhu', $suhu);
                $this->setAttribute('koreksi_meter', $koreksiMeter);
            }

            // Save the user
            $result = $this->save();

            DB::commit();

            return $result;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in addPricingHistory', [
                'user_id' => $this->id,
                'error' => $e->getMessage()
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
                $pricingHistory[$overlappingIndex] = $pricingEntry;
            } else {
                $pricingHistory[] = $pricingEntry;
            }

            // Update pricing history
            $this->setAttribute('pricing_history', $pricingHistory);

            // Save the user
            $result = $this->save();

            DB::commit();

            return $result;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in addCustomPeriodPricing', [
                'user_id' => $this->id,
                'error' => $e->getMessage()
            ]);
            return false;
        }
    }

    /**
     * Metode untuk menambah riwayat pricing khusus FOB
     */
    public function addPricingHistoryfob($hargaPerMeterKubik, $customDate = null)
    {
        try {
            DB::beginTransaction();

            // Ensure all values are numeric and properly formatted
            $hargaPerMeterKubik = floatval(str_replace(',', '.', $hargaPerMeterKubik));

            $pricingDate = $customDate ?: now();
            $yearMonth = $pricingDate->format('Y-m');

            // Prepare pricing entry
            $pricingEntry = [
                'date' => $pricingDate->format('Y-m-d H:i:s'),
                'year_month' => $yearMonth,
                'harga_per_meter_kubik' => round($hargaPerMeterKubik, 2)
            ];

            // Get current pricing history
            $pricingHistory = $this->ensureArray($this->pricing_history);

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
                $pricingHistory[$existingIndex] = $pricingEntry;
            } else {
                $pricingHistory[] = $pricingEntry;
            }

            // Update pricing history
            $this->setAttribute('pricing_history', $pricingHistory);

            // Update current values untuk bulan berjalan
            $currentMonth = now()->format('Y-m');
            if ($yearMonth === $currentMonth) {
                $this->setAttribute('harga_per_meter_kubik', $hargaPerMeterKubik);
            }

            // Save the user
            $result = $this->save();

            DB::commit();

            return $result;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in addPricingHistoryfob', [
                'user_id' => $this->id,
                'error' => $e->getMessage()
            ]);
            return false;
        }
    }

    // Mendapatkan data pricing untuk bulan dan tahun tertentu
    public function getPricingForYearMonth($yearMonth, $specificDate = null)
    {
        $pricingHistory = $this->ensureArray($this->pricing_history);
        $specificDateTime = null;

        // Khusus untuk FOB, hanya perlu harga per meter kubik, bukan koreksi meter
        $isFOB = $this->isFOB();

        if ($specificDate) {
            // Jika ada tanggal spesifik, konversi ke objek Carbon
            $specificDateTime = $specificDate instanceof Carbon ? $specificDate : Carbon::parse($specificDate);
        }

        // Periksa terlebih dahulu apakah ada periode khusus yang mencakup tanggal spesifik
        if ($specificDateTime) {
            foreach ($pricingHistory as $entry) {
                if (isset($entry['type']) && $entry['type'] === 'custom_period') {
                    $startDate = Carbon::parse($entry['start_date']);
                    $endDate = Carbon::parse($entry['end_date']);

                    // Jika tanggal spesifik berada dalam rentang periode khusus
                    if ($specificDateTime->between($startDate, $endDate)) {
                        // Jika FOB, pastikan nilai koreksi_meter selalu 1.0
                        if ($isFOB) {
                            $result = [
                                'harga_per_meter_kubik' => $entry['harga_per_meter_kubik'] ?? $this->harga_per_meter_kubik,
                                'koreksi_meter' => 1.0,
                                'is_fob' => true
                            ];
                            if (isset($entry['type'])) $result['type'] = $entry['type'];
                            return $result;
                        }

                        return $entry;
                    }
                }
            }
        }

        // Jika tidak ada periode khusus yang cocok, cari berdasarkan year_month
        foreach ($pricingHistory as $entry) {
            if (isset($entry['year_month']) && $entry['year_month'] === $yearMonth) {
                // Jika FOB, pastikan nilai koreksi_meter selalu 1.0
                if ($isFOB) {
                    $result = [
                        'harga_per_meter_kubik' => $entry['harga_per_meter_kubik'] ?? $this->harga_per_meter_kubik,
                        'koreksi_meter' => 1.0,
                        'is_fob' => true
                    ];
                    if (isset($entry['type'])) $result['type'] = $entry['type'];
                    return $result;
                }

                return $entry;
            }
        }

        // Jika tidak ditemukan, kembalikan data pricing terakhir
        if ($isFOB) {
            // Untuk FOB, hanya return harga per meter kubik
            $defaultPricing = [
                'harga_per_meter_kubik' => $this->harga_per_meter_kubik,
                'koreksi_meter' => 1.0,
                'is_fob' => true
            ];
        } else {
            // Untuk customer reguler, return semua nilai
            $defaultPricing = [
                'harga_per_meter_kubik' => $this->harga_per_meter_kubik,
                'tekanan_keluar' => $this->tekanan_keluar,
                'suhu' => $this->suhu,
                'koreksi_meter' => $this->koreksi_meter
            ];
        }

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
     * @param string $keterangan Type of transaction (penambahan/pengurangan)
     * @return bool
     */
    public function addDeposit($amount, $description = null, $customDate = null, $keterangan = 'penambahan')
    {
        try {
            DB::beginTransaction();
            $depositDate = $customDate ? $customDate : now();

            // Ensure amount is numeric
            $amount = floatval($amount);

            // Prepare deposit entry dengan struktur baru
            $depositEntry = [
                'date' => $depositDate->format('Y-m-d H:i:s'),
                'amount' => round($amount, 2),
                'keterangan' => $keterangan,
                'deskripsi' => $description
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

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in addDeposit', [
                'user_id' => $this->id,
                'error' => $e->getMessage()
            ]);
            return false;
        }
    }

    /**
     * Reduce balance (pengurangan saldo)
     *
     * @param float $amount Amount to reduce
     * @param string|null $description Description for the reduction
     * @param Carbon|null $customDate Custom date (optional)
     * @return bool
     */
    public function reduceBalance($amount, $description = null, $customDate = null)
    {
        try {
            DB::beginTransaction();
            $depositDate = $customDate ? $customDate : now();

            // Ensure amount is numeric and negative for reduction
            $amount = -abs(floatval($amount));

            // Prepare deposit entry dengan keterangan pengurangan
            $depositEntry = [
                'date' => $depositDate->format('Y-m-d H:i:s'),
                'amount' => round($amount, 2),
                'keterangan' => 'pengurangan',
                'deskripsi' => $description
            ];

            // Get current deposit history and ensure it's an array
            $depositHistory = $this->ensureArray($this->deposit_history);

            // Add new entry to history
            $depositHistory[] = $depositEntry;

            // Update user's total deposit (dikurangi karena amount sudah negatif)
            $this->total_deposit += $amount;

            // Update deposit history
            $this->deposit_history = $depositHistory;

            // Save the user
            $this->save();

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in reduceBalance', [
                'user_id' => $this->id,
                'error' => $e->getMessage()
            ]);
            return false;
        }
    }

    /**
     * Zero balance (nol-kan saldo)
     *
     * @param string|null $description Description for zeroing balance
     * @param Carbon|null $customDate Custom date (optional)
     * @return bool
     */
    public function zeroBalance($description = null, $customDate = null)
    {
        try {
            DB::beginTransaction();
            
            // Get current balance
            $currentBalance = $this->getCurrentBalance();
            
            // If balance is already zero, do nothing
            if (abs($currentBalance) < 0.01) {
                return true;
            }
            
            // Create reduction entry to zero the balance
            $reductionAmount = -$currentBalance; // Amount needed to make balance zero
            
            $result = $this->reduceBalance(
                abs($reductionAmount), 
                $description ?? 'Nol-kan saldo', 
                $customDate
            );
            
            DB::commit();
            
            return $result;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in zeroBalance', [
                'user_id' => $this->id,
                'error' => $e->getMessage()
            ]);
            return false;
        }
    }

    /**
     * Get deposit history with backward compatibility
     * Automatically adds 'keterangan' field to old entries
     */
    public function getDepositHistoryWithKeterangan()
    {
        $depositHistory = $this->ensureArray($this->deposit_history);
        
        // Add backward compatibility for old entries
        foreach ($depositHistory as &$entry) {
            // If keterangan doesn't exist, assume it's 'penambahan'
            if (!isset($entry['keterangan'])) {
                $entry['keterangan'] = 'penambahan';
            }
            
            // Handle description field rename
            if (isset($entry['description']) && !isset($entry['deskripsi'])) {
                $entry['deskripsi'] = $entry['description'];
            }
        }
        
        return $depositHistory;
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

            // Capture deposit amount before removing it
            $depositAmount = floatval($depositHistory[$index]['amount'] ?? 0);

            // Subtract the amount from total deposit
            $this->total_deposit -= $depositAmount;

            // Remove the specific deposit entry
            array_splice($depositHistory, $index, 1);

            // Update deposit history
            $this->deposit_history = $depositHistory;

            // Save the user
            $this->save();

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in removeDeposit', [
                'user_id' => $this->id,
                'error' => $e->getMessage()
            ]);
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

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error in recordPurchase', [
                'user_id' => $this->id,
                'error' => $e->getMessage()
            ]);
            return false;
        }
    }

    public function getCurrentBalance()
    {
        return floatval($this->total_deposit) - floatval($this->total_purchases);
    }

    /**
     * Simplified monthly balance update - DISABLED for performance
     */
    public function updateMonthlyBalances($startMonth = null)
    {
        // DISABLED to prevent performance issues
        return true;
    }

    /**
     * Check if user is admin
     */
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

    /**
     * Check if user is customer or FOB
     * Fungsi untuk bisa menampilkan data FOB di dashboard
     */
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
