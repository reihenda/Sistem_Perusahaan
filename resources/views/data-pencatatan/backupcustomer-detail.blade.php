@extends('layouts.app')

@section('title', 'Detail Data Pencatatan Customer')

@section('page-title', 'Data Pencatatan - ' . $customer->name)

@section('content')
    <div class="container-fluid">
        <div class="row">
            {{-- Notifications Section --}}
            <div class="col-12">
                @if (session('success'))
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle mr-2"></i>
                        {{ session('success') }}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                @endif

                @if (session('error'))
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        {{ session('error') }}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                @endif

                @if ($errors->any())
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-times-circle mr-2"></i>
                        <strong>Kesalahan Validasi:</strong>
                        <ul class="mt-2">
                            @foreach ($errors->all() as $error)
                                <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                @endif
            </div>

            {{-- Changes to Customer Summary Card for responsiveness --}}
            <div class="col-md-12">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-circle mr-2"></i>
                            Informasi Customer: {{ $customer->name }}
                        </h3>
                        <div class="card-tools">
                            @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
                                <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#setPricingModal">
                                    <i class="fas fa-cog mr-1"></i> Atur Harga & Koreksi
                                </button>
                                <button class="btn btn-success btn-sm mr-2" data-toggle="modal"
                                    data-target="#depositHistoryModal">
                                    <i class="fas fa-money-bill-alt mr-1"></i> History Deposit
                                </button>
                                <a href="{{ route('data-pencatatan.print-billing', ['customer' => $customer->id, 'bulan' => $selectedBulan, 'tahun' => $selectedTahun]) }}"
                                    class="btn btn-info btn-sm mr-2" target="_blank">
                                    <i class="fas fa-file-pdf mr-1"></i> Cetak Billing
                                </a>
                                <a href="{{ route('data-pencatatan.create-with-customer', $customer->id) }}"
                                    class="btn btn-info btn-sm">
                                    <i class="fas fa-plus mr-1"></i> Tambah Data
                                </a>
                            @endif
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-tachometer-alt mr-1"></i> Total Pemakaian</strong>
                                    <p class="text-muted mb-0">
                                        {{ number_format($totalVolumeSm3, 2) }} Sm³
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-money-bill-wave mr-1"></i> Total Pembelian</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format($customer->total_purchases ?? 0, 0) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-wallet mr-1"></i> Total Deposit</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format($customer->total_deposit ?? 0, 0) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-wallet mr-1"></i> Saldo</strong>
                                    <p class="text-muted mb-0">
                                        Rp
                                        {{ number_format(($customer->total_deposit ?? 0) - ($customer->total_purchases ?? 0), 0) }}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {{-- Yearly Period Information Card --}}
            <div class="col-md-12">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-alt mr-2"></i>
                            Informasi Periode Tahunan: {{ $selectedTahun }}
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-tachometer-alt mr-1"></i> Total Pemakaian Tahunan</strong>
                                    <p class="text-muted mb-0">
                                        {{ number_format($totalPemakaianTahunan, 2) }} Sm³
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-money-bill-wave mr-1"></i> Total Pembelian Tahunan</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format($totalPembelianTahunan, 0) }}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {{-- Changes to Period Information Card for responsiveness --}}
            <div class="col-md-12">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-line mr-2"></i>
                            Informasi Periode:
                            {{ \Carbon\Carbon::createFromDate($selectedTahun, $selectedBulan, 1)->format('F Y') }}
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-tachometer-alt mr-1"></i> Tekanan </strong>
                                    <p class="text-muted mb-0">
                                        {{ number_format($pricingInfo['tekanan_keluar'] ?? ($customer->tekanan_keluar ?? 0), 2) }}
                                        Bar
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-thermometer-half mr-1"></i> Suhu</strong>
                                    <p class="text-muted mb-0">
                                        {{ number_format($pricingInfo['suhu'] ?? ($customer->suhu ?? 0), 2) }} °C
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-tachometer-alt mr-1"></i> Koreksi Meter</strong>
                                    <p class="text-muted mb-0">
                                        {{ number_format($pricingInfo['koreksi_meter'] ?? ($customer->koreksi_meter ?? 1), 4) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-money-bill-wave mr-1"></i> Harga per Sm³</strong>
                                    <p class="text-muted mb-0">
                                        Rp
                                        {{ number_format($pricingInfo['harga_per_meter_kubik'] ?? ($customer->harga_per_meter_kubik ?? 0), 2) }}
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-gas-pump mr-1"></i> Volume Periode Ini</strong>
                                    <p class="text-muted mb-0">
                                        {{ number_format($filteredVolumeSm3, 2) }} Sm³
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-money-bill-wave mr-1"></i> Pembelian Periode Ini</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format($filteredTotalPurchases, 0) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-wallet mr-1"></i> Deposit Periode Ini</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format($filteredTotalDeposits, 0) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-balance-scale mr-1"></i> Saldo Bulan Ini</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format($currentMonthBalance, 0) }}
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-6 col-sm-12">
                                <div class="info-box" style="background-color: #f8fafc; border: 1px solid #e2e8f0;">
                                    <span class="info-box-icon bg-info"><i class="fas fa-calculator"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Informasi Saldo Bulan
                                            {{ \Carbon\Carbon::createFromDate($selectedTahun, $selectedBulan, 1)->format('F Y') }}</span>
                                        <div class="table-responsive mt-2">
                                            <table class="table table-sm table-bordered">
                                                <tr>
                                                    <td width="60%">Saldo Bulan Sebelumnya</td>
                                                    <td>Rp {{ number_format($prevMonthBalance, 0) }}</td>
                                                </tr>
                                                <tr>
                                                    <td>+ Deposit Bulan Ini</td>
                                                    <td>Rp {{ number_format($filteredTotalDeposits, 0) }}</td>
                                                </tr>
                                                <tr>
                                                    <td>- Pembelian Bulan Ini</td>
                                                    <td>Rp {{ number_format($filteredTotalPurchases, 0) }}</td>
                                                </tr>
                                                <tr class="font-weight-bold">
                                                    <td>= Saldo Bulan Ini</td>
                                                    <td>Rp {{ number_format($currentMonthBalance, 0) }}</td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {{-- Mobile-optimized Filter Form --}}
            <div class="col-md-12">
                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-filter mr-1"></i>
                            Filter Periode
                        </h3>
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                <i class="fas fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <form action="{{ route('data-pencatatan.filter-month-year', $customer->id) }}" method="POST"
                            id="filter-form">
                            @csrf
                            <div class="row">
                                <div class="col-md-3 col-sm-6">
                                    <div class="form-group">
                                        <label>Bulan:</label>
                                        <select class="form-control" name="bulan" id="bulan">
                                            @for ($i = 1; $i <= 12; $i++)
                                                <option value="{{ $i }}"
                                                    {{ $selectedBulan == $i ? 'selected' : '' }}>
                                                    {{ \Carbon\Carbon::create(null, $i, 1)->format('F') }}
                                                </option>
                                            @endfor
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3 col-sm-6">
                                    <div class="form-group">
                                        <label>Tahun:</label>
                                        <select class="form-control" name="tahun" id="tahun">
                                            @for ($year = date('Y'); $year >= 2020; $year--)
                                                <option value="{{ $year }}"
                                                    {{ $selectedTahun == $year ? 'selected' : '' }}>
                                                    {{ $year }}
                                                </option>
                                            @endfor
                                        </select>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="form-group mb-0">
                                        <div class="d-flex flex-column flex-md-row">
                                            <button type="submit" class="btn btn-primary mb-2 mb-md-0 mr-md-2">
                                                <i class="fas fa-search mr-1"></i> Terapkan Filter
                                            </button>
                                            <a href="{{ route('data-pencatatan.customer-detail', $customer->id) }}"
                                                class="btn btn-default">
                                                <i class="fas fa-sync-alt mr-1"></i> Reset
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            {{-- Data Pencatatan Table --}}
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-list-alt mr-2"></i>
                            Riwayat Pencatatan
                        </h3>
                    </div>
                    <div class="card-body table-responsive p-0">
                        <table class="table table-bordered table-striped" id="dataPencatatanTable">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th colspan="2">Pembacaan Awal</th>
                                    <th colspan="2">Pembacaan Akhir</th>
                                    <th>Volume</th>
                                    <th>Sm³</th>
                                    <th>Rupiah</th>
                                    <th>Aksi</th>
                                </tr>
                                <tr>
                                    <th></th>
                                    <th>Tanggal</th>
                                    <th>Meter</th>
                                    <th>Tanggal</th>
                                    <th>Meter</th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                @php $no = 1; @endphp
                                @foreach ($dataPencatatan as $item)
                                    @php
                                        $dataInput = is_string($item->data_input)
                                            ? json_decode($item->data_input, true)
                                            : (is_array($item->data_input)
                                                ? $item->data_input
                                                : []);

                                        $pembacaanAwal = $dataInput['pembacaan_awal'] ?? [
                                            'volume' => 0,
                                            'tanggal' => null,
                                        ];
                                        $pembacaanAkhir = $dataInput['pembacaan_akhir'] ?? [
                                            'volume' => 0,
                                            'tanggal' => null,
                                        ];
                                        $volumeFlowMeter = $dataInput['volume_flow_meter'] ?? 0;

                                        // Hitung Volume Sm³
                                        $volumeSm3 = $volumeFlowMeter * $customer->koreksi_meter;

                                        // Hitung Pembelian
                                        $pembelian = $volumeSm3 * $customer->harga_per_meter_kubik;

                                        // Get the timestamp for data-filter attribute
                                        $waktuAwalTimestamp = strtotime($dataInput['pembacaan_awal']['waktu'] ?? '');
                                        $tanggalAwalFilter = $waktuAwalTimestamp
                                            ? date('Y-m-d', $waktuAwalTimestamp)
                                            : '';
                                    @endphp
                                    <tr data-tanggal-awal="{{ $tanggalAwalFilter }}">
                                        <td>{{ $no++ }}</td>
                                        <td>{{ \Carbon\Carbon::parse($dataInput['pembacaan_awal']['waktu'])->format('d M Y H:i') }}
                                        </td>
                                        <td>{{ number_format($pembacaanAwal['volume'] ?? 0, 2) }} m³</td>
                                        <td>{{ \Carbon\Carbon::parse($dataInput['pembacaan_akhir']['waktu'])->format('d M Y H:i') }}
                                        </td>
                                        <td>{{ number_format($pembacaanAkhir['volume'] ?? 0, 2) }} m³</td>
                                        <td>{{ number_format($volumeFlowMeter, 2) }} m³</td>
                                        <td>{{ number_format($volumeSm3, 2) }}</td>
                                        <td>Rp {{ number_format($pembelian, 2) }}</td>

                                        <td>
                                            <div class="btn-group">
                                                <a href="{{ route('data-pencatatan.show', $item->id) }}"
                                                    class="btn btn-info btn-sm">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
                                                    <a href="{{ route('data-pencatatan.edit', $item->id) }}"
                                                        class="btn btn-warning btn-sm">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <form action="{{ route('data-pencatatan.destroy', $item->id) }}"
                                                        method="POST" class="d-inline"
                                                        onsubmit="return confirm('Apakah Anda yakin ingin menghapus data ini?');">
                                                        @csrf
                                                        @method('DELETE')
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                @endif
                                            </div>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        {{-- Deposit History Modal --}}
        @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
            <div class="modal fade" id="depositHistoryModal" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title" id="depositHistoryModalLabel">
                                <i class="fas fa-money-bill-alt mr-2"></i>History Deposit
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="row mb-3">
                                <div class="col-md-6 col-sm-12 mb-3">
                                    <h5>Total Deposit: <span class="text-success">Rp
                                            {{ number_format($customer->total_deposit, 2) }}</span></h5>
                                    <h5>Total Pembelian: <span class="text-danger">Rp
                                            {{ number_format($customer->total_purchases, 2) }}</span></h5>
                                    <h5>Saldo Tersisa: <span class="text-primary">Rp
                                            {{ number_format($customer->total_deposit - $customer->total_purchases, 2) }}</span>
                                    </h5>
                                </div>
                                <div class="col-md-6 col-sm-12 text-right">
                                    <button class="btn btn-primary w-100 w-md-auto" data-toggle="modal"
                                        data-target="#tambahDepositModal">
                                        <i class="fas fa-plus mr-1"></i> Tambah Deposit
                                    </button>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped" id="depositHistoryTable">
                                    <thead>
                                        <tr>
                                            <th>No</th>
                                            <th>Tanggal</th>
                                            <th>Jumlah Deposit</th>
                                            <th>Keterangan</th>
                                            <th>Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @php
                                            // Ensure deposit_history is an array before looping
                                            $depositHistory = $customer->deposit_history;
                                            if (is_string($depositHistory)) {
                                                $depositHistory = json_decode($depositHistory, true) ?? [];
                                            }
                                            // If it's still not an array (could be null), make it an empty array
                                            if (!is_array($depositHistory)) {
                                                $depositHistory = [];
                                            }
                                        @endphp

                                        @foreach ($depositHistory as $index => $deposit)
                                            <tr>
                                                <td>{{ $no++ }}</td>
                                                <td>
                                                    @if (isset($deposit['date']))
                                                        {{ date('d M Y H:i', strtotime($deposit['date'])) }}
                                                    @else
                                                        Tanggal tidak tersedia
                                                    @endif
                                                </td>
                                                <td>Rp {{ number_format($deposit['amount'] ?? 0, 2) }}</td>
                                                <td>{{ $deposit['description'] ?? '-' }}</td>
                                                <td>
                                                    <form action="{{ route('customer.remove-deposit', $customer->id) }}"
                                                        method="POST" class="d-inline"
                                                        onsubmit="return confirm('Apakah Anda yakin ingin menghapus deposit ini?');">
                                                        @csrf
                                                        @method('DELETE')
                                                        <input type="hidden" name="deposit_index"
                                                            value="{{ $index }}">
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- Tambah Deposit Modal --}}
            @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
                <div class="modal fade" id="tambahDepositModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title">
                                    <i class="fas fa-plus-circle mr-2"></i>Tambah Deposit
                                </h5>
                                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <form action="{{ route('customer.add-deposit', $customer->id) }}" method="POST"
                                id="tambahDepositForm">
                                @csrf
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label>Jumlah Deposit <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">Rp</span>
                                            </div>
                                            <input type="number" step="0.01" name="amount" class="form-control"
                                                placeholder="Jumlah deposit" required>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Tanggal Deposit <span class="text-danger">*</span></label>
                                        <input type="datetime-local" name="deposit_date" class="form-control"
                                            value="{{ now()->format('Y-m-d\TH:i') }}" required>
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Keterangan (Opsional)</label>
                                        <textarea name="description" class="form-control" placeholder="Keterangan deposit (opsional)" rows="2"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                        <i class="fas fa-times mr-1"></i>Batal
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save mr-1"></i>Simpan
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            @endif
        @endif

        <!-- Modal untuk Setting Pricing and Correction yang diperbarui -->
        @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
            <div class="modal fade" id="setPricingModal" tabindex="-1" role="dialog"
                aria-labelledby="setPricingModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="setPricingModalLabel">
                                <i class="fas fa-cog mr-2"></i>Atur Harga & Koreksi Meter untuk Periode Baru
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <form action="{{ route('user.update-pricing', $customer->id) }}" method="POST"
                            id="pricingForm">
                            @csrf
                            <div class="modal-body">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle mr-2"></i>
                                    Pengaturan harga dan koreksi meter ini akan disimpan untuk periode yang dipilih dan akan
                                    berlaku untuk semua pencatatan pada periode tersebut.
                                </div>

                                <!-- Periode -->
                                <div class="form-group">
                                    <label for="pricingDate"><strong>Periode</strong></label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-calendar-alt"></i></span>
                                        </div>
                                        <input type="month" name="pricing_date" id="pricingDate"
                                            class="form-control @error('pricing_date') is-invalid @enderror"
                                            value="{{ now()->format('Y-m') }}" required>
                                        @error('pricing_date')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Harga per meter kubik -->
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="modalHargaPerM3"><strong>Harga per m³</strong></label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text">Rp</span>
                                                </div>
                                                <input type="number" step="0.01" name="harga_per_meter_kubik"
                                                    id="modalHargaPerM3"
                                                    class="form-control @error('harga_per_meter_kubik') is-invalid @enderror"
                                                    value="{{ old('harga_per_meter_kubik', $customer->harga_per_meter_kubik ?? 0) }}"
                                                    placeholder="Masukkan harga per m³" required>
                                                <div class="input-group-append">
                                                    <span class="input-group-text">/m³</span>
                                                </div>
                                                @error('harga_per_meter_kubik')
                                                    <div class="invalid-feedback">{{ $message }}</div>
                                                @enderror
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Tekanan keluar -->
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="modalTekananKeluar"><strong>Tekanan Keluar (Bar)</strong></label>
                                            <div class="input-group">
                                                <input type="number" step="0.001" name="tekanan_keluar"
                                                    id="modalTekananKeluar"
                                                    class="form-control @error('tekanan_keluar') is-invalid @enderror"
                                                    value="{{ old('tekanan_keluar', $customer->tekanan_keluar ?? 0) }}"
                                                    placeholder="Tekanan Keluar" required>
                                                <div class="input-group-append">
                                                    <span class="input-group-text">Bar</span>
                                                </div>
                                                @error('tekanan_keluar')
                                                    <div class="invalid-feedback">{{ $message }}</div>
                                                @enderror
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Suhu -->
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="modalSuhu"><strong>Suhu (°C)</strong></label>
                                            <div class="input-group">
                                                <input type="number" step="0.1" name="suhu" id="modalSuhu"
                                                    class="form-control @error('suhu') is-invalid @enderror"
                                                    value="{{ old('suhu', $customer->suhu ?? 0) }}" placeholder="Suhu"
                                                    required>
                                                <div class="input-group-append">
                                                    <span class="input-group-text">°C</span>
                                                </div>
                                                @error('suhu')
                                                    <div class="invalid-feedback">{{ $message }}</div>
                                                @enderror
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Hasil koreksi meter -->
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="modalHasilKoreksi">
                                                <strong>Hasil Koreksi Meter</strong>
                                                <i class="fas fa-info-circle text-info" data-toggle="tooltip"
                                                    title="Koreksi meter dihitung otomatis berdasarkan tekanan keluar dan suhu"></i>
                                            </label>
                                            <div class="input-group">
                                                <input type="number" step="0.0001" name="koreksi_meter"
                                                    id="modalHasilKoreksi"
                                                    class="form-control @error('koreksi_meter') is-invalid @enderror"
                                                    value="{{ old('koreksi_meter', $customer->koreksi_meter ?? 1) }}"
                                                    readonly>
                                                @error('koreksi_meter')
                                                    <div class="invalid-feedback">{{ $message }}</div>
                                                @enderror
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Footer dengan tombol aksi -->
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                    <i class="fas fa-times mr-1"></i>Batal
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save mr-1"></i>Simpan Perubahan
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        @endif

        {{-- History Pricing Modal --}}
        @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
            <div class="modal fade" id="pricingHistoryModal" tabindex="-1" role="dialog"
                aria-labelledby="pricingHistoryModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-info text-white">
                            <h5 class="modal-title" id="pricingHistoryModalLabel">
                                <i class="fas fa-history mr-2"></i>Riwayat Harga & Koreksi Meter
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <table class="table table-bordered table-striped" id="pricingHistoryTable">
                                <thead>
                                    <tr>
                                        <th>No</th>
                                        <th>Periode</th>
                                        <th>Harga per m³</th>
                                        <th>Tekanan (Bar)</th>
                                        <th>Suhu (°C)</th>
                                        <th>Koreksi Meter</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @php
                                        // Ensure pricing_history is an array before looping
                                        $pricingHistory = $customer->pricing_history;
                                        if (is_string($pricingHistory)) {
                                            $pricingHistory = json_decode($pricingHistory, true) ?? [];
                                        }
                                        // If it's still not an array (could be null), make it an empty array
                                        if (!is_array($pricingHistory)) {
                                            $pricingHistory = [];
                                        }
                                        $no = 1;
                                    @endphp

                                    @foreach ($pricingHistory as $pricing)
                                        <tr>
                                            <td>{{ $no++ }}</td>
                                            <td>
                                                @if (isset($pricing['date']))
                                                    {{ \Carbon\Carbon::parse($pricing['date'])->format('F Y') }}
                                                @else
                                                    Periode tidak tersedia
                                                @endif
                                            </td>
                                            <td>Rp {{ number_format($pricing['harga_per_meter_kubik'] ?? 0, 2) }}</td>
                                            <td>{{ number_format($pricing['tekanan_keluar'] ?? 0, 2) }} Bar</td>
                                            <td>{{ number_format($pricing['suhu'] ?? 0, 2) }} °C</td>
                                            <td>{{ number_format($pricing['koreksi_meter'] ?? 1, 8) }}</td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        @endif
    </div>
@endsection

@section('css')
    <style>
        .table-bordered th,
        .table-bordered td {
            vertical-align: middle !important;
        }

        /* Highlight filtered rows */
        tr.filtered-row {
            background-color: #e8f4ff !important;
        }

        #setPricingModal .form-group {
            margin-bottom: 1.5rem;
        }

        #setPricingModal .input-group-text {
            background-color: #f8f9fa;
            border-color: #ced4da;
        }

        #setPricingModal .form-control {
            height: calc(2.25rem + 2px);
            font-size: 1rem;
        }

        #setPricingModal label {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #495057;
        }

        #setPricingModal .alert-info {
            background-color: #e3f2fd;
            border-color: #b3e5fc;
            color: #0277bd;
        }

        #setPricingModal #modalHasilKoreksi {
            background-color: #f8f9fa;
            color: #495057;
            font-weight: 600;
        }

        #setPricingModal .btn {
            border-radius: 4px;
            padding: 0.375rem 1rem;
        }

        #setPricingModal .input-group-prepend .input-group-text,
        #setPricingModal .input-group-append .input-group-text {
            min-width: 40px;
            justify-content: center;
        }

        #setPricingModal .modal-header {
            padding: 1rem;
            background: linear-gradient(135deg, #007bff, #0055cc);
        }

        #setPricingModal .modal-footer {
            border-top: 1px solid #e9ecef;
            padding: 1rem;
        }

        #setPricingModal .form-control:focus {
            border-color: #80bdff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        /* Memperbaiki tampilan input type="month" pada berbagai browser */
        input[type="month"] {
            -webkit-appearance: none;
            appearance: none;
            padding: 0.375rem 0.75rem;
        }

        /* Responsive styling */
        @media (max-width: 767.98px) {
            #setPricingModal .modal-dialog {
                margin: 0.5rem;
            }

            #setPricingModal .col-md-6 {
                margin-bottom: 1rem;
            }
        }
    </style>
@endsection

@section('js')
    <script>
        $(function() {
            // DataTables initialization
            var table = $("#dataPencatatanTable").DataTable({
                "responsive": true,
                "lengthChange": false,
                "autoWidth": false,
                "ordering": true,
                "order": [
                    [1, 'desc']
                ],
                "language": {
                    "emptyTable": "Tidak ada data pencatatan tersedia",
                    "zeroRecords": "Tidak ada data yang cocok ditemukan",
                    "info": "Menampilkan _START_ hingga _END_ dari _TOTAL_ entri",
                    "infoEmpty": "Menampilkan 0 hingga 0 dari 0 entri",
                    "infoFiltered": "(disaring dari _MAX_ total entri)",
                    "search": "Cari:",
                    "paginate": {
                        "first": "Pertama",
                        "last": "Terakhir",
                        "next": "Selanjutnya",
                        "previous": "Sebelumnya"
                    }
                }
            });

            // Initialize DataTable for deposit history modal
            $("#depositHistoryTable").DataTable({
                "responsive": true,
                "lengthChange": false,
                "autoWidth": false,
                "ordering": true,
                "order": [
                    [1, 'desc']
                ],
                "language": {
                    "emptyTable": "Tidak ada riwayat deposit",
                    "search": "Cari:"
                }
            });

            // Initialize DataTable for pricing history modal
            $("#pricingHistoryTable").DataTable({
                "responsive": true,
                "lengthChange": false,
                "autoWidth": false,
                "ordering": true,
                "order": [
                    [1, 'desc']
                ],
                "language": {
                    "emptyTable": "Tidak ada riwayat harga",
                    "search": "Cari:"
                }
            });

            function formatNumber(number, decimals = 2) {
                return number.toLocaleString('id-ID', {
                    minimumFractionDigits: decimals,
                    maximumFractionDigits: decimals
                });
            }
            // Fungsi untuk menghitung koreksi meter
            function hitungKoreksiMeter() {
                // Ambil nilai tekanan keluar dan suhu
                const tekananKeluar = parseFloat($('#modalTekananKeluar').val()) || 0;
                const suhu = parseFloat($('#modalSuhu').val()) || 0;

                // Perhitungan koreksi meter
                const A = (tekananKeluar + 1.01325) / 1.01325;
                const B = 300 / (suhu + 273);
                const C = 1 + (0.002 * tekananKeluar);

                const hasilKoreksi = A * B * C;

                // Update readonly field
                $('#modalHasilKoreksi').val(hasilKoreksi.toFixed(8));
            }

            // Trigger calculation on input changes in modal
            $('#modalTekananKeluar, #modalSuhu').on('input', function() {
                hitungKoreksiMeter();
            });

            // Trigger initial calculation when modal opens
            $('#setPricingModal').on('show.bs.modal', function() {
                hitungKoreksiMeter();

                // Fokus pada input pertama setelah modal terbuka
                setTimeout(function() {
                    $('#pricingDate').focus();
                }, 500);
            });
            // Validasi input tanggal pricing
            $('#pricingDate').on('change', function() {
                // Memastikan bahwa tanggal yang dipilih valid
                const selectedDate = $(this).val();
                if (!selectedDate) {
                    $(this).addClass('is-invalid');
                    $(this).after('<div class="invalid-feedback">Periode harus diisi</div>');
                } else {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.invalid-feedback').remove();
                }
            });
            $('#pricingForm').on('submit', function(e) {
                // Validasi dasar
                const hargaPerM3 = parseFloat($('#modalHargaPerM3').val());
                const tekananKeluar = parseFloat($('#modalTekananKeluar').val());
                const suhu = parseFloat($('#modalSuhu').val());

                let hasError = false;

                // Validasi harga
                if (isNaN(hargaPerM3) || hargaPerM3 < 0) {
                    $('#modalHargaPerM3').addClass('is-invalid');
                    hasError = true;
                } else {
                    $('#modalHargaPerM3').removeClass('is-invalid');
                }

                // Validasi tekanan
                if (isNaN(tekananKeluar) || tekananKeluar < 0) {
                    $('#modalTekananKeluar').addClass('is-invalid');
                    hasError = true;
                } else {
                    $('#modalTekananKeluar').removeClass('is-invalid');
                }

                // Validasi suhu
                if (isNaN(suhu)) {
                    $('#modalSuhu').addClass('is-invalid');
                    hasError = true;
                } else {
                    $('#modalSuhu').removeClass('is-invalid');
                }

                if (hasError) {
                    e.preventDefault();
                    return false;
                }
            });

            // Initialize tooltips
            $('[data-toggle="tooltip"]').tooltip();

            // Tambah tombol lihat riwayat pricing pada header
            $('.card-tools').prepend(
                '<button class="btn btn-info btn-sm mr-2" data-toggle="modal" data-target="#pricingHistoryModal">' +
                '<i class="fas fa-history mr-1"></i> Riwayat Harga' +
                '</button>'
            );

            // Auto submit form when filter changes (optional)
            /*
            $('#bulan, #tahun').on('change', function() {
                $('#filter-form').submit();
            });
            */
        });
    </script>
@endsection
