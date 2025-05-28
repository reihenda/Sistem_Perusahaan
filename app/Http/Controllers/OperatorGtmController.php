<?php

namespace App\Http\Controllers;

use App\Models\OperatorGtm;
use App\Models\OperatorGtmLembur;
use App\Models\KonfigurasiLembur;
use Illuminate\Http\Request;
use Carbon\Carbon;

class OperatorGtmController extends Controller
{
    /**
     * Menampilkan daftar operator GTM
     */
    public function index()
    {
        $operators = OperatorGtm::paginate(10);
        return view('operator-gtm.index', compact('operators'));
    }

    /**
     * Menampilkan form untuk menambah operator baru
     */
    public function create()
    {
        return view('operator-gtm.create');
    }

    /**
     * Menyimpan operator baru ke database
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nama' => 'required|string|max:255',
            'lokasi_kerja' => 'required|string|max:255',
            'gaji_pokok' => 'required|numeric|min:0',
            'tanggal_bergabung' => 'required|date',
        ]);

        OperatorGtm::create($validatedData);

        return redirect()->route('operator-gtm.index')
            ->with('success', 'Operator GTM berhasil ditambahkan');
    }

    /**
     * Menampilkan detail operator tertentu
     */
    public function show(Request $request, OperatorGtm $operatorGtm)
    {
        // Ambil semua data lembur untuk operator ini (tidak difilter di database)
        $lemburRecords = $operatorGtm->lemburRecords()->orderBy('tanggal', 'asc')->get();
        
        // Set default ke bulan dan tahun saat ini jika tidak ada parameter
        $selectedMonth = $request->input('month', date('m'));
        $selectedYear = $request->input('year', date('Y'));
        
        // Log untuk debugging
        \Log::info('Total data lembur operator: ' . count($lemburRecords));
        foreach ($lemburRecords as $record) {
            \Log::info('Record: ID=' . $record->id . ' | Tanggal=' . $record->tanggal . ' | Format=' . date('Y-m-d', strtotime($record->tanggal)) . 
            ' | Raw=' . var_export($record->getOriginal('tanggal'), true));
        }
        
        // Log untuk debugging periode yang dipilih
        \Log::info('Filter periode - bulan: ' . $selectedMonth . ', tahun: ' . $selectedYear);
            
        return view('operator-gtm.show', compact('operatorGtm', 'lemburRecords', 'selectedMonth', 'selectedYear'));
    }

    /**
     * Menampilkan form untuk mengedit operator
     */
    public function edit(OperatorGtm $operatorGtm)
    {
        return view('operator-gtm.edit', compact('operatorGtm'));
    }

    /**
     * Menyimpan perubahan pada operator ke database
     */
    public function update(Request $request, OperatorGtm $operatorGtm)
    {
        $validatedData = $request->validate([
            'nama' => 'required|string|max:255',
            'lokasi_kerja' => 'required|string|max:255',
            'gaji_pokok' => 'required|numeric|min:0',
            'tanggal_bergabung' => 'required|date',
        ]);

        $operatorGtm->update($validatedData);

        return redirect()->route('operator-gtm.show', $operatorGtm->id)
            ->with('success', 'Data operator GTM berhasil diperbarui');
    }

    /**
     * Menghapus operator dari database
     */
    public function destroy(OperatorGtm $operatorGtm)
    {
        $operatorGtm->delete();

        return redirect()->route('operator-gtm.index')
            ->with('success', 'Operator GTM berhasil dihapus');
    }

    /**
     * Menampilkan form untuk tambah data lembur
     */
    public function createLembur(Request $request, OperatorGtm $operatorGtm)
    {
        // Periksa apakah ada parameter tanggal di URL
        $tanggal = $request->query('tanggal') ?: date('Y-m-d');
        
        return view('operator-gtm.create-lembur', compact('operatorGtm', 'tanggal'));
    }

    /**
     * Menyimpan data lembur baru
     */
    public function storeLembur(Request $request, OperatorGtm $operatorGtm)
    {
        $validatedData = $request->validate([
            'tanggal' => 'required|date',
            'jam_masuk_sesi_1' => 'nullable|date_format:H:i',
            'jam_keluar_sesi_1' => 'nullable|date_format:H:i',
            'jam_masuk_sesi_2' => 'nullable|date_format:H:i',
            'jam_keluar_sesi_2' => 'nullable|date_format:H:i',
            'jam_masuk_sesi_3' => 'nullable|date_format:H:i',
            'jam_keluar_sesi_3' => 'nullable|date_format:H:i',
        ]);

        // Logging untuk debugging
        \Log::info('Jam masuk sesi 1: ' . $request->jam_masuk_sesi_1);
        \Log::info('Jam keluar sesi 1: ' . $request->jam_keluar_sesi_1);
        \Log::info('Jam masuk sesi 2: ' . $request->jam_masuk_sesi_2);
        \Log::info('Jam keluar sesi 2: ' . $request->jam_keluar_sesi_2);
        \Log::info('Jam masuk sesi 3: ' . $request->jam_masuk_sesi_3);
        \Log::info('Jam keluar sesi 3: ' . $request->jam_keluar_sesi_3);

        // Hitung total jam kerja
        $totalJamKerja = 0;
        
        // Hitung durasi sesi 1
        if ($request->filled('jam_masuk_sesi_1') && $request->filled('jam_keluar_sesi_1')) {
            // Menggunakan tanggal hari ini sebagai basis
            $today = Carbon::today();
            
            // Parse input time dengan tanggal hari ini
            $masukSesi1 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_masuk_sesi_1);
            $keluarSesi1 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_keluar_sesi_1);
            
            // Jika keluar sesi 1 lebih kecil dari masuk sesi 1, artinya melewati tengah malam
            if ($keluarSesi1->lt($masukSesi1)) {
                $keluarSesi1->addDay();
            }
            
            // Perhitungan durasi: jam keluar - jam masuk
            $durasiSesi1 = $masukSesi1->diffInMinutes($keluarSesi1);
            $totalJamKerja += $durasiSesi1;
            
            \Log::info('Durasi sesi 1: ' . $durasiSesi1 . ' menit');
        }
        
        // Hitung durasi sesi 2
        if ($request->filled('jam_masuk_sesi_2') && $request->filled('jam_keluar_sesi_2')) {
            // Menggunakan tanggal hari ini sebagai basis
            $today = Carbon::today();
            
            // Parse input time dengan tanggal hari ini
            $masukSesi2 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_masuk_sesi_2);
            $keluarSesi2 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_keluar_sesi_2);
            
            // Jika keluar sesi 2 lebih kecil dari masuk sesi 2, artinya melewati tengah malam
            if ($keluarSesi2->lt($masukSesi2)) {
                $keluarSesi2->addDay();
            }
            
            // Perhitungan durasi: jam keluar - jam masuk
            $durasiSesi2 = $masukSesi2->diffInMinutes($keluarSesi2);
            $totalJamKerja += $durasiSesi2;
            
            \Log::info('Durasi sesi 2: ' . $durasiSesi2 . ' menit');
        }

        // Hitung durasi sesi 3
        if ($request->filled('jam_masuk_sesi_3') && $request->filled('jam_keluar_sesi_3')) {
            // Menggunakan tanggal hari ini sebagai basis
            $today = Carbon::today();
            
            // Parse input time dengan tanggal hari ini
            $masukSesi3 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_masuk_sesi_3);
            $keluarSesi3 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_keluar_sesi_3);
            
            // Jika keluar sesi 3 lebih kecil dari masuk sesi 3, artinya melewati tengah malam
            if ($keluarSesi3->lt($masukSesi3)) {
                $keluarSesi3->addDay();
            }
            
            // Perhitungan durasi: jam keluar - jam masuk
            $durasiSesi3 = $masukSesi3->diffInMinutes($keluarSesi3);
            $totalJamKerja += $durasiSesi3;
            
            \Log::info('Durasi sesi 3: ' . $durasiSesi3 . ' menit');
        }
        
        \Log::info('Total jam kerja: ' . $totalJamKerja . ' menit');
        
        // Hitung jam lembur (jam kerja di atas 8 jam atau 480 menit)
        $jamLembur = max(0, $totalJamKerja - 480);
        \Log::info('Jam lembur: ' . $jamLembur . ' menit');
        
        // Ambil tarif lembur dari konfigurasi
        $upahPerJam = KonfigurasiLembur::getTarifLembur();
        $upahLembur = ($jamLembur / 60) * $upahPerJam;
        
        // Tambahkan data perhitungan ke validated data
        $validatedData['total_jam_kerja'] = $totalJamKerja;
        $validatedData['total_jam_lembur'] = $jamLembur;
        $validatedData['upah_lembur'] = $upahLembur;
        $validatedData['operator_gtm_id'] = $operatorGtm->id;

        OperatorGtmLembur::create($validatedData);

        return redirect()->route('operator-gtm.show', $operatorGtm->id)
            ->with('success', 'Data lembur berhasil ditambahkan');
    }

    /**
     * Menampilkan form untuk edit data lembur
     */
    public function editLembur(OperatorGtmLembur $lembur)
    {
        $operatorGtm = $lembur->operator;
        return view('operator-gtm.edit-lembur', compact('lembur', 'operatorGtm'));
    }

    /**
     * Menyimpan perubahan data lembur
     */
    public function updateLembur(Request $request, OperatorGtmLembur $lembur)
    {
        $validatedData = $request->validate([
            'tanggal' => 'required|date',
            'jam_masuk_sesi_1' => 'nullable|date_format:H:i',
            'jam_keluar_sesi_1' => 'nullable|date_format:H:i',
            'jam_masuk_sesi_2' => 'nullable|date_format:H:i',
            'jam_keluar_sesi_2' => 'nullable|date_format:H:i',
            'jam_masuk_sesi_3' => 'nullable|date_format:H:i',
            'jam_keluar_sesi_3' => 'nullable|date_format:H:i',
        ]);

        // Logging untuk debugging
        \Log::info('Jam masuk sesi 1: ' . $request->jam_masuk_sesi_1);
        \Log::info('Jam keluar sesi 1: ' . $request->jam_keluar_sesi_1);
        \Log::info('Jam masuk sesi 2: ' . $request->jam_masuk_sesi_2);
        \Log::info('Jam keluar sesi 2: ' . $request->jam_keluar_sesi_2);
        \Log::info('Jam masuk sesi 3: ' . $request->jam_masuk_sesi_3);
        \Log::info('Jam keluar sesi 3: ' . $request->jam_keluar_sesi_3);

        // Hitung total jam kerja
        $totalJamKerja = 0;
        
        // Hitung durasi sesi 1
        if ($request->filled('jam_masuk_sesi_1') && $request->filled('jam_keluar_sesi_1')) {
            // Menggunakan tanggal hari ini sebagai basis
            $today = Carbon::today();
            
            // Parse input time dengan tanggal hari ini
            $masukSesi1 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_masuk_sesi_1);
            $keluarSesi1 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_keluar_sesi_1);
            
            // Jika keluar sesi 1 lebih kecil dari masuk sesi 1, artinya melewati tengah malam
            if ($keluarSesi1->lt($masukSesi1)) {
                $keluarSesi1->addDay();
            }
            
            // Perhitungan durasi: jam keluar - jam masuk
            $durasiSesi1 = $masukSesi1->diffInMinutes($keluarSesi1);
            $totalJamKerja += $durasiSesi1;
            
            \Log::info('Durasi sesi 1: ' . $durasiSesi1 . ' menit');
        }
        
        // Hitung durasi sesi 2
        if ($request->filled('jam_masuk_sesi_2') && $request->filled('jam_keluar_sesi_2')) {
            // Menggunakan tanggal hari ini sebagai basis
            $today = Carbon::today();
            
            // Parse input time dengan tanggal hari ini
            $masukSesi2 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_masuk_sesi_2);
            $keluarSesi2 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_keluar_sesi_2);
            
            // Jika keluar sesi 2 lebih kecil dari masuk sesi 2, artinya melewati tengah malam
            if ($keluarSesi2->lt($masukSesi2)) {
                $keluarSesi2->addDay();
            }
            
            // Perhitungan durasi: jam keluar - jam masuk
            $durasiSesi2 = $masukSesi2->diffInMinutes($keluarSesi2);
            $totalJamKerja += $durasiSesi2;
            
            \Log::info('Durasi sesi 2: ' . $durasiSesi2 . ' menit');
        }

        // Hitung durasi sesi 3
        if ($request->filled('jam_masuk_sesi_3') && $request->filled('jam_keluar_sesi_3')) {
            // Menggunakan tanggal hari ini sebagai basis
            $today = Carbon::today();
            
            // Parse input time dengan tanggal hari ini
            $masukSesi3 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_masuk_sesi_3);
            $keluarSesi3 = Carbon::parse($today->format('Y-m-d') . ' ' . $request->jam_keluar_sesi_3);
            
            // Jika keluar sesi 3 lebih kecil dari masuk sesi 3, artinya melewati tengah malam
            if ($keluarSesi3->lt($masukSesi3)) {
                $keluarSesi3->addDay();
            }
            
            // Perhitungan durasi: jam keluar - jam masuk
            $durasiSesi3 = $masukSesi3->diffInMinutes($keluarSesi3);
            $totalJamKerja += $durasiSesi3;
            
            \Log::info('Durasi sesi 3: ' . $durasiSesi3 . ' menit');
        }
        
        \Log::info('Total jam kerja: ' . $totalJamKerja . ' menit');
        
        // Hitung jam lembur (jam kerja di atas 8 jam atau 480 menit)
        $jamLembur = max(0, $totalJamKerja - 480);
        \Log::info('Jam lembur: ' . $jamLembur . ' menit');
        
        // Ambil tarif lembur dari konfigurasi
        $upahPerJam = KonfigurasiLembur::getTarifLembur();
        $upahLembur = ($jamLembur / 60) * $upahPerJam;
        
        // Tambahkan data perhitungan ke validated data
        $validatedData['total_jam_kerja'] = $totalJamKerja;
        $validatedData['total_jam_lembur'] = $jamLembur;
        $validatedData['upah_lembur'] = $upahLembur;

        $lembur->update($validatedData);

        return redirect()->route('operator-gtm.show', $lembur->operator_gtm_id)
            ->with('success', 'Data lembur berhasil diperbarui');
    }

    /**
     * Menghapus data lembur
     */
    public function destroyLembur(OperatorGtmLembur $lembur)
    {
        $operatorId = $lembur->operator_gtm_id;
        $lembur->delete();

        return redirect()->route('operator-gtm.show', $operatorId)
            ->with('success', 'Data lembur berhasil dihapus');
    }
}