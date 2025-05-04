<?php

namespace App\Http\Controllers;

use App\Models\RekapPengambilan;
use App\Models\User;
use App\Models\NomorPolisi;
use Illuminate\Http\Request;
use Carbon\Carbon;

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

    /**
     * Store a newly created resource in storage.
     */
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
        
        RekapPengambilan::create($validatedBase);
        
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

    /**
     * Update the specified resource in storage.
     */
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
        
        $rekapPengambilan->update($validatedBase);
        
        return redirect()->route('rekap-pengambilan.index')
            ->with('success', 'Data pengambilan berhasil diperbarui.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(RekapPengambilan $rekapPengambilan)
    {
        $rekapPengambilan->delete();
        
        return redirect()->route('rekap-pengambilan.index')
            ->with('success', 'Data pengambilan berhasil dihapus.');
    }
    

}
