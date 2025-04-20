@extends('layouts.app')

@section('title', 'Dashboard')

@section('page-title', 'Dashboard')

@section('content')
    <style>
        .nav-pills .nav-link:not(.active) {
            color: white !important;
            transition: all 0.3s ease;
        }

        .nav-pills .nav-link:not(.active):hover {
            color: white !important;
            background-color: #28a745 !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
    </style>
    <!-- Filter Section -->
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-light">
                    <h3 class="card-title"><i class="fas fa-filter mr-2"></i>Filter Data</h3>
                </div>
                <div class="card-body py-3">
                    <form action="{{ route('admin.dashboard') }}" method="GET" class="d-flex align-items-center flex-wrap">
                        <div class="d-flex align-items-center mr-4 mb-2">
                            <label for="tahun" class="mb-0 mr-2 font-weight-bold">Tahun:</label>
                            <select name="tahun" id="tahun" class="form-control form-control-sm" style="width: 100px;"
                                onchange="this.form.submit()">
                                @foreach ($availableYears as $year)
                                    <option value="{{ $year }}" {{ $selectedTahun == $year ? 'selected' : '' }}>
                                        {{ $year }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="d-flex align-items-center mb-2">
                            <label for="bulan" class="mb-0 mr-2 font-weight-bold">Bulan:</label>
                            <select name="bulan" id="bulan" class="form-control form-control-sm" style="width: 150px;"
                                onchange="this.form.submit()">
                                @for ($i = 1; $i <= 12; $i++)
                                    <option value="{{ $i }}" {{ $selectedBulan == $i ? 'selected' : '' }}>
                                        {{ date('F', mktime(0, 0, 0, $i, 1)) }}
                                    </option>
                                @endfor
                            </select>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>



    <!-- TABS REKAP PENJUALAN & PENGAMBILAN -->
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-light p-2">
                    <ul class="nav nav-pills">
                        <li class="nav-item"><a class="nav-link active font-weight-bold" href="#rekap-penjualan"
                                data-toggle="tab"><i class="fas fa-chart-line mr-1"></i>Rekap Penjualan</a></li>
                        <li class="nav-item"><a class="nav-link font-weight-bold text-white" href="#rekap-pengambilan"
                                data-toggle="tab"><i class="fas fa-truck-loading mr-1"></i>Rekap Pengambilan</a></li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <!-- Tab Rekap Penjualan -->
                        <div class="tab-pane active" id="rekap-penjualan">
                            <!-- Tombol Cetak Rekap Penjualan -->
                            <div class="mb-3 text-right">
                                <a href="{{ route('rekap.penjualan.cetak', ['tahun' => $selectedTahun]) }}" class="btn btn-success btn-sm" target="_blank">
                                    <i class="fas fa-print mr-1"></i> Cetak Rekap Penjualan
                                </a>
                            </div>
                            <!-- Yearly Summary -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header bg-primary text-white">
                                            <h3 class="card-title">Rekap Penjualan Tahunan - {{ $selectedTahun }}</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="info-box bg-info">
                                                        <span class="info-box-icon"><i
                                                                class="fas fa-tachometer-alt"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text text-white">Total Pemakaian
                                                                (SM3)</span>
                                                            <span
                                                                class="info-box-number text-white">{{ number_format($penjualanTahunanData['total_pemakaian'], 2) }}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="info-box bg-success">
                                                        <span class="info-box-icon"><i
                                                                class="fas fa-money-bill-wave"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text text-white">Total Penjualan
                                                                (Rp)</span>
                                                            <span
                                                                class="info-box-number text-white">{{ number_format($penjualanTahunanData['total_pembelian']) }}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Grafik Tahunan -->
                                            <div class="row mt-4">
                                                <div class="col-md-6">
                                                    <div class="card card-outline card-primary">
                                                        <div class="card-header">
                                                            <h3 class="card-title"><i
                                                                    class="fas fa-tachometer-alt mr-1"></i> Pemakaian
                                                                Bulanan (SM3) - {{ $selectedTahun }}</h3>
                                                        </div>
                                                        <div class="card-body">
                                                            <canvas id="yearlyUsageChart"
                                                                style="min-height: 250px; height: 250px; max-height: 300px; max-width: 100%;"></canvas>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="card card-outline card-success">
                                                        <div class="card-header">
                                                            <h3 class="card-title"><i
                                                                    class="fas fa-money-bill-wave mr-1"></i> Penjualan
                                                                Bulanan (Juta Rp) - {{ $selectedTahun }}</h3>
                                                        </div>
                                                        <div class="card-body">
                                                            <canvas id="yearlySalesChart"
                                                                style="min-height: 250px; height: 250px; max-height: 300px; max-width: 100%;"></canvas>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Monthly Summary -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header bg-success text-white">
                                            <h3 class="card-title">Rekap Penjualan Bulanan -
                                                {{ date('F', mktime(0, 0, 0, $selectedBulan, 1)) }}
                                                {{ $selectedTahun }}</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="info-box bg-info">
                                                        <span class="info-box-icon"><i
                                                                class="fas fa-tachometer-alt"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text text-white">Total Pemakaian
                                                                (SM3)</span>
                                                            <span
                                                                class="info-box-number text-white">{{ number_format($penjualanBulananData['total_pemakaian'], 2) }}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="info-box bg-success">
                                                        <span class="info-box-icon"><i
                                                                class="fas fa-money-bill-wave"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text text-white">Total Penjualan
                                                                (Rp)</span>
                                                            <span
                                                                class="info-box-number text-white">{{ number_format($penjualanBulananData['total_pembelian']) }}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Grafik Bulanan -->
                                            <div class="row mt-4">
                                                <div class="col-md-6">
                                                    <div class="card card-outline card-info">
                                                        <div class="card-header">
                                                            <h3 class="card-title"><i
                                                                    class="fas fa-tachometer-alt mr-1"></i> Pemakaian
                                                                Harian (SM3) -
                                                                {{ date('F', mktime(0, 0, 0, $selectedBulan, 1)) }}</h3>
                                                        </div>
                                                        <div class="card-body">
                                                            <canvas id="monthlyUsageChart"
                                                                style="min-height: 250px; height: 250px; max-height: 300px; max-width: 100%;"></canvas>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="card card-outline card-success">
                                                        <div class="card-header">
                                                            <h3 class="card-title"><i
                                                                    class="fas fa-money-bill-wave mr-1"></i> Penjualan
                                                                Harian (Juta Rp) -
                                                                {{ date('F', mktime(0, 0, 0, $selectedBulan, 1)) }}</h3>
                                                        </div>
                                                        <div class="card-body">
                                                            <canvas id="monthlySalesChart"
                                                                style="min-height: 250px; height: 250px; max-height: 300px; max-width: 100%;"></canvas>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Customer Details Table -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header bg-light">
                                            <h3 class="card-title"><i class="fas fa-users mr-1"></i>Data Penjualan Per
                                                Customer</h3>
                                        </div>
                                        <div class="card-body table-responsive p-0">
                                            <table class="table table-hover table-striped">
                                                <thead>
                                                    <tr>
                                                        <th class="text-primary">Nama Customer</th>
                                                        <th class="text-primary">Tipe</th>
                                                        <th class="text-primary">Total Pemakaian (SM3)</th>
                                                        <th class="text-primary">Total Penjualan (Rp)</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    @if (count($customerPenjualanData) > 0)
                                                        @foreach ($customerPenjualanData as $data)
                                                            <tr>
                                                                <td>{{ $data['nama'] }}</td>
                                                                <td>
                                                                    @if ($data['role'] == 'customer')
                                                                        <span class="badge badge-primary">Customer</span>
                                                                    @else
                                                                        <span class="badge badge-warning">FOB</span>
                                                                    @endif
                                                                </td>
                                                                <td>
                                                                    <p class="mb-0">Tahun:
                                                                        {{ number_format($data['pemakaian_tahun'], 2) }}
                                                                    </p>
                                                                    <small class="text-info">Bulan:
                                                                        {{ number_format($data['pemakaian_bulan'], 2) }}</small>
                                                                </td>
                                                                <td>
                                                                    <p class="mb-0">Tahun:
                                                                        {{ number_format($data['pembelian_tahun']) }}</p>
                                                                    <small class="text-success">Bulan:
                                                                        {{ number_format($data['pembelian_bulan']) }}</small>
                                                                </td>
                                                            </tr>
                                                        @endforeach
                                                    @else
                                                        <tr>
                                                            <td colspan="4" class="text-center">Tidak ada data untuk
                                                                ditampilkan.</td>
                                                        </tr>
                                                    @endif
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tab Rekap Pengambilan -->
                        <div class="tab-pane" id="rekap-pengambilan">
                            <!-- Informasi Ringkasan -->
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <div class="info-box bg-info">
                                        <span class="info-box-icon"><i class="fas fa-calendar-alt"></i></span>
                                        <div class="info-box-content">
                                            <span class="info-box-text text-white">Total Volume Bulanan</span>
                                            <span
                                                class="info-box-number text-white">{{ number_format($totalVolumeBulanan, 2) }}
                                                SM³</span>
                                            <span
                                                class="info-box-text text-white">{{ date('F Y', mktime(0, 0, 0, $selectedBulan, 1, $selectedTahun)) }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Tabel Rekap Pengambilan -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header bg-light">
                                            <h3 class="card-title">
                                                <i class="fas fa-list-alt mr-1"></i>
                                                Data Rekap Pengambilan -
                                                {{ date('F Y', mktime(0, 0, 0, $selectedBulan, 1, $selectedTahun)) }}
                                            </h3>
                                        </div>
                                        <div class="card-body table-responsive p-0">
                                            <table class="table table-hover text-nowrap" id="rekapPengambilanTable">
                                                <thead>
                                                    <tr>
                                                        <th class="text-success">No</th>
                                                        <th class="text-success">Customer</th>
                                                        <th class="text-success">Tanggal</th>
                                                        <th class="text-success">NOPOL</th>
                                                        <th class="text-success">Volume (SM³)</th>
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
                                                            </tr>
                                                        @endforeach
                                                    @else
                                                        <tr>
                                                            <td colspan="5" class="text-center">Tidak ada data untuk
                                                                ditampilkan</td>
                                                        </tr>
                                                    @endif
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Customer Pengambilan Details -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header bg-light">
                                            <h3 class="card-title"><i class="fas fa-users mr-1"></i>Data Pengambilan Per
                                                Customer</h3>
                                        </div>
                                        <div class="card-body table-responsive p-0">
                                            <table class="table table-hover table-striped">
                                                <thead>
                                                    <tr>
                                                        <th class="text-success">Nama Customer</th>
                                                        <th class="text-success">Tipe</th>
                                                        <th class="text-success">Volume Tahun {{ $selectedTahun }}</th>
                                                        <th class="text-success">Volume Bulan
                                                            {{ date('F', mktime(0, 0, 0, $selectedBulan, 1)) }}</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    @if (count($customerPengambilanData) > 0)
                                                        @foreach ($customerPengambilanData as $data)
                                                            <tr>
                                                                <td>{{ $data['nama'] }}</td>
                                                                <td>
                                                                    @if ($data['role'] == 'customer')
                                                                        <span class="badge badge-primary">Customer</span>
                                                                    @else
                                                                        <span class="badge badge-warning">FOB</span>
                                                                    @endif
                                                                </td>
                                                                <td><span
                                                                        class="font-weight-bold">{{ number_format($data['volume_tahun'], 2) }}</span>
                                                                    SM³</td>
                                                                <td><span
                                                                        class="font-weight-bold text-success">{{ number_format($data['volume_bulan'], 2) }}</span>
                                                                    SM³</td>
                                                            </tr>
                                                        @endforeach
                                                    @else
                                                        <tr>
                                                            <td colspan="4" class="text-center">Tidak ada data untuk
                                                                ditampilkan.</td>
                                                        </tr>
                                                    @endif
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            // Periksa apakah Chart.js dimuat
            if (typeof Chart === 'undefined') {
                console.error('Chart.js is not loaded!');
                return;
            }

            // Initialize DataTable for rekap pengambilan
            if ($.fn.dataTable) {
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
            }

            // Persiapkan data grafik dengan aman
            var yearlyChartData = @json($yearlyChartData) || {
                pemakaian: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                penjualan: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            };
            var monthlyChartData = @json($monthlyChartData) || {
                pemakaian: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0
                ],
                penjualan: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0
                ]
            };

            // Warna dan gradien untuk grafik
            var months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
            var daysInMonth = new Date({{ $selectedTahun }}, {{ $selectedBulan }}, 0).getDate();
            var days = Array.from({
                length: daysInMonth
            }, (_, i) => i + 1);

            // Ciptakan gradien untuk grafik pemakaian
            var yearlyUsageCtx = document.getElementById('yearlyUsageChart');
            if (yearlyUsageCtx) {
                try {
                    var gradient1 = yearlyUsageCtx.getContext('2d').createLinearGradient(0, 0, 0, 250);
                    gradient1.addColorStop(0, 'rgba(66, 133, 244, 0.6)');
                    gradient1.addColorStop(1, 'rgba(66, 133, 244, 0.1)');

                    // Grafik pemakaian tahunan
                    new Chart(yearlyUsageCtx.getContext('2d'), {
                        type: 'line',
                        data: {
                            labels: months,
                            datasets: [{
                                label: 'Pemakaian (SM3)',
                                data: yearlyChartData.pemakaian || [],
                                borderColor: 'rgba(66, 133, 244, 1)',
                                backgroundColor: gradient1,
                                pointRadius: 4,
                                pointBackgroundColor: 'rgba(66, 133, 244, 1)',
                                pointBorderColor: '#fff',
                                pointHoverRadius: 6,
                                pointHoverBackgroundColor: '#fff',
                                pointHoverBorderColor: 'rgba(66, 133, 244, 1)',
                                borderWidth: 3,
                                fill: true,
                                tension: 0.4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                },
                                tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                    bodyFont: {
                                        size: 14
                                    },
                                    callbacks: {
                                        label: function(context) {
                                            return 'Pemakaian: ' + context.parsed.y.toLocaleString(
                                                'id-ID') + ' SM³';
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(200, 200, 200, 0.2)'
                                    },
                                    ticks: {
                                        font: {
                                            size: 12
                                        },
                                        callback: function(value) {
                                            return value.toLocaleString('id-ID');
                                        }
                                    }
                                },
                                x: {
                                    grid: {
                                        display: false
                                    },
                                    ticks: {
                                        font: {
                                            size: 12
                                        }
                                    }
                                }
                            }
                        }
                    });
                    console.log('Yearly usage chart initialized successfully');
                } catch (error) {
                    console.error('Error initializing yearly usage chart:', error);
                }
            }

            // Grafik penjualan tahunan
            var yearlySalesCtx = document.getElementById('yearlySalesChart');
            if (yearlySalesCtx) {
                try {
                    var gradient2 = yearlySalesCtx.getContext('2d').createLinearGradient(0, 0, 0, 250);
                    gradient2.addColorStop(0, 'rgba(40, 167, 69, 0.6)');
                    gradient2.addColorStop(1, 'rgba(40, 167, 69, 0.1)');

                    new Chart(yearlySalesCtx.getContext('2d'), {
                        type: 'line',
                        data: {
                            labels: months,
                            datasets: [{
                                label: 'Penjualan (Juta Rp)',
                                data: yearlyChartData.penjualan || [],
                                borderColor: 'rgba(40, 167, 69, 1)',
                                backgroundColor: gradient2,
                                pointRadius: 4,
                                pointBackgroundColor: 'rgba(40, 167, 69, 1)',
                                pointBorderColor: '#fff',
                                pointHoverRadius: 6,
                                pointHoverBackgroundColor: '#fff',
                                pointHoverBorderColor: 'rgba(40, 167, 69, 1)',
                                borderWidth: 3,
                                fill: true,
                                tension: 0.4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                },
                                tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                    bodyFont: {
                                        size: 14
                                    },
                                    callbacks: {
                                        label: function(context) {
                                            return 'Penjualan: Rp ' + context.parsed.y.toLocaleString(
                                                'id-ID') + ' Juta';
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(200, 200, 200, 0.2)'
                                    },
                                    ticks: {
                                        font: {
                                            size: 12
                                        },
                                        callback: function(value) {
                                            return 'Rp ' + value.toLocaleString('id-ID') + ' Jt';
                                        }
                                    }
                                },
                                x: {
                                    grid: {
                                        display: false
                                    },
                                    ticks: {
                                        font: {
                                            size: 12
                                        }
                                    }
                                }
                            }
                        }
                    });
                    console.log('Yearly sales chart initialized successfully');
                } catch (error) {
                    console.error('Error initializing yearly sales chart:', error);
                }
            }

            // Grafik pemakaian bulanan (harian)
            var monthlyUsageCtx = document.getElementById('monthlyUsageChart');
            if (monthlyUsageCtx) {
                try {
                    var gradient3 = monthlyUsageCtx.getContext('2d').createLinearGradient(0, 0, 0, 250);
                    gradient3.addColorStop(0, 'rgba(23, 162, 184, 0.6)');
                    gradient3.addColorStop(1, 'rgba(23, 162, 184, 0.1)');

                    new Chart(monthlyUsageCtx.getContext('2d'), {
                        type: 'line',
                        data: {
                            labels: days,
                            datasets: [{
                                label: 'Pemakaian Harian (SM3)',
                                data: monthlyChartData.pemakaian ? monthlyChartData.pemakaian.slice(
                                    0, daysInMonth) : [],
                                borderColor: 'rgba(23, 162, 184, 1)',
                                backgroundColor: gradient3,
                                pointRadius: 3,
                                pointBackgroundColor: 'rgba(23, 162, 184, 1)',
                                pointBorderColor: '#fff',
                                pointHoverRadius: 5,
                                pointHoverBackgroundColor: '#fff',
                                pointHoverBorderColor: 'rgba(23, 162, 184, 1)',
                                borderWidth: 3,
                                fill: true,
                                tension: 0.4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                },
                                tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                    bodyFont: {
                                        size: 14
                                    },
                                    callbacks: {
                                        title: function(tooltipItems) {
                                            return 'Tanggal: ' + tooltipItems[0].label + ' ' + ['Jan',
                                                'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags',
                                                'Sep', 'Okt', 'Nov', 'Des'
                                            ][{{ $selectedBulan }} - 1];
                                        },
                                        label: function(context) {
                                            return 'Pemakaian: ' + context.parsed.y.toLocaleString(
                                                'id-ID') + ' SM³';
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(200, 200, 200, 0.2)'
                                    },
                                    ticks: {
                                        font: {
                                            size: 12
                                        },
                                        callback: function(value) {
                                            return value.toLocaleString('id-ID');
                                        }
                                    }
                                },
                                x: {
                                    grid: {
                                        display: false
                                    },
                                    ticks: {
                                        font: {
                                            size: 11
                                        },
                                        maxRotation: 0,
                                        autoSkip: true,
                                        maxTicksLimit: 15
                                    }
                                }
                            }
                        }
                    });
                    console.log('Monthly usage chart initialized successfully');
                } catch (error) {
                    console.error('Error initializing monthly usage chart:', error);
                }
            }

            // Grafik penjualan bulanan (harian)
            var monthlySalesCtx = document.getElementById('monthlySalesChart');
            if (monthlySalesCtx) {
                try {
                    var gradient4 = monthlySalesCtx.getContext('2d').createLinearGradient(0, 0, 0, 250);
                    gradient4.addColorStop(0, 'rgba(40, 167, 69, 0.6)');
                    gradient4.addColorStop(1, 'rgba(40, 167, 69, 0.1)');

                    new Chart(monthlySalesCtx.getContext('2d'), {
                        type: 'line',
                        data: {
                            labels: days,
                            datasets: [{
                                label: 'Penjualan Harian (Juta Rp)',
                                data: monthlyChartData.penjualan ? monthlyChartData.penjualan.slice(
                                    0, daysInMonth) : [],
                                borderColor: 'rgba(40, 167, 69, 1)',
                                backgroundColor: gradient4,
                                pointRadius: 3,
                                pointBackgroundColor: 'rgba(40, 167, 69, 1)',
                                pointBorderColor: '#fff',
                                pointHoverRadius: 5,
                                pointHoverBackgroundColor: '#fff',
                                pointHoverBorderColor: 'rgba(40, 167, 69, 1)',
                                borderWidth: 3,
                                fill: true,
                                tension: 0.4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                },
                                tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                    bodyFont: {
                                        size: 14
                                    },
                                    callbacks: {
                                        title: function(tooltipItems) {
                                            return 'Tanggal: ' + tooltipItems[0].label + ' ' + ['Jan',
                                                'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags',
                                                'Sep', 'Okt', 'Nov', 'Des'
                                            ][{{ $selectedBulan }} - 1];
                                        },
                                        label: function(context) {
                                            return 'Penjualan: Rp ' + context.parsed.y.toLocaleString(
                                                'id-ID') + ' Juta';
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(200, 200, 200, 0.2)'
                                    },
                                    ticks: {
                                        font: {
                                            size: 12
                                        },
                                        callback: function(value) {
                                            return 'Rp ' + value.toLocaleString('id-ID') + ' Jt';
                                        }
                                    }
                                },
                                x: {
                                    grid: {
                                        display: false
                                    },
                                    ticks: {
                                        font: {
                                            size: 11
                                        },
                                        maxRotation: 0,
                                        autoSkip: true,
                                        maxTicksLimit: 15
                                    }
                                }
                            }
                        }
                    });
                    console.log('Monthly sales chart initialized successfully');
                } catch (error) {
                    console.error('Error initializing monthly sales chart:', error);
                }
            }
        });
    </script>
@endpush
