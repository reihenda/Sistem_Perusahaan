    /**
     * Rekalkulasi total pembelian khusus FOB dengan algoritma presisi tinggi
     */
    public function rekalkulasiTotalPembelianFob($fob)
    {
        try {
            DB::beginTransaction();

            // Reset total pembelian
            $fob->total_purchases = 0;

            // Ambil semua data pencatatan dengan urutan berdasarkan tanggal
            $dataPencatatans = $fob->dataPencatatan()->orderBy('created_at')->get();

            $totalPembelian = 0;
            $inconsistentRecords = 0; // Counter untuk record yang tidak konsisten

            foreach ($dataPencatatans as $dataPencatatan) {
                $dataInput = $this->ensureArray($dataPencatatan->data_input);

                // Untuk FOB, kita menggunakan volume_sm3 langsung
                $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);

                // Ambil waktu pencatatan dengan prioritas pada format 'waktu'
                $waktu = null;
                if (!empty($dataInput['waktu'])) {
                    $waktu = Carbon::parse($dataInput['waktu']);
                } elseif (!empty($dataInput['pembacaan_awal']['waktu'])) {
                    $waktu = Carbon::parse($dataInput['pembacaan_awal']['waktu']);
                } elseif ($dataPencatatan->created_at) {
                    $waktu = $dataPencatatan->created_at;
                }
                
                // Jika tidak ada waktu valid, gunakan harga_final jika tersedia
                if (!$waktu) {
                    if ($dataPencatatan->harga_final > 0) {
                        $totalPembelian += $dataPencatatan->harga_final;
                    }
                    continue;
                }

                $yearMonth = $waktu->format('Y-m');

                // SELALU hitung berdasarkan pricing terbaru (calculated) untuk akurasi
                if ($volumeSm3 > 0) {
                    // Ambil pricing info untuk bulan tersebut
                    $pricingInfo = $fob->getPricingForYearMonth($yearMonth, $waktu);

                    // Hitung dengan pricing yang sesuai (SELALU calculated, bukan harga_final lama)
                    $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $fob->harga_per_meter_kubik);
                    $pembelian = $volumeSm3 * $hargaPerM3;
                    
                    // Update harga final di database untuk konsistensi
                    $oldHargaFinal = $dataPencatatan->harga_final;
                    $dataPencatatan->harga_final = round($pembelian, 2);
                    $dataPencatatan->save();
                    
                    // Track jika ada perbedaan dari harga_final lama
                    if (abs($oldHargaFinal - $pembelian) > 0.01) {
                        $inconsistentRecords++;
                    }
                    
                    $totalPembelian += $pembelian;
                }
            }

            // Update total pembelian - pastikan numerik dengan pembulatan yang konsisten
            $fob->total_purchases = round(floatval($totalPembelian), 2);
            $result = $fob->save();

            DB::commit();

            return $fob->total_purchases;
        } catch (\Exception $e) {
            DB::rollBack();
            return 0;
        }
    }