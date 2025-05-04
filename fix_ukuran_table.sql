-- Cek apakah tabel ukuran sudah ada
CREATE TABLE IF NOT EXISTS `ukuran` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama_ukuran` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ukuran_nama_ukuran_unique` (`nama_ukuran`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tambahkan beberapa data ukuran awal (akan diabaikan jika sudah ada)
INSERT IGNORE INTO `ukuran` (`nama_ukuran`, `created_at`, `updated_at`) VALUES 
('Kecil', NOW(), NOW()),
('Sedang', NOW(), NOW()),
('Besar', NOW(), NOW());

-- Cek jika foreign key ada masalah
ALTER TABLE `nomor_polisi` DROP FOREIGN KEY IF EXISTS `nomor_polisi_ukuran_id_foreign`;

-- Tambahkan kolom ukuran_id jika belum ada
ALTER TABLE `nomor_polisi` ADD COLUMN IF NOT EXISTS `ukuran_id` bigint(20) UNSIGNED NULL AFTER `jenis`;

-- Buat ulang foreign key
ALTER TABLE `nomor_polisi` 
ADD CONSTRAINT `nomor_polisi_ukuran_id_foreign` FOREIGN KEY (`ukuran_id`) REFERENCES `ukuran` (`id`) ON DELETE SET NULL;
