-- Script untuk membersihkan data duplikat di tabel harga_gagas
-- Jalankan script ini SEBELUM menjalankan migration unique constraint

-- Hapus duplikasi, hanya simpan data terbaru per periode
DELETE h1 FROM harga_gagas h1
INNER JOIN harga_gagas h2 
WHERE h1.periode_tahun = h2.periode_tahun 
  AND h1.periode_bulan = h2.periode_bulan 
  AND h1.id < h2.id;

-- Verifikasi tidak ada duplikasi lagi
SELECT periode_tahun, periode_bulan, COUNT(*) as jumlah
FROM harga_gagas 
GROUP BY periode_tahun, periode_bulan 
HAVING COUNT(*) > 1;

-- Query ini seharusnya tidak mengembalikan hasil jika duplikasi sudah bersih
