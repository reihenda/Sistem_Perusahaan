-- Buat tabel ukuran untuk menyimpan daftar ukuran
CREATE TABLE IF NOT EXISTS `ukuran` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama_ukuran` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ukuran_nama_ukuran_unique` (`nama_ukuran`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tambahkan kolom baru ke tabel nomor_polisi jika belum ada
ALTER TABLE `nomor_polisi` 
ADD COLUMN IF NOT EXISTS `jenis` varchar(100) NULL AFTER `keterangan`,
ADD COLUMN IF NOT EXISTS `ukuran_id` bigint(20) UNSIGNED NULL AFTER `jenis`,
ADD COLUMN IF NOT EXISTS `no_gtm` varchar(20) NULL AFTER `ukuran_id`,
ADD COLUMN IF NOT EXISTS `status` ENUM('milik', 'sewa', 'disewakan') NULL AFTER `no_gtm`,
ADD COLUMN IF NOT EXISTS `iso` ENUM('ISO - 11439', 'ISO - 11119') NULL AFTER `status`,
ADD COLUMN IF NOT EXISTS `coi` ENUM('sudah', 'belum') NULL AFTER `iso`;

-- Tambahkan foreign key jika belum ada
ALTER TABLE `nomor_polisi` 
ADD CONSTRAINT IF NOT EXISTS `nomor_polisi_ukuran_id_foreign` FOREIGN KEY (`ukuran_id`) REFERENCES `ukuran` (`id`) ON DELETE SET NULL;

-- Tambahkan beberapa data ukuran awal untuk testing
INSERT INTO `ukuran` (`nama_ukuran`, `created_at`, `updated_at`) VALUES 
('Kecil', NOW(), NOW()),
('Sedang', NOW(), NOW()),
('Besar', NOW(), NOW())
ON DUPLICATE KEY UPDATE nama_ukuran = VALUES(nama_ukuran);
