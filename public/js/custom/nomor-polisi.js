/**
 * JavaScript kustom untuk halaman nomor polisi
 */

// Initialize document ready handler
$(document).ready(function() {
    // Inisialisasi DataTable
    if($.fn.DataTable) {
        $('#nopolTable').DataTable({
            "paging": true,
            "lengthChange": false,
            "searching": true,
            "ordering": true,
            "info": true,
            "autoWidth": false,
            "responsive": true,
        });
    }
    
    // Event handler untuk tombol edit menggunakan event delegation
    // Event delegation memastikan tombol berfungsi bahkan setelah DataTable memuat ulang data
    $(document).on('click', '.edit-nopol', function(e) {
        e.preventDefault();
        e.stopPropagation(); // Mencegah event propagation
        
        console.log('Edit button clicked');
        
        // Ambil data dari atribut data
        var id = $(this).data('id');
        var nopol = $(this).data('nopol');
        var keterangan = $(this).data('keterangan') || '';
        
        console.log('Edit data:', id, nopol, keterangan);
        
        // Set form action URL
        $('#formEditNopol').attr('action', BASE_URL + '/nomor-polisi/' + id);
        
        // Isi form dengan data
        $('#edit_nopol').val(nopol);
        $('#edit_keterangan').val(keterangan);
        
        // Tampilkan modal
        $('#editNopolModal').modal('show');
    });
    
    // Event handler untuk tombol edit pada mobile view
    // Kadang jQuery delegasi tidak berfungsi baik pada tampilan mobile
    $('.edit-nopol').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        console.log('Direct click handler');
        
        // Ambil data dari atribut data
        var id = $(this).data('id');
        var nopol = $(this).data('nopol');
        var keterangan = $(this).data('keterangan') || '';
        
        // Set form action URL
        $('#formEditNopol').attr('action', BASE_URL + '/nomor-polisi/' + id);
        
        // Isi form dengan data
        $('#edit_nopol').val(nopol);
        $('#edit_keterangan').val(keterangan);
        
        // Tampilkan modal
        $('#editNopolModal').modal('show');
    });
    
    // Log konfirmasi bahwa script sudah dimuat
    console.log('Nomor polisi script loaded successfully');
});
