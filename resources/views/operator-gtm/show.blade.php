@extends('layouts.app')

@section('title', 'Detail Operator GTM')

@section('page-title', 'Detail Operator GTM - ' . $operatorGtm->nama)

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

            {{-- Operator Summary Card --}}
            <div class="col-md-12">
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-circle mr-2"></i>
                            Informasi Operator: {{ $operatorGtm->nama }}
                        </h3>
                        <div class="card-tools">
                            <a href="{{ route('operator-gtm.edit', $operatorGtm->id) }}" class="btn btn-warning btn-sm">
                                <i class="fas fa-edit mr-1"></i> Edit
                            </a>
                            <form action="{{ route('operator-gtm.destroy', $operatorGtm->id) }}" method="POST" class="d-inline">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus operator ini?')">
                                    <i class="fas fa-trash mr-1"></i> Hapus
                                </button>
                            </form>
                            <a href="{{ route('operator-gtm.index') }}" class="btn btn-secondary btn-sm">
                                <i class="fas fa-arrow-left mr-1"></i> Kembali
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-user mr-1"></i> Nama Operator</strong>
                                    <p class="text-muted mb-0">
                                        {{ $operatorGtm->nama }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-map-marker-alt mr-1"></i> Lokasi Kerja</strong>
                                    <p class="text-muted mb-0">
                                        {{ $operatorGtm->lokasi_kerja }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-wallet mr-1"></i> Gaji Pokok</strong>
                                    <p class="text-muted mb-0">
                                        Rp {{ number_format($operatorGtm->gaji_pokok, 0, ',', '.') }}
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="mobile-summary-card">
                                    <strong><i class="fas fa-calendar-alt mr-1"></i> Tanggal Bergabung</strong>
                                    <p class="text-muted mb-0">
                                        {{ $operatorGtm->created_at->format('d M Y') }}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- Filter Periode --}}
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
                        <form action="{{ route('operator-gtm.show', $operatorGtm->id) }}" method="GET" id="filter-form">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Dari Tanggal:</label>
                                        <input type="date" class="form-control" name="start_date" id="start_date" value="{{ request('start_date') }}">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Sampai Tanggal:</label>
                                        <input type="date" class="form-control" name="end_date" id="end_date" value="{{ request('end_date') }}">
                                    </div>
                                </div>
                                <div class="col-md-4 d-flex align-items-end">
                                    <div class="form-group mb-0 w-100">
                                        <button type="submit" class="btn btn-primary btn-block">
                                            <i class="fas fa-search mr-1"></i> Terapkan Filter
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-12">
                                    <a href="{{ route('operator-gtm.show', $operatorGtm->id) }}" class="btn btn-default btn-sm">
                                        <i class="fas fa-sync-alt mr-1"></i> Reset Filter
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            {{-- Lembur Summary Card --}}
            <div class="col-md-12">
                <div class="card card-success">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-line mr-2"></i>
                            Ringkasan Lembur
                            @if(request('start_date') && request('end_date'))
                                - {{ \Carbon\Carbon::parse(request('start_date'))->format('d M Y') }} s/d {{ \Carbon\Carbon::parse(request('end_date'))->format('d M Y') }}
                            @endif
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 col-sm-6">
                                <div class="info-box enhanced-info-box">
                                    <span class="info-box-icon bg-warning"><i class="fas fa-clock"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Total Jam Lembur</span>
                                        <span class="info-box-number">
                                            @if(request('start_date') && request('end_date'))
                                                @php
                                                    $filteredRecords = $lemburRecords;
                                                    
                                                    // Filter berdasarkan tanggal jika ada di view (untuk client-side filtering)
                                                    $startDate = \Carbon\Carbon::parse(request('start_date'));
                                                    $endDate = \Carbon\Carbon::parse(request('end_date'));
                                                    
                                                    $filteredRecords = $lemburRecords->filter(function($record) use ($startDate, $endDate) {
                                                        $recordDate = \Carbon\Carbon::parse($record->tanggal);
                                                        return $recordDate->between($startDate, $endDate);
                                                    });
                                                    
                                                    $totalJamLembur = $filteredRecords->sum('total_jam_lembur');
                                                    echo floor($totalJamLembur / 60) . ' jam ' . ($totalJamLembur % 60) . ' menit';
                                                @endphp
                                            @else
                                                <span class="text-muted">Pilih periode terlebih dahulu</span>
                                            @endif
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 col-sm-6">
                                <div class="info-box enhanced-info-box">
                                    <span class="info-box-icon bg-danger"><i class="fas fa-money-bill-wave"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Total Upah Lembur</span>
                                        <span class="info-box-number">
                                            @if(request('start_date') && request('end_date'))
                                                @php
                                                    $totalUpahLembur = $filteredRecords->sum('upah_lembur');
                                                @endphp
                                                Rp {{ number_format($totalUpahLembur, 0, ',', '.') }}
                                            @else
                                                <span class="text-muted">Pilih periode terlebih dahulu</span>
                                            @endif
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 col-sm-6">
                                <div class="info-box enhanced-info-box">
                                    <span class="info-box-icon bg-primary"><i class="fas fa-calculator"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Total yang Harus Dibayarkan</span>
                                        <span class="info-box-number">
                                            @php
                                                // Selalu tampilkan gaji pokok, terlepas dari filter
                                                $gajiPokok = $operatorGtm->gaji_pokok;
                                                
                                                // Hitung upah lembur hanya jika ada filter periode
                                                $totalUpahLembur = 0;
                                                if (request('start_date') && request('end_date')) {
                                                    $totalUpahLembur = $filteredRecords->sum('upah_lembur');
                                                }
                                                
                                                $totalPembayaran = $gajiPokok + $totalUpahLembur;
                                            @endphp
                                            Rp {{ number_format($totalPembayaran, 0, ',', '.') }}
                                        </span>
                                        <span class="text-sm text-muted">Gaji Pokok + Upah Lembur</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- Data Lembur Table --}}
            @if(request('start_date') && request('end_date'))
            <div class="col-md-12">
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-list-alt mr-2"></i>
                            Data Lembur
                            @if(request('start_date') && request('end_date'))
                                - {{ \Carbon\Carbon::parse(request('start_date'))->format('d M Y') }} s/d {{ \Carbon\Carbon::parse(request('end_date'))->format('d M Y') }}
                            @endif
                        </h3>
                        <div class="card-tools">
                            <a href="{{ route('operator-gtm.create-lembur', $operatorGtm->id) }}" class="btn btn-success btn-sm">
                                <i class="fas fa-plus mr-1"></i> Tambah Data Lembur
                            </a>
                        </div>
                    </div>
                    <div class="card-body table-responsive p-0">
                        <table class="table table-bordered table-striped table-hover" id="dataLemburTable">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Tanggal</th>
                                    <th>Sesi 1</th>
                                    <th>Sesi 2</th>
                                    <th>Sesi 3</th>
                                    <th>Total Jam Kerja</th>
                                    <th>Jam Lembur</th>
                                    <th>Upah Lembur</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @php $no = 1; @endphp
                                @forelse($lemburRecords as $record)
                                    @php
                                        // Filter berdasarkan range tanggal
                                        if (request('start_date') && request('end_date')) {
                                            $startDate = \Carbon\Carbon::parse(request('start_date'));
                                            $endDate = \Carbon\Carbon::parse(request('end_date'));
                                            $recordDate = \Carbon\Carbon::parse($record->tanggal);
                                            
                                            if (!$recordDate->between($startDate, $endDate)) {
                                                continue; // Skip record jika tidak dalam range
                                            }
                                        }
                                    @endphp
                                    <tr>
                                        <td>{{ $no++ }}</td>
                                        <td>{{ \Carbon\Carbon::parse($record->tanggal)->format('d M Y') }}</td>
                                        <td>
                                            @if($record->jam_masuk_sesi_1 && $record->jam_keluar_sesi_1)
                                                {{ substr($record->jam_masuk_sesi_1, 0, 5) }} - {{ substr($record->jam_keluar_sesi_1, 0, 5) }}
                                            @else
                                                -
                                            @endif
                                        </td>
                                        <td>
                                            @if($record->jam_masuk_sesi_2 && $record->jam_keluar_sesi_2)
                                                {{ substr($record->jam_masuk_sesi_2, 0, 5) }} - {{ substr($record->jam_keluar_sesi_2, 0, 5) }}
                                            @else
                                                -
                                            @endif
                                        </td>
                                        <td>
                                            @if($record->jam_masuk_sesi_3 && $record->jam_keluar_sesi_3)
                                                {{ substr($record->jam_masuk_sesi_3, 0, 5) }} - {{ substr($record->jam_keluar_sesi_3, 0, 5) }}
                                            @else
                                                -
                                            @endif
                                        </td>
                                        <td>{{ floor($record->total_jam_kerja / 60) }} jam {{ $record->total_jam_kerja % 60 }} menit</td>
                                        <td>{{ floor($record->total_jam_lembur / 60) }} jam {{ $record->total_jam_lembur % 60 }} menit</td>
                                        <td>Rp {{ number_format($record->upah_lembur, 0, ',', '.') }}</td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="{{ route('operator-gtm.edit-lembur', $record->id) }}" class="btn btn-warning btn-sm">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <form action="{{ route('operator-gtm.destroy-lembur', $record->id) }}" method="POST" class="d-inline">
                                                    @csrf
                                                    @method('DELETE')
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus data lembur ini?')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                @empty
                                    <tr>
                                        <td colspan="9" class="text-center">Belum ada data lembur dalam periode ini.</td>
                                    </tr>
                                @endforelse
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="6" class="text-right">Total:</th>
                                    <th>
                                        @php
                                            echo floor($totalJamLembur / 60) . ' jam ' . ($totalJamLembur % 60) . ' menit';
                                        @endphp
                                    </th>
                                    <th>
                                        Rp {{ number_format($totalUpahLembur, 0, ',', '.') }}
                                    </th>
                                    <th></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
            @else
            <div class="col-md-12">
                <div class="card card-warning">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-info-circle mr-2"></i>
                            Informasi
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle mr-1"></i> Silahkan pilih periode tanggal terlebih dahulu untuk melihat data lembur operator.
                        </div>
                    </div>
                </div>
            </div>
            @endif
        </div>
    </div>
@endsection

@section('css')
<style>
    /* Style untuk info box */
    .enhanced-info-box {
        border-radius: 6px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s, box-shadow 0.2s;
    }
    
    .enhanced-info-box:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }
    
    .mobile-summary-card {
        margin-bottom: 15px;
        padding: 10px;
        border-radius: 5px;
        background-color: #f8f9fa;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        transition: all 0.2s ease;
    }
    
    .mobile-summary-card:hover {
        background-color: #e9ecef;
    }
    
    /* Responsiveness */
    @media (max-width: 767.98px) {
        .card-tools .btn {
            margin-bottom: 5px;
        }
        
        .card-tools {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
        }
    }
    
    /* Table styling */
    .table-bordered th,
    .table-bordered td {
        vertical-align: middle !important;
    }
    
    .table th {
        background-color: #f4f6f9;
    }
    
    .table tfoot th {
        background-color: #e9ecef;
    }
</style>
@endsection

@section('js')
<script>
    $(function() {
        // Validasi range tanggal
        $('#filter-form').on('submit', function(e) {
            var startDate = $('#start_date').val();
            var endDate = $('#end_date').val();
            
            if ((startDate && !endDate) || (!startDate && endDate)) {
                e.preventDefault();
                alert('Silakan pilih kedua tanggal untuk melakukan filter.');
                return false;
            }
            
            if (startDate && endDate && startDate > endDate) {
                e.preventDefault();
                alert('Tanggal mulai tidak boleh lebih besar dari tanggal akhir.');
                return false;
            }
        });
        
        // DataTables initialization
        var table = $("#dataLemburTable").DataTable({
            "responsive": true,
            "lengthChange": false,
            "autoWidth": false,
            "ordering": true,
            "order": [[1, 'desc']], // Sorting by date
            "language": {
                "emptyTable": "Tidak ada data lembur tersedia",
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
        
        // Add animations to cards on hover
        $('.card').css('opacity', 0); // Initially hide
        $('.mobile-summary-card').css('opacity', 0); // Initially hide
        
        // Show elements with animation
        $(window).on('load', function() {
            // Animate elements one by one
            $('.card').each(function(i) {
                $(this).delay(i * 150).animate({
                    'opacity': 1
                }, 500);
            });
            $('.mobile-summary-card').each(function(i) {
                $(this).delay(i * 100).animate({
                    'opacity': 1
                }, 500);
            });
        });
    });
</script>
@endsection