@extends('layouts.app')

@section('title', 'Tambah Rekap Pengambilan')

@section('page-title', 'Tambah Data Rekap Pengambilan')

@section('content')
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-plus-circle mr-2"></i>
                            Form Tambah Data Pengambilan
                        </h3>
                        <div class="card-tools">
                            <a href="{{ route('nomor-polisi.index') }}" class="btn btn-info btn-sm">
                                <i class="fas fa-truck mr-1"></i> Halaman Nomor Polisi
                            </a>

                        </div>
                    </div>

                    <form action="{{ route('rekap-pengambilan.store') }}" method="POST" id="formTambahData">
                        @csrf
                        <div class="card-body">
                            @if ($errors->any())
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle mr-2"></i>
                                    <strong>Kesalahan:</strong>
                                    <ul class="mt-2 mb-0">
                                        @foreach ($errors->all() as $error)
                                            <li>{{ $error }}</li>
                                        @endforeach
                                    </ul>
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                            @endif

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="customer_id">Customer <span class="text-danger">*</span></label>
                                        <select name="customer_id" id="customer_id" class="form-control select2" required>
                                            <option value="">-- Pilih Customer --</option>
                                            @foreach ($customers as $customer)
                                                <option value="{{ $customer->id }}"
                                                    {{ old('customer_id') == $customer->id ? 'selected' : '' }}>
                                                    {{ $customer->name }} ({{ ucfirst($customer->role) }})
                                                </option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="tanggal">Tanggal dan Waktu <span class="text-danger">*</span></label>
                                        <input type="datetime-local" name="tanggal" id="tanggal"
                                            class="form-control @error('tanggal') is-invalid @enderror"
                                            value="{{ old('tanggal', now()->format('Y-m-d\TH:i')) }}" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="nopol">Nomor Polisi <span class="text-danger">*</span></label>
                                        <select name="nopol" id="nopol" class="form-control select2" required>
                                            <option value="">-- Pilih Nomor Polisi --</option>
                                            @foreach ($nomorPolisList as $nopol)
                                                <option value="{{ $nopol->nopol }}"
                                                    {{ old('nopol') == $nopol->nopol ? 'selected' : '' }}>
                                                    {{ $nopol->nopol }}
                                                </option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="volume">Volume (SM³) <span class="text-danger">*</span></label>
                                        <input type="number" step="0.01" name="volume" id="volume"
                                            class="form-control @error('volume') is-invalid @enderror"
                                            value="{{ old('volume', 0) }}" min="0" required>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="keterangan">Keterangan</label>
                                <textarea name="keterangan" id="keterangan" rows="3"
                                    class="form-control @error('keterangan') is-invalid @enderror" placeholder="Tambahkan keterangan jika diperlukan">{{ old('keterangan') }}</textarea>
                            </div>
                        </div>

                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save mr-1"></i> Simpan
                            </button>
                            <a href="{{ route('rekap-pengambilan.index') }}" class="btn btn-secondary">
                                <i class="fas fa-arrow-left mr-1"></i> Kembali
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


@endsection

@section('js')
    <script>
        $(function() {
            // Initialize Select2
            $('.select2').select2({
                theme: 'bootstrap4',
                placeholder: "Pilih",
                allowClear: true
            });

            // Initialize DataTable for modal
            let modalNopolTable = $('#modalNopolTable').DataTable({
                "paging": true,
                "lengthChange": false,
                "searching": true,
                "ordering": true,
                "info": true,
                "autoWidth": false,
                "responsive": true,
                "pageLength": 5
            });

            // Load nomor polisi list when modal is opened
            $('#kelolaNopolModal').on('shown.bs.modal', function() {
                console.log('Modal opened, API URL:', '{{ route('nomor-polisi.getAll') }}');
                loadNopolList();
            });

            // Form submission handler for adding new nopol
            $('#formTambahNopolModal').on('submit', function(e) {
                e.preventDefault();

                const nopol = $('#modal_nopol').val();
                const keterangan = $('#modal_keterangan').val();

                if (!nopol) {
                    showNopolError('Nomor polisi harus diisi.');
                    return;
                }

                // Submit AJAX request
                $.ajax({
                    url: '{{ route('nomor-polisi.store') }}',
                    type: 'POST',
                    data: {
                        _token: '{{ csrf_token() }}',
                        nopol: nopol,
                        keterangan: keterangan
                    },
                    success: function(response) {
                        // Clear form inputs
                        $('#modal_nopol').val('');

                        // Show success message
                        showNopolSuccess('Nomor polisi berhasil ditambahkan.');

                        // Reload nopol list
                        loadNopolList();

                        // Refresh dropdown in the main form
                        refreshNopolDropdown(response.nopol);
                    },
                    error: function(xhr) {
                        let errorMessage = 'Terjadi kesalahan saat menambahkan nomor polisi.';

                        // Try to get error message from response
                        if (xhr.responseJSON && xhr.responseJSON.errors) {
                            if (xhr.responseJSON.errors.nopol) {
                                errorMessage = xhr.responseJSON.errors.nopol[0];
                            }
                        }

                        showNopolError(errorMessage);
                    }
                });
            });

            // Function to load nomor polisi list
            function loadNopolList() {
                console.log('Loading nomor polisi list...');
                $.ajax({
                    url: '{{ route('nomor-polisi.getAll') }}',
                    type: 'GET',
                    dataType: 'json',
                    success: function(response) {
                        console.log('API Response:', response);
                        // Clear existing table data
                        modalNopolTable.clear();

                        // Add data to table
                        if (response && response.length > 0) {
                            $.each(response, function(index, item) {
                                console.log('Adding row:', item);
                                modalNopolTable.row.add([
                                    index + 1,
                                    item.nopol,
                                    item.keterangan || '-',
                                    `<button type="button" class="btn btn-danger btn-sm delete-nopol" data-id="${item.id}">
                                    <i class="fas fa-trash"></i>
                                </button>`
                                ]);
                            });
                        } else {
                            console.log('No nomor polisi data found or empty response');
                        }

                        modalNopolTable.draw();

                        // Attach event handlers to delete buttons
                        attachDeleteHandlers();
                    },
                    error: function(xhr, status, error) {
                        console.error('Error loading nomor polisi:', status, error);
                        console.error('XHR Response:', xhr.responseText);
                        showNopolError('Gagal memuat daftar nomor polisi.');
                    }
                });
            }

            // Function to attach delete handlers
            function attachDeleteHandlers() {
                $('.delete-nopol').on('click', function() {
                    const id = $(this).data('id');

                    if (confirm('Apakah Anda yakin ingin menghapus nomor polisi ini?')) {
                        $.ajax({
                            url: `{{ url('nomor-polisi') }}/${id}`,
                            type: 'DELETE',
                            data: {
                                _token: '{{ csrf_token() }}'
                            },
                            success: function(response) {
                                showNopolSuccess('Nomor polisi berhasil dihapus.');
                                loadNopolList();
                                refreshNopolDropdown();
                            },
                            error: function(xhr) {
                                let errorMessage = 'Gagal menghapus nomor polisi.';

                                if (xhr.responseJSON && xhr.responseJSON.error) {
                                    errorMessage = xhr.responseJSON.error;
                                }

                                showNopolError(errorMessage);
                            }
                        });
                    }
                });
            }

            // Function to refresh nopol dropdown
            function refreshNopolDropdown(selectedNopol = null) {
                $.ajax({
                    url: '{{ route('nomor-polisi.getAll') }}',
                    type: 'GET',
                    dataType: 'json',
                    success: function(response) {
                        // Clear existing options
                        $('#nopol').empty().append(
                            '<option value="">-- Pilih Nomor Polisi --</option>');

                        // Add new options
                        $.each(response, function(index, item) {
                            const selected = (selectedNopol && selectedNopol === item.nopol) ?
                                'selected' : '';
                            $('#nopol').append(
                                `<option value="${item.nopol}" ${selected}>${item.nopol}</option>`
                            );
                        });

                        // Refresh Select2
                        $('#nopol').trigger('change');
                    }
                });
            }

            // Functions to show success/error messages
            function showNopolSuccess(message) {
                $('#nopol-success-message').text(message);
                $('#nopol-success-alert').show();
                $('#nopol-error-alert').hide();

                // Auto hide after 3 seconds
                setTimeout(function() {
                    $('#nopol-success-alert').fadeOut('slow');
                }, 3000);
            }

            function showNopolError(message) {
                $('#nopol-error-message').text(message);
                $('#nopol-error-alert').show();
                $('#nopol-success-alert').hide();
            }
        });
    </script>
@endsection
