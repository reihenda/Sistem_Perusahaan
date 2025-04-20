@extends('layouts.app')

@section('title', 'Buat Billing Baru')

@section('page-title', 'Buat Billing Baru untuk ' . $customer->name)

@section('content')
<div class="card">
    <div class="card-header">
        <h3 class="card-title">Form Billing Baru</h3>
    </div>
    <form action="{{ route('billings.store', $customer) }}" method="POST">
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
                        <label for="billing_number">Nomor Billing</label>
                        <input type="text" class="form-control @error('billing_number') is-invalid @enderror" 
                            id="billing_number" name="billing_number" value="{{ old('billing_number', $billingNumber) }}">
                        @error('billing_number')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                        <small class="form-text text-muted">
                            Format: [no]/MPS/BIL-[CUSTOMER]/[bulan]/[tahun]
                        </small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="billing_date">Tanggal Billing</label>
                        <input type="date" class="form-control @error('billing_date') is-invalid @enderror" 
                            id="billing_date" name="billing_date" value="{{ old('billing_date', date('Y-m-d')) }}">
                        @error('billing_date')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
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
            
            <div class="alert alert-info">
                <p class="mb-0">
                    <i class="fas fa-info-circle mr-1"></i> Semua perhitungan biaya, deposit, dan saldo akan dihitung otomatis berdasarkan data pencatatan dan deposit untuk periode yang dipilih.
                </p>
            </div>
        </div>
        <div class="card-footer">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save mr-1"></i>Simpan
            </button>
            <a href="{{ route('billings.select-customer') }}" class="btn btn-secondary">
                <i class="fas fa-times mr-1"></i>Batal
            </a>
        </div>
    </form>
</div>
@endsection
