: exact !important;
                print-color-adjust: exact !important;
            }

            .card-footer .row {
                display: flex !important;
                visibility: visible !important;
                align-items: center !important;
            }

            .card-footer .col-md-6 {
                display: block !important;
                visibility: visible !important;
            }

            .card-footer .col-md-6:first-child {
                flex: 1 !important;
                text-align: left !important;
            }

            .card-footer .col-md-6:last-child {
                text-align: right !important;
                font-size: 11pt !important;
                color: #666 !important;
            }

            .card-footer strong {
                display: inline !important;
                visibility: visible !important;
                font-size: 16pt !important;
                font-weight: bold !important;
                color: black !important;
            }

            .card-footer .text-primary {
                display: inline !important;
                visibility: visible !important;
                color: black !important;
                font-weight: bold !important;
                font-size: 18pt !important;
            }

            .card-footer .fas {
                display: inline !important;
                visibility: visible !important;
                margin-right: 6px !important;
            }

            /* Page setup */
            @page {
                size: A4 landscape !important;
                margin: 15mm !important;
            }

            /* Force hide everything else with higher specificity */
            .main-header,
            .main-sidebar,
            .main-footer,
            .content-header,
            .navbar,
            .breadcrumb,
            .alert,
            .modal,
            .card:not(.print-table-card) {
                display: none !important;
                visibility: hidden !important;
            }
        }

        /* Print header - hidden by default, shown only when printing */
        .print-header {
            display: none;
        }

        .print-info {
            display: none;
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
                "lengthChange": true,
                "autoWidth": false,
                "ordering": false, // Disable client-side ordering since we're using server-side ordering
                "stateSave": false, // Disable state saving to prevent caching issues
                "pageLength": 10, // Default entries per page
                "lengthMenu": [
                    [10, 25, 50, -1],
                    [10, 25, 50, "Semua"]
                ], // Length menu options
                "language": {
                    "emptyTable": "Tidak ada data pencatatan tersedia",
                    "zeroRecords": "Tidak ada data yang cocok ditemukan",
                    "info": "Menampilkan _START_ hingga _END_ dari _TOTAL_ entri",
                    "infoEmpty": "Menampilkan 0 hingga 0 dari 0 entri",
                    "infoFiltered": "(disaring dari _MAX_ total entri)",
                    "search": "Cari:",
                    "lengthMenu": "Tampilkan _MENU_ entri",
                    "paginate": {
                        "first": "Pertama",
                        "last": "Terakhir",
                        "next": "Selanjutnya",
                        "previous": "Sebelumnya"
                    }
                },
                "paging": true,
                "info": true,
                "searching": true,
                "destroy": true, // Allow re-initialization
                "initComplete": function(settings, json) {
                    console.log("DataTable initialized successfully with", this.api().data().length,
                        "records");
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
                    [0, 'asc']
                ],
                "language": {
                    "emptyTable": "Tidak ada riwayat harga",
                    "search": "Cari:"
                }
            });

            // Initialize tooltips
            $('[data-toggle="tooltip"]').tooltip();

            // Menghilangkan kode AJAX yang membingungkan
            // Biarkan form submit secara native untuk memudahkan debugging
            /*
            $("#pricingForm").on("submit", function() {
                console.log("Form submitted directly (non-AJAX)");
                // Tampilkan indikator loading pada tombol
                $("#savePricingButton").prop('disabled', true).html(
                    '<i class="fas fa-spinner fa-spin mr-1"></i> Menyimpan...');
                return true; // Allow normal form submission
            });
            */
        });

        // Simple function to open print page
        function openPrintPage() {
            console.log('Opening print page...');

            // Get current filter parameters
            const bulan = '{{ $selectedBulan }}';
            const tahun = '{{ $selectedTahun }}';
            const customerId = '{{ $customer->id }}';

            // Build URL with parameters
            const printUrl = `/data-pencatatan/fob/${customerId}/print?bulan=${bulan}&tahun=${tahun}`;

            // Open in new window/tab
            window.open(printUrl, '_blank', 'width=1200,height=800,scrollbars=yes,resizable=yes');
        }

        // Advanced Fix Functions
        function analyzeAndFixData() {
            if (!confirm('Ini akan menganalisis dan memperbaiki data yang tidak sinkron. Proses ini mungkin memakan waktu beberapa menit. Lanjutkan?')) {
                return;
            }

            // Show loading
            Swal.fire({
                title: 'Menganalisis Data...',
                text: 'Sedang memeriksa dan memperbaiki data yang tidak sinkron',
                allowOutsideClick: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            $.ajax({
                url: '{{ route("data-sync.fob.analyze-and-fix", $customer->id) }}',
                method: 'POST',
                success: function(response) {
                    Swal.fire({
                        title: 'Analisis Selesai!',
                        html: `
                            <div class="text-left">
                                <p><strong>Hasil Analisis:</strong></p>
                                <ul>
                                    <li>Data Rekap: ${response.rekap_count}</li>
                                    <li>Data Pencatatan: ${response.pencatatan_count}</li>
                                    <li>Data Dibuat: ${response.created_pencatatan}</li>
                                    <li>Data Dihapus: ${response.deleted_orphaned}</li>
                                    <li>Relasi Diperbaiki: ${response.fixed_relations}</li>
                                </ul>
                                <p><strong>Total Pembelian Baru: Rp ${new Intl.NumberFormat('id-ID').format(response.new_total_purchases)}</strong></p>
                            </div>
                        `,
                        icon: 'success',
                        confirmButtonText: 'Refresh Halaman'
                    }).then(() => {
                        location.reload();
                    });
                },
                error: function(xhr) {
                    let errorMsg = 'Terjadi kesalahan';
                    if (xhr.responseJSON && xhr.responseJSON.error) {
                        errorMsg = xhr.responseJSON.error;
                    }
                    Swal.fire({
                        title: 'Error!',
                        text: errorMsg,
                        icon: 'error'
                    });
                }
            });
        }

        function debugDataSync() {
            // Show loading
            Swal.fire({
                title: 'Mengambil Data Debug...',
                allowOutsideClick: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            $.ajax({
                url: '{{ route("data-sync.fob.debug", $customer->id) }}',
                method: 'GET',
                success: function(response) {
                    // Format data untuk ditampilkan
                    let debugInfo = `
                        <div class="text-left" style="max-height: 400px; overflow-y: auto;">
                            <h5>Customer Info:</h5>
                            <p><strong>ID:</strong> ${response.customer_info.id}</p>
                            <p><strong>Name:</strong> ${response.customer_info.name}</p>
                            <p><strong>Total Purchases:</strong> Rp ${new Intl.NumberFormat('id-ID').format(response.customer_info.total_purchases)}</p>
                            
                            <h5>Data Rekap (${response.rekap_data.length} records):</h5>
                            <div style="max-height: 150px; overflow-y: auto; border: 1px solid #ddd; padding: 10px; margin: 5px 0;">
                    `;
                    
                    response.rekap_data.forEach(function(item) {
                        debugInfo += `<p><strong>ID ${item.id}:</strong> ${item.tanggal} - ${item.volume} Sm³ ${item.has_pencatatan ? '✓' : '✗'}</p>`;
                    });
                    
                    debugInfo += `
                            </div>
                            <h5>Data Pencatatan (${response.pencatatan_data.length} records):</h5>
                            <div style="max-height: 150px; overflow-y: auto; border: 1px solid #ddd; padding: 10px; margin: 5px 0;">
                    `;
                    
                    response.pencatatan_data.forEach(function(item) {
                        debugInfo += `<p><strong>ID ${item.id}:</strong> ${item.waktu} - ${item.volume_sm3} Sm³ (Rekap ID: ${item.rekap_pengambilan_id || 'None'})</p>`;
                    });
                    
                    debugInfo += `
                            </div>
                        </div>
                    `;

                    Swal.fire({
                        title: 'Debug Info',
                        html: debugInfo,
                        width: '80%',
                        showConfirmButton: true,
                        confirmButtonText: 'Tutup'
                    });
                },
                error: function(xhr) {
                    let errorMsg = 'Terjadi kesalahan';
                    if (xhr.responseJSON && xhr.responseJSON.error) {
                        errorMsg = xhr.responseJSON.error;
                    }
                    Swal.fire({
                        title: 'Error!',
                        text: errorMsg,
                        icon: 'error'
                    });
                }
            });
        }
    </script>
@endsection
