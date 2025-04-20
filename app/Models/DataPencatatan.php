<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Carbon\Carbon;

class DataPencatatan extends Model
{
    use HasFactory;

    protected $table = 'data_pencatatan';

    protected $fillable = [
        'customer_id',
        'nama_customer',
        'data_input',
        'harga_final',
        'status_pembayaran'

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

    // Relasi dengan User (Customer)
    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    // Method perhitungan harga
    public function hitungHarga()
    {
        $customer = $this->customer;
        if (!$customer) {
            return false;
        }

        // Get input data
        $dataInput = $this->ensureArray($this->data_input);

        // Get volume flow meter
        $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);

        // Get waktu pencatatan awal
        $waktuPencatatanAwal = !empty($dataInput['pembacaan_awal']['waktu'])
            ? Carbon::parse($dataInput['pembacaan_awal']['waktu'])
            : null;

        if (!$waktuPencatatanAwal) {
            return false;
        }

        // Get pricing for the date
        $yearMonth = $waktuPencatatanAwal->format('Y-m');
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);

        // Calculate volume SM3
        $koreksiMeter = floatval($pricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
        $volumeSm3 = $volumeFlowMeter * $koreksiMeter;

        // Calculate price
        $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
        $harga = $volumeSm3 * $hargaPerM3;

        // Set harga_final
        $this->harga_final = round($harga, 2);
        $this->save();

        // Record purchase to customer
        $customer->recordPurchase($harga);

        return $harga;
    }
}
