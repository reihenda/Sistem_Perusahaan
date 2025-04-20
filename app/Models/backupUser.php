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
        'pricing_history' => 'array'
    ];
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
            $dataInput = is_string($item->data_input)
                ? json_decode($item->data_input, true)
                : (is_array($item->data_input) ? $item->data_input : []);

            $volumeFlowMeter = $dataInput['volume_flow_meter'] ?? 0;

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

            $pricingDate = $customDate ? $customDate : now();
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
            $pricingHistory = $this->pricing_history;

            if (is_string($pricingHistory)) {
                $pricingHistory = json_decode($pricingHistory, true) ?? [];
            }

            // If it's still not an array (could be null), make it an empty array
            if (!is_array($pricingHistory)) {
                $pricingHistory = [];
            }

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
            $this->pricing_history = $pricingHistory;

            // Update current values
            $this->harga_per_meter_kubik = $hargaPerMeterKubik;
            $this->tekanan_keluar = $tekananKeluar;
            $this->suhu = $suhu;
            $this->koreksi_meter = $koreksiMeter;

            // Save the user
            $this->save();

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            return false;
        }
    }

    // Mendapatkan data pricing untuk bulan dan tahun tertentu
    public function getPricingForYearMonth($yearMonth)
    {
        $pricingHistory = $this->pricing_history;

        // Ensure pricing_history is an array before looping
        if (is_string($pricingHistory)) {
            $pricingHistory = json_decode($pricingHistory, true) ?? [];
        }

        // If it's still not an array (could be null), make it an empty array
        if (!is_array($pricingHistory)) {
            $pricingHistory = [];
        }

        foreach ($pricingHistory as $entry) {
            if (isset($entry['year_month']) && $entry['year_month'] === $yearMonth) {
                return $entry;
            }
        }

        // Jika tidak ditemukan, kembalikan data pricing terakhir
        return [
            'harga_per_meter_kubik' => $this->harga_per_meter_kubik,
            'tekanan_keluar' => $this->tekanan_keluar,
            'suhu' => $this->suhu,
            'koreksi_meter' => $this->koreksi_meter
        ];
    }

    // Mendapatkan koreksi meter untuk tanggal tertentu
    public function getKoreksiMeterForDate($date)
    {
        $carbonDate = $date instanceof Carbon ? $date : Carbon::parse($date);
        $yearMonth = $carbonDate->format('Y-m');

        $pricingData = $this->getPricingForYearMonth($yearMonth);
        return $pricingData['koreksi_meter'] ?? $this->koreksi_meter;
    }

    // Mendapatkan harga per meter kubik untuk tanggal tertentu
    public function getHargaPerMeterKubikForDate($date)
    {
        $carbonDate = $date instanceof Carbon ? $date : Carbon::parse($date);
        $yearMonth = $carbonDate->format('Y-m');

        $pricingData = $this->getPricingForYearMonth($yearMonth);
        return $pricingData['harga_per_meter_kubik'] ?? $this->harga_per_meter_kubik;
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


            // Prepare deposit entry
            $depositEntry = [
                'date' => $depositDate->format('Y-m-d H:i:s'),
                'amount' => round($amount, 2),
                'description' => $description
            ];

            // Get current deposit history and ensure it's an array
            $depositHistory = $this->deposit_history;

            // Convert to array if it's a string or null
            if (is_string($depositHistory)) {
                $depositHistory = json_decode($depositHistory, true) ?? [];
            } else if ($depositHistory === null) {
                $depositHistory = [];
            }

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
            return false;
        }
    }
    public function removeDeposit($index)
    {
        try {
            DB::beginTransaction();

            // Get current deposit history
            $depositHistory = $this->deposit_history ?? [];

            // Validate index
            if (!isset($depositHistory[$index])) {
                return false;
            }

            // Subtract the amount from total deposit
            $this->total_deposit -= $depositHistory[$index]['amount'];

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
            return false;
        }
    }

    public function recordPurchase($amount)
    {
        try {
            DB::beginTransaction();

            // Update total purchases
            $this->total_purchases += $amount;

            // Save the user
            $this->save();

            DB::commit();

            return true;
        } catch (\Exception $e) {
            DB::rollBack();
            return false;
        }
    }

    public function getCurrentBalance()
    {
        return $this->total_deposit - $this->total_purchases;
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
}
