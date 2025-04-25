@extends('layouts.app')

@section('title', 'Daftar Operator GTM')

@section('page-title', 'Daftar Operator GTM')

@section('content')
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Daftar Operator GTM</h3>
                <div class="card-tools">
                    <a href="{{ route('operator-gtm.create') }}" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus mr-1"></i> Tambah Operator
                    </a>
                </div>
            </div>
            <!-- /.card-header -->
            <div class="card-body table-responsive p-0">
                @if(session('success'))
                    <div class="alert alert-success alert-dismissible fade show m-3" role="alert">
                        {{ session('success') }}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                @endif

                <table class="table table-hover text-nowrap">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nama</th>
                            <th>Lokasi Kerja</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($operators as $operator)
                            <tr>
                                <td>{{ $operator->id }}</td>
                                <td>{{ $operator->nama }}</td>
                                <td>{{ $operator->lokasi_kerja }}</td>
                                <td>
                                    <a href="{{ route('operator-gtm.show', $operator->id) }}" class="btn btn-info btn-sm">
                                        <i class="fas fa-eye"></i> Detail
                                    </a>
                                    <a href="{{ route('operator-gtm.edit', $operator->id) }}" class="btn btn-warning btn-sm">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <form action="{{ route('operator-gtm.destroy', $operator->id) }}" method="POST" class="d-inline">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus operator ini?')">
                                            <i class="fas fa-trash"></i> Hapus
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="4" class="text-center">Tidak ada data operator GTM.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
            <!-- /.card-body -->
        </div>
        <!-- /.card -->
    </div>
</div>
@endsection