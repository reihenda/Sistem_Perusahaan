@extends('layouts.app')

@section('title', 'Kelola Nomor Polisi')

@section('page-title', 'Kelola Nomor Polisi')

@section('content')
    <div class="container-fluid">
        <!-- Notification -->
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

        <!-- Card for Managing NoPol -->
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-truck mr-2"></i>Daftar Nomor Polisi
                        </h3>
                        <div class="card-tools">
                            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal"
                                data-target="#tambahNopolModal">
                                <i class="fas fa-plus-circle mr-1"></i> Tambah Nomor Polisi
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped" id="nopolTable">
                                <thead>
                                    <tr>
                                        <th style="width: 50px">No</th>
                                        <th>Nomor Polisi</th>
                                        <th>Keterangan</th>
                                        <th>Tanggal Dibuat</th>
                                        <th style="width: 150px">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @if (count($nomorPolisiList) > 0)
                                        @foreach ($nomorPolisiList as $index => $nopol)
                                            <tr>
                                                <td>{{ $index + 1 }}</td>
                                                <td>{{ $nopol->nopol }}</td>
                                                <td>{{ $nopol->keterangan ?? '-' }}</td>
                                                <td>{{ $nopol->created_at->format('d M Y H:i') }}</td>
                                                <td>
                                                    <button type="button" class="btn btn-warning btn-sm edit-nopol"
                                                        data-id="{{ $nopol->id }}" data-nopol="{{ $nopol->nopol }}"
                                                        data-keterangan="{{ $nopol->keterangan ?? '' }}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <form action="{{ route('nomor-polisi.destroy', $nopol->id) }}"
                                                        method="POST" class="d-inline"
                                                        onsubmit="return confirm('Apakah Anda yakin ingin menghapus nomor polisi ini?');">
                                                        @csrf
                                                        @method('DELETE')
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        @endforeach
                                    @else
                                        <tr>
                                            <td colspan="5" class="text-center">Tidak ada data nomor polisi.</td>
                                        </tr>
                                    @endif
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Action Button -->
        <div class="row mt-3">
            <div class="col-md-12">
                <a href="{{ route('rekap-pengambilan.create') }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-left mr-1"></i> Kembali ke Rekap Pengambilan ss
                </a>


            </div>
        </div>
    </div>

    <!-- Modal Tambah Nomor Polisi -->
    <div class="modal fade" id="tambahNopolModal" tabindex="-1" role="dialog" aria-labelledby="tambahNopolModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="tambahNopolModalLabel">
                        <i class="fas fa-plus-circle mr-2"></i>Tambah Nomor Polisi
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="{{ route('nomor-polisi.store') }}" method="POST" id="formTambahNopol">
                    @csrf
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="nopol">Nomor Polisi <span class="text-danger">*</span></label>
                            <input type="text" name="nopol" id="nopol" class="form-control"
                                placeholder="Contoh: B 1234 ABC" required>
                        </div>
                        <div class="form-group mb-0">
                            <label for="keterangan">Keterangan</label>
                            <textarea name="keterangan" id="keterangan" class="form-control" rows="3"
                                placeholder="Masukkan keterangan jika ada"></textarea>
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

    <!-- Modal Edit Nomor Polisi -->
    <div class="modal fade" id="editNopolModal" tabindex="-1" role="dialog" aria-labelledby="editNopolModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title" id="editNopolModalLabel">
                        <i class="fas fa-edit mr-2"></i>Edit Nomor Polisi
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <form action="" method="POST" id="formEditNopol">
                    @csrf
                    @method('PUT')
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="edit_nopol">Nomor Polisi <span class="text-danger">*</span></label>
                            <input type="text" name="nopol" id="edit_nopol" class="form-control" required>
                        </div>
                        <div class="form-group mb-0">
                            <label for="edit_keterangan">Keterangan</label>
                            <textarea name="keterangan" id="edit_keterangan" class="form-control" rows="3"
                                placeholder="Masukkan keterangan jika ada"></textarea>
                        </div>
                    </div>
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
@endsection

@push('scripts')
    <script>
        // Define base URL for JavaScript
        var BASE_URL = "{{ url('') }}";

        // Debugging untuk membantu identifikasi masalah
        $(document).ready(function() {
            console.log('Document ready handler triggered');

            // Cek apakah selector menemukan elemen
            var editButtons = $('.edit-nopol');
            console.log('Found ' + editButtons.length + ' edit buttons');
        });
    </script>
    <script src="{{ asset('js/custom/nomor-polisi.js') }}"></script>
@endpush
