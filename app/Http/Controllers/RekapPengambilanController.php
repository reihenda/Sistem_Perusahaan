<?php

namespace App\Http\Controllers;

use App\Models\RekapPengambilan;
use App\Models\User;
use App\Models\NomorPolisi;
use App\Models\DataPencatatan;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class RekapPengambilanController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        // Get tanggal from request or use current date
        $tanggal = $request->input('tanggal', now()->format('Y-m-d'));

        // Extract month and year from the selected date
        $selectedDate = Carbon::parse($tanggal);
        $bulan = $selectedDate->month;
        $tahun = $selectedDate->year;

        // Get data berdasarkan filter dengan paginasi
        $rekapPengambilan = RekapPengambilan::filterByMonthYear($bulan, $tahun)
            ->with('customer')
            ->orderBy('tanggal', 'desc')
            ->paginate(20);

        // Hitung total volume bulanan
        $totalVolumeBulanan = RekapPengambilan::getTotalVolumeMonthly($bulan, $tahun);

        // Hitung total volume harian berdasarkan tanggal yang dipilih
        $totalVolumeHarian = RekapPengambilan::getTotalVolumeDaily($tanggal);

        // Get list customer untuk dropdown
        $customers = User::where('role', 'customer')->orWhere('role', 'fob')->get();

        return view('rekap-pengambilan.index', compact(
            'rekapPengambilan',
            'customers',
            'bulan',
            'tahun',
            'tanggal',
            'totalVolumeBulanan',
            'totalVolumeHarian'
        ));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $customers = User::where('role', 'customer')->orWhere('role', 'fob')->get();
        $nomorPolisList = NomorPolisi::orderBy('nopol')->get();

        return view('rekap-pengambilan.create', compact('customers', 'nomorPolisList'));
    }

    public function store(Request $request)
    {
        $validatedBase = $request->validate([
            'customer_id' => 'required|exists:users,id',
            'tanggal' => 'required|date',
            'nopol' => 'required|string|max:20',
            'volume' => 'required|numeric|min:0',
            'alamat_pengambilan' => 'nullable|string|max:500',
            'keterangan' => 'nullable|string',
        ]);

        $customer = User::findOrFail($validatedBase['customer_id']);

        // Buat rekap pengambilan
        $rekap = RekapPengambilan::create($validatedBase);

        // Jika customer adalah FOB, tambahkan juga ke data_pencatatan untuk sinkronisasi data
        if ($customer->isFOB()) {
            // Hitung harga
            $volumeSm3 = floatval($validatedBase['volume']);
            $hargaPerM3 = floatval($customer->harga_per_meter_kubik) > 0 ?
                floatval($customer->harga_per_meter_kubik) : 0;
            $hargaFinal = $volumeSm3 * $hargaPerM3;

            // Format data untuk FOB
            $dataInput = [
                'waktu' => Carbon::parse($validatedBase['tanggal'])->format('Y-m-d H:i:s'),
                'volume_sm3' => $validatedBase['volume'],
                'keterangan' => $validatedBase['keterangan'] ?? null
            ];

            // Tambahkan log untuk melihat data yang disimpan
            \Log::info('Menyimpan data FOB dari RekapPengambilan', [
                'customer_id' => $validatedBase['customer_id'],
                'tanggal' => $validatedBase['tanggal'],
                'volume' => $validatedBase['volume'],
                'keterangan' => $validatedBase['keterangan'] ?? null,
                'dataInput' => $dataInput
            ]);

            // Buat data pencatatan baru
            $dataPencatatan = new \App\Models\DataPencatatan();
            $dataPencatatan->customer_id = $validatedBase['customer_id'];
            $dataPencatatan->data_input = json_encode($dataInput);
            $dataPencatatan->nama_customer = $customer->name;
            $dataPencatatan->status_pembayaran = 'belum_lunas'; // Default status
            $dataPencatatan->harga_final = $hargaFinal;
            $dataPencatatan->save();

            // Periksa isi object DataPencatatan yang berhasil dibuat
            \Log::info('Data pencatatan FOB berhasil dibuat', [
                'id' => $dataPencatatan->id,
                'customer_id' => $dataPencatatan->customer_id,
                'nama_customer' => $dataPencatatan->nama_customer,
                'data_input' => json_decode($dataPencatatan->data_input, true),
                'created_at' => $dataPencatatan->created_at
            ]);

            // Update total pembelian customer
            $customer->recordPurchase($hargaFinal);
            $userController = new UserController();
            $userController->rekalkulasiTotalPembelianFob($customer);
        }

        return redirect()->route('rekap-pengambilan.index')
            ->with('success', 'Data pengambilan berhasil ditambahkan.');
    }

    /**
     * Display the specified resource.
     */
    public function show(RekapPengambilan $rekapPengambilan)
    {
        return view('rekap-pengambilan.show', compact('rekapPengambilan'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(RekapPengambilan $rekapPengambilan)
    {
        $customers = User::where('role', 'customer')->orWhere('role', 'fob')->get();
        $nomorPolisList = NomorPolisi::orderBy('nopol')->get();

        return view('rekap-pengambilan.edit', compact('rekapPengambilan', 'customers', 'nomorPolisList'));
    }

    public function update(Request $request, RekapPengambilan $rekapPengambilan)
    {
        $validatedBase = $request->validate([
            'customer_id' => 'required|exists:users,id',
            'tanggal' => 'required|date',
            'nopol' => 'required|string|max:20',
            'volume' => 'required|numeric|min:0',
            'alamat_pengambilan' => 'nullable|string|max:500',
            'keterangan' => 'nullable|string',
        ]);

        $customer = User::findOrFail($validatedBase['customer_id']);

        // Update rekap pengambilan
        $rekapPengambilan->update($validatedBase);

        // Jika customer adalah FOB, update atau buat data_pencatatan untuk sinkronisasi
        if ($customer->isFOB()) {
            // Hitung harga
            $volumeSm3 = floatval($validatedBase['volume']);
            $hargaPerM3 = floatval($customer->harga_per_meter_kubik) > 0 ?
                floatval($customer->harga_per_meter_kubik) : 0;
            $hargaFinal = $volumeSm3 * $hargaPerM3;

            // Format data untuk FOB
            $dataInput = [
                'waktu' => Carbon::parse($validatedBase['tanggal'])->format('Y-m-d H:i:s'),
                'volume_sm3' => $validatedBase['volume'],
                'keterangan' => $validatedBase['keterangan'] ?? null
            ];

            // Cari data pencatatan yang terkait berdasarkan tanggal
            // Karena kita tidak memiliki relasi langsung antara RekapPengambilan dan DataPencatatan
            // Format tanggal Y-m-d untuk pencarian JSON substring (lebih fleksibel dari whereJsonContains)
            $tanggalSearch = Carbon::parse($validatedBase['tanggal'])->format('Y-m-d');
            $dataPencatatan = \App\Models\DataPencatatan::where('customer_id', $customer->id)
                ->where('data_input', 'like', '%"waktu":"%' . $tanggalSearch . '%"%')
                ->first();

            if ($dataPencatatan) {
                // Update data pencatatan yang ada
                $dataPencatatan->data_input = json_encode($dataInput);
                $dataPencatatan->harga_final = $hargaFinal;
                $dataPencatatan->save();
            } else {
                // Buat data pencatatan baru jika tidak ditemukan
                $dataPencatatan = new \App\Models\DataPencatatan();
                $dataPencatatan->customer_id = $validatedBase['customer_id'];
                $dataPencatatan->data_input = json_encode($dataInput);
                $dataPencatatan->nama_customer = $customer->name;
                $dataPencatatan->status_pembayaran = 'belum_lunas'; // Default status
                $dataPencatatan->harga_final = $hargaFinal;
                $dataPencatatan->save();
            }

            // Rekalkulasi total pembelian customer
            $userController = new UserController();
            $userController->rekalkulasiTotalPembelianFob($customer);
        }

        return redirect()->route('rekap-pengambilan.index')
            ->with('success', 'Data pengambilan berhasil diperbarui.');
    }

    public function destroy(RekapPengambilan $rekapPengambilan)
    {
        $customer = $rekapPengambilan->customer;
        $tanggal = $rekapPengambilan->tanggal;

        // Jika customer adalah FOB, hapus juga data di data_pencatatan untuk menjaga konsistensi
        if ($customer && $customer->isFOB()) {
            // Cari dan hapus data pencatatan terkait berdasarkan customer_id dan tanggal
            // Format tanggal Y-m-d untuk pencarian JSON substring (lebih fleksibel dari whereJsonContains)
            $tanggalSearch = Carbon::parse($tanggal)->format('Y-m-d');
            \App\Models\DataPencatatan::where('customer_id', $customer->id)
                ->where('data_input', 'like', '%"waktu":"%' . $tanggalSearch . '%"%')
                ->delete();

            // Rekalkulasi total pembelian customer
            $userController = new UserController();
            $userController->rekalkulasiTotalPembelianFob($customer);
        }

        // Hapus rekap pengambilan
        $rekapPengambilan->delete();

        return redirect()->route('rekap-pengambilan.index')
            ->with('success', 'Data pengambilan berhasil dihapus.');
    }
}
