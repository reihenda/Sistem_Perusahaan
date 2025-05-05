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
use Illuminate\Support\Facades\Log;

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

    /**
     * Fungsi untuk auto-sinkronisasi data rekap pengambilan ke data pencatatan FOB
     * Fungsi ini akan dijalankan setiap kali halaman fob-detail diakses
     */
    /**
     * Metode untuk menjalankan sinkronisasi data manual
     */
    public function syncData(User $customer)
    {
        // Verifikasi bahwa customer adalah FOB
        if (!$customer->isFOB()) {
            Log::warning('Attempt to sync data for non-FOB user', ['user_id' => $customer->id, 'role' => $customer->role]);
            return redirect()->back()->with('error', 'User yang dipilih bukan FOB');
        }

        // Verifikasi user memiliki izin (admin atau superadmin)
        if (!Auth::user()->isAdmin() && !Auth::user()->isSuperAdmin()) {
            return redirect()->back()->with('error', 'Anda tidak memiliki izin untuk melakukan operasi ini');
        }

        // Ambil SEMUA rekap pengambilan dan data pencatatan yang ada
        $rekapData = RekapPengambilan::where('customer_id', $customer->id)->get();

        // Lakukan sinkronisasi data dengan metode yang lebih agresif
        $newDataCount = $this->forceSyncRekapPengambilanData($customer, $rekapData);

        if ($newDataCount > 0) {
            return redirect()->route('data-pencatatan.fob-detail', ['customer' => $customer->id])
                ->with('success', "$newDataCount data berhasil disinkronkan dari rekap pengambilan!");
        } else {
            return redirect()->route('data-pencatatan.fob-detail', ['customer' => $customer->id])
                ->with('info', "Tidak ada data baru untuk disinkronkan. Semua data sudah sinkron.");
        }
    }

    /**
     * Fungsi untuk force-sinkronisasi data rekap pengambilan
     * Lebih agresif, mencari dengan berbagai metode
     */
    private function forceSyncRekapPengambilanData(User $customer, $rekapData = null)
    {
        // Pastikan ini adalah user FOB
        if (!$customer->isFOB()) {
            return 0;
        }

        // Ambil rekap pengambilan untuk FOB ini jika tidak disediakan
        if (!$rekapData) {
            $rekapData = RekapPengambilan::where('customer_id', $customer->id)->get();
        }

        // Ambil data pencatatan yang sudah ada
        $existingPencatatanData = DataPencatatan::where('customer_id', $customer->id)->get();

        // Siapkan array untuk melacak tanggal dari data pencatatan yang sudah ada
        $existingDates = [];
        foreach ($existingPencatatanData as $data) {
            $dataInput = json_decode($data->data_input, true) ?? [];

            if (!empty($dataInput['waktu'])) {
                try {
                    $date = Carbon::parse($dataInput['waktu'])->format('Y-m-d');
                    $existingDates[$date] = true;
                } catch (\Exception $e) {
                    // Ignore errors
                }
            }
        }

        $importedCount = 0;
        $rekapList = $rekapData->toArray();

        // Log untuk debugging
        Log::info('Memulai force sync untuk FOB', [
            'customer_id' => $customer->id,
            'rekap_count' => count($rekapList),
            'existing_pencatatan_count' => count($existingDates)
        ]);

        // Proses setiap rekap pengambilan
        foreach ($rekapData as $rekap) {
            try {
                // Format tanggal untuk pencarian
                $tanggalYmd = Carbon::parse($rekap->tanggal)->format('Y-m-d');

                // Jika sudah ada di data pencatatan, skip (lewati)
                if (isset($existingDates[$tanggalYmd])) {
                    Log::info("Tanggal $tanggalYmd sudah ada di data pencatatan, dilewati");
                    continue;
                }

                // Hitung harga
                $volumeSm3 = floatval($rekap->volume);
                $hargaPerM3 = floatval($customer->harga_per_meter_kubik) > 0 ?
                    floatval($customer->harga_per_meter_kubik) : 0;
                $hargaFinal = $volumeSm3 * $hargaPerM3;

                // Format data untuk FOB
                $dataInput = [
                    'waktu' => Carbon::parse($rekap->tanggal)->format('Y-m-d H:i:s'),
                    'volume_sm3' => $volumeSm3,
                    'keterangan' => $rekap->keterangan
                ];

                DB::beginTransaction();

                // Buat data pencatatan baru
                $dataPencatatan = new DataPencatatan();
                $dataPencatatan->customer_id = $rekap->customer_id;
                $dataPencatatan->data_input = json_encode($dataInput);
                $dataPencatatan->nama_customer = $customer->name;
                $dataPencatatan->status_pembayaran = 'belum_lunas'; // Default status
                $dataPencatatan->harga_final = $hargaFinal;
                $dataPencatatan->created_at = $rekap->created_at; // Gunakan created_at yang sama
                $dataPencatatan->updated_at = $rekap->updated_at; // Gunakan updated_at yang sama
                $dataPencatatan->save();

                DB::commit();

                // Tambahkan ke tanggal yang sudah ada
                $existingDates[$tanggalYmd] = true;

                $importedCount++;
                Log::info("Berhasil mengimpor data rekap pengambilan ID {$rekap->id} dengan tanggal $tanggalYmd");
            } catch (\Exception $e) {
                DB::rollBack();
                Log::error("Error saat memproses rekap ID {$rekap->id}: " . $e->getMessage());
            }
        }

        // Jika ada data yang diimpor, rekalkulasi total pembelian
        if ($importedCount > 0) {
            try {
                $userController = new UserController();
                $userController->rekalkulasiTotalPembelianFob($customer);
                Log::info("Berhasil merekalkulasi total pembelian FOB {$customer->name}");
            } catch (\Exception $e) {
                Log::error("Error saat merekalkulasi total pembelian FOB {$customer->name}: " . $e->getMessage());
            }
        }

        Log::info("Total $importedCount data rekap pengambilan berhasil diimpor untuk FOB {$customer->name}");
        return $importedCount;
    }
    /**
     * Fungsi untuk auto-sinkronisasi data rekap pengambilan ke data pencatatan FOB
     * Fungsi ini akan dijalankan setiap kali halaman fob-detail diakses
     * Versi yang ditingkatkan dengan deteksi lebih kuat
     */
    private function syncRekapPengambilanData(User $customer)
    {
        // Pastikan ini adalah user FOB
        if (!$customer->isFOB()) {
            return 0;
        }

        // Ambil rekap pengambilan untuk FOB ini
        $rekapData = RekapPengambilan::where('customer_id', $customer->id)->get();

        // Ambil data pencatatan yang sudah ada
        $existingPencatatanData = DataPencatatan::where('customer_id', $customer->id)->get();

        // Siapkan array untuk melacak tanggal dari data pencatatan yang sudah ada
        $existingDates = [];
        foreach ($existingPencatatanData as $data) {
            $dataInput = json_decode($data->data_input, true) ?? [];

            if (!empty($dataInput['waktu'])) {
                try {
                    $date = Carbon::parse($dataInput['waktu'])->format('Y-m-d');
                    $existingDates[$date] = true;
                } catch (\Exception $e) {
                    // Ignore errors
                }
            }
        }

        $importedCount = 0;

        // Batasi maksimal jumlah data yang diimpor per kali akses halaman (untuk performa)
        $maxImportPerVisit = 5;
        $currentImport = 0;

        foreach ($rekapData as $rekap) {
            try {
                // Format tanggal untuk pencarian
                $tanggalYmd = Carbon::parse($rekap->tanggal)->format('Y-m-d');

                // Jika sudah ada di data pencatatan, skip
                if (isset($existingDates[$tanggalYmd])) {
                    continue;
                }

                // Batasi jumlah data yang diimpor per kali akses
                if ($currentImport >= $maxImportPerVisit) {
                    break;
                }

                // Hitung harga
                $volumeSm3 = floatval($rekap->volume);
                $hargaPerM3 = floatval($customer->harga_per_meter_kubik) > 0 ?
                    floatval($customer->harga_per_meter_kubik) : 0;
                $hargaFinal = $volumeSm3 * $hargaPerM3;

                // Format data untuk FOB
                $dataInput = [
                    'waktu' => Carbon::parse($rekap->tanggal)->format('Y-m-d H:i:s'),
                    'volume_sm3' => $volumeSm3,
                    'keterangan' => $rekap->keterangan
                ];

                DB::beginTransaction();

                // Buat data pencatatan baru
                $dataPencatatan = new DataPencatatan();
                $dataPencatatan->customer_id = $rekap->customer_id;
                $dataPencatatan->data_input = json_encode($dataInput);
                $dataPencatatan->nama_customer = $customer->name;
                $dataPencatatan->status_pembayaran = 'belum_lunas'; // Default status
                $dataPencatatan->harga_final = $hargaFinal;
                $dataPencatatan->created_at = $rekap->created_at; // Gunakan created_at yang sama
                $dataPencatatan->updated_at = $rekap->updated_at; // Gunakan updated_at yang sama
                $dataPencatatan->save();

                DB::commit();

                // Tambahkan ke tanggal yang sudah ada
                $existingDates[$tanggalYmd] = true;

                $importedCount++;
                $currentImport++;
            } catch (\Exception $e) {
                DB::rollBack();
                Log::error("Error saat memproses rekap ID {$rekap->id}: " . $e->getMessage());
            }
        }

        // Jika ada data yang diimpor, rekalkulasi total pembelian
        if ($importedCount > 0) {
            try {
                $userController = new UserController();
                $userController->rekalkulasiTotalPembelianFob($customer);
            } catch (\Exception $e) {
                Log::error("Error saat merekalkulasi total pembelian FOB {$customer->name}: " . $e->getMessage());
            }
        }

        return $importedCount;
    }

    // Fungsi untuk menghitung informasi tahunan FOB
    private function calculateYearlyData(User $customer, $tahun)
    {
        // Ambil semua data pencatatan
        $allData = $customer->dataPencatatan()->get();

        // Filter hanya data dari tahun yang dipilih dengan metode yang ditingkatkan
        $yearlyData = $allData->filter(function ($item) use ($tahun) {
            $dataInput = $this->ensureArray($item->data_input);

            // Jika data input kosong, skip
            if (empty($dataInput)) {
                return false;
            }

            // Coba berbagai format dan kunci data
            $matchFound = false;

            // 1. Cek format standard 'waktu' (string datetime)
            if (!empty($dataInput['waktu']) && is_string($dataInput['waktu'])) {
                try {
                    $waktu = Carbon::parse($dataInput['waktu']);
                    $dataYear = $waktu->format('Y');
                    $matchFound = ($dataYear === $tahun);

                    if ($matchFound) {
                        return true;
                    }
                } catch (\Exception $e) {
                    // Ignore errors and try next format
                }
            }

            // 2. Cek format tanggal (string date only)
            if (!empty($dataInput['tanggal']) && is_string($dataInput['tanggal'])) {
                try {
                    $tanggal = Carbon::parse($dataInput['tanggal']);
                    $dataYear = $tanggal->format('Y');
                    $matchFound = ($dataYear === $tahun);

                    if ($matchFound) {
                        return true;
                    }
                } catch (\Exception $e) {
                    // Ignore errors and try next format
                }
            }

            // 3. Cek format pembacaan_awal.waktu (nested object)
            if (!empty($dataInput['pembacaan_awal']['waktu']) && is_string($dataInput['pembacaan_awal']['waktu'])) {
                try {
                    $waktu = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                    $dataYear = $waktu->format('Y');
                    $matchFound = ($dataYear === $tahun);

                    if ($matchFound) {
                        return true;
                    }
                } catch (\Exception $e) {
                    // Ignore errors and try next format
                }
            }

            // 4. Cek format created_at dari item (fallback)
            try {
                if ($item->created_at) {
                    $createdAt = Carbon::parse($item->created_at);
                    $dataYear = $createdAt->format('Y');
                    $matchFound = ($dataYear === $tahun);

                    if ($matchFound) {
                        return true;
                    }
                }
            } catch (\Exception $e) {
                // Ignore errors
            }

            return false; // No match found in any format
        });

        // Hitung total pemakaian dengan penanganan berbagai format
        $totalPemakaianTahunan = 0;
        foreach ($yearlyData as $item) {
            $dataInput = $this->ensureArray($item->data_input);

            // Ambil volume SM3 dari berbagai format yang mungkin
            $volumeSm3 = 0;

            // Format FOB standard menggunakan volume_sm3 langsung
            if (isset($dataInput['volume_sm3'])) {
                $volumeSm3 = floatval($dataInput['volume_sm3']);
            }
            // Format dari rekap_pengambilan menggunakan volume
            else if (isset($dataInput['volume'])) {
                $volumeSm3 = floatval($dataInput['volume']);
            }
            // Format customer biasa menggunakan volume_flow_meter dan koreksi
            else if (isset($dataInput['volume_flow_meter'])) {
                $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);
                $koreksiMeter = floatval($customer->koreksi_meter ?? 1.0);
                $volumeSm3 = $volumeFlowMeter * $koreksiMeter;
            }

            // Log volume info
            Log::info('FOB volume calculation', [
                'id' => $item->id,
                'data_input' => $dataInput,
                'has_volume_sm3' => isset($dataInput['volume_sm3']),
                'has_volume' => isset($dataInput['volume']),
                'has_volume_flow_meter' => isset($dataInput['volume_flow_meter']),
                'calculated_volume' => $volumeSm3
            ]);

            $totalPemakaianTahunan += $volumeSm3;
        }

        // Hitung total pembelian berdasarkan volume Sm3 dan harga per meter kubik
        $totalPembelianTahunan = 0;
        foreach ($yearlyData as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);

            // Ambil waktu untuk mendapatkan pricing yang tepat - dengan penanganan berbagai format
            $waktuYearMonth = null;

            // Coba berbagai format dan kunci data
            if (!empty($dataInput['waktu']) && is_string($dataInput['waktu'])) {
                try {
                    $waktuYearMonth = Carbon::parse($dataInput['waktu'])->format('Y-m');
                } catch (\Exception $e) {
                    // Ignore errors and try next format
                }
            }

            if (!$waktuYearMonth && !empty($dataInput['tanggal']) && is_string($dataInput['tanggal'])) {
                try {
                    $waktuYearMonth = Carbon::parse($dataInput['tanggal'])->format('Y-m');
                } catch (\Exception $e) {
                    // Ignore errors and try next format
                }
            }

            if (!$waktuYearMonth && !empty($dataInput['pembacaan_awal']['waktu']) && is_string($dataInput['pembacaan_awal']['waktu'])) {
                try {
                    $waktuYearMonth = Carbon::parse($dataInput['pembacaan_awal']['waktu'])->format('Y-m');
                } catch (\Exception $e) {
                    // Ignore errors and try next format
                }
            }

            // Fallback ke created_at jika semua format gagal
            if (!$waktuYearMonth && $item->created_at) {
                try {
                    $waktuYearMonth = Carbon::parse($item->created_at)->format('Y-m');
                } catch (\Exception $e) {
                    // Use current date as last resort
                    $waktuYearMonth = Carbon::now()->format('Y-m');
                }
            }

            // Fallback terakhir jika masih null
            if (!$waktuYearMonth) {
                $waktuYearMonth = Carbon::now()->format('Y-m');
            }
            $pricingInfo = $customer->getPricingForYearMonth($waktuYearMonth);

            // Gunakan harga yang sesuai untuk periode ini
            $hargaPerMeterKubik = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
            $pembelian = $volumeSm3 * $hargaPerMeterKubik;

            $totalPembelianTahunan += $pembelian;
        }

        // Log untuk debugging
        Log::info("FOB {$customer->name} - Tahunan ($tahun): Pemakaian: $totalPemakaianTahunan Sm³, Pembelian: Rp " . number_format($totalPembelianTahunan, 0));

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
        // Verifikasi bahwa customer adalah FOB
        if (!$customer->isFOB()) {
            Log::warning('Attempt to access FOB detail for non-FOB user', ['user_id' => $customer->id, 'role' => $customer->role]);
            return redirect()->back()->with('error', 'User yang dipilih bukan FOB');
        }

        // Jalankan sinkronisasi data secara otomatis
        // Ini akan mengimpor data dari rekap_pengambilan ke data_pencatatan jika belum ada
        $newDataCount = $this->syncRekapPengambilanData($customer);
        $syncMessage = '';
        if ($newDataCount > 0) {
            $syncMessage = $newDataCount . ' data baru berhasil diimpor dari rekap pengambilan.';
            Log::info("Berhasil menyinkronkan $newDataCount data FOB untuk customer ID {$customer->id}");
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

        // Tambahkan log untuk melihat semua data yang ada
        Log::info('All FOB data before filtering', [
            'customer_id' => $customer->id,
            'total_records' => $dataPencatatan->count(),
            'data_samples' => $dataPencatatan->take(5)->map(function ($item) {
                return [
                    'id' => $item->id,
                    'data_input' => is_string($item->data_input) ? json_decode($item->data_input, true) : $item->data_input,
                    'created_at' => $item->created_at
                ];
            })->toArray()
        ]);

        // Metode filter yang diperbaiki dan lebih fleksibel
        $dataPencatatan = $dataPencatatan->filter(function ($item) use ($yearMonth, $bulan, $tahun) {
            $dataInput = $this->ensureArray($item->data_input);

            // Log untuk melihat format data input setiap item
            Log::info('FOB data item format', [
                'id' => $item->id,
                'data_input' => $dataInput,
                'has_waktu' => isset($dataInput['waktu']),
                'waktu_value' => $dataInput['waktu'] ?? 'not_set',
                'target_yearMonth' => $yearMonth,
                'target_year' => $tahun,
                'target_month' => $bulan
            ]);

            // Jika data input kosong, skip
            if (empty($dataInput)) {
                return false;
            }

            // Coba berbagai format dan kunci data
            $matchFound = false;

            // 1. Cek format standard 'waktu' (string datetime)
            if (!empty($dataInput['waktu']) && is_string($dataInput['waktu'])) {
                try {
                    $waktu = Carbon::parse($dataInput['waktu']);
                    $dataYearMonth = $waktu->format('Y-m');
                    $matchFound = ($dataYearMonth === $yearMonth);

                    // Log detail
                    Log::info('Checking waktu match', [
                        'id' => $item->id,
                        'waktu' => $dataInput['waktu'],
                        'parsed_yearMonth' => $dataYearMonth,
                        'target' => $yearMonth,
                        'match' => $matchFound
                    ]);

                    if ($matchFound) {
                        return true;
                    }
                } catch (\Exception $e) {
                    Log::warning('Error parsing waktu', [
                        'id' => $item->id,
                        'waktu' => $dataInput['waktu'],
                        'error' => $e->getMessage()
                    ]);
                }
            }

            // 2. Cek format tanggal (string date only)
            if (!empty($dataInput['tanggal']) && is_string($dataInput['tanggal'])) {
                try {
                    $tanggal = Carbon::parse($dataInput['tanggal']);
                    $dataYearMonth = $tanggal->format('Y-m');
                    $matchFound = ($dataYearMonth === $yearMonth);

                    if ($matchFound) {
                        return true;
                    }
                } catch (\Exception $e) {
                    // Ignore errors and try next format
                }
            }

            // 3. Cek format pembacaan_awal.waktu (nested object)
            if (!empty($dataInput['pembacaan_awal']['waktu']) && is_string($dataInput['pembacaan_awal']['waktu'])) {
                try {
                    $waktu = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                    $dataYearMonth = $waktu->format('Y-m');
                    $matchFound = ($dataYearMonth === $yearMonth);

                    if ($matchFound) {
                        return true;
                    }
                } catch (\Exception $e) {
                    // Ignore errors and try next format
                }
            }

            // 4. Cek format created_at dari item (fallback)
            try {
                if ($item->created_at) {
                    $createdAt = Carbon::parse($item->created_at);
                    $dataYearMonth = $createdAt->format('Y-m');
                    $matchFound = ($dataYearMonth === $yearMonth);

                    if ($matchFound) {
                        Log::info('Match found using created_at', [
                            'id' => $item->id,
                            'created_at' => $item->created_at,
                            'parsed_yearMonth' => $dataYearMonth
                        ]);
                        return true;
                    }
                }
            } catch (\Exception $e) {
                // Ignore errors
            }

            return false; // No match found in any format
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

        // Tampilkan pesan sinkronisasi jika ada
        if (!empty($syncMessage)) {
            session()->flash('success', $syncMessage);
        }

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
