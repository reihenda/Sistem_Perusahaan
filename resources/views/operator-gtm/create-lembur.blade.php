@extends('layouts.app')

@section('title', 'Tambah Data Lembur')

@section('page-title', 'Tambah Data Lembur Operator')

@section('content')
<div class="row justify-content-center">
    <div class="col-md-8">
        <div class="card card-primary">
            <div class="card-header">
                <h3 class="card-title">Form Tambah Data Lembur</h3>
            </div>
            <!-- /.card-header -->
            
            <!-- form start -->
            <form action="{{ route('operator-gtm.store-lembur', $operatorGtm->id) }}" method="POST">
                @csrf
                <div class="card-body">
                    <div class="form-group">
                        <label>Operator:</label>
                        <p><strong>{{ $operatorGtm->nama }}</strong> ({{ $operatorGtm->lokasi_kerja }})</p>
                    </div>
                    
                    <div class="form-group">
                        <label for="tanggal">Tanggal <span class="text-danger">*</span></label>
                        <input type="date" class="form-control @error('tanggal') is-invalid @enderror" id="tanggal" name="tanggal" value="{{ old('tanggal', $tanggal) }}" required>
                        @error('tanggal')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>
                    
                    <div class="card card-success">
                        <div class="card-header">
                            <h3 class="card-title">Sesi 1</h3>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="jam_masuk_sesi_1">Jam Masuk</label>
                                        <input type="time" class="form-control @error('jam_masuk_sesi_1') is-invalid @enderror" id="jam_masuk_sesi_1" name="jam_masuk_sesi_1" value="{{ old('jam_masuk_sesi_1') }}">
                                        @error('jam_masuk_sesi_1')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="jam_keluar_sesi_1">Jam Keluar</label>
                                        <input type="time" class="form-control @error('jam_keluar_sesi_1') is-invalid @enderror" id="jam_keluar_sesi_1" name="jam_keluar_sesi_1" value="{{ old('jam_keluar_sesi_1') }}">
                                        @error('jam_keluar_sesi_1')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card card-success">
                        <div class="card-header">
                            <h3 class="card-title">Sesi 2</h3>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="jam_masuk_sesi_2">Jam Masuk</label>
                                        <input type="time" class="form-control @error('jam_masuk_sesi_2') is-invalid @enderror" id="jam_masuk_sesi_2" name="jam_masuk_sesi_2" value="{{ old('jam_masuk_sesi_2') }}">
                                        @error('jam_masuk_sesi_2')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="jam_keluar_sesi_2">Jam Keluar</label>
                                        <input type="time" class="form-control @error('jam_keluar_sesi_2') is-invalid @enderror" id="jam_keluar_sesi_2" name="jam_keluar_sesi_2" value="{{ old('jam_keluar_sesi_2') }}">
                                        @error('jam_keluar_sesi_2')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card card-success">
                        <div class="card-header">
                            <h3 class="card-title">Sesi 3</h3>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="jam_masuk_sesi_3">Jam Masuk</label>
                                        <input type="time" class="form-control @error('jam_masuk_sesi_3') is-invalid @enderror" id="jam_masuk_sesi_3" name="jam_masuk_sesi_3" value="{{ old('jam_masuk_sesi_3') }}">
                                        @error('jam_masuk_sesi_3')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="jam_keluar_sesi_3">Jam Keluar</label>
                                        <input type="time" class="form-control @error('jam_keluar_sesi_3') is-invalid @enderror" id="jam_keluar_sesi_3" name="jam_keluar_sesi_3" value="{{ old('jam_keluar_sesi_3') }}">
                                        @error('jam_keluar_sesi_3')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="alert alert-info mt-3">
                        <i class="fas fa-info-circle mr-1"></i> 
                        Sistem akan menghitung total jam kerja, jam lembur, dan upah lembur secara otomatis berdasarkan data yang dimasukkan.
                        <br>
                        <small>Jam lembur dihitung jika total jam kerja melebihi <strong>{{ $operatorGtm->jam_kerja ?? 8 }} jam</strong> (sesuai setting jam kerja operator ini).</small>
                    </div>
                </div>
                <!-- /.card-body -->

                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-1"></i> Simpan
                    </button>
                    <a href="{{ route('operator-gtm.show', $operatorGtm->id) }}" class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-1"></i> Kembali
                    </a>
                </div>
            </form>
        </div>
        <!-- /.card -->
    </div>
</div>
@endsection