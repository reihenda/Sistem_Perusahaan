@extends('layouts.app')

@section('title', 'Buat Proforma Invoice')

@section('page-title', 'Buat Proforma Invoice - ' . $customer->name)

@section('content')
<div class="card">
    <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
            <h3 class="card-title">Form Proforma Invoice</h3>
            <a href="{{ route('proforma-invoices.select-customer') }}" class="btn btn-secondary">
                <i class="fas fa-arrow-left mr-1"></i>Kembali
            </a>
        </div>
    </div>
    <form action="{{ route('proforma-invoices.store', $customer) }}" method="POST">
        @csrf
        <div class="card-body">
            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <div class="row">
                <!-- Customer Info -->
                <div class="col-md-6">
                    <div class="card bg-light">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-user mr-2"></i>Informasi Customer
                            </h5>
                            <p class="card-text">
                                <strong>Nama:</strong> {{ $customer->name }}<br>
                                <strong>Email:</strong> {{ $customer->email }}<br>
                                <strong>Role:</strong> {{ ucfirst($customer->role) }}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Proforma Info -->
                <div class="col-md-6">
                    <div class="card bg-light">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-info-circle mr-2"></i>Info Proforma
                            </h5>
                            <div class="form-group">
                                <label for="proforma_number">Nomor Proforma</label>
                                <div class="input-group">
                                    <input type="text" class="form-control @error('proforma_number') is-invalid @enderror" 
                                           id="proforma_number" name="proforma_number" 
                                           value="{{ old('proforma_number', $proformaNumber) }}" required readonly>
                                    <div class="input-group-append">
                                        <button type="button" class="btn btn-outline-secondary" id="generateNumber">
                                            <i class="fas fa-sync-alt"></i>
                                        </button>
                                    </div>
                                </div>
                                @error('proforma_number')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-3">
                <!-- Tanggal Proforma -->
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="proforma_date">Tanggal Proforma <span class="text-danger">*</span></label>
                        <input type="date" class="form-control @error('proforma_date') is-invalid @enderror" 
                               id="proforma_date" name="proforma_date" 
                               value="{{ old('proforma_date', now()->format('Y-m-d')) }}" required>
                        @error('proforma_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>

                <!-- Due Date -->
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="due_date">Tanggal Jatuh Tempo <span class="text-danger">*</span></label>
                        <input type="date" class="form-control @error('due_date') is-invalid @enderror" 
                               id="due_date" name="due_date" 
                               value="{{ old('due_date', now()->addDays(30)->format('Y-m-d')) }}" required>
                        @error('due_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>

                <!-- Validity Date -->
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="validity_date">Berlaku Sampai</label>
                        <input type="date" class="form-control @error('validity_date') is-invalid @enderror" 
                               id="validity_date" name="validity_date" 
                               value="{{ old('validity_date', now()->addDays(30)->format('Y-m-d')) }}">
                        @error('validity_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                        <small class="text-muted">Opsional - tanggal berlaku proforma invoice</small>
                    </div>
                </div>
            </div>

            <!-- Periode Data -->
            <div class="row">
                <div class="col-md-12">
                    <h5 class="mt-3 mb-3">
                        <i class="fas fa-calendar-alt mr-2"></i>Periode Data Pencatatan
                    </h5>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="period_start_date">Tanggal Mulai <span class="text-danger">*</span></label>
                        <input type="date" class="form-control @error('period_start_date') is-invalid @enderror" 
                               id="period_start_date" name="period_start_date" 
                               value="{{ old('period_start_date', $startDate) }}" required>
                        @error('period_start_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="period_end_date">Tanggal Selesai <span class="text-danger">*</span></label>
                        <input type="date" class="form-control @error('period_end_date') is-invalid @enderror" 
                               id="period_end_date" name="period_end_date" 
                               value="{{ old('period_end_date', $endDate) }}" required>
                        @error('period_end_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                        <small class="text-muted">Maksimal 60 hari dari tanggal mulai</small>
                    </div>
                </div>
            </div>

            <!-- Additional Info -->
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="no_kontrak">No. Kontrak <span class="text-danger">*</span></label>
                        <input type="text" class="form-control @error('no_kontrak') is-invalid @enderror" 
                               id="no_kontrak" name="no_kontrak" 
                               value="{{ old('no_kontrak') }}" required>
                        @error('no_kontrak')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="id_pelanggan">ID Pelanggan <span class="text-danger">*</span></label>
                        <input type="text" class="form-control @error('id_pelanggan') is-invalid @enderror" 
                               id="id_pelanggan" name="id_pelanggan" 
                               value="{{ old('id_pelanggan', sprintf('03C%04d', $customer->id)) }}" required>
                        @error('id_pelanggan')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="description">Deskripsi</label>
                        <textarea class="form-control @error('description') is-invalid @enderror" 
                                  id="description" name="description" rows="3" 
                                  placeholder="Deskripsi tambahan untuk proforma invoice...">{{ old('description') }}</textarea>
                        @error('description')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
            </div>
        </div>
        <div class="card-footer">
            <div class="d-flex justify-content-between">
                <a href="{{ route('proforma-invoices.select-customer') }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-left mr-1"></i>Kembali
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save mr-1"></i>Buat Proforma Invoice
                </button>
            </div>
        </div>
    </form>
</div>
@endsection

@section('js')
<script>
$(document).ready(function() {
    // Generate nomor proforma otomatis
    $('#generateNumber').click(function() {
        $.ajax({
            url: '{{ route("proforma-invoices.generate-number", $customer) }}',
            type: 'POST',
            data: {
                _token: '{{ csrf_token() }}'
            },
            success: function(response) {
                $('#proforma_number').val(response.proforma_number);
            },
            error: function() {
                alert('Gagal generate nomor proforma');
            }
        });
    });
    
    // Validasi periode tanggal
    $('#period_start_date, #period_end_date').change(function() {
        const startDate = new Date($('#period_start_date').val());
        const endDate = new Date($('#period_end_date').val());
        
        if (startDate && endDate) {
            const diffTime = Math.abs(endDate - startDate);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            
            if (diffDays > 60) {
                alert('Periode maksimal adalah 60 hari!');
                $('#period_end_date').val('');
            }
        }
    });
    
    // Set minimum date untuk due date dan validity date
    $('#proforma_date').change(function() {
        const selectedDate = $(this).val();
        $('#due_date').attr('min', selectedDate);
        $('#validity_date').attr('min', selectedDate);
    });
    
    // Set minimum date untuk period end date
    $('#period_start_date').change(function() {
        const selectedDate = $(this).val();
        $('#period_end_date').attr('min', selectedDate);
    });
    
    // Initialize minimum dates
    const today = new Date().toISOString().split('T')[0];
    $('#proforma_date').attr('min', today);
    $('#due_date').attr('min', $('#proforma_date').val());
    $('#validity_date').attr('min', $('#proforma_date').val());
    $('#period_end_date').attr('min', $('#period_start_date').val());
});
</script>
@endsection
