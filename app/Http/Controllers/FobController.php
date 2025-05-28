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
     * Metode untuk menjalankan sinkronisasi data manual dengan pemeriksaan integritas
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

        try {
            DB::beginTransaction();
            
            // Ambil SEMUA rekap pengambilan dan data pencatatan yang ada
            $rekapData = RekapPengambilan::where('customer_id', $customer->id)->get();

            // Lakukan sinkronisasi data dengan metode yang lebih agresif
            $newDataCount = $this->forceSyncRekapPengambilanData($customer, $rekapData);
            
            // Langkah 1: Rekalkulasi total pembelian
            $userController = new UserController();
            $newTotalPurchases = $userController->rekalkulasiTotalPembelianFob($customer);
            
            // Log hasil rekalkulasi
            Log::info("Hasil rekalkulasi total pembelian setelah sync", [
                'customer_id' => $customer->id,
                'old_total_purchases' => $customer->total_purchases, 
                'new_total_purchases' => $newTotalPurchases,
                'difference' => $newTotalPurchases - $customer->total_purchases
            ]);
            
            // Langkah 2: Verifikasi dan perbaiki konsistensi data deposit
            $depositHistory = $this->ensureArray($customer->deposit_history);
            $calculatedTotalDeposit = 0;
            
            foreach ($depositHistory as $deposit) {
                if (isset($deposit['amount'])) {
                    $calculatedTotalDeposit += floatval($deposit['amount']);
                }
            }
            
            // Jika ada perbedaan dalam total deposit, perbaiki
            if (abs($calculatedTotalDeposit - $customer->total_deposit) > 0.01) {
                Log::warning("Perbedaan total deposit terdeteksi", [
                    'customer_id' => $customer->id,
                    'stored_total_deposit' => $customer->total_deposit,
                    'calculated_total_deposit' => $calculatedTotalDeposit,
                    'difference' => $calculatedTotalDeposit - $customer->total_deposit
                ]);
                
                // Update total deposit ke nilai yang benar
                $customer->total_deposit = $calculatedTotalDeposit;
                $customer->save();
                
                Log::info("Total deposit dikoreksi", [
                    'customer_id' => $customer->id,
                    'new_total_deposit' => $customer->total_deposit
                ]);
            }
            
            // Langkah 3: Reset dan perbarui monthly balances dengan data yang sudah dikoreksi
            // Hapus monthly_balances yang ada dan buat ulang dari awal
            $customer->monthly_balances = [];
            $customer->save();
            
            // Perbarui monthly_balances dari awal (4 tahun ke belakang)
            $fourYearsAgo = Carbon::now()->subYears(4)->startOfMonth()->format('Y-m');
            $updateResult = $customer->updateMonthlyBalances($fourYearsAgo);
            
            Log::info("Monthly balances diperbarui setelah sync", [
                'customer_id' => $customer->id,
                'success' => $updateResult ? 'true' : 'false',
                'start_from' => $fourYearsAgo
            ]);
            
            // Langkah 4: Verifikasi final keseluruhan proses
            // Reload customer dari database untuk memastikan data terbaru
            $customer = User::findOrFail($customer->id);
            
            // Validasi saldo akhir sesuai dengan total_deposit - total_purchases
            $expectedBalance = $customer->total_deposit - $customer->total_purchases;
            $currentYearMonth = Carbon::now()->format('Y-m');
            $latestBalance = $customer->monthly_balances[$currentYearMonth] ?? null;
            
            if ($latestBalance !== null && abs($expectedBalance - $latestBalance) > 0.01) {
                Log::warning("Saldo akhir masih tidak konsisten setelah sync", [
                    'customer_id' => $customer->id,
                    'expected_balance' => $expectedBalance,
                    'latest_monthly_balance' => $latestBalance,
                    'difference' => $expectedBalance - $latestBalance
                ]);
                
                // Koreksi saldo bulan terakhir jika masih tidak konsisten
                $monthlyBalances = $customer->monthly_balances;
                $monthlyBalances[$currentYearMonth] = $expectedBalance;
                $customer->monthly_balances = $monthlyBalances;
                $customer->save();
                
                Log::info("Saldo bulan terakhir dikoreksi manual", [
                    'customer_id' => $customer->id,
                    'current_month' => $currentYearMonth,
                    'corrected_balance' => $expectedBalance
                ]);
            }
            
            DB::commit();
            
            if ($newDataCount > 0) {
                return redirect()->route('data-pencatatan.fob-detail', ['customer' => $customer->id])
                    ->with('success', "$newDataCount data berhasil disinkronkan dan saldo sudah dikoreksi dengan akurat!");
            } else {
                return redirect()->route('data-pencatatan.fob-detail', ['customer' => $customer->id])
                    ->with('info', "Tidak ada data baru, tetapi semua saldo telah diverifikasi dan dikoreksi jika diperlukan.");
            }
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Error saat sinkronisasi data", [
                'customer_id' => $customer->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return redirect()->route('data-pencatatan.fob-detail', ['customer' => $customer->id])
                ->with('error', "Terjadi kesalahan: {$e->getMessage()}");
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
            'existing_pencatatan_count' => count($existingDates),
            'existing_dates' => array_keys($existingDates)
        ]);

        // Proses setiap rekap pengambilan
        foreach ($rekapData as $rekap) {
            try {
                // Format tanggal untuk pencarian
                $tanggalYmd = Carbon::parse($rekap->tanggal)->format('Y-m-d');

                // Jika sudah ada di data pencatatan, skip (lewati)
                if (isset($existingDates[$tanggalYmd])) {
                    Log::info("Tanggal $tanggalYmd sudah ada di data pencatatan, dilewati", [
                        'rekap_id' => $rekap->id,
                        'tanggal' => $tanggalYmd,
                        'customer_id' => $customer->id
                    ]);
                    continue;
                }

                // Hitung harga
                $volumeSm3 = floatval($rekap->volume);
                
                // Ambil pricing info berdasarkan tanggal spesifik rekap
                $rekap_date = Carbon::parse($rekap->tanggal);
                $rekap_yearMonth = $rekap_date->format('Y-m');
                $pricingInfo = $customer->getPricingForYearMonth($rekap_yearMonth, $rekap_date);
                
                // Gunakan harga per meter kubik yang sesuai dengan periode
                $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                $hargaFinal = $volumeSm3 * $hargaPerM3;

                // Format data untuk FOB
                $dataInput = [
                    'waktu' => Carbon::parse($rekap->tanggal)->format('Y-m-d H:i:s'),
                    'volume_sm3' => $volumeSm3,
                    'keterangan' => $rekap->keterangan,
                    'alamat_pengambilan' => $rekap->alamat_pengambilan
                ];
                
                // Log detail pricing untuk debugging
                Log::info('Pricing info for new FOB record', [
                    'rekap_id' => $rekap->id,
                    'tanggal' => $tanggalYmd,
                    'volume' => $volumeSm3,
                    'harga_per_m3' => $hargaPerM3,
                    'harga_final' => $hargaFinal,
                    'pricing_info' => $pricingInfo
                ]);

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
                Log::info("Berhasil mengimpor data rekap pengambilan ID {$rekap->id} dengan tanggal $tanggalYmd", [
                    'data_pencatatan_id' => $dataPencatatan->id,
                    'harga_final' => $hargaFinal
                ]);
            } catch (\Exception $e) {
                DB::rollBack();
                Log::error("Error saat memproses rekap ID {$rekap->id}: " . $e->getMessage(), [
                    'file' => $e->getFile(),
                    'line' => $e->getLine(),
                    'trace' => $e->getTraceAsString()
                ]);
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

        // Log existingDates untuk debugging
        Log::info('Existing dates for sync', [
            'customer_id' => $customer->id,
            'count' => count($existingDates),
            'dates' => array_keys($existingDates)
        ]);

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
                
                // Ambil pricing info berdasarkan tanggal spesifik rekap
                $rekap_date = Carbon::parse($rekap->tanggal);
                $rekap_yearMonth = $rekap_date->format('Y-m');
                $pricingInfo = $customer->getPricingForYearMonth($rekap_yearMonth, $rekap_date);
                
                // Gunakan harga per meter kubik yang sesuai dengan periode
                $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                $hargaFinal = $volumeSm3 * $hargaPerM3;

                // Format data untuk FOB
                $dataInput = [
                    'waktu' => Carbon::parse($rekap->tanggal)->format('Y-m-d H:i:s'),
                    'volume_sm3' => $volumeSm3,
                    'keterangan' => $rekap->keterangan,
                    'alamat_pengambilan' => $rekap->alamat_pengambilan
                ];
                
                // Log detail pricing untuk debugging
                Log::info('Pricing info for sync FOB record', [
                    'rekap_id' => $rekap->id,
                    'tanggal' => $tanggalYmd,
                    'volume' => $volumeSm3,
                    'harga_per_m3' => $hargaPerM3,
                    'harga_final' => $hargaFinal,
                    'pricing_info' => $pricingInfo
                ]);

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
                
                Log::info("Auto-sync: Berhasil mengimpor data rekap ID {$rekap->id}", [
                    'tanggal' => $tanggalYmd,
                    'data_pencatatan_id' => $dataPencatatan->id,
                    'harga_final' => $hargaFinal
                ]);
            } catch (\Exception $e) {
                DB::rollBack();
                Log::error("Error saat memproses rekap ID {$rekap->id}: " . $e->getMessage(), [
                    'file' => $e->getFile(),
                    'line' => $e->getLine()
                ]);
            }
        }

        // Jika ada data yang diimpor, rekalkulasi total pembelian
        if ($importedCount > 0) {
            try {
                $userController = new UserController();
                $userController->rekalkulasiTotalPembelianFob($customer);
                Log::info("Auto-sync: Rekalkulasi total pembelian sukses", [
                    'customer_id' => $customer->id,
                    'customer_name' => $customer->name
                ]);
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
            // Jika harga_final sudah tersedia, gunakan itu (lebih akurat)
            if ($item->harga_final > 0) {
                $totalPembelianTahunan += floatval($item->harga_final);
                continue;
            }
            
            // Jika tidak ada harga_final, kita perlu menghitung berdasarkan volume dan harga
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
            
            // Dapatkan tanggal yang tepat untuk pricing
            $recordDate = null;
            if (!empty($dataInput['waktu'])) {
                $recordDate = Carbon::parse($dataInput['waktu']);
            } elseif (!empty($dataInput['tanggal'])) {
                $recordDate = Carbon::parse($dataInput['tanggal']);
            } elseif (!empty($dataInput['pembacaan_awal']['waktu'])) {
                $recordDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
            } elseif ($item->created_at) {
                $recordDate = $item->created_at;
            } else {
                $recordDate = Carbon::now();
            }
            
            $pricingInfo = $customer->getPricingForYearMonth($waktuYearMonth, $recordDate);

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
            'nopol' => 'required|string|max:20',
            'alamat_pengambilan' => 'nullable|string|max:500'
        ]);

        $customer = User::findOrFail($validatedData['customer_id']);

        // Verifikasi bahwa customer adalah FOB
        if (!$customer->isFOB()) {
            return redirect()->back()->with('error', 'User yang dipilih bukan FOB')->withInput();
        }

        // Validasi data input FOB
        $this->validateFobInput($validatedData['data_input']);
        
        // Ambil waktu untuk mendapatkan pricing yang tepat
        $waktuDateTime = Carbon::parse($validatedData['data_input']['waktu']);
        $waktuYearMonth = $waktuDateTime->format('Y-m');
        
        // Ambil pricing info berdasarkan tanggal spesifik
        $pricingInfo = $customer->getPricingForYearMonth($waktuYearMonth, $waktuDateTime);

        // Hitung harga dengan pricing yang sesuai periode
        $volumeSm3 = floatval($validatedData['data_input']['volume_sm3']);
        $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
        $hargaFinal = $volumeSm3 * $hargaPerM3;
        
        // Simpan alamat pengambilan di data_input juga
        $validatedData['data_input']['alamat_pengambilan'] = $validatedData['alamat_pengambilan'] ?? null;
        
        // Log detail pricing untuk debugging
        Log::info('Creating new FOB data with pricing', [
            'customer_id' => $customer->id,
            'waktu' => $waktuDateTime->format('Y-m-d H:i:s'),
            'volume_sm3' => $volumeSm3,
            'harga_per_m3' => $hargaPerM3,
            'harga_final' => $hargaFinal,
            'pricing_info' => $pricingInfo,
            'alamat_pengambilan' => $validatedData['alamat_pengambilan'] ?? null
        ]);

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
        $rekapPengambilan->alamat_pengambilan = $validatedData['alamat_pengambilan'] ?? null;
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

        // Jalankan sinkronisasi data secara otomatis dengan force untuk memastikan konsistensi
        // Ini akan mengimpor SEMUA data dari rekap_pengambilan ke data_pencatatan yang belum tercatat
        $newDataCount = $this->forceSyncRekapPengambilanData($customer);
        $syncMessage = '';
        if ($newDataCount > 0) {
            $syncMessage = $newDataCount . ' data baru berhasil diimpor dari rekap pengambilan.';
            Log::info("Berhasil menyinkronkan $newDataCount data FOB untuk customer ID {$customer->id}");
            
            // Jika ada data baru yang diimpor, kita perlu merekalkulasi total pembelian juga
            $userController = new UserController();
            $userController->rekalkulasiTotalPembelianFob($customer);
            Log::info("Rekalkulasi pembelian FOB setelah impor data baru untuk customer ID {$customer->id}");
        }
        
        // PERBAIKAN: Jalankan validasi dan koreksi otomatis setiap kali halaman dimuat
        $this->performAutomaticDataValidation($customer);
        
        // Jalankan sinkronisasi saldo SELALU setiap kali halaman dimuat untuk memastikan konsistensi data
        // Bahkan jika user bukan admin, ini akan membantu menyesuaikan data
        $userController = new UserController();
        try {
            // Rekalkulasi total pembelian dahulu
            $userController->rekalkulasiTotalPembelianFob($customer);
            // Sinkronisasi saldo untuk memastikan data akurat
            $userController->syncBalanceSilent($customer);
            Log::info("Auto-sync saldo untuk customer ID {$customer->id} berhasil dilakukan");
            
            // Refresh data customer setelah sinkronisasi
            $customer = User::findOrFail($customer->id);
        } catch (\Exception $e) {
            Log::error("Error saat auto-sync saldo: {$e->getMessage()}");
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
        
        // Perbarui monthly_balances setiap kali filter berubah untuk memastikan data akurat
        // Hal ini memastikan bahwa saat pengguna berpindah antar bulan, data selalu konsisten
        $customer->updateMonthlyBalances();

        // Format filter untuk query - tanggal awal dan akhir bulan untuk filtering yang lebih tepat
        $yearMonth = $tahun . '-' . str_pad($bulan, 2, '0', STR_PAD_LEFT);
        $startDate = Carbon::createFromDate($tahun, $bulan, 1)->startOfDay();
        $endDate = Carbon::createFromDate($tahun, $bulan, 1)->endOfMonth()->endOfDay();
        
        // Log detail filter period untuk debugging
        Log::info('FOB detail filter period', [
            'customer_id' => $customer->id,
            'year_month' => $yearMonth,
            'start_date' => $startDate->format('Y-m-d H:i:s'),
            'end_date' => $endDate->format('Y-m-d H:i:s'),
            'selected_bulan' => $bulan,
            'selected_tahun' => $tahun
        ]);

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

        // Metode filter yang diperbaiki - fokus pada range tanggal yang tepat
        $dataPencatatan = $dataPencatatan->filter(function ($item) use ($startDate, $endDate) {
            $dataInput = $this->ensureArray($item->data_input);
            
            // Log untuk debugging
            Log::info('FOB data filtering details', [
                'id' => $item->id,
                'data_input' => $dataInput
            ]);

            // Jika data input kosong, skip
            if (empty($dataInput)) {
                return false;
            }

            // Ambil tanggal data dari berbagai format
            $dataDate = null;

            // 1. Cek format standard 'waktu' (string datetime) - format FOB
            if (!empty($dataInput['waktu']) && is_string($dataInput['waktu'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['waktu']);
                } catch (\Exception $e) {
                    Log::warning('Error parsing waktu', [
                        'id' => $item->id,
                        'waktu' => $dataInput['waktu'],
                        'error' => $e->getMessage()
                    ]);
                }
            }

            // 2. Cek format tanggal (string date only)
            if (!$dataDate && !empty($dataInput['tanggal']) && is_string($dataInput['tanggal'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['tanggal']);
                } catch (\Exception $e) {
                    Log::warning('Error parsing tanggal', [
                        'id' => $item->id,
                        'tanggal' => $dataInput['tanggal'],
                        'error' => $e->getMessage()
                    ]);
                }
            }

            // 3. Cek format pembacaan_awal.waktu (nested object)
            if (!$dataDate && !empty($dataInput['pembacaan_awal']['waktu']) && is_string($dataInput['pembacaan_awal']['waktu'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                } catch (\Exception $e) {
                    Log::warning('Error parsing pembacaan_awal.waktu', [
                        'id' => $item->id,
                        'waktu' => $dataInput['pembacaan_awal']['waktu'],
                        'error' => $e->getMessage()
                    ]);
                }
            }

            // 4. Gunakan created_at sebagai fallback terakhir
            if (!$dataDate && $item->created_at) {
                $dataDate = $item->created_at;
            }

            // Jika tidak ada tanggal yang valid ditemukan, skip
            if (!$dataDate) {
                Log::warning('No valid date found in data', ['id' => $item->id]);
                return false;
            }

            // Cek apakah data berada dalam range tanggal yang difilter
            $isInRange = $dataDate->between($startDate, $endDate);
            
            // Log hasil filter untuk debugging
            Log::info('FOB data date check', [
                'id' => $item->id,
                'data_date' => $dataDate->format('Y-m-d H:i:s'),
                'start_date' => $startDate->format('Y-m-d H:i:s'),
                'end_date' => $endDate->format('Y-m-d H:i:s'),
                'is_in_range' => $isInRange
            ]);

            return $isInRange;
        });
        
        // Log jumlah data setelah filtering
        Log::info('Data count after filtering', [
            'customer_id' => $customer->id,
            'count' => $dataPencatatan->count(),
            'period' => $yearMonth
        ]);
        
        // Penting: Tambahkan peringatan jika periode yang dipilih adalah bulan & tahun saat ini
        // Ini untuk memastikan filter periode bekerja dengan benar
        $isCurrentPeriod = ($bulan == date('m') && $tahun == date('Y'));  
        if ($isCurrentPeriod) {
            Log::info('Current period selected - strict filtering applied', [
                'current_year_month' => date('Y-m'),
                'filter_year_month' => $yearMonth,
                'date_range_check' => true,
                'customer_id' => $customer->id
            ]);
            
            // Double-check: Pastikan semua data memang berada dalam range waktu yang benar
            foreach ($dataPencatatan as $index => $item) {
                $dataInput = $this->ensureArray($item->data_input);
                $dataDate = null;
                
                // Ekstrak tanggal dari data
                if (!empty($dataInput['waktu'])) {
                    $dataDate = Carbon::parse($dataInput['waktu']);
                } elseif (!empty($dataInput['tanggal'])) {
                    $dataDate = Carbon::parse($dataInput['tanggal']);
                } elseif (!empty($dataInput['pembacaan_awal']['waktu'])) {
                    $dataDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                }
                
                if ($dataDate) {
                    $inCurrentMonth = ($dataDate->month == $bulan && $dataDate->year == $tahun);
                    
                    // Jika bukan dari bulan & tahun ini, hapus dari koleksi
                    if (!$inCurrentMonth) {
                        Log::warning('Removing data outside current period', [
                            'id' => $item->id,
                            'date' => $dataDate->format('Y-m-d'),
                            'expected_period' => $yearMonth
                        ]);
                        unset($dataPencatatan[$index]);
                    }
                }
            }
        }

        // Get pricing info for selected month
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);

        // Calculate total volume SM3 for all time
        $totalVolumeSm3 = $dataPencatatan->sum(function ($item) {
            $dataInput = $this->ensureArray($item->data_input);
            return floatval($dataInput['volume_sm3'] ?? 0);
        });

        // Calculate total volume SM3 for filtered period and total purchases dengan metode yang lebih akurat
        $filteredVolumeSm3 = 0;
        $filteredTotalPurchases = 0;
        
        foreach ($dataPencatatan as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);
            $filteredVolumeSm3 += $volumeSm3;
            
            // PERBAIKAN: Gunakan harga_final jika tersedia untuk akurasi terbaik
            if ($item->harga_final > 0) {
                $filteredTotalPurchases += floatval($item->harga_final);
                
                // Log perhitungan untuk debugging dengan flag harga_final
                Log::info('Using harga_final for purchase', [
                    'id' => $item->id,
                    'volume_sm3' => $volumeSm3,
                    'harga_final' => $item->harga_final,
                    'running_volume' => $filteredVolumeSm3,
                    'running_purchases' => $filteredTotalPurchases
                ]);
            } else {
                // Jika harga_final tidak tersedia, hitung manual dengan metode yang konsisten
                // Ambil tanggal waktu pencatatan dari berbagai format dengan prioritas yang jelas
                $recordDate = null;
                
                if (!empty($dataInput['waktu'])) {
                    $recordDate = Carbon::parse($dataInput['waktu']);
                } elseif (!empty($dataInput['tanggal'])) {
                    $recordDate = Carbon::parse($dataInput['tanggal']);
                } elseif (!empty($dataInput['pembacaan_awal']['waktu'])) {
                    $recordDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                } elseif ($item->created_at) {
                    $recordDate = $item->created_at;
                } else {
                    $recordDate = Carbon::now(); // Fallback ke tanggal saat ini
                }
                
                // Ambil pricing info berdasarkan tanggal spesifik
                $recordYearMonth = $recordDate->format('Y-m');
                $pricingInfo = $customer->getPricingForYearMonth($recordYearMonth, $recordDate);
                
                // Gunakan harga yang tepat sesuai periode
                $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                $pembelian = $volumeSm3 * $hargaPerM3;
                
                // Update harga_final untuk konsistensi di kemudian hari
                $item->harga_final = $pembelian;
                $item->save();
                
                $filteredTotalPurchases += $pembelian;
                
                // Log perhitungan untuk debugging
                Log::info('Calculating purchase manually', [
                    'id' => $item->id,
                    'record_date' => $recordDate->format('Y-m-d H:i:s'),
                    'volume_sm3' => $volumeSm3,
                    'harga_per_m3' => $hargaPerM3,
                    'pembelian' => $pembelian,
                    'running_purchases' => $filteredTotalPurchases
                ]);
            }
        }
        
        // Log ringkasan final perhitungan untuk debugging
        Log::info('Final filter calculation results', [
            'customer_id' => $customer->id,
            'period' => $yearMonth,
            'total_records' => count($dataPencatatan),
            'total_volume' => $filteredVolumeSm3,
            'total_purchases' => $filteredTotalPurchases
        ]);

        // Pastikan monthly balances telah diupdate dengan data terbaru
        $customer->updateMonthlyBalances();

        // Metode yang lebih konsisten untuk menghitung prevMonthBalance dengan perhitungan real-time
        // 1. Cari bulan sebelumnya - handling untuk Januari dengan pergantian tahun
        $carbonDate = Carbon::createFromDate($tahun, $bulan, 1);
        $prevCarbonDate = $carbonDate->copy()->subMonth();
        $prevMonthFormat = $prevCarbonDate->format('Y-m');
        $prevYear = $prevCarbonDate->year;
        $prevMonth = $prevCarbonDate->month;

        // 2. Hitung saldo bulan sebelumnya dengan algoritma yang sama persis dengan 
        // yang digunakan untuk menampilkan halaman bulan sebelumnya

        // 2.1. Ambil semua deposit sebelum bulan ini
        $totalDepositsUntilPrevMonth = 0;
        $depositHistory = $this->ensureArray($customer->deposit_history);
        foreach ($depositHistory as $deposit) {
            if (isset($deposit['date'])) {
                $depositDate = Carbon::parse($deposit['date']);
                if ($depositDate < $carbonDate) { // Semua deposit sebelum bulan ini
                    $totalDepositsUntilPrevMonth += floatval($deposit['amount'] ?? 0);
                }
            }
        }

        // 2.2. Ambil semua pembelian sebelum bulan ini
        $totalPurchasesUntilPrevMonth = 0;
        $allData = $customer->dataPencatatan()->get();
        foreach ($allData as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $recordDate = null;
            
            // Coba mendapatkan tanggal dari berbagai format
            if (!empty($dataInput['waktu'])) {
                $recordDate = Carbon::parse($dataInput['waktu']);
            } elseif (!empty($dataInput['pembacaan_awal']['waktu'])) {
                $recordDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
            } elseif ($item->created_at) {
                $recordDate = $item->created_at;
            } else {
                continue; // Skip item tanpa tanggal
            }
            
            // Hanya pembelian sebelum bulan ini
            if ($recordDate < $carbonDate) {
                $hargaFinal = floatval($item->harga_final);
                $totalPurchasesUntilPrevMonth += $hargaFinal;
            }
        }

        // 2.3. Hitung saldo akhir bulan sebelumnya
        $prevMonthBalance = $totalDepositsUntilPrevMonth - $totalPurchasesUntilPrevMonth;
        
        // 3. Log informasi saldo bulan lalu untuk debugging
        Log::info('Informasi saldo bulan lalu dengan perhitungan real-time', [
            'bulan_dipilih' => $bulan . '-' . $tahun,
            'bulan_sebelumnya' => $prevMonthFormat,
            'total_deposits_until_prev_month' => $totalDepositsUntilPrevMonth,
            'total_purchases_until_prev_month' => $totalPurchasesUntilPrevMonth,
            'saldo_bulan_sebelumnya_realtime' => $prevMonthBalance,
            'saldo_bulan_sebelumnya_db' => isset($monthlyBalances[$prevMonthFormat]) ? 
                floatval($monthlyBalances[$prevMonthFormat]) : 'tidak ada'
        ]);
            
        // Calculate total deposits for the filtered period
        $filteredTotalDeposits = 0;
        // Ambil deposit history dari customer
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
        
        // Pastikan monthly balances diperbarui secara berkala
        // Ini penting untuk memastikan saldo bulan-bulan sebelumnya tersedia
        $customer->updateMonthlyBalances();
        
        // Store the selected month and year for view
        $selectedBulan = $bulan;
        $selectedTahun = $tahun;

        // Tampilkan pesan sinkronisasi jika ada
        if (!empty($syncMessage)) {
            session()->flash('success', $syncMessage);
        }

        return view('data-pencatatan.fob.fob-detail', [
            'customer' => $customer,
            'dataPencatatan' => $dataPencatatan,
            'depositHistory' => $this->ensureArray($customer->deposit_history),
            'totalDeposit' => $customer->total_deposit,
            'totalPurchases' => $customer->total_purchases,
            'currentBalance' => $customer->getCurrentBalance(),
            'selectedBulan' => $selectedBulan,
            'selectedTahun' => $selectedTahun,
            'pricingInfo' => $pricingInfo,
            'totalVolumeSm3' => $totalVolumeSm3,
            'filteredVolumeSm3' => $filteredVolumeSm3,
            'filteredTotalPurchases' => $filteredTotalPurchases,
            'filteredTotalDeposits' => $filteredTotalDeposits,
            'prevMonthBalance' => $prevMonthBalance,
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

        // Gunakan with() untuk menyimpan data dalam session flash
        // ini akan memastikan variabel $depositHistory tersedia di view
        return redirect()->route('data-pencatatan.fob-detail', [
            'customer' => $customer->id,
            'bulan' => $validatedData['bulan'],
            'tahun' => $validatedData['tahun']
        ]);
    }
    
    /**
     * Fungsi untuk force-reset monthly balances dan menghitung ulang seluruh saldo
     * Digunakan untuk memperbaiki data yang tidak konsisten
     */
    public function resetAndRecalculateBalance(User $customer)
    {
        try {
            DB::beginTransaction();
            
            // Verifikasi bahwa user memiliki izin (admin atau superadmin)
            if (!Auth::user()->isAdmin() && !Auth::user()->isSuperAdmin()) {
                return redirect()->back()->with('error', 'Anda tidak memiliki izin untuk melakukan operasi ini');
            }
            
            // Log operasi reset
            Log::info('Memulai reset dan rekalkulasi saldo untuk customer', [
                'customer_id' => $customer->id,
                'customer_name' => $customer->name,
            ]);
            
            // 1. Reset total_purchases dan hitung ulang dari semua data pencatatan
            $userController = new UserController();
            if ($customer->isFOB()) {
                $newTotalPurchases = $userController->rekalkulasiTotalPembelianFob($customer);
            } else {
                $newTotalPurchases = $userController->rekalkulasiTotalPembelian($customer);
            }
            
            // 2. Reset total_deposit dan hitung ulang dari deposit_history
            $depositHistory = $this->ensureArray($customer->deposit_history);
            $newTotalDeposit = 0;
            
            foreach ($depositHistory as $deposit) {
                $newTotalDeposit += floatval($deposit['amount'] ?? 0);
            }
            
            // Update total_deposit jika berbeda
            if (abs($newTotalDeposit - $customer->total_deposit) > 0.01) {
                Log::info('Memperbarui total_deposit', [
                    'customer_id' => $customer->id,
                    'old_total_deposit' => $customer->total_deposit,
                    'new_total_deposit' => $newTotalDeposit,
                    'difference' => $newTotalDeposit - $customer->total_deposit
                ]);
                
                $customer->total_deposit = $newTotalDeposit;
                $customer->save();
            }
            
            // 3. Hapus monthly_balances dan hitung ulang dari awal secara menyeluruh
            // Reset monthly_balances ke array kosong
            $customer->monthly_balances = [];
            $customer->save();
            
            // Jalankan updateMonthlyBalances dengan waktu awal 4 tahun ke belakang untuk memastikan semua data tercakup
            $fourYearsAgo = Carbon::now()->subYears(4)->startOfMonth()->format('Y-m');
            Log::info('Menghitung ulang monthly_balances dari 4 tahun lalu', [
                'start_month' => $fourYearsAgo
            ]);
            
            $customer->updateMonthlyBalances($fourYearsAgo);
            
            // 4. Log hasil rekalkulasi
            $monthlyBalances = $this->ensureArray($customer->monthly_balances);
            Log::info('Reset dan rekalkulasi saldo selesai', [
                'customer_id' => $customer->id,
                'monthly_balances_count' => count($monthlyBalances),
                'new_total_deposit' => $customer->total_deposit,
                'new_total_purchases' => $customer->total_purchases,
                'new_balance' => $customer->getCurrentBalance()
            ]);
            
            DB::commit();
            
            return redirect()->route('data-pencatatan.fob-detail', ['customer' => $customer->id])
                ->with('success', 'Reset dan rekalkulasi saldo berhasil dilakukan.');
            
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error saat reset dan rekalkulasi saldo: ' . $e->getMessage(), [
                'customer_id' => $customer->id,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return redirect()->back()
                ->with('error', 'Terjadi kesalahan saat melakukan reset dan rekalkulasi saldo: ' . $e->getMessage());
        }
    }

    /**
     * Fungsi untuk melakukan validasi dan koreksi data otomatis
     * Dipanggil setiap kali halaman detail FOB diakses
     *
     * @param User $customer
     * @return void
     */
    private function performAutomaticDataValidation(User $customer)
    {
        try {
            // 1. Validasi dan perbaiki harga_final yang kosong
            $recordsWithoutHargaFinal = $customer->dataPencatatan()
                ->where(function($query) {
                    $query->whereNull('harga_final')
                          ->orWhere('harga_final', '<=', 0);
                })
                ->get();

            $fixedRecords = 0;
            foreach ($recordsWithoutHargaFinal as $record) {
                $dataInput = $this->ensureArray($record->data_input);
                $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);

                if ($volumeSm3 > 0) {
                    // Ambil tanggal untuk pricing
                    $recordDate = null;
                    if (!empty($dataInput['waktu'])) {
                        $recordDate = Carbon::parse($dataInput['waktu']);
                    } elseif ($record->created_at) {
                        $recordDate = $record->created_at;
                    } else {
                        continue;
                    }

                    $yearMonth = $recordDate->format('Y-m');
                    $pricingInfo = $customer->getPricingForYearMonth($yearMonth, $recordDate);
                    $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                    $calculatedPrice = $volumeSm3 * $hargaPerM3;

                    // Update harga_final
                    $record->harga_final = round($calculatedPrice, 2);
                    $record->save();
                    $fixedRecords++;
                }
            }

            if ($fixedRecords > 0) {
                Log::info("Auto-fixed records without harga_final", [
                    'customer_id' => $customer->id,
                    'fixed_count' => $fixedRecords
                ]);
            }

            // 2. Validasi konsistensi total deposit
            $depositHistory = $this->ensureArray($customer->deposit_history);
            $calculatedTotalDeposit = 0;
            
            foreach ($depositHistory as $deposit) {
                if (isset($deposit['amount'])) {
                    $calculatedTotalDeposit += floatval($deposit['amount']);
                }
            }
            
            // Perbaiki jika ada perbedaan
            if (abs($calculatedTotalDeposit - $customer->total_deposit) > 0.01) {
                Log::info("Auto-correcting total deposit", [
                    'customer_id' => $customer->id,
                    'old_total' => $customer->total_deposit,
                    'new_total' => $calculatedTotalDeposit
                ]);
                
                $customer->total_deposit = $calculatedTotalDeposit;
                $customer->save();
            }

            // 3. Validasi dan update monthly_balances jika diperlukan
            $currentYearMonth = Carbon::now()->format('Y-m');
            $expectedBalance = $customer->total_deposit - $customer->total_purchases;
            $monthlyBalances = $this->ensureArray($customer->monthly_balances);
            $currentMonthBalance = $monthlyBalances[$currentYearMonth] ?? null;

            // Jika saldo bulan ini tidak ada atau berbeda signifikan
            if ($currentMonthBalance === null || abs($expectedBalance - $currentMonthBalance) > 1) {
                Log::info("Auto-updating monthly balances due to inconsistency", [
                    'customer_id' => $customer->id,
                    'expected_balance' => $expectedBalance,
                    'current_month_balance' => $currentMonthBalance
                ]);
                
                // Update monthly balances
                $customer->updateMonthlyBalances();
            }

        } catch (\Exception $e) {
            Log::error("Error in automatic data validation", [
                'customer_id' => $customer->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
        }
    }
}
