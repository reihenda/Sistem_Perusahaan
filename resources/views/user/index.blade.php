@extends('layouts.app')

@section('title', 'Kelola User')

@section('page-title', 'Kelola User')

@section('content')
    <div class="card">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="card-title">Data User</h3>
                <a href="#" class="btn btn-primary" data-toggle="modal" data-target="#tambahUserModal">
                    <i class="fas fa-user-plus mr-1"></i>Tambah User
                </a>
            </div>
            <div class="mt-3">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                    </div>
                    <input type="text" id="searchUser" class="form-control" placeholder="Cari user..."
                        value="{{ request('search') }}">
                </div>
            </div>
        </div>
        <div class="card-body">
            @if (session('success'))
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    {{ session('success') }}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            @endif

            @if (session('error'))
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    {{ session('error') }}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            @endif

            <div id="user-table-container">
                @include('user.partials.user-table')
            </div>
        </div>
    </div>

    {{-- Modal Tambah User --}}
    <div class="modal fade" id="tambahUserModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-user-plus mr-2"></i>
                        Tambah User Baru
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form id="tambahUserForm" action="{{ route('tambah.user') }}" method="POST" novalidate>
                    @csrf
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="name">Nama <span class="text-danger">*</span></label>
                            <input type="text" class="form-control @error('name') is-invalid @enderror" id="name"
                                name="name" value="{{ old('name') }}" required>
                            @error('name')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                        <div class="form-group">
                            <label for="email">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control @error('email') is-invalid @enderror" id="email"
                                name="email" value="{{ old('email') }}" required>
                            @error('email')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                        <div class="form-group">
                            <label for="password">Password <span class="text-danger">*</span></label>
                            <input type="password" class="form-control @error('password') is-invalid @enderror"
                                id="password" name="password" required>
                            <small class="text-muted">Minimal 3 karakter</small>
                            @error('password')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                        <div class="form-group mb-0">
                            <label for="role">Role <span class="text-danger">*</span></label>
                            <select class="form-control @error('role') is-invalid @enderror" id="role" name="role"
                                required>
                                <option value="admin" {{ old('role') == 'admin' ? 'selected' : '' }}>Admin</option>
                                <option value="customer" {{ old('role') == 'customer' ? 'selected' : '' }}>Customer
                                </option>
                                <option value="fob" {{ old('role') == 'fob' ? 'selected' : '' }}>FOB</option>
                                <option value="demo" {{ old('role') == 'demo' ? 'selected' : '' }}>Demo</option>
                            </select>
                            @error('role')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <i class="fas fa-times mr-1"></i>Tutup
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save mr-1"></i>Simpan
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection

@section('js')
    <script>
        $(document).ready(function() {
            // Timer untuk debounce pencarian
            let searchTimer;

            // Event listener untuk input pencarian
            $('#searchUser').on('input', function() {
                const searchTerm = $(this).val();

                // Clear timer sebelumnya
                clearTimeout(searchTimer);

                // Set timer baru (300ms delay)
                searchTimer = setTimeout(function() {
                    // Tampilkan loading spinner
                    $('#user-table-container').html(
                        '<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x"></i></div>'
                        );

                    // Kirim request AJAX
                    $.ajax({
                        url: '{{ route('user.index') }}',
                        type: 'GET',
                        data: {
                            search: searchTerm
                        },
                        dataType: 'json',
                        success: function(response) {
                            // Update tabel
                            $('#user-table-container').html(response.html);

                            // Update URL untuk history browser
                            const url = new URL(window.location.href);
                            if (searchTerm) {
                                url.searchParams.set('search', searchTerm);
                            } else {
                                url.searchParams.delete('search');
                            }
                            window.history.pushState({}, '', url);
                        },
                        error: function() {
                            // Tampilkan pesan error
                            $('#user-table-container').html(
                                '<div class="alert alert-danger">Terjadi kesalahan saat mengambil data</div>'
                                );
                        }
                    });
                }, 300);
            });

            // Form validation
            const userForm = $('#tambahUserForm');
            const submitButton = userForm.find('button[type="submit"]');

            // Input fields
            const nameInput = userForm.find('input[name="name"]');
            const emailInput = userForm.find('input[name="email"]');
            const passwordInput = userForm.find('input[name="password"]');

            // Validation feedback elements
            const nameError = $('<div class="invalid-feedback">Nama harus diisi</div>');
            const emailError = $('<div class="invalid-feedback">Email tidak valid</div>');
            const passwordError = $('<div class="invalid-feedback">Password minimal 3 karakter</div>');

            // // Add feedback elements after inputs
            // nameInput.after(nameError);
            // emailInput.after(emailError);
            // passwordInput.after(passwordError);

            // Real-time validation function
            function validateForm() {
                let isValid = true;

                // Validate name (required)
                if (!nameInput.val().trim()) {
                    nameInput.addClass('is-invalid').removeClass('is-valid');
                    nameError.show();
                    isValid = false;
                } else {
                    nameInput.removeClass('is-invalid').addClass('is-valid');
                    nameError.hide();
                }

                // Validate email (required, valid format)
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailInput.val().trim() || !emailRegex.test(emailInput.val())) {
                    emailInput.addClass('is-invalid').removeClass('is-valid');
                    emailError.show();
                    isValid = false;
                } else {
                    emailInput.removeClass('is-invalid').addClass('is-valid');
                    emailError.hide();
                }

                // Validate password (required, min 3 chars)
                if (!passwordInput.val() || passwordInput.val().length < 3) {
                    passwordInput.addClass('is-invalid').removeClass('is-valid');
                    passwordError.show();
                    isValid = false;
                } else {
                    passwordInput.removeClass('is-invalid').addClass('is-valid');
                    passwordError.hide();
                }

                // Enable/disable submit button based on validation
                submitButton.prop('disabled', !isValid);

                return isValid;
            }

            // Initial validation
            validateForm();

            // Validate on input
            userForm.find('input, select').on('input change', validateForm);

            // Form submission handler
            userForm.on('submit', function(e) {
                if (!validateForm()) {
                    e.preventDefault();

                    // Show toast notification for invalid form
                    Swal.fire({
                        icon: 'error',
                        title: 'Validasi Gagal',
                        text: 'Mohon periksa kembali data yang dimasukkan',
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                }
            });
        });
    </script>
@endsection
