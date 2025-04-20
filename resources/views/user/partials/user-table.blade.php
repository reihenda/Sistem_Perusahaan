<div class="table-responsive">
    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Nama</th>
                <th>Email</th>
                <th>Role</th>
                <th>Tanggal Dibuat</th>
                <th>Status</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @php
                $currentRole = null;
            @endphp
            @foreach ($users as $user)
                @if ($currentRole !== $user->role)
                    @php $currentRole = $user->role; @endphp
                    <tr class="bg-light">
                        <td colspan="6" class="font-weight-bold">
                            @if($user->role == 'superadmin')
                                <i class="fas fa-crown text-danger mr-2"></i> Superadmin
                            @elseif($user->role == 'admin')
                                <i class="fas fa-user-shield text-primary mr-2"></i> Admin
                            @elseif($user->role == 'customer')
                                <i class="fas fa-user-tie text-success mr-2"></i> Customer
                            @elseif($user->role == 'fob')
                                <i class="fas fa-truck text-warning mr-2"></i> FOB
                            @else
                                <i class="fas fa-user-graduate text-info mr-2"></i> Demo
                            @endif
                        </td>
                    </tr>
                @endif
                <tr>
                    <td>{{ $user->name }}</td>
                    <td>{{ $user->email }}</td>
                    <td>
                        <span class="badge 
                            @if($user->role == 'superadmin') badge-danger
                            @elseif($user->role == 'admin') badge-primary
                            @elseif($user->role == 'customer') badge-success
                            @elseif($user->role == 'fob') badge-warning
                            @else badge-info
                            @endif">
                            {{ ucfirst($user->role) }}
                        </span>
                    </td>
                    <td>{{ $user->created_at->format('d/m/Y H:i') }}</td>
                    <td>
                        <span class="badge badge-success">Aktif</span>
                    </td>
                    <td>
                        <div class="btn-group">
                            @if($user->isCustomer())
                                <a href="{{ route('data-pencatatan.customer-detail', $user->id) }}"
                                    class="btn btn-info btn-sm" title="Lihat Detail">
                                    <i class="fas fa-eye"></i>
                                </a>
                            @elseif($user->isFOB())
                                <a href="{{ route('data-pencatatan.fob-detail', $user->id) }}"
                                    class="btn btn-info btn-sm" title="Lihat Detail">
                                    <i class="fas fa-eye"></i>
                                </a>
                            @endif
                            <button class="btn btn-warning btn-sm" title="Edit User"
                                onclick="alert('Fitur edit user belum tersedia')">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-danger btn-sm" title="Hapus User"
                                onclick="alert('Fitur hapus user belum tersedia')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            @endforeach
            @if(count($users) == 0)
                <tr>
                    <td colspan="6" class="text-center">Tidak ada data user yang ditemukan</td>
                </tr>
            @endif
        </tbody>
    </table>
</div>