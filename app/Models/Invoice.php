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
        'status',
        'description',
        'no_kontrak',
        'id_pelanggan',
        'period_month',
        'period_year',
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
    public static function generateInvoiceNumber($customer, $date = null)
    {
        $date = $date ? \Carbon\Carbon::parse($date) : now();
        
        // Format: 'no'/MPS/INV-'CUSTOMER'/'tgl'/'thn'
        // Misalnya: 001/MPS/INV-NOMI/12/2023
        $customerCode = strtoupper($customer->name);
        
        // Cari invoice terakhir untuk customer ini
        $lastInvoice = self::where('customer_id', $customer->id)
                           ->orderBy('id', 'desc')
                           ->first();
        
        // Jika ada invoice terakhir, ekstrak nomor urut dan tambahkan 1
        if ($lastInvoice) {
            $lastInvoiceNumber = $lastInvoice->invoice_number;
            // Ekstrak nomor urut dari format 'XXX/MPS/INV-CUSTOMER/MM/YYYY'
            $matches = [];
            if (preg_match('/^(\d+)\/MPS\/INV-/', $lastInvoiceNumber, $matches)) {
                $lastNumber = (int)$matches[1];
                $nextNumber = $lastNumber + 1;
            } else {
                // Jika tidak ditemukan pola yang benar, mulai dari 1
                $nextNumber = 1;
            }
        } else {
            // Jika tidak ada invoice sebelumnya, mulai dari 1
            $nextNumber = 1;
        }
        
        $invoiceNumber = sprintf('%03d/MPS/INV-%s/%s/%s', 
            $nextNumber,
            $customerCode,
            $date->format('m'),
            $date->format('Y')
        );
        
        return $invoiceNumber;
    }
}