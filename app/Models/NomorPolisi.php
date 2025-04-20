<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NomorPolisi extends Model
{
    use HasFactory;

    protected $table = 'nomor_polisi';

    protected $fillable = [
        'nopol',
        'keterangan',
    ];

    /**
     * Get rekap pengambilan records associated with this nomor polisi.
     */
    public function rekapPengambilan()
    {
        return $this->hasMany(RekapPengambilan::class, 'nopol', 'nopol');
    }
}
