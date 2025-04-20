@extends('layouts.app')

@section('title', 'Edit Rekap Pengambilan')

@section('page-title', 'Edit Data Rekap Pengambilan')

@section('content')
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-warning">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-edit mr-2"></i>
                        Form Edit Data Pengambilan
                    </h3>
                </div>
                
                <form action="{{ route('rekap-pengambilan.update', $rekapPengambilan->id) }}" method="POST" id="formEditData">
                    @csrf
                    @method('PUT')
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
                                        @foreach($customers as $customer)
                                            <option value="{{ $customer->id }}" {{ (old('customer_id', $rekapPengambilan->customer_id) == $customer->id) ? 'selected' : '' }}>
                                                {{ $customer->name }} ({{ ucfirst($customer->role) }})
                                            </option>
                                        @endforeach
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="tanggal">Tanggal dan Waktu <span class="text-danger">*</span></label>
                                    <input type="datetime-local" name="tanggal" id="tanggal" class="form-control @error('tanggal') is-invalid @enderror" 
                                        value="{{ old('tanggal', $rekapPengambilan->tanggal->format('Y-m-d\TH:i')) }}" required>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="nopol">Nomor Polisi <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <select name="nopol" id="nopol_select" class="form-control select2 @error('nopol') is-invalid @enderror">
                                            @foreach($nomorPolisList as $nomorPolisi)
                                                <option value="{{ $nomorPolisi->nopol }}" {{ old('nopol', $rekapPengambilan->nopol) == $nomorPolisi->nopol ? 'selected' : '' }}>
                                                    {{ $nomorPolisi->nopol }}
                                                </option>
                                            @endforeach
                                            <option value="new">+ Tambah Nomor Polisi Baru</option>
                                        </select>
                                        <input type="text" name="nopol_new" id="nopol_new" class="form-control @error('nopol') is-invalid @enderror" 
                                               placeholder="Masukkan nomor polisi baru" style="display: none;">
                                        <div class="input-group-append" id="nopol_toggle_group" style="display: none;">
                                            <button type="button" id="toggle_nopol_input" class="btn btn-default">
                                                <i class="fas fa-undo"></i> Kembali
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="volume">Volume (SM³) <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" name="volume" id="volume" class="form-control @error('volume') is-invalid @enderror" 
                                        value="{{ old('volume', $rekapPengambilan->volume) }}" min="0" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="keterangan">Keterangan</label>
                            <textarea name="keterangan" id="keterangan" rows="3" class="form-control @error('keterangan') is-invalid @enderror" 
                                placeholder="Tambahkan keterangan jika diperlukan">{{ old('keterangan', $rekapPengambilan->keterangan) }}</textarea>
                        </div>
                    </div>

                    <div class="card-footer">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save mr-1"></i> Simpan Perubahan
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
    $(function () {
        // Initialize Select2
        $('.select2').select2({
            theme: 'bootstrap4',
            placeholder: "Pilih",
            allowClear: true
        });
        
        // Handle nopol selection
        $('#nopol_select').on('change', function() {
            if ($(this).val() === 'new') {
                $(this).hide();
                $('#nopol_new').show().focus().attr('required', true);
                $('#nopol_toggle_group').show();
            }
        });
        
        // Toggle back to dropdown
        $('#toggle_nopol_input').on('click', function() {
            $('#nopol_select').val('{{ $rekapPengambilan->nopol }}').trigger('change').show();
            $('#nopol_new').hide().val('').removeAttr('required');
            $('#nopol_toggle_group').hide();
        });
        
        // Form submission handler
        $('#formEditData').on('submit', function(e) {
            // If using new nopol input, copy value to nopol field
            if ($('#nopol_new').is(':visible') && $('#nopol_new').val()) {
                e.preventDefault(); // Prevent default submission temporarily
                
                // Set the value directly to nopol field
                $('<input>').attr({
                    type: 'hidden',
                    name: 'nopol',
                    value: $('#nopol_new').val()
                }).appendTo(this);
                
                // Now submit the form
                this.submit();
            }
        });
    });
</script>
@endsection
