-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 07, 2025 at 03:03 PM
-- Server version: 10.11.10-MariaDB
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u575891269_mpsfix`
--

-- --------------------------------------------------------

--
-- Table structure for table `alamat_pengambilan`
--

CREATE TABLE `alamat_pengambilan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_alamat` varchar(500) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bank_transactions`
--

CREATE TABLE `bank_transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `voucher_number` varchar(255) NOT NULL,
  `account_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_date` date NOT NULL,
  `description` text DEFAULT NULL,
  `credit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `debit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `billings`
--

CREATE TABLE `billings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invoice_id` bigint(20) UNSIGNED DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `billing_number` varchar(255) NOT NULL,
  `billing_date` date NOT NULL,
  `total_volume` decimal(12,2) NOT NULL,
  `total_amount` decimal(20,2) NOT NULL,
  `total_deposit` decimal(12,2) NOT NULL,
  `previous_balance` decimal(20,2) NOT NULL,
  `current_balance` decimal(20,2) NOT NULL,
  `amount_to_pay` decimal(20,2) NOT NULL,
  `period_month` int(11) NOT NULL,
  `period_year` int(11) NOT NULL,
  `period_type` enum('monthly','custom') NOT NULL DEFAULT 'monthly',
  `custom_start_date` date DEFAULT NULL,
  `custom_end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `data_pencatatan`
--

CREATE TABLE `data_pencatatan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `nama_customer` varchar(255) NOT NULL,
  `data_input` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data_input`)),
  `harga_final` decimal(15,2) NOT NULL DEFAULT 0.00,
  `status_pembayaran` enum('belum_lunas','lunas') NOT NULL DEFAULT 'belum_lunas',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `financial_accounts`
--

CREATE TABLE `financial_accounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `account_code` varchar(255) NOT NULL,
  `account_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `account_type` enum('kas','bank') NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `billing_id` bigint(20) UNSIGNED DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `id_pelanggan` varchar(15) NOT NULL,
  `invoice_number` varchar(255) NOT NULL,
  `invoice_date` date NOT NULL,
  `due_date` date NOT NULL,
  `total_amount` decimal(20,2) NOT NULL,
  `total_volume` decimal(12,2) DEFAULT 0.00,
  `no_kontrak` varchar(255) NOT NULL,
  `status` enum('paid','unpaid','partial','cancelled') NOT NULL DEFAULT 'unpaid',
  `description` text DEFAULT NULL,
  `period_month` int(11) NOT NULL,
  `period_year` int(11) NOT NULL,
  `period_type` enum('monthly','custom') NOT NULL DEFAULT 'monthly',
  `custom_start_date` date DEFAULT NULL,
  `custom_end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kas_transactions`
--

CREATE TABLE `kas_transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `voucher_number` varchar(255) NOT NULL,
  `account_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_date` date NOT NULL,
  `description` text DEFAULT NULL,
  `credit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `debit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `konfigurasi_lembur`
--

CREATE TABLE `konfigurasi_lembur` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_konfigurasi` varchar(255) NOT NULL,
  `tarif_per_jam` decimal(12,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `monthly_customer_balances`
--

CREATE TABLE `monthly_customer_balances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `year_month` varchar(7) NOT NULL COMMENT 'Format: 2024-01',
  `opening_balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_deposits` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_purchases` decimal(15,2) NOT NULL DEFAULT 0.00,
  `closing_balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_volume_sm3` decimal(15,4) NOT NULL DEFAULT 0.0000,
  `calculation_details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Detail perhitungan untuk audit' CHECK (json_valid(`calculation_details`)),
  `last_calculated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nomor_polisi`
--

CREATE TABLE `nomor_polisi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nopol` varchar(20) NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `jenis` varchar(100) DEFAULT NULL,
  `ukuran_id` bigint(20) UNSIGNED DEFAULT NULL,
  `area_operasi` varchar(100) DEFAULT NULL,
  `no_gtm` varchar(20) DEFAULT NULL,
  `status` enum('milik','sewa','disewakan','FOB') DEFAULT NULL,
  `iso` enum('ISO - 11439','ISO - 11119') DEFAULT NULL,
  `coi` enum('sudah','belum') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operator_gtm`
--

CREATE TABLE `operator_gtm` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `lokasi_kerja` varchar(255) NOT NULL,
  `gaji_pokok` decimal(12,2) NOT NULL DEFAULT 3500000.00,
  `jam_kerja` int(11) NOT NULL DEFAULT 8,
  `tanggal_bergabung` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operator_gtm_lembur`
--

CREATE TABLE `operator_gtm_lembur` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `operator_gtm_id` bigint(20) UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `jam_masuk_sesi_1` time DEFAULT NULL,
  `jam_keluar_sesi_1` time DEFAULT NULL,
  `jam_masuk_sesi_2` time DEFAULT NULL,
  `jam_keluar_sesi_2` time DEFAULT NULL,
  `jam_masuk_sesi_3` time DEFAULT NULL,
  `jam_keluar_sesi_3` time DEFAULT NULL,
  `total_jam_kerja` int(11) DEFAULT NULL,
  `total_jam_lembur` int(11) DEFAULT NULL,
  `upah_lembur` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `proforma_invoices`
--

CREATE TABLE `proforma_invoices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `proforma_number` varchar(255) NOT NULL,
  `proforma_date` date NOT NULL,
  `due_date` date NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `total_volume` decimal(10,3) NOT NULL DEFAULT 0.000,
  `volume_per_day` decimal(10,3) NOT NULL,
  `price_per_sm3` decimal(12,2) NOT NULL,
  `total_days` int(11) NOT NULL,
  `status` enum('draft','sent','expired','converted') NOT NULL DEFAULT 'draft',
  `description` text DEFAULT NULL,
  `no_kontrak` varchar(255) NOT NULL,
  `id_pelanggan` varchar(255) NOT NULL,
  `period_start_date` date NOT NULL,
  `period_end_date` date NOT NULL,
  `validity_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rekap_pengambilan`
--

CREATE TABLE `rekap_pengambilan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tanggal` datetime DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `nopol` varchar(20) NOT NULL,
  `volume` decimal(10,2) NOT NULL,
  `alamat_pengambilan_id` bigint(20) UNSIGNED DEFAULT NULL,
  `alamat_pengambilan` text DEFAULT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` text NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_calculations`
--

CREATE TABLE `transaction_calculations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `data_pencatatan_id` bigint(20) UNSIGNED NOT NULL,
  `year_month` varchar(7) NOT NULL COMMENT 'Format: 2024-01',
  `transaction_date` date NOT NULL,
  `volume_flow_meter` decimal(15,4) NOT NULL DEFAULT 0.0000,
  `koreksi_meter` decimal(15,8) NOT NULL DEFAULT 1.00000000,
  `volume_sm3` decimal(15,4) NOT NULL DEFAULT 0.0000,
  `harga_per_m3` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_harga` decimal(15,2) NOT NULL DEFAULT 0.00,
  `pricing_used` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Pricing yang digunakan saat perhitungan' CHECK (json_valid(`pricing_used`)),
  `tekanan_keluar` decimal(10,3) DEFAULT NULL,
  `suhu` decimal(10,2) DEFAULT NULL,
  `calculated_at` timestamp NOT NULL,
  `is_recalculated` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_descriptions`
--

CREATE TABLE `transaction_descriptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `description` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `category` enum('kas','bank','both') NOT NULL DEFAULT 'both',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ukuran`
--

CREATE TABLE `ukuran` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_ukuran` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `total_deposit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_purchases` decimal(15,2) NOT NULL DEFAULT 0.00,
  `deposit_history` text DEFAULT NULL,
  `monthly_balances` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`monthly_balances`)),
  `pricing_history` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`pricing_history`)),
  `balance_last_updated_at` timestamp NULL DEFAULT NULL,
  `use_realtime_calculation` tinyint(1) NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','superadmin','customer','demo','fob') NOT NULL DEFAULT 'customer',
  `no_kontrak` varchar(255) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `nomor_tlpn` varchar(20) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `harga_per_meter_kubik` decimal(10,2) DEFAULT 0.00 COMMENT 'Harga per meter kubik',
  `tekanan_keluar` decimal(10,3) DEFAULT 0.000 COMMENT 'Tekanan keluar dalam Bar',
  `suhu` decimal(10,2) DEFAULT 0.00 COMMENT 'Suhu dalam Celsius',
  `koreksi_meter` decimal(16,14) DEFAULT 1.00000000000000 COMMENT 'Faktor koreksi meter'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alamat_pengambilan`
--
ALTER TABLE `alamat_pengambilan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alamat_pengambilan_nama_alamat_unique` (`nama_alamat`);

--
-- Indexes for table `bank_transactions`
--
ALTER TABLE `bank_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bank_transactions_voucher_number_unique` (`voucher_number`),
  ADD KEY `bank_transactions_account_id_foreign` (`account_id`),
  ADD KEY `bank_transactions_year_month_index` (`year`,`month`),
  ADD KEY `bank_transactions_transaction_date_index` (`transaction_date`);

--
-- Indexes for table `billings`
--
ALTER TABLE `billings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `billings_customer_id_foreign` (`customer_id`),
  ADD KEY `billings_invoice_id_foreign` (`invoice_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `data_pencatatan`
--
ALTER TABLE `data_pencatatan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `data_pencatatan_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `financial_accounts`
--
ALTER TABLE `financial_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `financial_accounts_account_code_unique` (`account_code`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoices_customer_id_foreign` (`customer_id`),
  ADD KEY `invoices_billing_id_foreign` (`billing_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kas_transactions`
--
ALTER TABLE `kas_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kas_transactions_voucher_number_unique` (`voucher_number`),
  ADD KEY `kas_transactions_account_id_foreign` (`account_id`),
  ADD KEY `kas_transactions_year_month_index` (`year`,`month`),
  ADD KEY `kas_transactions_transaction_date_index` (`transaction_date`);

--
-- Indexes for table `konfigurasi_lembur`
--
ALTER TABLE `konfigurasi_lembur`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `monthly_customer_balances`
--
ALTER TABLE `monthly_customer_balances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `monthly_customer_balances_customer_id_year_month_unique` (`customer_id`,`year_month`),
  ADD KEY `monthly_customer_balances_customer_id_year_month_index` (`customer_id`,`year_month`),
  ADD KEY `monthly_customer_balances_year_month_index` (`year_month`),
  ADD KEY `idx_monthly_balances_year_month_balance` (`year_month`,`closing_balance`);

--
-- Indexes for table `nomor_polisi`
--
ALTER TABLE `nomor_polisi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nomor_polisi_nopol_unique` (`nopol`),
  ADD KEY `nomor_polisi_ukuran_id_foreign` (`ukuran_id`);

--
-- Indexes for table `operator_gtm`
--
ALTER TABLE `operator_gtm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `operator_gtm_lembur`
--
ALTER TABLE `operator_gtm_lembur`
  ADD PRIMARY KEY (`id`),
  ADD KEY `operator_gtm_lembur_operator_gtm_id_foreign` (`operator_gtm_id`);

--
-- Indexes for table `proforma_invoices`
--
ALTER TABLE `proforma_invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proforma_invoices_customer_id_foreign` (`customer_id`),
  ADD KEY `proforma_invoices_customer_id_proforma_date_index` (`customer_id`,`proforma_date`),
  ADD KEY `proforma_invoices_status_index` (`status`);

--
-- Indexes for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rekap_pengambilan_customer_id_foreign` (`customer_id`),
  ADD KEY `rekap_pengambilan_nopol_foreign` (`nopol`),
  ADD KEY `rekap_pengambilan_alamat_pengambilan_id_foreign` (`alamat_pengambilan_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `transaction_calculations`
--
ALTER TABLE `transaction_calculations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_calculations_data_pencatatan_id_unique` (`data_pencatatan_id`),
  ADD KEY `transaction_calculations_customer_id_year_month_index` (`customer_id`,`year_month`),
  ADD KEY `transaction_calculations_customer_id_transaction_date_index` (`customer_id`,`transaction_date`),
  ADD KEY `transaction_calculations_year_month_index` (`year_month`),
  ADD KEY `idx_transaction_calc_date_amount` (`transaction_date`,`total_harga`);

--
-- Indexes for table `transaction_descriptions`
--
ALTER TABLE `transaction_descriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_descriptions_description_unique` (`description`);

--
-- Indexes for table `ukuran`
--
ALTER TABLE `ukuran`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ukuran_nama_ukuran_unique` (`nama_ukuran`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `idx_users_realtime_flag` (`use_realtime_calculation`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alamat_pengambilan`
--
ALTER TABLE `alamat_pengambilan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bank_transactions`
--
ALTER TABLE `bank_transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `billings`
--
ALTER TABLE `billings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `data_pencatatan`
--
ALTER TABLE `data_pencatatan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `financial_accounts`
--
ALTER TABLE `financial_accounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kas_transactions`
--
ALTER TABLE `kas_transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `konfigurasi_lembur`
--
ALTER TABLE `konfigurasi_lembur`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `monthly_customer_balances`
--
ALTER TABLE `monthly_customer_balances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nomor_polisi`
--
ALTER TABLE `nomor_polisi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operator_gtm`
--
ALTER TABLE `operator_gtm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operator_gtm_lembur`
--
ALTER TABLE `operator_gtm_lembur`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `proforma_invoices`
--
ALTER TABLE `proforma_invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_calculations`
--
ALTER TABLE `transaction_calculations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_descriptions`
--
ALTER TABLE `transaction_descriptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ukuran`
--
ALTER TABLE `ukuran`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bank_transactions`
--
ALTER TABLE `bank_transactions`
  ADD CONSTRAINT `bank_transactions_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `financial_accounts` (`id`);

--
-- Constraints for table `billings`
--
ALTER TABLE `billings`
  ADD CONSTRAINT `billings_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `data_pencatatan`
--
ALTER TABLE `data_pencatatan`
  ADD CONSTRAINT `data_pencatatan_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_billing_id_foreign` FOREIGN KEY (`billing_id`) REFERENCES `billings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `kas_transactions`
--
ALTER TABLE `kas_transactions`
  ADD CONSTRAINT `kas_transactions_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `financial_accounts` (`id`);

--
-- Constraints for table `monthly_customer_balances`
--
ALTER TABLE `monthly_customer_balances`
  ADD CONSTRAINT `monthly_customer_balances_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `nomor_polisi`
--
ALTER TABLE `nomor_polisi`
  ADD CONSTRAINT `nomor_polisi_ukuran_id_foreign` FOREIGN KEY (`ukuran_id`) REFERENCES `ukuran` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `operator_gtm_lembur`
--
ALTER TABLE `operator_gtm_lembur`
  ADD CONSTRAINT `operator_gtm_lembur_operator_gtm_id_foreign` FOREIGN KEY (`operator_gtm_id`) REFERENCES `operator_gtm` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `proforma_invoices`
--
ALTER TABLE `proforma_invoices`
  ADD CONSTRAINT `proforma_invoices_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  ADD CONSTRAINT `rekap_pengambilan_alamat_pengambilan_id_foreign` FOREIGN KEY (`alamat_pengambilan_id`) REFERENCES `alamat_pengambilan` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `transaction_calculations`
--
ALTER TABLE `transaction_calculations`
  ADD CONSTRAINT `transaction_calculations_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaction_calculations_data_pencatatan_id_foreign` FOREIGN KEY (`data_pencatatan_id`) REFERENCES `data_pencatatan` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
