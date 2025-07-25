<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Invoice extends Model
{
    use HasFactory;

    protected $fillable = [
        'customer_id',
        'invoice_number',
        'invoice_date',
        'due_date',
        'total_amount',
        'total_volume',
        'status',
        'description',
        'no_kontrak',
        'id_pelanggan',
        'period_month',
        'period_year',
        'period_type',
        'custom_start_date',
        'custom_end_date',
    ];

    protected $casts = [
        'invoice_date' => 'date',
        'due_date' => 'date',
        'total_amount' => 'decimal:2',
    ];

    // Relasi dengan User (Customer)
    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    // Mendapatkan format nomor invoice
    public static function generateInvoiceNumber($customer, $date = null, $periodType = 'monthly', $customStartDate = null)
    {
        // Untuk periode custom, gunakan custom start date
        if ($periodType === 'custom' && $customStartDate) {
            $date = \Carbon\Carbon::parse($customStartDate);
        } else {
            $date = $date ? \Carbon\Carbon::parse($date) : now();
        }
        
        // Format: 'no'/MPS/INV-'CUSTOMER'/'tgl'/'thn'
        // Misalnya: 001/MPS/INV-NOMI/12/2023
        $customerCode = substr(strtoupper($customer->name), 0, 4);
        
        // Dapatkan nomor urut invoice untuk customer ini
        $count = self::where('customer_id', $customer->id)
                    ->whereMonth('created_at', $date->month)
                    ->whereYear('created_at', $date->year)
                    ->count() + 1;
        
        $invoiceNumber = sprintf('%03d/MPS/INV-%s/%s/%s', 
            $count,
            $customerCode,
            $date->format('m'),
            $date->format('Y')
        );
        
        return $invoiceNumber;
    }
}