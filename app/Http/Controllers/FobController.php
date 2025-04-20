<?php

namespace App\Http\Controllers;

use App\Models\DataPencatatan;
use App\Models\RekapPengambilan;
use App\Models\User;
use App\Models\NomorPolisi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class FobController extends Controller
{
    // Helper function to ensure data is always an array
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

    // Fungsi untuk menghitung informasi tahunan FOB
    private function calculateYearlyData(User $customer, $tahun)
    {
        // Ambil semua data pencatatan
        $allData = $customer->dataPencatatan()->get();

        // Filter hanya data dari tahun yang dipilih
        $yearlyData = $allData->filter(function ($item) use ($tahun) {
            $dataInput = $this->ensureArray($item->data_input);

            // Jika data input kosong atau tidak ada waktu, skip
            if (empty($dataInput) || empty($dataInput['waktu'])) {
                return false;
            }

            // Ambil tahun dari waktu pencatatan
            $waktuTahun = Carbon::parse($dataInput['waktu'])->format('Y');

            // Filter by year
            return $waktuTahun === $tahun;
        });

        // Hitung total pemakaian
        $totalPemakaianTahunan = 0;
        foreach ($yearlyData as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);
            $totalPemakaianTahunan += $volumeSm3;
        }

        // Hitung total pembelian berdasarkan volume Sm3 dan harga per meter kubik
        $totalPembelianTahunan = 0;
        foreach ($yearlyData as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);

            // Ambil waktu untuk mendapatkan pricing yang tepat
            $waktuYearMonth = Carbon::parse($dataInput['waktu'])->format('Y-m');
            $pricingInfo = $customer->getPricingForYearMonth($waktuYearMonth);

            // Gunakan harga yang sesuai untuk periode ini
            $hargaPerMeterKubik = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
            $pembelian = $volumeSm3 * $hargaPerMeterKubik;
            
            $totalPembelianTahunan += $pembelian;
        }

        // Log untuk debugging
        \Log::info("FOB {$customer->name} - Tahunan ($tahun): Pemakaian: $totalPemakaianTahunan Sm³, Pembelian: Rp " . number_format($totalPembelianTahunan, 0));

        return [
            'totalPemakaianTahunan' => round($totalPemakaianTahunan, 2),
            'totalPembelianTahunan' => round($totalPembelianTahunan, 0) // Bulatkan ke angka bulat untuk Rupiah
        ];
    }

    // Menampilkan form untuk membuat data pencatatan FOB
    public function create()
    {
        // Ambil daftar FOB untuk dipilih
        $fobs = User::where('role', User::ROLE_FOB)->get();
        $nomorPolisList = NomorPolisi::orderBy('nopol')->get();
        return view('data-pencatatan.fob.fob-create', compact('fobs', 'nomorPolisList'));
    }

    // Menampilkan form untuk membuat data pencatatan FOB dengan FOB yang sudah dipilih
    public function createWithFob($fobId)
    {
        // Ambil daftar FOB untuk dipilih
        $fobs = User::where('role', User::ROLE_FOB)->get();
        $selectedCustomer = User::findOrFail($fobId);
        $nomorPolisList = NomorPolisi::orderBy('nopol')->get();

        return view('data-pencatatan.fob.fob-create', compact('fobs', 'selectedCustomer', 'nomorPolisList'));
    }

    // Proses penyimpanan data pencatatan FOB
    public function store(Request $request)
    {

        $validatedData = $request->validate([
            'customer_id' => 'required|exists:users,id',
            'data_input' => 'required|array',
            'nopol' => 'required|string|max:20'
        ]);

        $customer = User::findOrFail($validatedData['customer_id']);

        // Verifikasi bahwa customer adalah FOB
        if (!$customer->isFOB()) {
            return redirect()->back()->with('error', 'User yang dipilih bukan FOB')->withInput();
        }

        // Validasi data input FOB
        $this->validateFobInput($validatedData['data_input']);

        // Hitung harga
        $volumeSm3 = floatval($validatedData['data_input']['volume_sm3']);
        $hargaPerM3 = floatval($customer->harga_per_meter_kubik) > 0 ?
            floatval($customer->harga_per_meter_kubik) : 0;
        $hargaFinal = $volumeSm3 * $hargaPerM3;

        // Buat data pencatatan baru
        $dataPencatatan = new DataPencatatan();
        $dataPencatatan->customer_id = $validatedData['customer_id'];
        $dataPencatatan->data_input = json_encode($validatedData['data_input']);
        $dataPencatatan->nama_customer = $customer->name;
        $dataPencatatan->status_pembayaran = 'belum_lunas'; // Default status
        $dataPencatatan->harga_final = $hargaFinal;
        $dataPencatatan->save();

        // Update total pembelian customer
        $customer->recordPurchase($hargaFinal);
        $userController = new UserController();
        $userController->rekalkulasiTotalPembelianFob($customer);

        // Tambahkan data ke rekap pengambilan
        $rekapPengambilan = new RekapPengambilan();
        $rekapPengambilan->customer_id = $validatedData['customer_id'];
        $rekapPengambilan->tanggal = $validatedData['data_input']['waktu'];
        $rekapPengambilan->nopol = $validatedData['nopol'];
        $rekapPengambilan->volume = $volumeSm3;
        $rekapPengambilan->keterangan = $validatedData['data_input']['keterangan'] ?? null;
        $rekapPengambilan->save();

        return redirect()->route('data-pencatatan.fob-detail', ['customer' => $validatedData['customer_id']])
            ->with('success', 'Data FOB berhasil disimpan');
    }

    // Validasi input FOB
    private function validateFobInput($dataInput)
    {
        // Validasi waktu
        if (empty($dataInput['waktu'])) {
            throw new \InvalidArgumentException('Tanggal dan waktu harus diisi');
        }

        // Validasi volume SM3
        if (!isset($dataInput['volume_sm3']) || floatval($dataInput['volume_sm3']) < 0) {
            throw new \InvalidArgumentException('Volume Sm³ tidak valid');
        }
    }

    // Menampilkan detail pencatatan untuk FOB tertentu
    public function fobDetail(User $customer, Request $request)
    {
        // Debug
        \Log::info('Accessing FOB detail page', ['customer_id' => $customer->id, 'role' => $customer->role]);

        // Verifikasi bahwa customer adalah FOB
        if (!$customer->isFOB()) {
            \Log::warning('Attempt to access FOB detail for non-FOB user', ['user_id' => $customer->id, 'role' => $customer->role]);
            return redirect()->back()->with('error', 'User yang dipilih bukan FOB');
        }

        // Get filter parameters
        $bulan = $request->input('bulan');
        $tahun = $request->input('tahun');

        // Default to current month and year if not specified
        if (!$bulan) {
            $bulan = date('m');
        }
        if (!$tahun) {
            $tahun = date('Y');
        }

        // Format filter untuk query
        $yearMonth = $tahun . '-' . str_pad($bulan, 2, '0', STR_PAD_LEFT);

        // Base query
        $query = $customer->dataPencatatan();

        // Ambil semua data dulu
        $dataPencatatan = $query->get();

        // Filter data berdasarkan bulan dan tahun dari waktu pencatatan
        $dataPencatatan = $dataPencatatan->filter(function ($item) use ($yearMonth) {
            $dataInput = $this->ensureArray($item->data_input);

            // Jika data input kosong atau tidak ada waktu, skip
            if (empty($dataInput) || empty($dataInput['waktu'])) {
                return false;
            }

            // Convert the timestamp to year-month format for comparison
            $waktu = Carbon::parse($dataInput['waktu'])->format('Y-m');

            // Filter by year-month
            return $waktu === $yearMonth;
        });

        // Get pricing info for selected month
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);

        // Calculate total volume SM3 for all time
        $totalVolumeSm3 = $dataPencatatan->sum(function ($item) {
            $dataInput = $this->ensureArray($item->data_input);
            return floatval($dataInput['volume_sm3'] ?? 0);
        });

        // Calculate total volume SM3 for filtered period
        $filteredVolumeSm3 = $dataPencatatan->sum(function ($item) {
            $dataInput = $this->ensureArray($item->data_input);
            return floatval($dataInput['volume_sm3'] ?? 0);
        });

        // Calculate total purchases for the filtered period
        $filteredTotalPurchases = $dataPencatatan->sum(function ($item) use ($customer) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);
            return $volumeSm3 * floatval($customer->harga_per_meter_kubik);
        });

        // Calculate total deposits for the filtered period
        $filteredTotalDeposits = 0;
        $depositHistory = $this->ensureArray($customer->deposit_history);

        foreach ($depositHistory as $deposit) {
            if (isset($deposit['date'])) {
                $depositDate = Carbon::parse($deposit['date']);
                if ($depositDate->month == $bulan && $depositDate->year == $tahun) {
                    $filteredTotalDeposits += floatval($deposit['amount'] ?? 0);
                }
            }
        }

        // Calculate yearly data
        $yearlyData = $this->calculateYearlyData($customer, $tahun);

        return view('data-pencatatan.fob.fob-detail', [
            'customer' => $customer,
            'dataPencatatan' => $dataPencatatan,
            'depositHistory' => $customer->deposit_history ?? [],
            'totalDeposit' => $customer->total_deposit,
            'totalPurchases' => $customer->total_purchases,
            'currentBalance' => $customer->getCurrentBalance(),
            'selectedBulan' => $bulan,
            'selectedTahun' => $tahun,
            'pricingInfo' => $pricingInfo,
            'totalVolumeSm3' => $totalVolumeSm3,
            'filteredVolumeSm3' => $filteredVolumeSm3,
            'filteredTotalPurchases' => $filteredTotalPurchases,
            'filteredTotalDeposits' => $filteredTotalDeposits,
            'totalPemakaianTahunan' => $yearlyData['totalPemakaianTahunan'],
            'totalPembelianTahunan' => $yearlyData['totalPembelianTahunan']
        ]);
    }

    // Filter data pencatatan FOB berdasarkan bulan dan tahun
    public function filterByMonthYear(Request $request, User $customer)
    {
        $validatedData = $request->validate([
            'bulan' => 'required|numeric|between:1,12',
            'tahun' => 'required|numeric|between:2000,2100'
        ]);

        return redirect()->route('data-pencatatan.fob-detail', [
            'customer' => $customer->id,
            'bulan' => $validatedData['bulan'],
            'tahun' => $validatedData['tahun']
        ]);
    }
}
