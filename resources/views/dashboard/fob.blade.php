@extends('layouts.app')

@section('title', 'Dashboard Customer FOB')

@section('page-title', 'Dashboard Customer FOB')

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

            {{-- Customer Summary Card --}}
            <div class="col-md-12">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-circle mr-2"></i>
                            Informasi Customer FOB: {{ Auth::user()->name }}
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-tachometer-alt mr-1"></i> Total Pemakaian</strong>
                                    <p class="text-muted mb-0">
                                        {{ number_format($totalVolumeSm3 ?? 0, 2) }} Sm³
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-money-bill-wave mr-1"></i> Total Pembelian</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format(Auth::user()->total_purchases ?? 0, 2) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-wallet mr-1"></i> Jumlah Deposit</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format(Auth::user()->total_deposit ?? 0, 2) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-wallet mr-1"></i> Saldo</strong>
                                    <p class="text-muted mb-0">
                                        Rp
                                        {{ number_format((Auth::user()->total_deposit ?? 0) - (Auth::user()->total_purchases ?? 0), 2) }}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- Period Information Card --}}
            <div class="col-md-12">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-line mr-2"></i>
                            Informasi Periode:
                            {{ \Carbon\Carbon::createFromDate($selectedTahun ?? date('Y'), $selectedBulan ?? date('m'), 1)->format('F Y') }}
                        </h3>
                    </div>
                    <div class="card-body">

                        <div class="row mt-3">
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-gas-pump mr-1"></i> Volume Periode Ini</strong>
                                    <p class="text-muted mb-0">
                                        {{ number_format($filteredVolumeSm3 ?? 0, 2) }} Sm³
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-money-bill-wave mr-1"></i> Pembelian Periode Ini</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format($filteredTotalPurchases ?? 0, 0) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-money-bill-wave mr-1"></i> Harga per Sm³</strong>
                                    <p class="text-muted mb-0">
                                        Rp
                                        {{ number_format($pricingInfo['harga_per_meter_kubik'] ?? (Auth::user()->harga_per_meter_kubik ?? 0), 2) }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-balance-scale mr-1"></i> Saldo Periode Bulan Ini</strong>
                                    <p class="text-muted mb-0">
                                        Rp
                                        {{ number_format($realTimeCurrentMonthBalance ?? 0, 0) }}
                                        <span class="badge badge-success"
                                            title="Saldo real-time untuk periode bulan yang dipilih"><i
                                                class="fas fa-sync-alt"></i> Real-time</span>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-6 col-sm-12">
                                <div class="info-box enhanced-info-box"
                                    style="background-color: #f8fafc; border: 1px solid #e2e8f0;">
                                    <span class="info-box-icon bg-info"><i class="fas fa-calculator"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text d-flex justify-content-between align-items-center">
                                            <span>Informasi Saldo Bulan
                                                {{ \Carbon\Carbon::createFromDate($selectedTahun, $selectedBulan, 1)->format('F Y') }}</span>
                                        </span>
                                        <div class="table-responsive mt-2">
                                            <table class="table table-sm table-bordered">
                                                <tr>
                                                    <td width="60%">Saldo Bulan Sebelumnya</td>
                                                    <td>Rp {{ number_format($realTimePrevMonthBalance ?? 0, 0) }}</td>
                                                </tr>
                                                <tr>
                                                    <td>+ Deposit Bulan Ini</td>
                                                    <td>Rp {{ number_format($filteredTotalDeposits ?? 0, 0) }}</td>
                                                </tr>
                                                <tr>
                                                    <td>- Pembelian Bulan Ini</td>
                                                    <td>Rp {{ number_format($filteredTotalPurchases ?? 0, 0) }}</td>
                                                </tr>
                                                <tr class="font-weight-bold">
                                                    <td>= Sisa Saldo Periode Bulan Ini</td>
                                                    <td>Rp {{ number_format($realTimeCurrentMonthBalance ?? 0, 0) }}</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" class="text-muted"><small>* Saldo ini hanya
                                                            menunjukkan saldo untuk periode
                                                            {{ \Carbon\Carbon::createFromDate($selectedTahun, $selectedBulan, 1)->format('F Y') }}
                                                            saja (Perhitungan Real-time)</small></td>
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

            {{-- Filter Form --}}
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
                        <form action="{{ route('fob.filter') }}" method="GET" id="filter-form">
                            <div class="row">
                                <div class="col-md-3 col-sm-6">
                                    <div class="form-group">
                                        <label>Bulan:</label>
                                        <select class="form-control" name="bulan" id="bulan">
                                            @for ($i = 1; $i <= 12; $i++)
                                                <option value="{{ $i }}"
                                                    {{ isset($selectedBulan) && $selectedBulan == $i ? 'selected' : ($i == date('n') && !isset($selectedBulan) ? 'selected' : '') }}>
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
                                                    {{ isset($selectedTahun) && $selectedTahun == $year ? 'selected' : ($year == date('Y') && !isset($selectedTahun) ? 'selected' : '') }}>
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
                                            <a href="{{ route('fob.dashboard') }}" class="btn btn-default">
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

            {{-- Data Pencatatan Table for FOB (simplified) --}}
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-list-alt mr-2"></i>
                            Riwayat Pencatatan
                        </h3>
                    </div>
                    <div class="card-body table-responsive p-0">
                        <table class="table table-bordered table-striped custom-datatable" id="dataPencatatanTable">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Tanggal</th>
                                    <th>Volume Sm³</th>
                                    <th>Alamat Pengambilan</th>
                                    <th>Rupiah</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @php $no = 1; @endphp
                                @forelse ($dataPencatatan as $item)
                                    @php
                                        $dataInput = is_string($item->data_input)
                                            ? json_decode($item->data_input, true)
                                            : (is_array($item->data_input)
                                                ? $item->data_input
                                                : []);

                                        $volumeSm3 = $dataInput['volume_sm3'] ?? 0;

                                        // Get the timestamp for data-filter attribute
                                        $waktuTimestamp = strtotime($dataInput['waktu'] ?? '');
                                        $tanggalFilter = $waktuTimestamp ? date('Y-m-d', $waktuTimestamp) : '';

                                        // Ambil waktu untuk mendapatkan pricing yang tepat
                                        $waktuDateTime = $waktuTimestamp
                                            ? \Carbon\Carbon::createFromTimestamp($waktuTimestamp)
                                            : null;
                                        $waktuYearMonth = $waktuTimestamp ? date('Y-m', $waktuTimestamp) : date('Y-m');

                                        // Ambil pricing info berdasarkan tanggal spesifik
                                        $itemPricingInfo = Auth::user()->getPricingForYearMonth(
                                            $waktuYearMonth,
                                            $waktuDateTime,
                                        );

                                        // Hitung Pembelian dengan harga sesuai periode
                                        $hargaPerM3 = floatval(
                                            $itemPricingInfo['harga_per_meter_kubik'] ??
                                                Auth::user()->harga_per_meter_kubik,
                                        );
                                        $pembelian = $volumeSm3 * $hargaPerM3;
                                    @endphp
                                    <tr data-tanggal="{{ $tanggalFilter }}">
                                        <td>{{ $no++ }}</td>
                                        <td>{{ isset($dataInput['waktu']) ? \Carbon\Carbon::parse($dataInput['waktu'])->format('d M Y H:i') : '-' }}
                                        </td>
                                        <td>{{ number_format($volumeSm3, 2) }}</td>
                                        <td>{{ $dataInput['alamat_pengambilan'] ?? '-' }}</td>
                                        <td>Rp {{ number_format($pembelian, 2) }}</td>
                                        <td>
                                            <div class="btn-group">
                                                @php
                                                    // Extract date from data_input for finding corresponding rekap pengambilan
                                                    $waktuData = $dataInput['waktu'] ?? null;
                                                    $tanggalData = $waktuData
                                                        ? \Carbon\Carbon::parse($waktuData)->format('Y-m-d')
                                                        : null;
                                                @endphp

                                                @if ($tanggalData)
                                                    <a href="{{ route('rekap-pengambilan.find-by-date', [Auth::user()->id, $tanggalData]) }}"
                                                        class="btn btn-info btn-sm" title="Lihat/Edit Rekap Pengambilan">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                @else
                                                    <a href="{{ route('data-pencatatan.show', $item->id) }}"
                                                        class="btn btn-info btn-sm">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                @endif

                                                @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
                                                    @if ($tanggalData)
                                                        <a href="{{ route('rekap-pengambilan.find-by-date', [Auth::user()->id, $tanggalData]) }}"
                                                            class="btn btn-warning btn-sm" title="Edit Rekap Pengambilan">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    @else
                                                        <a href="{{ route('data-pencatatan.edit', $item->id) }}"
                                                            class="btn btn-warning btn-sm">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    @endif

                                                    <form action="{{ route('data-pencatatan.destroy', $item->id) }}"
                                                        method="POST" class="d-inline"
                                                        onsubmit="return confirm('Apakah Anda yakin ingin menghapus data ini?');">
                                                        @csrf
                                                        @method('DELETE')
                                                        <input type="hidden" name="bulan"
                                                            value="{{ $selectedBulan }}">
                                                        <input type="hidden" name="tahun"
                                                            value="{{ $selectedTahun }}">
                                                        <input type="hidden" name="fob" value="1">
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                @endif
                                            </div>
                                        </td>
                                    </tr>
                                @empty
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            <div class="py-3">
                                                <i class="fas fa-inbox fa-3x mb-3 text-muted"></i>
                                                <h5>Tidak ada data untuk periode ini</h5>
                                                <p class="text-muted">Data riwayat pencatatan FOB belum tersedia untuk periode {{ \Carbon\Carbon::createFromDate($selectedTahun, $selectedBulan, 1)->format('F Y') }}</p>
                                                <small class="text-info">
                                                    <i class="fas fa-info-circle"></i>
                                                    Silakan pilih periode lain atau hubungi administrator jika data seharusnya ada
                                                </small>
                                            </div>
                                        </td>
                                    </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
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

        /* Mobile Summary Card Styling */
        .mobile-summary-card {
            padding: 15px;
            margin-bottom: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .mobile-summary-card strong {
            display: block;
            margin-bottom: 5px;
            color: #495057;
        }

        .mobile-summary-card p {
            font-size: 1.2rem;
            font-weight: 500;
        }

        /* Responsive adjustments */
        @media (max-width: 767.98px) {
            .card-title {
                font-size: 1.1rem;
            }

            .mobile-summary-card {
                padding: 10px;
            }

            .card-body {
                padding: 0.75rem;
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

            // Initialize tooltips
            $('[data-toggle="tooltip"]').tooltip();
        });
    </script>
@endsection
