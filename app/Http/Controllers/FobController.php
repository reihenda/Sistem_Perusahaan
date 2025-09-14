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
     * Fungsi untuk force-sinkronisasi data rekap pengambilan (DIPERBAIKI)
     * Mencegah duplikasi data dengan validasi yang lebih ketat
     */
    private function forceSyncRekapPengambilanData(User $customer, $rekapData = null)
    {
        // Pastikan ini adalah user FOB
        if (!$customer->isFOB()) {
            return 0;
        }

        // PERBAIKAN: Gunakan DB transaction untuk memastikan konsistensi
        DB::beginTransaction();
        
        try {
            // Ambil rekap pengambilan untuk FOB ini jika tidak disediakan
            if (!$rekapData) {
                $rekapData = RekapPengambilan::where('customer_id', $customer->id)->get();
            }

            // PERBAIKAN: Ambil data pencatatan yang sudah ada dengan indexing yang lebih baik
            $existingRecords = DB::table('data_pencatatan')
                ->where('customer_id', $customer->id)
                ->get()
                ->keyBy(function($item) {
                    $dataInput = json_decode($item->data_input, true) ?? [];
                    if (!empty($dataInput['waktu'])) {
                        try {
                            return Carbon::parse($dataInput['waktu'])->format('Y-m-d');
                        } catch (\Exception $e) {
                            return null;
                        }
                    }
                    return null;
                })
                ->filter(); // Remove null keys

            $importedCount = 0;
            $skippedCount = 0;
            $duplicateCount = 0;

            // Log untuk debugging
            Log::info('Memulai force sync untuk FOB dengan validasi duplikasi', [
                'customer_id' => $customer->id,
                'rekap_count' => $rekapData->count(),
                'existing_records_count' => $existingRecords->count(),
                'existing_dates' => $existingRecords->keys()->toArray()
            ]);

            foreach ($rekapData as $rekap) {
                $tanggalKey = Carbon::parse($rekap->tanggal)->format('Y-m-d');
                
                // PERBAIKAN: Skip jika sudah ada data untuk tanggal ini
                if ($existingRecords->has($tanggalKey)) {
                    $skippedCount++;
                    Log::info("Tanggal $tanggalKey sudah ada, dilewati", [
                        'rekap_id' => $rekap->id,
                        'existing_record_id' => $existingRecords[$tanggalKey]->id
                    ]);
                    continue;
                }

                // PERBAIKAN: Cek duplikasi berdasarkan kombinasi tanggal + volume + customer
                $existingWithSameData = DB::table('data_pencatatan')
                    ->where('customer_id', $customer->id)
                    ->where('data_input', 'LIKE', '%"waktu":"' . Carbon::parse($rekap->tanggal)->format('Y-m-d') . '%')
                    ->where('data_input', 'LIKE', '%"volume_sm3":' . $rekap->volume . '%')
                    ->exists();

                if ($existingWithSameData) {
                    $duplicateCount++;
                    Log::warning('Skipping potential duplicate record', [
                        'rekap_id' => $rekap->id,
                        'tanggal' => $tanggalKey,
                        'volume' => $rekap->volume
                    ]);
                    continue;
                }

                // Lanjutkan proses impor jika tidak ada duplikasi
                $volumeSm3 = floatval($rekap->volume);
                $rekap_date = Carbon::parse($rekap->tanggal);
                $rekap_yearMonth = $rekap_date->format('Y-m');
                $pricingInfo = $customer->getPricingForYearMonth($rekap_yearMonth, $rekap_date);
                
                $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                $hargaFinal = $volumeSm3 * $hargaPerM3;

                $dataInput = [
                    'waktu' => $rekap_date->format('Y-m-d H:i:s'),
                    'volume_sm3' => $volumeSm3,
                    'keterangan' => $rekap->keterangan,
                    'alamat_pengambilan' => $rekap->alamat_pengambilan
                ];

                // Buat data pencatatan baru
                $dataPencatatan = new DataPencatatan();
                $dataPencatatan->customer_id = $rekap->customer_id;
                $dataPencatatan->data_input = json_encode($dataInput);
                $dataPencatatan->nama_customer = $customer->name;
                $dataPencatatan->status_pembayaran = 'belum_lunas';
                $dataPencatatan->harga_final = $hargaFinal;
                $dataPencatatan->created_at = $rekap->created_at;
                $dataPencatatan->updated_at = $rekap->updated_at;
                $dataPencatatan->save();

                // Update existing records untuk mencegah duplikasi selanjutnya
                $existingRecords[$tanggalKey] = (object)['id' => $dataPencatatan->id];

                $importedCount++;
                Log::info("Berhasil mengimpor data rekap pengambilan ID {$rekap->id}", [
                    'data_pencatatan_id' => $dataPencatatan->id,
                    'tanggal' => $tanggalKey,
                    'harga_final' => $hargaFinal
                ]);
            }

            // Rekalkulasi total pembelian jika ada data yang diimpor
            if ($importedCount > 0) {
                $userController = new UserController();
                $userController->rekalkulasiTotalPembelianFob($customer);
                Log::info("Rekalkulasi total pembelian setelah import", [
                    'customer_id' => $customer->id,
                    'imported_count' => $importedCount
                ]);
            }

            DB::commit();
            
            Log::info("Force sync selesai", [
                'customer_id' => $customer->id,
                'imported' => $importedCount,
                'skipped' => $skippedCount,
                'duplicates_prevented' => $duplicateCount
            ]);
            
            return $importedCount;
            
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error in forceSyncRekapPengambilanData: ' . $e->getMessage(), [
                'customer_id' => $customer->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return 0;
        }
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
        
        // DEBUG: Log detail untuk troubleshooting
        Log::info('FOB calculateYearlyData - Detail', [
            'customer_id' => $customer->id,
            'customer_name' => $customer->name,
            'tahun' => $tahun,
            'total_records_all' => $allData->count(),
            'total_records_yearly_filtered' => $yearlyData->count(),
            'calculated_total_pemakaian_tahunan' => $totalPemakaianTahunan,
            'calculated_total_pembelian_tahunan' => $totalPembelianTahunan,
            'database_total_purchases_current' => $customer->total_purchases,
            'yearly_vs_total_purchases_diff' => $totalPembelianTahunan - $customer->total_purchases
        ]);

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
        }
        
        // PERBAIKAN: SELALU jalankan rekalkulasi total pembelian dengan logic baru
        // untuk memastikan semua harga_final menggunakan pricing terbaru
        $userController = new UserController();
        $oldTotal = $customer->total_purchases;
        $newTotal = $userController->rekalkulasiTotalPembelianFob($customer);
        
        Log::info("Rekalkulasi pembelian FOB dengan logic baru", [
            'customer_id' => $customer->id,
            'old_total' => $oldTotal,
            'new_total' => $newTotal,
            'difference' => $newTotal - $oldTotal,
            'sync_message' => $syncMessage
        ]);
        
        // Refresh customer data setelah rekalkulasi
        $customer = User::findOrFail($customer->id);
        
        // PERBAIKAN: Jalankan cleaning duplikat dan validasi konsistensi
        $duplicatesRemoved = $this->cleanDuplicateFobData($customer);
        if ($duplicatesRemoved > 0) {
            Log::info("Removed $duplicatesRemoved duplicate records for FOB {$customer->id}");
        }
        
        // PERBAIKAN: Validasi konsistensi total
        $inconsistency = $this->validateFobTotalConsistency($customer);
        if ($inconsistency > 0) {
            Log::info("Fixed total inconsistency of Rp " . number_format($inconsistency, 2) . " for FOB {$customer->id}");
        }
        
        // Jalankan validasi otomatis lainnya
        $this->performAutomaticDataValidation($customer);
        
        // Sinkronisasi saldo untuk memastikan monthly_balances akurat
        try {
            $userController->syncBalanceSilent($customer);
            $customer = User::findOrFail($customer->id);
        } catch (\Exception $e) {
            // Silent error handling
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

        // Definisi periode filter
        $yearMonth = $tahun . '-' . str_pad($bulan, 2, '0', STR_PAD_LEFT);
        $startDate = Carbon::createFromDate($tahun, $bulan, 1)->startOfDay();
        $endDate = Carbon::createFromDate($tahun, $bulan, 1)->endOfMonth()->endOfDay();

        // Ambil semua data pencatatan
        $allDataPencatatan = $customer->dataPencatatan()->get();
        $dataPencatatan = $allDataPencatatan;

        // Filter data berdasarkan periode tanpa logging berlebihan
        $dataPencatatanFiltered = $dataPencatatan->filter(function ($item) use ($startDate, $endDate) {
            $dataInput = $this->ensureArray($item->data_input);
            
            if (empty($dataInput)) {
                return false;
            }

            $dataDate = null;
            
            // Cek berbagai format tanggal
            if (!empty($dataInput['waktu'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['waktu']);
                } catch (\Exception $e) {
                    // Skip jika error parsing
                }
            }
            
            if (!$dataDate && !empty($dataInput['tanggal'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['tanggal']);
                } catch (\Exception $e) {
                    // Skip jika error parsing
                }
            }
            
            if (!$dataDate && !empty($dataInput['pembacaan_awal']['waktu'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                } catch (\Exception $e) {
                    // Skip jika error parsing
                }
            }
            
            if (!$dataDate && $item->created_at) {
                $dataDate = $item->created_at;
            }

            return $dataDate ? $dataDate->between($startDate, $endDate) : false;
        });


        // Get pricing info for selected month
        $pricingInfo = $customer->getPricingForYearMonth($yearMonth);

        // Calculate total volume SM3 for ALL TIME (tidak difilter)
        $totalVolumeSm3 = $allDataPencatatan->sum(function ($item) {
            $dataInput = $this->ensureArray($item->data_input);
            return floatval($dataInput['volume_sm3'] ?? 0);
        });

        // DEBUG: Log perhitungan total untuk troubleshooting
        Log::info('FOB Detail - Perhitungan Total', [
            'customer_id' => $customer->id,
            'customer_name' => $customer->name,
            'total_data_pencatatan' => $allDataPencatatan->count(),
            'filtered_data_pencatatan' => $dataPencatatanFiltered->count(),
            'calculated_total_volume_sm3' => $totalVolumeSm3,
            'database_total_purchases' => $customer->total_purchases,
            'database_total_deposit' => $customer->total_deposit,
            'yearly_data_requested' => $tahun,
            'selected_period' => $bulan . '/' . $tahun
        ]);

        // Calculate total volume dan purchases dengan SELALU menggunakan calculated (untuk periode yang difilter)
        $filteredVolumeSm3 = 0;
        $filteredTotalPurchases = 0;
        $processedIds = []; // Untuk mencegah duplikasi perhitungan
        
        foreach ($dataPencatatanFiltered as $item) {
            // Pastikan tidak ada duplikasi perhitungan
            if (in_array($item->id, $processedIds)) {
                continue;
            }
            $processedIds[] = $item->id;

            $dataInput = $this->ensureArray($item->data_input);
            $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);
            $filteredVolumeSm3 += $volumeSm3;
            
            // SELALU hitung berdasarkan calculated untuk konsistensi dengan view
            if ($volumeSm3 > 0) {
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
                
                $recordYearMonth = $recordDate->format('Y-m');
                $pricingInfo = $customer->getPricingForYearMonth($recordYearMonth, $recordDate);
                $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);
                $calculated = $volumeSm3 * $hargaPerM3;
                
                // Update harga_final di database untuk konsistensi (jika berbeda)
                if (abs($item->harga_final - $calculated) > 0.01) {
                    $item->harga_final = round($calculated, 2);
                    $item->save();
                }
                
                // Gunakan calculated value, bukan harga_final lama
                $filteredTotalPurchases += $calculated;
            }
        }
        


        // Pastikan monthly balances telah diupdate dengan data terbaru
        $customer->updateMonthlyBalances();

        // Hitung saldo bulan sebelumnya dengan perhitungan real-time
        $carbonDate = Carbon::createFromDate($tahun, $bulan, 1);
        $prevCarbonDate = $carbonDate->copy()->subMonth();
        $prevMonthFormat = $prevCarbonDate->format('Y-m');
        $prevYear = $prevCarbonDate->year;
        $prevMonth = $prevCarbonDate->month;

        // Hitung total deposits sampai bulan sebelumnya
        $totalDepositsUntilPrevMonth = 0;
        $depositHistory = $this->ensureArray($customer->deposit_history);
        foreach ($depositHistory as $deposit) {
            if (isset($deposit['date'])) {
                $depositDate = Carbon::parse($deposit['date']);
                if ($depositDate < $carbonDate) {
                    $totalDepositsUntilPrevMonth += floatval($deposit['amount'] ?? 0);
                }
            }
        }

        // Hitung total purchases sampai bulan sebelumnya
        $totalPurchasesUntilPrevMonth = 0;
        $allData = $customer->dataPencatatan()->get();
        foreach ($allData as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $recordDate = null;
            
            if (!empty($dataInput['waktu'])) {
                $recordDate = Carbon::parse($dataInput['waktu']);
            } elseif (!empty($dataInput['pembacaan_awal']['waktu'])) {
                $recordDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
            } elseif ($item->created_at) {
                $recordDate = $item->created_at;
            } else {
                continue;
            }
            
            if ($recordDate < $carbonDate) {
                $hargaFinal = floatval($item->harga_final);
                $totalPurchasesUntilPrevMonth += $hargaFinal;
            }
        }

        $prevMonthBalance = $totalDepositsUntilPrevMonth - $totalPurchasesUntilPrevMonth;
            
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
            'dataPencatatan' => $dataPencatatanFiltered,
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
     * Method untuk menganalisis data FOB untuk debugging
     */
    public function analyzeFobData(User $customer)
    {
        if (!$customer->isFOB()) {
            return response()->json(['error' => 'User bukan FOB'], 400);
        }

        // Ambil semua data pencatatan
        $allRecords = $customer->dataPencatatan()->get();
        $rekapRecords = RekapPengambilan::where('customer_id', $customer->id)->get();
        
        // Analisis duplikasi
        $duplicates = [];
        $uniqueRecords = [];
        
        foreach ($allRecords as $record) {
            $dataInput = $this->ensureArray($record->data_input);
            
            if (!empty($dataInput['waktu']) && isset($dataInput['volume_sm3'])) {
                $dateKey = Carbon::parse($dataInput['waktu'])->format('Y-m-d');
                $volumeKey = $dataInput['volume_sm3'];
                $uniqueKey = $dateKey . '_' . $volumeKey;

                if (isset($uniqueRecords[$uniqueKey])) {
                    $duplicates[] = [
                        'original_id' => $uniqueRecords[$uniqueKey]->id,
                        'duplicate_id' => $record->id,
                        'date' => $dateKey,
                        'volume' => $volumeKey,
                        'original_harga' => $uniqueRecords[$uniqueKey]->harga_final,
                        'duplicate_harga' => $record->harga_final
                    ];
                } else {
                    $uniqueRecords[$uniqueKey] = $record;
                }
            }
        }
        
        // Analisis konsistensi total
        $manualTotal = $allRecords->sum('harga_final');
        $storedTotal = $customer->total_purchases;
        $difference = abs($manualTotal - $storedTotal);
        
        // Analisis data yang tidak ter-sync
        $rekapDates = $rekapRecords->pluck('tanggal')->map(function($date) {
            return Carbon::parse($date)->format('Y-m-d');
        })->toArray();
        
        $pencatatanDates = $allRecords->map(function($record) {
            $dataInput = $this->ensureArray($record->data_input);
            if (!empty($dataInput['waktu'])) {
                return Carbon::parse($dataInput['waktu'])->format('Y-m-d');
            }
            return null;
        })->filter()->toArray();
        
        $missingFromPencatatan = array_diff($rekapDates, $pencatatanDates);
        $extraInPencatatan = array_diff($pencatatanDates, $rekapDates);
        
        // Analisis data tanpa harga_final
        $recordsWithoutHarga = $allRecords->filter(function($record) {
            return $record->harga_final <= 0;
        });
        
        $analysis = [
            'summary' => [
                'total_pencatatan_records' => $allRecords->count(),
                'total_rekap_records' => $rekapRecords->count(),
                'duplicates_found' => count($duplicates),
                'records_without_harga' => $recordsWithoutHarga->count(),
                'missing_from_pencatatan' => count($missingFromPencatatan),
                'extra_in_pencatatan' => count($extraInPencatatan)
            ],
            'totals' => [
                'manual_total' => $manualTotal,
                'stored_total' => $storedTotal,
                'difference' => $difference,
                'is_consistent' => $difference < 0.01
            ],
            'duplicates' => $duplicates,
            'missing_dates' => $missingFromPencatatan,
            'extra_dates' => $extraInPencatatan,
            'records_without_harga' => $recordsWithoutHarga->map(function($record) {
                $dataInput = $this->ensureArray($record->data_input);
                return [
                    'id' => $record->id,
                    'date' => $dataInput['waktu'] ?? 'unknown',
                    'volume' => $dataInput['volume_sm3'] ?? 0,
                    'harga_final' => $record->harga_final
                ];
            })->toArray()
        ];
        
        if (request()->expectsJson()) {
            return response()->json($analysis);
        }
        
        return view('debug.fob-analysis', compact('customer', 'analysis'));
    }

    /**
     * Method untuk membersihkan data duplikat FOB (dengan response)  
     */
    public function cleanDuplicateFobData(User $customer)
    {
        if (!$customer->isFOB()) {
            return false;
        }

        DB::beginTransaction();
        
        try {
            // Ambil semua data pencatatan FOB
            $allRecords = $customer->dataPencatatan()->get();
            $duplicateIds = [];
            $uniqueRecords = [];

            foreach ($allRecords as $record) {
                $dataInput = $this->ensureArray($record->data_input);
                
                if (!empty($dataInput['waktu']) && isset($dataInput['volume_sm3'])) {
                    $dateKey = Carbon::parse($dataInput['waktu'])->format('Y-m-d');
                    $volumeKey = $dataInput['volume_sm3'];
                    $uniqueKey = $dateKey . '_' . $volumeKey;

                    if (isset($uniqueRecords[$uniqueKey])) {
                        // Ini adalah duplikat, tandai untuk dihapus
                        $duplicateIds[] = $record->id;
                        Log::info('Found duplicate FOB record', [
                            'original_id' => $uniqueRecords[$uniqueKey]->id,
                            'duplicate_id' => $record->id,
                            'date' => $dateKey,
                            'volume' => $volumeKey
                        ]);
                    } else {
                        $uniqueRecords[$uniqueKey] = $record;
                    }
                }
            }

            // Hapus data duplikat
            if (!empty($duplicateIds)) {
                DataPencatatan::whereIn('id', $duplicateIds)->delete();
                Log::info('Cleaned duplicate FOB records', [
                    'customer_id' => $customer->id,
                    'deleted_count' => count($duplicateIds),
                    'deleted_ids' => $duplicateIds
                ]);
            }

            DB::commit();
            return count($duplicateIds);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error cleaning duplicate data: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Method untuk memvalidasi konsistensi total pembelian FOB
     */
    public function validateFobTotalConsistency(User $customer)
    {
        if (!$customer->isFOB()) {
            return false;
        }

        // Hitung manual total dari semua harga_final
        $manualTotal = $customer->dataPencatatan()->sum('harga_final');
        
        // Bandingkan dengan total_purchases di customer
        $storedTotal = $customer->total_purchases;
        $difference = abs($manualTotal - $storedTotal);

        Log::info('FOB total consistency check', [
            'customer_id' => $customer->id,
            'manual_total' => $manualTotal,
            'stored_total' => $storedTotal,
            'difference' => $difference,
            'is_consistent' => $difference < 0.01
        ]);

        // Jika perbedaan signifikan, update total_purchases
        if ($difference > 0.01) {
            $customer->total_purchases = $manualTotal;
            $customer->save();
            
            Log::warning('Fixed inconsistent FOB total', [
                'customer_id' => $customer->id,
                'old_total' => $storedTotal,
                'new_total' => $manualTotal
            ]);
            
            return $difference;
        }

        return 0;
    }

    /**
     * Debug dan perbaiki perhitungan FOB
     */
    public function debugAndFixCalculations(User $customer)
    {
        if (!$customer->isFOB()) {
            return response()->json(['error' => 'User bukan FOB'], 400);
        }

        try {
            DB::beginTransaction();
            
            // 1. Ambil semua data
            $allData = $customer->dataPencatatan()->get();
            
            // 2. Hitung manual total volume dan total pembelian
            $manualTotalVolume = 0;
            $manualTotalPurchases = 0;
            $recordCount = 0;
            
            foreach ($allData as $item) {
                $dataInput = $this->ensureArray($item->data_input);
                $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);
                
                if ($volumeSm3 > 0) {
                    $manualTotalVolume += $volumeSm3;
                    
                    // Hitung pembelian berdasarkan harga_final yang tersimpan
                    $manualTotalPurchases += floatval($item->harga_final ?? 0);
                    $recordCount++;
                }
            }
            
            // 3. Bandingkan dengan database
            $dbTotalPurchases = $customer->total_purchases;
            $dbTotalDeposit = $customer->total_deposit;
            $currentBalance = $dbTotalDeposit - $dbTotalPurchases;
            
            // 4. Perbaiki jika ada perbedaan
            $fixed = false;
            if (abs($manualTotalPurchases - $dbTotalPurchases) > 0.01) {
                $customer->total_purchases = $manualTotalPurchases;
                $customer->save();
                $fixed = true;
            }
            
            // 5. Update monthly balances
            $customer->updateMonthlyBalances();
            
            DB::commit();
            
            $result = [
                'customer_info' => [
                    'id' => $customer->id,
                    'name' => $customer->name,
                    'role' => $customer->role
                ],
                'calculations' => [
                    'total_records' => $recordCount,
                    'manual_total_volume' => $manualTotalVolume,
                    'manual_total_purchases' => $manualTotalPurchases,
                    'db_total_purchases_before' => $dbTotalPurchases,
                    'db_total_purchases_after' => $customer->fresh()->total_purchases,
                    'db_total_deposit' => $dbTotalDeposit,
                    'current_balance' => $currentBalance,
                    'fixed' => $fixed,
                    'difference_before_fix' => $manualTotalPurchases - $dbTotalPurchases
                ],
                'status' => 'success'
            ];
            
            if (request()->expectsJson()) {
                return response()->json($result);
            }
            
            return redirect()->route('data-pencatatan.fob-detail', $customer->id)
                ->with('success', 'Debug dan perbaikan selesai. ' . ($fixed ? 'Data telah diperbaiki.' : 'Tidak ada yang perlu diperbaiki.'));
                
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error in debugAndFixCalculations: ' . $e->getMessage());
            
            if (request()->expectsJson()) {
                return response()->json(['error' => $e->getMessage()], 500);
            }
            
            return redirect()->back()->with('error', 'Error: ' . $e->getMessage());
        }
    }
    /**
     * Halaman print terpisah untuk FOB
     */
    public function printPage(User $customer, Request $request)
    {
        // Verifikasi bahwa customer adalah FOB
        if (!$customer->isFOB()) {
            abort(404, 'Customer tidak ditemukan');
        }

        // Get filter parameters
        $bulan = $request->input('bulan', date('m'));
        $tahun = $request->input('tahun', date('Y'));

        // Definisi periode filter
        $yearMonth = $tahun . '-' . str_pad($bulan, 2, '0', STR_PAD_LEFT);
        $startDate = Carbon::createFromDate($tahun, $bulan, 1)->startOfDay();
        $endDate = Carbon::createFromDate($tahun, $bulan, 1)->endOfMonth()->endOfDay();

        // Ambil semua data pencatatan
        $allDataPencatatan = $customer->dataPencatatan()->get();

        // Filter data berdasarkan periode
        $dataPencatatan = $allDataPencatatan->filter(function ($item) use ($startDate, $endDate) {
            $dataInput = $this->ensureArray($item->data_input);
            
            if (empty($dataInput)) {
                return false;
            }

            $dataDate = null;
            
            // Cek berbagai format tanggal
            if (!empty($dataInput['waktu'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['waktu']);
                } catch (\Exception $e) {
                    // Skip jika error parsing
                }
            }
            
            if (!$dataDate && !empty($dataInput['tanggal'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['tanggal']);
                } catch (\Exception $e) {
                    // Skip jika error parsing
                }
            }
            
            if (!$dataDate && !empty($dataInput['pembacaan_awal']['waktu'])) {
                try {
                    $dataDate = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                } catch (\Exception $e) {
                    // Skip jika error parsing
                }
            }
            
            if (!$dataDate && $item->created_at) {
                $dataDate = $item->created_at;
            }

            return $dataDate ? $dataDate->between($startDate, $endDate) : false;
        });

        // Hitung total volume untuk print
        $totalVolume = 0;
        foreach ($dataPencatatan as $item) {
            $dataInput = $this->ensureArray($item->data_input);
            $totalVolume += floatval($dataInput['volume_sm3'] ?? 0);
        }

        $printData = [
            'customer' => $customer,
            'dataPencatatan' => $dataPencatatan,
            'selectedBulan' => $bulan,
            'selectedTahun' => $tahun,
            'totalVolume' => $totalVolume,
            'jumlahData' => $dataPencatatan->count(),
            'tanggalCetak' => now()->format('d F Y H:i'),
            'periode' => Carbon::createFromDate($tahun, $bulan, 1)->format('F Y')
        ];

        return view('data-pencatatan.fob.print-page', $printData);
    }

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
