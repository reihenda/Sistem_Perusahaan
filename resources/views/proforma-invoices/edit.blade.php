@extends('layouts.app')

@section('title', 'Edit Proforma Invoice')

@section('page-title', 'Edit Proforma Invoice - ' . $customer->name)

@section('content')
<div class="card">
    <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
            <h3 class="card-title">Edit Proforma Invoice</h3>
            <a href="{{ route('proforma-invoices.show', $proformaInvoice) }}" class="btn btn-secondary">
                <i class="fas fa-arrow-left mr-1"></i>Kembali
            </a>
        </div>
    </div>
    <form action="{{ route('proforma-invoices.update', $proformaInvoice) }}" method="POST">
        @csrf
        @method('PUT')
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
                                <input type="text" class="form-control @error('proforma_number') is-invalid @enderror" 
                                       id="proforma_number" name="proforma_number" 
                                       value="{{ old('proforma_number', $proformaInvoice->proforma_number) }}" required>
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
                               value="{{ old('proforma_date', $proformaInvoice->proforma_date->format('Y-m-d')) }}" required>
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
                               value="{{ old('due_date', $proformaInvoice->due_date->format('Y-m-d')) }}" required>
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
                               value="{{ old('validity_date', $proformaInvoice->validity_date ? $proformaInvoice->validity_date->format('Y-m-d') : '') }}">
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
                               value="{{ old('period_start_date', $proformaInvoice->period_start_date->format('Y-m-d')) }}" required>
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
                               value="{{ old('period_end_date', $proformaInvoice->period_end_date->format('Y-m-d')) }}" required>
                        @error('period_end_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                        <small class="text-muted">Maksimal 60 hari dari tanggal mulai</small>
                    </div>
                </div>
            </div>

            <!-- Status -->
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="status">Status <span class="text-danger">*</span></label>
                        <select class="form-control @error('status') is-invalid @enderror" id="status" name="status" required>
                            <option value="draft" {{ old('status', $proformaInvoice->status) == 'draft' ? 'selected' : '' }}>Draft</option>
                            <option value="sent" {{ old('status', $proformaInvoice->status) == 'sent' ? 'selected' : '' }}>Sent</option>
                            <option value="expired" {{ old('status', $proformaInvoice->status) == 'expired' ? 'selected' : '' }}>Expired</option>
                            <option value="converted" {{ old('status', $proformaInvoice->status) == 'converted' ? 'selected' : '' }}>Converted</option>
                        </select>
                        @error('status')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="no_kontrak">No. Kontrak <span class="text-danger">*</span></label>
                        <input type="text" class="form-control @error('no_kontrak') is-invalid @enderror" 
                               id="no_kontrak" name="no_kontrak" 
                               value="{{ old('no_kontrak', $proformaInvoice->no_kontrak) }}" required>
                        @error('no_kontrak')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="id_pelanggan">ID Pelanggan <span class="text-danger">*</span></label>
                        <input type="text" class="form-control @error('id_pelanggan') is-invalid @enderror" 
                               id="id_pelanggan" name="id_pelanggan" 
                               value="{{ old('id_pelanggan', $proformaInvoice->id_pelanggan) }}" required>
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
                                  placeholder="Deskripsi tambahan untuk proforma invoice...">{{ old('description', $proformaInvoice->description) }}</textarea>
                        @error('description')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
            </div>
        </div>
        <div class="card-footer">
            <div class="d-flex justify-content-between">
                <a href="{{ route('proforma-invoices.show', $proformaInvoice) }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-left mr-1"></i>Kembali
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save mr-1"></i>Update Proforma Invoice
                </button>
            </div>
        </div>
    </form>
</div>
@endsection

@section('js')
<script>
$(document).ready(function() {
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
    $('#due_date').attr('min', $('#proforma_date').val());
    $('#validity_date').attr('min', $('#proforma_date').val());
    $('#period_end_date').attr('min', $('#period_start_date').val());
});
</script>
@endsection
