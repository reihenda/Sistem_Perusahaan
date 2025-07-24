<?php

namespace App\Http\Controllers;

use App\Models\ProformaInvoice;
use App\Models\User;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class ProformaInvoiceController extends Controller
{
    /**
     * Generate proforma number via AJAX
     */
    public function generateProformaNumber(Request $request, User $customer)
    {
        $proformaNumber = ProformaInvoice::generateProformaNumber($customer);
        
        return response()->json([
            'proforma_number' => $proformaNumber
        ]);
    }

    /**
     * Display a listing of proforma invoices.
     */
    public function index(Request $request)
    {
        // Ambil semua customer (termasuk FOB)
        $customers = User::whereIn('role', ['customer', 'fob'])
            ->orderBy('name')
            ->get();
        
        // Query dasar
        $query = ProformaInvoice::with('customer')
            ->orderBy('created_at', 'desc');
        
        // Filter berdasarkan pencarian customer jika ada
        if ($request->has('search') && !empty($request->search)) {
            // Dapatkan ID customer yang namanya cocok dengan pencarian
            $customerIds = User::whereIn('role', ['customer', 'fob'])
                ->where('name', 'like', '%' . $request->search . '%')
                ->pluck('id');
            
            // Filter proforma invoice berdasarkan customer_id yang cocok
            $query->whereIn('customer_id', $customerIds);
        }

        // Filter berdasarkan status jika ada
        if ($request->has('status') && !empty($request->status)) {
            $query->where('status', $request->status);
        }
        
        $proformaInvoices = $query->paginate(15);
        
        // Menyimpan parameter filter dalam pagination links
        $proformaInvoices->appends($request->only(['search', 'status']));
        
        // Deteksi jika request adalah AJAX untuk pencarian real-time
        if ($request->ajax()) {
            return response()->json([
                'html' => view('proforma-invoices.partials.proforma-table', compact('proformaInvoices'))->render(),
                'pagination' => view('proforma-invoices.partials.pagination', compact('proformaInvoices'))->render(),
            ]);
        }
        
        return view('proforma-invoices.index', compact('proformaInvoices', 'customers'));
    }

    /**
     * Display the list of customers to select for a new proforma invoice.
     */
    public function selectCustomer()
    {
        $customers = User::whereIn('role', ['customer', 'fob'])
            ->orderBy('name')
            ->get();
        
        return view('proforma-invoices.select-customer', compact('customers'));
    }

    /**
     * Show the form for creating a new proforma invoice for a specific customer.
     */
    public function create(User $customer)
    {
        // Generate a default proforma number
        $proformaNumber = ProformaInvoice::generateProformaNumber($customer);
        
        // Default period: current month
        $startDate = now()->startOfMonth()->format('Y-m-d');
        $endDate = now()->endOfMonth()->format('Y-m-d');
        
        return view('proforma-invoices.create', compact('customer', 'proformaNumber', 'startDate', 'endDate'));
    }

    /**
     * Store a newly created proforma invoice in storage.
     */
    public function store(Request $request, User $customer)
    {
        $request->validate([
            'proforma_number' => 'required|string|max:50',
            'proforma_date' => 'required|date',
            'due_date' => 'required|date|after_or_equal:proforma_date',
            'period_start_date' => 'required|date',
            'period_end_date' => 'required|date|after_or_equal:period_start_date',
            'validity_date' => 'nullable|date|after_or_equal:proforma_date',
            'no_kontrak' => 'required|string|max:50',
            'id_pelanggan' => 'required|string|max:20',
            'description' => 'nullable|string',
        ]);

        // Validasi periode maksimal 60 hari
        $startDate = Carbon::parse($request->period_start_date);
        $endDate = Carbon::parse($request->period_end_date);
        $diffDays = $startDate->diffInDays($endDate) + 1;
        
        if ($diffDays > 60) {
            return back()->withErrors(['period_end_date' => 'Periode maksimal adalah 60 hari.'])->withInput();
        }

        // Get pricing info untuk periode yang dipilih
        $yearMonth = $startDate->format('Y-m');
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);

        // Base query untuk data pencatatan
        $query = $customer->dataPencatatan();
        $dataPencatatan = $query->get();

        // Filter data berdasarkan periode yang dipilih
        $dataPencatatan = $dataPencatatan->filter(function ($item) use ($startDate, $endDate) {
            $dataInput = $this->ensureArray($item->data_input);

            if (empty($dataInput) || empty($dataInput['pembacaan_awal']['waktu'])) {
                return false;
            }

            $waktuAwal = Carbon::parse($dataInput['pembacaan_awal']['waktu'])->startOfDay();
            $startFilter = $startDate->copy()->startOfDay();
            $endFilter = $endDate->copy()->endOfDay();

            return $waktuAwal->between($startFilter, $endFilter);
        });

        // Perhitungan volume dan biaya total
        $totalVolume = 0;
        $totalBiaya = 0;
        $processedDates = [];
        $pricingPeriods = [];
        
        foreach ($dataPencatatan as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
            
            $waktuAwal = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
            $tanggalKey = $waktuAwal->format('Y-m-d');
            
            // Skip jika tanggal sudah diproses (hindari duplikasi)
            if (isset($processedDates[$tanggalKey])) {
                continue;
            }
            
            $processedDates[$tanggalKey] = true;
            
            // Get pricing info for this specific date
            $waktuAwalYearMonth = $waktuAwal->format('Y-m');
            $itemPricingInfo = $customer->getPricingForYearMonth($waktuAwalYearMonth, $waktuAwal);
            
            $volumeSm3 = $volumeFlowMeter * floatval($itemPricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
            $hargaGas = floatval($itemPricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
            
            // Group by price to detect price changes
            $priceKey = $hargaGas;
            if (!isset($pricingPeriods[$priceKey])) {
                $pricingPeriods[$priceKey] = [
                    'harga' => $hargaGas,
                    'volume' => 0
                ];
            }
            
            $pricingPeriods[$priceKey]['volume'] += $volumeSm3;
            $totalVolume += $volumeSm3;
        }
        
        // Calculate total cost from all pricing periods
        foreach ($pricingPeriods as $period) {
            $totalBiaya += $period['volume'] * $period['harga'];
        }

        // Bulatkan total biaya untuk konsistensi
        $totalBiaya = round($totalBiaya);
        
        // Buat proforma invoice baru
        $proformaInvoice = new ProformaInvoice();
        $proformaInvoice->customer_id = $customer->id;
        $proformaInvoice->proforma_number = $request->proforma_number;
        $proformaInvoice->proforma_date = $request->proforma_date;
        $proformaInvoice->due_date = $request->due_date;
        $proformaInvoice->total_amount = $totalBiaya;
        $proformaInvoice->total_volume = $totalVolume;
        $proformaInvoice->status = 'draft';
        $proformaInvoice->description = $request->description;
        $proformaInvoice->no_kontrak = $request->no_kontrak;
        $proformaInvoice->id_pelanggan = $request->id_pelanggan;
        $proformaInvoice->period_start_date = $request->period_start_date;
        $proformaInvoice->period_end_date = $request->period_end_date;
        $proformaInvoice->validity_date = $request->validity_date;
        
        $proformaInvoice->save();

        return redirect()->route('proforma-invoices.show', $proformaInvoice)
            ->with('success', 'Proforma Invoice berhasil dibuat.');
    }

    /**
     * Display the specified proforma invoice.
     */
    public function show(ProformaInvoice $proformaInvoice)
    {
        $customer = $proformaInvoice->customer;
        $startDate = $proformaInvoice->period_start_date;
        $endDate = $proformaInvoice->period_end_date;
        
        // Get pricing info
        $yearMonth = $startDate->format('Y-m');
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);
        
        // Retrieve and filter the relevant data
        $dataPencatatan = $customer->dataPencatatan()->get();
        
        // Filter data berdasarkan periode proforma invoice
        $dataPencatatan = $dataPencatatan->filter(function ($item) use ($startDate, $endDate) {
            $dataInput = $this->ensureArray($item->data_input);

            if (empty($dataInput) || empty($dataInput['pembacaan_awal']['waktu'])) {
                return false;
            }

            $waktuAwal = Carbon::parse($dataInput['pembacaan_awal']['waktu'])->startOfDay();
            $startFilter = $startDate->copy()->startOfDay();
            $endFilter = $endDate->copy()->endOfDay();

            return $waktuAwal->between($startFilter, $endFilter);
        });

        // Perhitungan untuk volume dan biaya pemakaian gas
        $pemakaianGas = [];
        $totalVolume = 0;
        $totalBiaya = 0;
        $processedDates = [];
        $pricingPeriods = [];
        
        foreach ($dataPencatatan as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
            
            $waktuAwal = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
            $tanggalKey = $waktuAwal->format('Y-m-d');
            
            // Skip jika tanggal sudah diproses (hindari duplikasi)
            if (isset($processedDates[$tanggalKey])) {
                continue;
            }
            
            $processedDates[$tanggalKey] = true;
            
            // Get pricing info for this specific date
            $waktuAwalYearMonth = $waktuAwal->format('Y-m');
            $itemPricingInfo = $customer->getPricingForYearMonth($waktuAwalYearMonth, $waktuAwal);
            
            $volumeSm3 = $volumeFlowMeter * floatval($itemPricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
            $hargaGas = floatval($itemPricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
            
            // Group by price to detect price changes
            $priceKey = $hargaGas;
            if (!isset($pricingPeriods[$priceKey])) {
                $pricingPeriods[$priceKey] = [
                    'harga' => $hargaGas,
                    'volume' => 0,
                    'dates' => [],
                    'start_date' => $waktuAwal,
                    'end_date' => $waktuAwal
                ];
            }
            
            $pricingPeriods[$priceKey]['volume'] += $volumeSm3;
            $pricingPeriods[$priceKey]['dates'][] = $waktuAwal;
            
            // Update date range for this price period
            if ($waktuAwal->lt($pricingPeriods[$priceKey]['start_date'])) {
                $pricingPeriods[$priceKey]['start_date'] = $waktuAwal;
            }
            if ($waktuAwal->gt($pricingPeriods[$priceKey]['end_date'])) {
                $pricingPeriods[$priceKey]['end_date'] = $waktuAwal;
            }
            
            $totalVolume += $volumeSm3;
        }
        
        // Sort pricing periods by start date
        uasort($pricingPeriods, function($a, $b) {
            return $a['start_date']->timestamp - $b['start_date']->timestamp;
        });
        
        // Create rows for each pricing period
        $rowNumber = 1;
        foreach ($pricingPeriods as $period) {
            $biayaPemakaian = $period['volume'] * $period['harga'];
            $totalBiaya += $biayaPemakaian;
            
            // Format periode based on date range
            if ($period['start_date']->format('Y-m-d') === $period['end_date']->format('Y-m-d')) {
                $periodePemakaian = $period['start_date']->format('d F Y');
            } else {
                $periodePemakaian = $period['start_date']->format('d F Y') . ' - ' . $period['end_date']->format('d F Y');
            }
            
            $pemakaianGas[] = [
                'no' => $rowNumber++,
                'periode_pemakaian' => $periodePemakaian,
                'volume_sm3' => $period['volume'],
                'harga_gas' => $period['harga'],
                'biaya_pemakaian' => $biayaPemakaian
            ];
        }
        
        // Generate ID Pelanggan (contoh format)
        $idPelanggan = sprintf('03C%04d', $customer->id);
        
        // Bulatkan total biaya untuk konsistensi dengan tampilan
        $totalBiaya = round($totalBiaya);
        
        // Terbilang untuk total tagihan
        $terbilang = $this->terbilang($totalBiaya);

        // Setup data untuk view Proforma Invoice
        $data = [
            'proformaInvoice' => $proformaInvoice,
            'customer' => $customer,
            'periode_bulan' => $proformaInvoice->period_formatted,
            'pemakaian_gas' => $pemakaianGas,
            'total_volume' => $totalVolume,
            'total_biaya' => $totalBiaya,
            'id_pelanggan' => $idPelanggan,
            'terbilang' => $terbilang
        ];

        return view('proforma-invoices.show', $data);
    }

    /**
     * Show the form for editing the proforma invoice.
     */
    public function edit(ProformaInvoice $proformaInvoice)
    {
        $customer = $proformaInvoice->customer;
        return view('proforma-invoices.edit', compact('proformaInvoice', 'customer'));
    }

    /**
     * Update the specified proforma invoice in storage.
     */
    public function update(Request $request, ProformaInvoice $proformaInvoice)
    {
        $request->validate([
            'proforma_number' => 'required|string|max:50',
            'proforma_date' => 'required|date',
            'due_date' => 'required|date|after_or_equal:proforma_date',
            'period_start_date' => 'required|date',
            'period_end_date' => 'required|date|after_or_equal:period_start_date',
            'validity_date' => 'nullable|date|after_or_equal:proforma_date',
            'status' => 'required|in:draft,sent,expired,converted',
            'no_kontrak' => 'required|string|max:50',
            'id_pelanggan' => 'required|string|max:20',
            'description' => 'nullable|string',
        ]);

        $proformaInvoice->proforma_number = $request->proforma_number;
        $proformaInvoice->proforma_date = $request->proforma_date;
        $proformaInvoice->due_date = $request->due_date;
        $proformaInvoice->period_start_date = $request->period_start_date;
        $proformaInvoice->period_end_date = $request->period_end_date;
        $proformaInvoice->validity_date = $request->validity_date;
        $proformaInvoice->status = $request->status;
        $proformaInvoice->description = $request->description;
        $proformaInvoice->no_kontrak = $request->no_kontrak;
        $proformaInvoice->id_pelanggan = $request->id_pelanggan;
        $proformaInvoice->save();

        return redirect()->route('proforma-invoices.show', $proformaInvoice)
            ->with('success', 'Proforma Invoice berhasil diperbarui.');
    }

    /**
     * Remove the specified proforma invoice from storage.
     */
    public function destroy(ProformaInvoice $proformaInvoice)
    {
        $proformaInvoice->delete();
        return redirect()->route('proforma-invoices.index')
            ->with('success', 'Proforma Invoice berhasil dihapus.');
    }

    /**
     * Ensure array format for data.
     */
    private function ensureArray($data)
    {
        if (is_string($data) && !empty($data)) {
            return json_decode($data, true) ?? [];
        }
        
        return is_array($data) ? $data : [];
    }
    
    /**
     * Convert number to Indonesian words.
     */
    private function terbilang($angka) {
        $angka = abs($angka);
        $baca = array('', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan', 'sepuluh', 'sebelas');
        $terbilang = '';
        
        if ($angka < 12) {
            $terbilang = ' ' . $baca[$angka];
        } elseif ($angka < 20) {
            $terbilang = $this->terbilang($angka - 10) . ' belas';
        } elseif ($angka < 100) {
            $terbilang = $this->terbilang((int)($angka / 10)) . ' puluh' . $this->terbilang($angka % 10);
        } elseif ($angka < 200) {
            $terbilang = ' seratus' . $this->terbilang($angka - 100);
        } elseif ($angka < 1000) {
            $terbilang = $this->terbilang((int)($angka / 100)) . ' ratus' . $this->terbilang($angka % 100);
        } elseif ($angka < 2000) {
            $terbilang = ' seribu' . $this->terbilang($angka - 1000);
        } elseif ($angka < 1000000) {
            $terbilang = $this->terbilang((int)($angka / 1000)) . ' ribu' . $this->terbilang($angka % 1000);
        } elseif ($angka < 1000000000) {
            $terbilang = $this->terbilang((int)($angka / 1000000)) . ' juta' . $this->terbilang($angka % 1000000);
        } elseif ($angka < 1000000000000) {
            $terbilang = $this->terbilang((int)($angka / 1000000000)) . ' milyar' . $this->terbilang($angka % 1000000000);
        } elseif ($angka < 1000000000000000) {
            $terbilang = $this->terbilang((int)($angka / 1000000000000)) . ' trilyun' . $this->terbilang($angka % 1000000000000);
        }
        
        return $terbilang;
    }
}
