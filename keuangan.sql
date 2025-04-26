-- Membuat tabel financial_accounts
CREATE TABLE `financial_accounts` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_type` enum('kas','bank') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `financial_accounts_account_code_unique` (`account_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Membuat tabel kas_transactions
CREATE TABLE `kas_transactions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `voucher_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `debit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kas_transactions_voucher_number_unique` (`voucher_number`),
  KEY `kas_transactions_account_id_foreign` (`account_id`),
  KEY `kas_transactions_year_month_index` (`year`,`month`),
  KEY `kas_transactions_transaction_date_index` (`transaction_date`),
  CONSTRAINT `kas_transactions_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `financial_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Membuat tabel bank_transactions
CREATE TABLE `bank_transactions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `voucher_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `debit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bank_transactions_voucher_number_unique` (`voucher_number`),
  KEY `bank_transactions_account_id_foreign` (`account_id`),
  KEY `bank_transactions_year_month_index` (`year`,`month`),
  KEY `bank_transactions_transaction_date_index` (`transaction_date`),
  CONSTRAINT `bank_transactions_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `financial_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Membuat tabel transaction_descriptions
CREATE TABLE `transaction_descriptions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `category` enum('kas','bank','both') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'both',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_descriptions_description_unique` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Menambahkan beberapa data awal untuk akun keuangan
INSERT INTO `financial_accounts` (`account_code`, `account_name`, `description`, `account_type`, `is_active`, `created_at`, `updated_at`) VALUES
('KAS001', 'Kas Operasional', 'Kas untuk kegiatan operasional sehari-hari', 'kas', 1, NOW(), NOW()),
('KAS002', 'Kas Kecil', 'Kas untuk pengeluaran kecil', 'kas', 1, NOW(), NOW()),
('BNK001', 'Bank BCA', 'Rekening Bank BCA', 'bank', 1, NOW(), NOW()),
('BNK002', 'Bank Mandiri', 'Rekening Bank Mandiri', 'bank', 1, NOW(), NOW());

-- Menambahkan contoh deskripsi transaksi
INSERT INTO `transaction_descriptions` (`description`, `is_active`, `category`, `created_at`, `updated_at`) VALUES
('Pembayaran Gaji Karyawan', 1, 'both', NOW(), NOW()),
('Pembayaran Listrik', 1, 'both', NOW(), NOW()),
('Pembayaran Air', 1, 'both', NOW(), NOW()),
('Pembayaran Internet', 1, 'both', NOW(), NOW()),
('Pembayaran Sewa Kantor', 1, 'both', NOW(), NOW()),
('Penerimaan Pembayaran Invoice', 1, 'both', NOW(), NOW()),
('Setoran Kas ke Bank', 1, 'both', NOW(), NOW()),
('Penarikan Kas dari Bank', 1, 'both', NOW(), NOW()),
('Pembelian ATK', 1, 'kas', NOW(), NOW()),
('Biaya Transportasi', 1, 'kas', NOW(), NOW()),
('Biaya Entertainment', 1, 'kas', NOW(), NOW()),
('Transfer Antar Bank', 1, 'bank', NOW(), NOW()),
('Biaya Admin Bank', 1, 'bank', NOW(), NOW()),
('Penerimaan Bunga Bank', 1, 'bank', NOW(), NOW());

-- Menambahkan contoh data transaksi kas
INSERT INTO `kas_transactions` (`voucher_number`, `account_id`, `transaction_date`, `description`, `credit`, `debit`, `balance`, `year`, `month`, `created_at`, `updated_at`) VALUES
('KAS0001', 1, '2025-04-01', 'Saldo Awal', 5000000.00, 0.00, 5000000.00, 2025, 4, NOW(), NOW()),
('KAS0002', 1, '2025-04-05', 'Pembelian ATK', 0.00, 500000.00, 4500000.00, 2025, 4, NOW(), NOW()),
('KAS0003', 1, '2025-04-10', 'Penerimaan Pembayaran Invoice', 1000000.00, 0.00, 5500000.00, 2025, 4, NOW(), NOW()),
('KAS0004', 2, '2025-04-15', 'Saldo Awal Kas Kecil', 1000000.00, 0.00, 1000000.00, 2025, 4, NOW(), NOW()),
('KAS0005', 2, '2025-04-20', 'Biaya Transportasi', 0.00, 150000.00, 850000.00, 2025, 4, NOW(), NOW());

-- Menambahkan contoh data transaksi bank
INSERT INTO `bank_transactions` (`voucher_number`, `account_id`, `transaction_date`, `description`, `credit`, `debit`, `balance`, `year`, `month`, `created_at`, `updated_at`) VALUES
('MDR0001', 3, '2025-04-01', 'Saldo Awal', 10000000.00, 0.00, 10000000.00, 2025, 4, NOW(), NOW()),
('MDR0002', 3, '2025-04-07', 'Pembayaran Supplier', 0.00, 2500000.00, 7500000.00, 2025, 4, NOW(), NOW()),
('MDR0003', 3, '2025-04-12', 'Penerimaan Pembayaran Invoice', 5000000.00, 0.00, 12500000.00, 2025, 4, NOW(), NOW()),
('MDR0004', 4, '2025-04-05', 'Saldo Awal Bank Mandiri', 8000000.00, 0.00, 8000000.00, 2025, 4, NOW(), NOW()),
('MDR0005', 4, '2025-04-18', 'Pembayaran Gaji Karyawan', 0.00, 3000000.00, 5000000.00, 2025, 4, NOW(), NOW());
