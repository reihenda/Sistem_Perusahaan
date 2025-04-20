<?php

namespace App\Http\Controllers;

use App\Models\Billing;
use App\Models\User;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class BillingController extends Controller
{
    /**
     * Display a listing of billings.
     */
    public function index()
    {
        $billings = Billing::with('customer')
            ->orderBy('created_at', 'desc')
            ->paginate(15);
        
        return view('billings.index', compact('billings'));
    }

    /**
     * Display the list of customers to select for a new billing.
     */
    public function selectCustomer()
    {
        $customers = User::where('role', 'customer')
            ->orderBy('name')
            ->get();
        
        return view('billings.select-customer', compact('customers'));
    }

    /**
     * Show the form for creating a new billing for a specific customer.
     */
    public function create(User $customer)
    {
        // Generate a default billing number based on the current date
        $billingNumber = Billing::generateBillingNumber($customer);
        
        // Default to current month and year
        $month = now()->month;
        $year = now()->year;
        
        return view('billings.create', compact('customer', 'billingNumber', 'month', 'year'));
    }

    /**
     * Store a newly created billing in storage.
     */
    public function store(Request $request, User $customer)
    {
        $request->validate([
            'billing_number' => 'required|string|max:50',
            'billing_date' => 'required|date',
            'month' => 'required|integer|min:1|max:12',
            'year' => 'required|integer|min:2000|max:2100',
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

        // Perhitungan untuk volume dan biaya pemakaian gas
        $totalVolume = 0;
        $totalBiaya = 0;

        foreach ($dataPencatatan as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
            $volumeSm3 = $volumeFlowMeter * floatval($pricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
            $hargaGas = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
            $biayaPemakaian = $volumeSm3 * $hargaGas;

            $totalVolume += $volumeSm3;
            $totalBiaya += $biayaPemakaian;
        }

        // Perhitungan untuk penerimaan deposit
        $totalDeposit = 0;

        $depositHistory = $this->ensureArray($customer->deposit_history);
        foreach ($depositHistory as $deposit) {
            if (isset($deposit['date'])) {
                $depositDate = Carbon::parse($deposit['date']);
                if ($depositDate->month == $request->month && $depositDate->year == $request->year) {
                    $totalDeposit += floatval($deposit['amount'] ?? 0);
                }
            }
        }

        // Menghitung saldo bulan sebelumnya
        $prevDate = Carbon::createFromDate($request->year, $request->month, 1)->subMonth();
        $prevMonthYear = $prevDate->format('Y-m');
        
        // Mendapatkan deposit dan pembelian pada semua periode sebelumnya
        $prevTotalDeposits = 0;
        $prevTotalPurchases = 0;
        
        // Menghitung deposit seluruh periode sebelumnya
        foreach ($depositHistory as $deposit) {
            if (isset($deposit['date'])) {
                $depositDate = Carbon::parse($deposit['date']);
                if ($depositDate < Carbon::createFromDate($request->year, $request->month, 1)) {
                    $prevTotalDeposits += floatval($deposit['amount'] ?? 0);
                }
            }
        }
        
        // Menghitung pembelian seluruh periode sebelumnya
        $allData = $customer->dataPencatatan()->get();
        foreach ($allData as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            
            // Jika data input kosong atau tidak ada waktu awal, skip
            if (empty($dataInput) || empty($dataInput['pembacaan_awal']['waktu'])) {
                continue;
            }
            
            $itemDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
            if ($itemDate < Carbon::createFromDate($request->year, $request->month, 1)) {
                $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
                $itemYearMonth = $itemDate->format('Y-m');
                $itemPricingInfo = $customer->getPricingForYearMonth($itemYearMonth);
                $volumeSm3 = $volumeFlowMeter * floatval($itemPricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
                $prevTotalPurchases += $volumeSm3 * floatval($itemPricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
            }
        }
        
        // Menghitung saldo bulan sebelumnya
        $prevMonthBalance = $prevTotalDeposits - $prevTotalPurchases;
        
        // Menghitung saldo bulan ini
        $currentMonthBalance = $prevMonthBalance + $totalDeposit - $totalBiaya;
        
        // Menghitung biaya yang harus dibayar (jika saldo negatif)
        $amountToPay = $currentMonthBalance < 0 ? abs($currentMonthBalance) : 0;

        // Buat billing baru
        $billing = new Billing();
        $billing->customer_id = $customer->id;
        $billing->billing_number = $request->billing_number;
        $billing->billing_date = $request->billing_date;
        $billing->total_volume = $totalVolume;
        $billing->total_amount = $totalBiaya;
        $billing->total_deposit = $totalDeposit;
        $billing->previous_balance = $prevMonthBalance;
        $billing->current_balance = $currentMonthBalance;
        $billing->amount_to_pay = $amountToPay;
        $billing->period_month = $request->month;
        $billing->period_year = $request->year;
        $billing->status = 'unpaid';
        $billing->save();

        return redirect()->route('billings.show', $billing)
            ->with('success', 'Billing berhasil dibuat.');
    }

    /**
     * Display the specified billing.
     */
    public function show(Billing $billing)
    {
        $customer = $billing->customer;
        $yearMonth = $billing->period_year . '-' . str_pad($billing->period_month, 2, '0', STR_PAD_LEFT);
        
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
        $i = 1;
        foreach ($dataPencatatan as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
            $volumeSm3 = $volumeFlowMeter * floatval($pricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
            $hargaGas = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
            $biayaPemakaian = $volumeSm3 * $hargaGas;

            $periodePemakaian = isset($dataInput['pembacaan_awal']['waktu']) ? 
                            Carbon::parse($dataInput['pembacaan_awal']['waktu'])->format('d/m/Y') : '';
            
            $tanggalPemakaian = isset($dataInput['pembacaan_awal']['waktu']) ?
                            Carbon::parse($dataInput['pembacaan_awal']['waktu']) : null;

            $pemakaianGas[] = [
                'no' => $i++,
                'periode_pemakaian' => $periodePemakaian,
                'tanggal_pemakaian' => $tanggalPemakaian,
                'volume_sm3' => $volumeSm3,
                'harga_gas' => $hargaGas,
                'biaya_pemakaian' => $biayaPemakaian
            ];
        }
        
        // Urutkan data berdasarkan tanggal periode pemakaian
        usort($pemakaianGas, function($a, $b) {
            if (!$a['tanggal_pemakaian'] || !$b['tanggal_pemakaian']) {
                return 0;
            }
            return $a['tanggal_pemakaian']->timestamp - $b['tanggal_pemakaian']->timestamp;
        });
        
        // Reset nomor urut setelah pengurutan
        $i = 1;
        foreach ($pemakaianGas as &$item) {
            $item['no'] = $i++;
            unset($item['tanggal_pemakaian']); // Hapus field yang hanya untuk pengurutan
        }

        // Perhitungan untuk penerimaan deposit
        $penerimaanDeposit = [];
        $j = 1;
        $depositHistory = $this->ensureArray($customer->deposit_history);
        foreach ($depositHistory as $deposit) {
            if (isset($deposit['date'])) {
                $depositDate = Carbon::parse($deposit['date']);
                if ($depositDate->month == $billing->period_month && $depositDate->year == $billing->period_year) {
                    $jumlahDeposit = floatval($deposit['amount'] ?? 0);
                    $penerimaanDeposit[] = [
                        'no' => $j++,
                        'tanggal_deposit' => $depositDate->format('d/m/Y'),
                        'tanggal_untuk_urutan' => $depositDate,
                        'jumlah_penerimaan' => $jumlahDeposit
                    ];
                }
            }
        }
        
        // Urutkan data penerimaan deposit berdasarkan tanggal
        usort($penerimaanDeposit, function($a, $b) {
            if (!isset($a['tanggal_untuk_urutan']) || !isset($b['tanggal_untuk_urutan'])) {
                return 0;
            }
            return $a['tanggal_untuk_urutan']->timestamp - $b['tanggal_untuk_urutan']->timestamp;
        });
        
        // Reset nomor urut setelah pengurutan
        $j = 1;
        foreach ($penerimaanDeposit as &$item) {
            $item['no'] = $j++;
            unset($item['tanggal_untuk_urutan']); // Hapus field yang hanya untuk pengurutan
        }

        // Setup data untuk view Billing
        $data = [
            'billing' => $billing,
            'customer' => $customer,
            'periode_bulan' => Carbon::createFromDate($billing->period_year, $billing->period_month, 1)->format('F Y'),
            'pemakaian_gas' => $pemakaianGas,
            'penerimaan_deposit' => $penerimaanDeposit,
        ];

        return view('billings.show', $data);
    }

    /**
     * Show the form for editing the billing.
     */
    public function edit(Billing $billing)
    {
        $customer = $billing->customer;
        return view('billings.edit', compact('billing', 'customer'));
    }

    /**
     * Update the specified billing in storage.
     */
    public function update(Request $request, Billing $billing)
    {
        $request->validate([
            'billing_number' => 'required|string|max:50',
            'billing_date' => 'required|date',
            'status' => 'required|in:paid,unpaid,partial,cancelled',
        ]);

        $billing->billing_number = $request->billing_number;
        $billing->billing_date = $request->billing_date;
        $billing->status = $request->status;
        $billing->save();

        return redirect()->route('billings.show', $billing)
            ->with('success', 'Billing berhasil diperbarui.');
    }

    /**
     * Remove the specified billing from storage.
     */
    public function destroy(Billing $billing)
    {
        $billing->delete();
        return redirect()->route('billings.index')
            ->with('success', 'Billing berhasil dihapus.');
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
}
