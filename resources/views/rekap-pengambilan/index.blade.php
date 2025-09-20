@extends('layouts.app')

@section('title', 'Rekap Pengambilan')

@section('page-title', 'Rekap Pengambilan')

@section('content')
    <div class="container-fluid">
        <!-- Notifikasi -->
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

        <!-- Tombol Tambah Data -->
        <div class="row mb-3">
            <div class="col-md-12">
                <a href="{{ route('rekap-pengambilan.create') }}" class="btn btn-primary">
                    <i class="fas fa-plus-circle mr-1"></i> Tambah Data
                </a>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-light">
                        <h3 class="card-title"><i class="fas fa-filter mr-2"></i>Filter Data</h3>
                    </div>
                    <div class="card-body py-3">
                        <form action="{{ route('rekap-pengambilan.index') }}" method="GET"
                            class="d-flex align-items-center flex-wrap">
                            <div class="d-flex align-items-center mr-4 mb-2">
                                <label for="tanggal" class="mb-0 mr-2 font-weight-bold">Tanggal:</label>
                                <input type="date" name="tanggal" id="tanggal" class="form-control form-control-sm"
                                    style="width: 180px;" value="{{ $tanggal }}">
                            </div>

                            <div class="mb-2">
                                <button type="submit" class="btn btn-sm btn-primary">
                                    <i class="fas fa-search mr-1"></i> Terapkan Filter
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Informasi Ringkasan -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="info-box bg-info">
                    <span class="info-box-icon"><i class="fas fa-calendar-alt"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text text-white">Total Volume Bulanan</span>
                        <span class="info-box-number">{{ number_format($totalVolumeBulanan, 2) }} SM³</span>
                        <span class="info-box-text text-white">{{ date('F Y', mktime(0, 0, 0, $bulan, 1, $tahun)) }}</span>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="info-box bg-success">
                    <span class="info-box-icon"><i class="fas fa-truck"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text text-white">Total Volume Harian</span>
                        <span class="info-box-number">{{ number_format($totalVolumeHarian, 2) }} SM³</span>
                        <span class="info-box-text text-white">{{ \Carbon\Carbon::parse($tanggal)->format('d F Y') }}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabel Data -->
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="card-title">
                                <i class="fas fa-list-alt mr-1"></i>
                                Data Rekap Pengambilan - {{ date('F Y', mktime(0, 0, 0, $bulan, 1, $tahun)) }}
                            </h3>
                        </div>
                        <div class="mt-3">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                </div>
                                <input type="text" id="searchData" class="form-control" 
                                       placeholder="Cari customer, nopol, alamat, volume..." value="{{ request('search') }}">
                            </div>
                        </div>
                    </div>
                    <div class="card-body" id="rekap-table-container">
                        @include('rekap-pengambilan.partials.table', ['rekapPengambilan' => $rekapPengambilan])
                    </div>
                    <div class="card-footer clearfix">
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('js')
    <script>
        $(document).ready(function() {
            // Timer untuk debounce pencarian
            let searchTimer;

            // Event listener untuk pencarian data real-time
            $('#searchData').on('input', function() {
                const searchTerm = $(this).val();
                const tanggal = $('#tanggal').val();
                
                clearTimeout(searchTimer);

                searchTimer = setTimeout(function() {
                    $('#rekap-table-container').html(
                        '<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x"></i></div>'
                    );

                    $.ajax({
                        url: '{{ route('rekap-pengambilan.index') }}',
                        type: 'GET',
                        data: { 
                            search: searchTerm,
                            tanggal: tanggal
                        },
                        dataType: 'json',
                        success: function(response) {
                            $('#rekap-table-container').html(response.html);
                        },
                        error: function() {
                            $('#rekap-table-container').html(
                                '<div class="alert alert-danger">Terjadi kesalahan saat mengambil data</div>'
                            );
                        }
                    });
                }, 300);
            });
            
            // Auto submit form when date changes dan reset search
            $('#tanggal').on('change', function() {
                // Reset search input
                $('#searchData').val('');
                // Submit form untuk filter tanggal
                $(this).closest('form').submit();
            });
        });
    </script>
@endsection
