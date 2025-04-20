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
                        <h3 class="card-title">
                            <i class="fas fa-list-alt mr-1"></i>
                            Data Rekap Pengambilan - {{ date('F Y', mktime(0, 0, 0, $bulan, 1, $tahun)) }}
                        </h3>
                    </div>
                    <div class="card-body table-responsive p-0">
                        <table class="table table-hover text-nowrap" id="rekapPengambilanTable">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Customer</th>
                                    <th>Tanggal</th>
                                    <th>NOPOL</th>
                                    <th>Volume (SM³)</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @if (count($rekapPengambilan) > 0)
                                    @php $no = 1; @endphp
                                    @foreach ($rekapPengambilan as $rekap)
                                        <tr>
                                            <td>{{ $no++ }}</td>
                                            <td>{{ $rekap->customer->name }}</td>
                                            <td>{{ $rekap->tanggal->format('d M Y H:i') }}</td>
                                            <td>{{ $rekap->nopol }}</td>
                                            <td>{{ number_format($rekap->volume, 2) }}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="{{ route('rekap-pengambilan.show', $rekap->id) }}"
                                                        class="btn btn-info btn-sm">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="{{ route('rekap-pengambilan.edit', $rekap->id) }}"
                                                        class="btn btn-warning btn-sm">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <form action="{{ route('rekap-pengambilan.destroy', $rekap->id) }}"
                                                        method="POST"
                                                        onsubmit="return confirm('Apakah Anda yakin ingin menghapus data ini?');">
                                                        @csrf
                                                        @method('DELETE')
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    @endforeach
                                @else
                                    <tr>
                                        <td colspan="6" class="text-center">Tidak ada data untuk ditampilkan</td>
                                    </tr>
                                @endif
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('js')
    <script>
        $(function() {
            $('#rekapPengambilanTable').DataTable({
                "paging": true,
                "lengthChange": false,
                "searching": true,
                "ordering": true,
                "info": true,
                "autoWidth": false,
                "responsive": true,
                "language": {
                    "emptyTable": "Tidak ada data yang tersedia",
                    "info": "Menampilkan _START_ hingga _END_ dari _TOTAL_ entri",
                    "infoEmpty": "Menampilkan 0 hingga 0 dari 0 entri",
                    "infoFiltered": "(disaring dari total _MAX_ entri)",
                    "search": "Cari:",
                    "paginate": {
                        "first": "Pertama",
                        "last": "Terakhir",
                        "next": "Selanjutnya",
                        "previous": "Sebelumnya"
                    }
                }
            });

            // Auto submit form when date changes
            $('#tanggal').on('change', function() {
                $(this).closest('form').submit();
            });
        });
    </script>
@endsection
