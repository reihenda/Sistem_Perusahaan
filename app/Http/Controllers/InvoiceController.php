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
        // Generate a default invoice number based on the current date
        $invoiceNumber = Invoice::generateInvoiceNumber($customer);
        
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
        $request->validate([
            'invoice_number' => 'required|string|max:50',
            'invoice_date' => 'required|date',
            'due_date' => 'required|date|after_or_equal:invoice_date',
            'month' => 'required|integer|min:1|max:12',
            'year' => 'required|integer|min:2000|max:2100',
            'no_kontrak' => 'required|string|max:50',
            'id_pelanggan' => 'required|string|max:20',
            'description' => 'nullable|string',
        ]);

        // Format filter untuk query
        $yearMonth = $request->year . '-' . str_pad($request->month, 2, '0', STR_PAD_LEFT);

        // Get pricing info for selected month
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);

        // Base query
        $query = $customer->dataPencatatan();

        // Ambil semua data
        $dataPencatatan = $query->get();

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

        // Perhitungan volume dan biaya total
        $totalVolume = 0;
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

        // Buat invoice baru
        $invoice = new Invoice();
        $invoice->customer_id = $customer->id;
        $invoice->invoice_number = $request->invoice_number;
        $invoice->invoice_date = $request->invoice_date;
        $invoice->due_date = $request->due_date;
        $invoice->total_amount = $totalBiaya;
        $invoice->status = 'unpaid';
        $invoice->description = $request->description;
        $invoice->no_kontrak = $request->no_kontrak;
        $invoice->id_pelanggan = $request->id_pelanggan;
        $invoice->period_month = $request->month;
        $invoice->period_year = $request->year;
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
        $yearMonth = $invoice->period_year . '-' . str_pad($invoice->period_month, 2, '0', STR_PAD_LEFT);
        
        // Get pricing info
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);
        
        // Retrieve and filter the relevant data
        $dataPencatatan = $customer->dataPencatatan()->get();
        
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

        // Perhitungan untuk volume dan biaya pemakaian gas
        $pemakaianGas = [];
        $totalVolume = 0;
        $totalBiaya = 0;
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
        
        // Create a single row with month's total
        // Format periode pemakaian for the entire month
        $periodePemakaian = Carbon::createFromDate($invoice->period_year, $invoice->period_month, 1)->format('1 F Y') . " - " . 
                         Carbon::createFromDate($invoice->period_year, $invoice->period_month, 1)->endOfMonth()->format('d F Y');
        
        $pemakaianGas[] = [
            'no' => 1,
            'periode_pemakaian' => $periodePemakaian,
            'volume_sm3' => $totalVolume,
            'harga_gas' => $hargaGas,
            'biaya_pemakaian' => $totalBiaya
        ];
        
        // Generate ID Pelanggan (contoh format)
        $idPelanggan = sprintf('03C%04d', $customer->id);
        
        // Terbilang untuk total tagihan
        $terbilang = $this->terbilang($totalBiaya);

        // Setup data untuk view Invoice
        $data = [
            'invoice' => $invoice,
            'customer' => $customer,
            'periode_bulan' => Carbon::createFromDate($invoice->period_year, $invoice->period_month, 1)->format('F Y'),
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
