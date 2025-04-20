<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class UserController extends Controller
{
    /**
     * Display a listing of the users.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        // Query dasar
        $query = User::query()->orderBy('role');
        
        // Filter berdasarkan pencarian jika ada
        if ($request->has('search') && !empty($request->search)) {
            $searchTerm = $request->search;
            $query->where(function($q) use ($searchTerm) {
                $q->where('name', 'like', '%' . $searchTerm . '%')
                  ->orWhere('email', 'like', '%' . $searchTerm . '%')
                  ->orWhere('role', 'like', '%' . $searchTerm . '%');
            });
        }
        
        $users = $query->get();
        
        // Deteksi jika request adalah AJAX untuk pencarian real-time
        if ($request->ajax()) {
            return response()->json([
                'html' => view('user.partials.user-table', compact('users'))->render(),
            ]);
        }
        
        return view('user.index', compact('users'));
    }

    /**
     * Helper function to ensure data is always an array
     */
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
     * Update customer pricing and meter correction
     */
    public function addDeposit(Request $request, $userId)
    {
        $request->validate([
            'amount' => 'required|numeric|min:0.01',
            'deposit_date' => 'required|date',
            'description' => 'nullable|string|max:255',
        ]);

        $user = User::findOrFail($userId);

        // Validate user permissions (only admin can add deposit)
        if (!Auth::user()->isAdmin() && !Auth::user()->isSuperAdmin()) {
            return redirect()->back()->with('error', 'Anda tidak memiliki izin untuk menambah deposit');
        }
        $depositDate = Carbon::parse($request->deposit_date);

        // Add deposit
        if ($user->addDeposit($request->amount, $request->description, $depositDate)) {
            return redirect()->back()->with('success', 'Deposit berhasil ditambahkan');
        } else {
            return redirect()->back()->with('error', 'Gagal menambahkan deposit');
        }
    }

    public function removeDeposit(Request $request, $userId)
    {
        // Validate user permissions (only admin can remove deposit)
        if (!Auth::user()->isAdmin() && !Auth::user()->isSuperAdmin()) {
            return redirect()->back()->with('error', 'Anda tidak memiliki izin untuk menghapus deposit');
        }

        $request->validate([
            'deposit_index' => 'required|integer|min:0'
        ]);

        $user = User::findOrFail($userId);

        if ($user->removeDeposit($request->deposit_index)) {
            return redirect()->back()->with('success', 'Deposit berhasil dihapus');
        } else {
            return redirect()->back()->with('error', 'Gagal menghapus deposit');
        }
    }

    public function updateCustomerPricing(Request $request, $customerId)
    {
        // Pastikan hanya admin atau super admin yang bisa mengakses
        if (!Auth::user()->isAdmin() && !Auth::user()->isSuperAdmin()) {
            return redirect()->back()->with('error', 'Anda tidak memiliki izin');
        }

        // Validasi input
        $validator = Validator::make($request->all(), [
            'harga_per_meter_kubik' => 'required|numeric|min:0',
            'tekanan_keluar' => 'required|numeric|min:0',
            'suhu' => 'required|numeric',
            'pricing_date' => 'required|date', // Tambahkan validasi untuk tanggal pricing
        ], [
            'harga_per_meter_kubik.required' => 'Harga per m³ harus diisi',
            'harga_per_meter_kubik.numeric' => 'Harga per m³ harus berupa angka',
            'harga_per_meter_kubik.min' => 'Harga per m³ tidak boleh kurang dari 0',
            'tekanan_keluar.required' => 'Tekanan keluar harus diisi',
            'tekanan_keluar.numeric' => 'Tekanan keluar harus berupa angka',
            'tekanan_keluar.min' => 'Tekanan keluar tidak boleh kurang dari 0',
            'suhu.required' => 'Suhu harus diisi',
            'suhu.numeric' => 'Suhu harus berupa angka',
            'pricing_date.required' => 'Tanggal pricing harus diisi',
            'pricing_date.date' => 'Format tanggal pricing tidak valid',
        ]);

        // Jika validasi gagal
        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput();
        }

        try {
            DB::beginTransaction();

            // Cari customer
            $customer = User::findOrFail($customerId);

            // Hitung koreksi meter dan tambahkan ke pricing history
            $koreksiMeter = self::hitungKoreksiMeter(
                floatval($request->input('tekanan_keluar')),
                floatval($request->input('suhu'))
            );

            $pricingDate = Carbon::parse($request->input('pricing_date'));
            $customer->addPricingHistory(
                floatval($request->input('harga_per_meter_kubik')),
                floatval($request->input('tekanan_keluar')),
                floatval($request->input('suhu')),
                $koreksiMeter,
                $pricingDate
            );

            // Re-kalkulasi total pembelian berdasarkan pricing history baru
            $this->rekalkulasiTotalPembelian($customer);

            DB::commit();

            // Redirect dengan refresh data
            return redirect()->route('data-pencatatan.customer-detail', [
                'customer' => $customer->id,
                'refresh' => true
            ])->with('success', 'Harga dan koreksi meter untuk periode ' . $pricingDate->format('F Y') . ' berhasil diperbarui');
        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'Gagal memperbarui data: ' . $e->getMessage());
        }
    }

    public function rekalkulasiTotalPembelian($customer)
    {
        try {
            DB::beginTransaction();

            // Reset total pembelian
            $customer->total_purchases = 0;

            // Ambil semua data pencatatan
            $dataPencatatans = $customer->dataPencatatan()->get();

            $totalPembelian = 0;

            foreach ($dataPencatatans as $dataPencatatan) {
                $dataInput = $this->ensureArray($dataPencatatan->data_input);

                $volumeFlowMeter = floatval($dataInput['volume_flow_meter'] ?? 0);

                // Ambil waktu pembacaan awal
                $waktuAwal = !empty($dataInput['pembacaan_awal']['waktu'])
                    ? Carbon::parse($dataInput['pembacaan_awal']['waktu'])
                    : null;

                if ($waktuAwal) {
                    $yearMonth = $waktuAwal->format('Y-m');

                    // Ambil pricing info untuk bulan tersebut
                    $pricingInfo = $customer->getPricingForYearMonth($yearMonth);

                    // Hitung dengan pricing yang sesuai
                    $koreksiMeter = floatval($pricingInfo['koreksi_meter'] ?? $customer->koreksi_meter);
                    $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $customer->harga_per_meter_kubik);

                    $volumeSm3 = $volumeFlowMeter * $koreksiMeter;
                    $pembelian = $volumeSm3 * $hargaPerM3;

                    // Debugging - uncomment to check values
                    // error_log("Data ID: {$dataPencatatan->id}, Volume: {$volumeFlowMeter}, Koreksi: {$koreksiMeter}, Harga: {$hargaPerM3}, Pembelian: {$pembelian}");

                    $totalPembelian += $pembelian;
                }
            }

            // Update total pembelian - pastikan numerik
            $customer->total_purchases = floatval($totalPembelian);
            $customer->save();

            DB::commit();

            return $totalPembelian;
        } catch (\Exception $e) {
            DB::rollBack();
            error_log("Error in rekalkulasiTotalPembelian: " . $e->getMessage());
            return 0;
        }
    }

    /**
     * Update FOB pricing for a specific period
     *
     * @param Request $request
     * @param int $fobId
     * @return \Illuminate\Http\JsonResponse
     */
    public function updateFobPricing(Request $request, $customerId)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'harga_per_meter_kubik' => 'required|numeric|min:0',
                'pricing_date' => 'required|date',
            ]);

            // Jika validasi gagal
            if ($validator->fails()) {
                return redirect()->back()
                    ->withErrors($validator)
                    ->withInput();
            }

            DB::beginTransaction();
            // Cari customer
            $customer = User::findOrFail($customerId);

            $pricingDate = Carbon::parse($request->input('pricing_date'));
            $customer->addPricingHistoryfob(
                floatval($request->input('harga_per_meter_kubik')),
                $pricingDate
            );

            // Call the rekalkulasi method to update total purchases
            $this->rekalkulasiTotalPembelianfob($customer);

            DB::commit();

            // For AJAX request
            if ($request->ajax() || $request->wantsJson()) {
                return response()->json([
                    'success' => true,
                    'message' => 'Harga untuk periode ' . $pricingDate->format('F Y') . ' berhasil diperbarui'
                ]);
            }

            // Redirect dengan refresh data
            return redirect()->route('data-pencatatan.fob-detail', [
                'customer' => $customer->id,
                'refresh' => true
            ])->with('success', 'Harga untuk periode ' . $pricingDate->format('F Y') . ' berhasil diperbarui');
        } catch (\Exception $e) {
            DB::rollBack();

            // For AJAX request
            if ($request->ajax() || $request->wantsJson()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Gagal memperbarui data: ' . $e->getMessage()
                ], 422);
            }

            return redirect()->back()->with('error', 'Gagal memperbarui data: ' . $e->getMessage());
        }
    }

    /**
     * Rekalkulasi total pembelian khusus FOB
     */
    public function rekalkulasiTotalPembelianFob($fob)
    {
        try {
            DB::beginTransaction();

            // Reset total pembelian
            $fob->total_purchases = 0;

            // Ambil semua data pencatatan
            $dataPencatatans = $fob->dataPencatatan()->get();

            $totalPembelian = 0;

            foreach ($dataPencatatans as $dataPencatatan) {
                $dataInput = $this->ensureArray($dataPencatatan->data_input);

                // Untuk FOB, kita menggunakan volume_sm3 langsung
                $volumeSm3 = floatval($dataInput['volume_sm3'] ?? 0);

                // Ambil waktu pencatatan
                $waktu = !empty($dataInput['waktu'])
                    ? Carbon::parse($dataInput['waktu'])
                    : null;

                if ($waktu) {
                    $yearMonth = $waktu->format('Y-m');

                    // Ambil pricing info untuk bulan tersebut
                    $pricingInfo = $fob->getPricingForYearMonth($yearMonth);

                    // Hitung dengan pricing yang sesuai
                    $hargaPerM3 = floatval($pricingInfo['harga_per_meter_kubik'] ?? $fob->harga_per_meter_kubik);

                    $pembelian = $volumeSm3 * $hargaPerM3;
                    $totalPembelian += $pembelian;
                }
            }

            // Update total pembelian - pastikan numerik
            $fob->total_purchases = floatval($totalPembelian);
            $fob->save();

            DB::commit();

            return $totalPembelian;
        } catch (\Exception $e) {
            DB::rollBack();
            error_log("Error in rekalkulasiTotalPembelianFob: " . $e->getMessage());
            return 0;
        }
    }

    public function getPricingHistory(Request $request, $customerId)
    {
        $customer = User::findOrFail($customerId);
        return response()->json([
            'pricing_history' => $this->ensureArray($customer->pricing_history)
        ]);
    }

    /**
     * Hitung koreksi meter
     * Metode statis yang bisa digunakan di berbagai tempat
     */
    public static function hitungKoreksiMeter($tekananKeluar, $suhu)
    {
        // Ensure numeric values
        $tekananKeluar = floatval($tekananKeluar);
        $suhu = floatval($suhu);

        // Perhitungan koreksi meter sesuai standar
        $A = ($tekananKeluar + 1.01325) / 1.01325;
        $B = 300 / ($suhu + 273);
        $C = 1 + (0.002 * $tekananKeluar);

        return $A * $B * $C;
    }
}
