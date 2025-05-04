-- Tambahkan kolom area_operasi ke tabel nomor_polisi
ALTER TABLE `nomor_polisi` 
ADD COLUMN IF NOT EXISTS `area_operasi` varchar(100) NULL AFTER `ukuran_id`;
