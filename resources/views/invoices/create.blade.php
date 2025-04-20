@extends('layouts.app')

@section('title', 'Buat Invoice Baru')

@section('page-title', 'Buat Invoice Baru untuk ' . $customer->name)

@section('content')
<div class="card">
    <div class="card-header">
        <h3 class="card-title">Form Invoice Baru</h3>
    </div>
    <form action="{{ route('invoices.store', $customer) }}" method="POST">
        @csrf
        <div class="card-body">
            @if (session('error'))
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    {{ session('error') }}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            @endif

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="invoice_number">Nomor Invoice</label>
                        <input type="text" class="form-control @error('invoice_number') is-invalid @enderror" 
                            id="invoice_number" name="invoice_number" value="{{ old('invoice_number', $invoiceNumber) }}">
                        @error('invoice_number')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                        <small class="form-text text-muted">
                            Format: [no]/MPS/INV-{{ strtoupper($customer->name) }}/[bulan]/[tahun]
                        </small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="invoice_date">Tanggal Invoice</label>
                        <input type="date" class="form-control @error('invoice_date') is-invalid @enderror" 
                            id="invoice_date" name="invoice_date" value="{{ old('invoice_date', date('Y-m-d')) }}">
                        @error('invoice_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="no_kontrak">No Kontrak</label>
                        <input type="text" class="form-control @error('no_kontrak') is-invalid @enderror" 
                            id="no_kontrak" name="no_kontrak" value="{{ old('no_kontrak', '001/PJBG-MPS/I/' . date('Y')) }}">
                        @error('no_kontrak')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="id_pelanggan">ID Pelanggan</label>
                        <input type="text" class="form-control @error('id_pelanggan') is-invalid @enderror" 
                            id="id_pelanggan" name="id_pelanggan" value="{{ old('id_pelanggan', sprintf('03C%04d', $customer->id)) }}">
                        @error('id_pelanggan')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="due_date">Tanggal Jatuh Tempo</label>
                        <input type="date" class="form-control @error('due_date') is-invalid @enderror" 
                            id="due_date" name="due_date" value="{{ old('due_date', date('Y-m-d', strtotime('+10 days'))) }}">
                        @error('due_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>Periode Pencatatan</label>
                        <div class="row">
                            <div class="col-md-6">
                                <select class="form-control @error('month') is-invalid @enderror" name="month">
                                    @for ($i = 1; $i <= 12; $i++)
                                        <option value="{{ $i }}" {{ old('month', $month) == $i ? 'selected' : '' }}>
                                            {{ date('F', mktime(0, 0, 0, $i, 1)) }}
                                        </option>
                                    @endfor
                                </select>
                                @error('month')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                            <div class="col-md-6">
                                <select class="form-control @error('year') is-invalid @enderror" name="year">
                                    @for ($i = date('Y') - 3; $i <= date('Y') + 1; $i++)
                                        <option value="{{ $i }}" {{ old('year', $year) == $i ? 'selected' : '' }}>
                                            {{ $i }}
                                        </option>
                                    @endfor
                                </select>
                                @error('year')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="description">Keterangan (Opsional)</label>
                <textarea class="form-control @error('description') is-invalid @enderror" 
                    id="description" name="description" rows="3">{{ old('description', 'Pemakaian CNG') }}</textarea>
                @error('description')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
            
            <div class="alert alert-info">
                <p class="mb-0">
                    <i class="fas fa-info-circle mr-1"></i> Total biaya akan dihitung otomatis berdasarkan data pencatatan untuk periode yang dipilih.
                </p>
            </div>
        </div>
        <div class="card-footer">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save mr-1"></i>Simpan
            </button>
            <a href="{{ route('invoices.select-customer') }}" class="btn btn-secondary">
                <i class="fas fa-times mr-1"></i>Batal
            </a>
        </div>
    </form>
</div>
@endsection