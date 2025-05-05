@extends('layouts.app')

@section('title', 'Detail Data Pencatatan FOB')

@section('page-title', 'Data Pencatatan - ' . $customer->name)

@section('content')
    <div class="container-fluid">
        {{-- DEBUG INFO --}}
        @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
            <div class="row">
                <div class="col-12">
                    <div class="card collapsed-card">

                        <div class="card-body">
                            <h5>Customer Info:</h5>
                            <ul>
                                <li>ID: {{ $customer->id }}</li>
                                <li>Name: {{ $customer->name }}</li>
                                <li>Role: {{ $customer->role }}</li>
                                <li>isFOB(): {{ $customer->isFOB() ? 'true' : 'false' }}</li>
                                <li>Current harga: {{ $customer->harga_per_meter_kubik }}</li>
                            </ul>
                            <h5>Pricing History:</h5>
                            <pre>{{ json_encode($customer->pricing_history, JSON_PRETTY_PRINT) }}</pre>
                            <p>Debug Links:</p>
                            <a href="{{ route('fob.debug', $customer->id) }}" class="btn btn-warning" target="_blank">Open
                                Debug Page</a>
                        </div>
                    </div>
                </div>
            </div>
        @endif
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

            {{-- FOB Summary Card --}}
            <div class="col-md-12">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-circle mr-2"></i>
                            Informasi FOB: {{ $customer->name }}
                        </h3>
                        <div class="card-tools">
                            @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
                                <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#setPricingModal">
                                    <i class="fas fa-cog mr-1"></i> Atur Harga
                                </button>
                                <button class="btn btn-success btn-sm" data-toggle="modal"
                                    data-target="#depositHistoryModal">
                                    <i class="fas fa-money-bill-alt mr-1"></i> History Deposit
                                </button>
                                <a href="{{ route('data-pencatatan.fob.sync-data', $customer->id) }}"
                                    class="btn btn-warning btn-sm" onclick="return confirm('Apakah Anda yakin ingin menyinkronkan data rekap pengambilan?')">
                                    <i class="fas fa-sync mr-1"></i> Sinkronkan Data
                                </a>
                                <a href="{{ route('data-pencatatan.fob.create-with-fob', $customer->id) }}"
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
                        <form action="{{ route('data-pencatatan.fob.filter-month-year', $customer->id) }}" method="POST"
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
                                            <a href="{{ route('data-pencatatan.fob-detail', $customer->id) }}"
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
                        <table class="table table-bordered table-striped" id="dataPencatatanTable">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Tanggal</th>
                                    <th>Volume Sm³</th>
                                    <th>Rupiah</th>
                                    <th>Aksi</th>
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

                                        $volumeSm3 = $dataInput['volume_sm3'] ?? 0;

                                        // Hitung Pembelian
                                        $pembelian = $volumeSm3 * $customer->harga_per_meter_kubik;

                                        // Get the timestamp for data-filter attribute
                                        $waktuTimestamp = strtotime($dataInput['waktu'] ?? '');
                                        $tanggalFilter = $waktuTimestamp ? date('Y-m-d', $waktuTimestamp) : '';
                                    @endphp
                                    <tr data-tanggal="{{ $tanggalFilter }}">
                                        <td>{{ $no++ }}</td>
                                        <td>{{ isset($dataInput['waktu']) ? \Carbon\Carbon::parse($dataInput['waktu'])->format('d M Y H:i') : '-' }}
                                        </td>
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
                                        @php $no = 1; @endphp
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

        <!-- Modal untuk Setting Pricing (simplified for FOB) -->
        @if (Auth::user()->isAdmin() || Auth::user()->isSuperAdmin())
            <div class="modal fade" id="setPricingModal" tabindex="-1" role="dialog"
                aria-labelledby="setPricingModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="setPricingModalLabel">
                                <i class="fas fa-cog mr-2"></i>Atur Harga FOB untuk Periode Baru
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <form action="{{ route('fob.update-pricing', $customer->id) }}" method="POST" id="pricingForm">
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
                                                    value="0" placeholder="Tekanan Keluar" readonly>
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
                                                    value="0" placeholder="Suhu" readonly>
                                                <div class="input-group-append">
                                                    <span class="input-group-text">°C</span>
                                                </div>
                                                @error('suhu')
                                                    <div class="invalid-feedback">{{ $message }}</div>
                                                @enderror
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
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <script>
        // Set up CSRF token for AJAX requests
        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

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

            // Initialize tooltips
            $('[data-toggle="tooltip"]').tooltip();

            $("#pricingForm").on("submit", function(e) {
                e.preventDefault(); // Prevent default form submission

                // Disable button and show loading indicator
                $("#savePricingButton").prop('disabled', true).html(
                    '<i class="fas fa-spinner fa-spin mr-1"></i> Menyimpan...');

                // Get form data
                var formData = $(this).serialize();

                // Get target URL
                var targetUrl = $(this).attr('action');

                // Make an AJAX request to submit the form
                $.ajax({
                    url: targetUrl,
                    type: 'POST',
                    data: formData,
                    dataType: 'json',
                    success: function(response) {
                        // Enable button and restore text
                        $("#savePricingButton").prop('disabled', false).html(
                            '<i class="fas fa-save mr-1"></i> Simpan Perubahan');

                        if (response.success) {
                            // Show success message
                            alert(response.message || "Harga berhasil diperbarui!");

                            // Close the modal
                            $('#setPricingModal').modal('hide');

                            // Reload the page to see changes
                            location.reload();
                        } else {
                            // Show error message from response
                            alert("Gagal: " + (response.message ||
                                "Terjadi kesalahan saat memperbarui harga"));
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error submitting form:", error);
                        console.log("Status:", status);
                        console.log("Response Text:", xhr.responseText);

                        // Enable button and restore text
                        $("#savePricingButton").prop('disabled', false).html(
                            '<i class="fas fa-save mr-1"></i> Simpan Perubahan');

                        // Try to parse JSON response if available
                        try {
                            var errorResponse = JSON.parse(xhr.responseText);
                            alert("Error: " + (errorResponse.message || error));
                        } catch (e) {
                            alert("Error: " + error + "\nSilakan periksa console untuk detail");
                        }
                    }
                });

                return false; // Prevent default form submission
            });
        });
    </script>
@endsection
