<?php

namespace App\Http\Controllers;

use App\Models\Invoice;
use App\Models\User;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class InvoiceController extends Controller
{
    /**
     * Generate invoice number via AJAX
     */
    public function generateInvoiceNumber(Request $request, User $customer)
    {
        $periodType = $request->input('period_type', 'monthly');
        $customStartDate = $request->input('custom_start_date');
        
        $invoiceNumber = Invoice::generateInvoiceNumber($customer, null, $periodType, $customStartDate);
        
        return response()->json([
            'invoice_number' => $invoiceNumber
        ]);
    }
    /**
     * Display a listing of invoices.
     */
    public function index(Request $request)
    {
        // Ambil semua customer (termasuk FOB)
        $customers = User::whereIn('role', ['customer', 'fob'])
            ->orderBy('name')
            ->get();
        
        // Query dasar
        $query = Invoice::with('customer')
            ->orderBy('created_at', 'desc');
        
        // Filter berdasarkan pencarian customer jika ada
        if ($request->has('search') && !empty($request->search)) {
            // Dapatkan ID customer yang namanya cocok dengan pencarian
            $customerIds = User::whereIn('role', ['customer', 'fob'])
                ->where('name', 'like', '%' . $request->search . '%')
                ->pluck('id');
            
            // Filter invoice berdasarkan customer_id yang cocok
            $query->whereIn('customer_id', $customerIds);
        }
        
        $invoices = $query->paginate(15);
        
        // Menyimpan parameter filter dalam pagination links
        $invoices->appends($request->only('search'));
        
        // Deteksi jika request adalah AJAX untuk pencarian real-time
        if ($request->ajax()) {
            return response()->json([
                'html' => view('invoices.partials.invoice-table', compact('invoices'))->render(),
                'pagination' => view('invoices.partials.pagination', compact('invoices'))->render(),
            ]);
        }
        
        return view('invoices.index', compact('invoices', 'customers'));
    }

    /**
     * Display the list of customers to select for a new invoice.
     */
    public function selectCustomer()
    {
        $customers = User::whereIn('role', ['customer', 'fob'])
            ->orderBy('name')
            ->get();
        
        return view('invoices.select-customer', compact('customers'));
    }

    /**
     * Show the form for creating a new invoice for a specific customer.
     */
    public function create(User $customer)
    {
        // Generate a default invoice number based on the current date (monthly period)
        $invoiceNumber = Invoice::generateInvoiceNumber($customer, null, 'monthly');
        
        // Default to current month and year
        $month = now()->month;
        $year = now()->year;
        
        return view('invoices.create', compact('customer', 'invoiceNumber', 'month', 'year'));
    }

    /**
     * Store a newly created invoice in storage.
     */
    public function store(Request $request, User $customer)
    {
        // Validation rules berdasarkan period type
        $baseRules = [
            'invoice_number' => 'required|string|max:50',
            'invoice_date' => 'required|date',
            'due_date' => 'required|date|after_or_equal:invoice_date',
            'period_type' => 'required|in:monthly,custom',
            'no_kontrak' => 'required|string|max:50',
            'id_pelanggan' => 'required|string|max:20',
            'description' => 'nullable|string',
        ];
        
        // Add conditional validation
        if ($request->period_type === 'custom') {
            $baseRules['custom_start_date'] = 'required|date';
            $baseRules['custom_end_date'] = 'required|date|after_or_equal:custom_start_date';
        } else {
            $baseRules['month'] = 'required|integer|min:1|max:12';
            $baseRules['year'] = 'required|integer|min:2000|max:2100';
        }
        
        $request->validate($baseRules);
        
        // Additional validation for custom period
        if ($request->period_type === 'custom') {
            $startDate = Carbon::parse($request->custom_start_date);
            $endDate = Carbon::parse($request->custom_end_date);
            $diffDays = $startDate->diffInDays($endDate) + 1;
            
            if ($diffDays > 60) {
                return back()->withErrors(['custom_end_date' => 'Periode maksimal adalah 60 hari.'])->withInput();
            }
        }

        // Determine period for filtering data
        if ($request->period_type === 'custom') {
            $startDate = Carbon::parse($request->custom_start_date);
            $endDate = Carbon::parse($request->custom_end_date);
            $periodType = 'custom';
            $yearMonth = $startDate->format('Y-m');
        } else {
            $yearMonth = $request->year . '-' . str_pad($request->month, 2, '0', STR_PAD_LEFT);
            $periodType = 'monthly';
        }

        // Get pricing info for selected period
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);

        // Base query
        $query = $customer->dataPencatatan();

        // Ambil semua data
        $dataPencatatan = $query->get();

        // Filter data berdasarkan periode yang dipilih
        if ($periodType === 'custom') {
            // Filter berdasarkan range tanggal custom
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
        } else {
            // Filter data berdasarkan bulan dan tahun
            $dataPencatatan = $dataPencatatan->filter(function ($item) use ($yearMonth) {
                $dataInput = $this->ensureArray($item->data_input);

                // Jika data input kosong atau tidak ada waktu awal, skip
                if (empty($dataInput) || empty($dataInput['pembacaan_awal']['waktu'])) {
                    return false;
                }

                // Convert the timestamp to year-month format for comparison
                $waktuAwal = Carbon::parse($dataInput['pembacaan_awal']['waktu'])->format('Y-m');

                // Filter by year-month
                return $waktuAwal === $yearMonth;
            });
        }

        // Perhitungan volume dan biaya total
        $totalVolume = 0;
        $totalBiaya = 0;
        $processedDates = [];

        // Group data by price periods for custom period
        if ($periodType === 'custom') {
            // Collect all unique pricing periods within the custom date range
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
        } else {
            // For monthly period, use existing logic
            $hargaGas = 0;
            
            foreach ($dataPencatatan as $item) {
                $dataInput = $this->ensureArray($item->data_input);
                $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
                $volumeSm3 = $volumeFlowMeter * floatval($pricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
                // Use the last price as the standard price
                $hargaGas = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                
                $totalVolume += $volumeSm3;
            }
            
            // Calculate total cost with total volume
            $totalBiaya = $totalVolume * $hargaGas;
        }

        // Buat invoice baru
        $invoice = new Invoice();
        $invoice->customer_id = $customer->id;
        $invoice->invoice_number = $request->invoice_number;
        $invoice->invoice_date = $request->invoice_date;
        $invoice->due_date = $request->due_date;
        $invoice->total_amount = $totalBiaya;
        $invoice->total_volume = $totalVolume;
        $invoice->status = 'unpaid';
        $invoice->description = $request->description;
        $invoice->no_kontrak = $request->no_kontrak;
        $invoice->id_pelanggan = $request->id_pelanggan;
        $invoice->period_type = $request->period_type;
        
        if ($request->period_type === 'custom') {
            $invoice->custom_start_date = $request->custom_start_date;
            $invoice->custom_end_date = $request->custom_end_date;
            // Set period month/year berdasarkan start date untuk kompatibilitas
            $invoice->period_month = $startDate->month;
            $invoice->period_year = $startDate->year;
        } else {
            $invoice->period_month = $request->month;
            $invoice->period_year = $request->year;
            $invoice->custom_start_date = null;
            $invoice->custom_end_date = null;
        }
        
        $invoice->save();

        return redirect()->route('invoices.show', $invoice)
            ->with('success', 'Invoice berhasil dibuat.');
    }

    /**
     * Display the specified invoice.
     */
    public function show(Invoice $invoice)
    {
        $customer = $invoice->customer;
        
        // Determine period based on invoice type
        if ($invoice->period_type === 'custom') {
            $startDate = Carbon::parse($invoice->custom_start_date);
            $endDate = Carbon::parse($invoice->custom_end_date);
            $yearMonth = $startDate->format('Y-m');
        } else {
            $yearMonth = $invoice->period_year . '-' . str_pad($invoice->period_month, 2, '0', STR_PAD_LEFT);
        }
        
        // Get pricing info
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);
        
        // Retrieve and filter the relevant data
        $dataPencatatan = $customer->dataPencatatan()->get();
        
        // Filter data berdasarkan periode invoice
        if ($invoice->period_type === 'custom') {
            // Filter berdasarkan range tanggal custom
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
        } else {
            // Filter data berdasarkan bulan dan tahun
            $dataPencatatan = $dataPencatatan->filter(function ($item) use ($yearMonth) {
                $dataInput = $this->ensureArray($item->data_input);

                // Jika data input kosong atau tidak ada waktu awal, skip
                if (empty($dataInput) || empty($dataInput['pembacaan_awal']['waktu'])) {
                    return false;
                }

                // Convert the timestamp to year-month format for comparison
                $waktuAwal = Carbon::parse($dataInput['pembacaan_awal']['waktu'])->format('Y-m');

                // Filter by year-month
                return $waktuAwal === $yearMonth;
            });
        }

        // Perhitungan untuk volume dan biaya pemakaian gas
        $pemakaianGas = [];
        $totalVolume = 0;
        $totalBiaya = 0;
        $processedDates = [];
        
        // Group data by price periods for custom period
        if ($invoice->period_type === 'custom') {
            // Collect all unique pricing periods within the custom date range
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
        } else {
            // For monthly period, use existing logic
            $hargaGas = 0;
            
            foreach ($dataPencatatan as $item) {
                $dataInput = $this->ensureArray($item->data_input);
                $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
                $volumeSm3 = $volumeFlowMeter * floatval($pricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
                // Use the last price as the standard price
                $hargaGas = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                
                $totalVolume += $volumeSm3;
            }
            
            // Calculate total cost with total volume
            $totalBiaya = $totalVolume * $hargaGas;
            
            // Create a single row with period's total
            $periodePemakaian = Carbon::createFromDate($invoice->period_year, $invoice->period_month, 1)->format('1 F Y') . " - " . 
                             Carbon::createFromDate($invoice->period_year, $invoice->period_month, 1)->endOfMonth()->format('d F Y');
            
            $pemakaianGas[] = [
                'no' => 1,
                'periode_pemakaian' => $periodePemakaian,
                'volume_sm3' => $totalVolume,
                'harga_gas' => $hargaGas,
                'biaya_pemakaian' => $totalBiaya
            ];
        }
        
        // Generate ID Pelanggan (contoh format)
        $idPelanggan = sprintf('03C%04d', $customer->id);
        
        // Terbilang untuk total tagihan
        $terbilang = $this->terbilang($totalBiaya);

        // Setup data untuk view Invoice
        $data = [
            'invoice' => $invoice,
            'customer' => $customer,
            'periode_bulan' => $invoice->period_type === 'custom' ? 
                Carbon::parse($invoice->custom_start_date)->format('d/m/Y') . ' - ' . Carbon::parse($invoice->custom_end_date)->format('d/m/Y') :
                Carbon::createFromDate($invoice->period_year, $invoice->period_month, 1)->format('F Y'),
            'pemakaian_gas' => $pemakaianGas,
            'total_volume' => $totalVolume,
            'total_biaya' => $totalBiaya,
            'id_pelanggan' => $idPelanggan,
            'terbilang' => $terbilang
        ];

        return view('invoices.show', $data);
    }

    /**
     * Show the form for editing the invoice.
     */
    public function edit(Invoice $invoice)
    {
        $customer = $invoice->customer;
        return view('invoices.edit', compact('invoice', 'customer'));
    }

    /**
     * Update the specified invoice in storage.
     */
    public function update(Request $request, Invoice $invoice)
    {
        $request->validate([
            'invoice_number' => 'required|string|max:50',
            'invoice_date' => 'required|date',
            'due_date' => 'required|date|after_or_equal:invoice_date',
            'status' => 'required|in:paid,unpaid,partial,cancelled',
            'no_kontrak' => 'required|string|max:50',
            'id_pelanggan' => 'required|string|max:20',
            'description' => 'nullable|string',
        ]);

        $invoice->invoice_number = $request->invoice_number;
        $invoice->invoice_date = $request->invoice_date;
        $invoice->due_date = $request->due_date;
        $invoice->status = $request->status;
        $invoice->description = $request->description;
        $invoice->no_kontrak = $request->no_kontrak;
        $invoice->id_pelanggan = $request->id_pelanggan;
        $invoice->save();

        return redirect()->route('invoices.show', $invoice)
            ->with('success', 'Invoice berhasil diperbarui.');
    }

    /**
     * Remove the specified invoice from storage.
     */
    public function destroy(Invoice $invoice)
    {
        $invoice->delete();
        return redirect()->route('invoices.index')
            ->with('success', 'Invoice berhasil dihapus.');
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
