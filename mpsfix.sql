-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 04, 2025 at 09:55 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mpsfix`
--

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

--
-- Dumping data for table `bank_transactions`
--

INSERT INTO `bank_transactions` (`id`, `voucher_number`, `account_id`, `transaction_date`, `description`, `credit`, `debit`, `balance`, `year`, `month`, `created_at`, `updated_at`) VALUES
(1, 'MDR0001', 3, '2025-04-01', 'Saldo Awal', 10000000.00, 0.00, 10000000.00, 2025, 4, '2025-04-26 00:28:29', '2025-04-26 00:28:29'),
(2, 'MDR0002', 3, '2025-04-07', 'Pembayaran Supplier', 0.00, 2500000.00, 7500000.00, 2025, 4, '2025-04-26 00:28:29', '2025-04-26 00:28:29');

-- --------------------------------------------------------

--
-- Table structure for table `billings`
--

CREATE TABLE `billings` (
  `id` bigint(20) UNSIGNED NOT NULL,
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
  `status` enum('paid','unpaid','partial','cancelled') NOT NULL DEFAULT 'unpaid',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `billings`
--

INSERT INTO `billings` (`id`, `customer_id`, `billing_number`, `billing_date`, `total_volume`, `total_amount`, `total_deposit`, `previous_balance`, `current_balance`, `amount_to_pay`, `period_month`, `period_year`, `status`, `created_at`, `updated_at`) VALUES
(1, 5, '001/MPS/BIL-CUST/04/2025', '2025-04-12', 179249406.96, 1667019484724.90, 0.00, -440626781359.93, -2107646266084.90, 2107646266084.90, 4, 2025, 'unpaid', '2025-04-11 20:45:08', '2025-04-11 20:45:08'),
(2, 14, '001/MPS/BIL-PT M/04/2025', '2025-04-14', 1018.00, 4072009.86, 11111111.00, -1357352.92, 5681748.22, 0.00, 3, 2025, 'unpaid', '2025-04-13 19:20:10', '2025-04-13 19:20:10'),
(3, 14, '002/MPS/BIL-PT M/04/2025', '2025-04-14', 0.00, 0.00, 0.00, 5681748.22, 5681748.22, 0.00, 4, 2025, 'unpaid', '2025-04-14 00:45:49', '2025-04-14 00:45:49'),
(4, 14, '003/MPS/BIL-PT M/04/2025', '2025-04-14', 5774.81, 23099248.42, 22222222.00, 4312154.77, 3435128.35, 0.00, 3, 2025, 'unpaid', '2025-04-14 01:03:59', '2025-04-14 01:03:59'),
(5, 14, '004/MPS/BIL-PT M/04/2025', '2025-04-14', 5774.81, 23099248.42, 22222222.00, 4312154.77, 3435128.35, 0.00, 3, 2025, 'unpaid', '2025-04-14 01:05:53', '2025-04-14 01:05:53'),
(6, 4, '001/MPS/BIL-CUST/06/2025', '2025-06-04', 4029820.76, 4029820756.52, 0.00, -954467933.13, -4984288689.65, 4984288689.65, 5, 2025, 'unpaid', '2025-06-03 22:37:46', '2025-06-03 22:37:46'),
(7, 1, '001/MPS/BIL-TEST/06/2025', '2025-06-04', 340.98, 988852.65, 0.00, -861318343.01, -862307195.66, 862307195.66, 5, 2025, 'unpaid', '2025-06-03 22:38:17', '2025-06-03 22:38:17'),
(8, 19, '001/MPS/BIL-TEST/06/2025', '2025-06-04', 31373.77, 188242620.73, 0.00, -394531651.86, -582774272.60, 582774272.60, 5, 2025, 'unpaid', '2025-06-03 23:02:13', '2025-06-03 23:02:13'),
(9, 19, '002/MPS/BIL-TEST/06/2025', '2025-06-04', 31373.77, 188242620.73, 0.00, -394531651.86, -582774272.60, 582774272.60, 5, 2025, 'unpaid', '2025-06-03 23:16:24', '2025-06-03 23:16:24'),
(10, 19, '003/MPS/BIL-TEST/06/2025', '2025-06-04', 31373.77, 188242620.73, 0.00, -394531651.86, -582774272.60, 582774272.60, 5, 2025, 'unpaid', '2025-06-03 23:20:59', '2025-06-03 23:20:59');

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

--
-- Dumping data for table `data_pencatatan`
--

INSERT INTO `data_pencatatan` (`id`, `customer_id`, `nama_customer`, `data_input`, `harga_final`, `status_pembayaran`, `created_at`, `updated_at`) VALUES
(1, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-01T20:45:27\",\"volume\":12205.49},\"pembacaan_akhir\":{\"waktu\":\"2025-03-02T20:46:48\",\"volume\":12463.4},\"volume_flow_meter\":257.91}', 0.00, 'belum_lunas', '2025-03-12 06:46:59', '2025-03-12 06:46:59'),
(2, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-02T21:05:46\",\"volume\":12463.4},\"pembacaan_akhir\":{\"waktu\":\"2025-03-03T21:06:31\",\"volume\":12764.3},\"volume_flow_meter\":300.9}', 0.00, 'belum_lunas', '2025-03-12 07:07:10', '2025-03-12 07:07:10'),
(3, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-03T21:08:20\",\"volume\":12764.3},\"pembacaan_akhir\":{\"waktu\":\"2025-03-04T21:08:49\",\"volume\":12989.78},\"volume_flow_meter\":225.48}', 0.00, 'belum_lunas', '2025-03-12 07:09:21', '2025-03-12 07:09:21'),
(4, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-04T21:10:56\",\"volume\":12989.78},\"pembacaan_akhir\":{\"waktu\":\"2025-03-05T21:11:10\",\"volume\":13247.93},\"volume_flow_meter\":258.15}', 0.00, 'belum_lunas', '2025-03-12 07:11:35', '2025-03-12 07:11:35'),
(5, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-01T21:19:20\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-04-02T21:19:28\",\"volume\":20449.95},\"volume_flow_meter\":286.32}', 0.00, 'belum_lunas', '2025-03-12 07:22:43', '2025-03-12 07:22:43'),
(6, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-02T21:23:41\",\"volume\":20449.95},\"pembacaan_akhir\":{\"waktu\":\"2025-04-03T21:23:51\",\"volume\":20582.09},\"volume_flow_meter\":132.14}', 0.00, 'belum_lunas', '2025-03-12 07:26:42', '2025-03-12 07:26:42'),
(8, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-13T10:08:29\",\"volume\":121212},\"pembacaan_akhir\":{\"waktu\":\"2025-03-14T10:08:33\",\"volume\":12132424},\"volume_flow_meter\":12011212}', 0.00, 'belum_lunas', '2025-03-12 20:08:37', '2025-03-12 20:08:37'),
(18, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-14 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-14 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 21:20:45', '2025-03-19 21:20:45'),
(19, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-15 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-15 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 21:20:45', '2025-03-19 21:20:45'),
(20, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-16 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-16 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 21:20:45', '2025-03-19 21:20:45'),
(21, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-17 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-17 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 21:20:45', '2025-03-19 21:20:45'),
(23, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-15 00:00\",\"volume\":221111},\"pembacaan_akhir\":{\"waktu\":\"2025-03-15 23:59\",\"volume\":221111},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 21:57:47', '2025-03-19 21:57:47'),
(24, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-16 00:00\",\"volume\":221111},\"pembacaan_akhir\":{\"waktu\":\"2025-03-16 23:59\",\"volume\":221111},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 21:57:47', '2025-03-19 21:57:47'),
(25, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-17 00:00\",\"volume\":221111},\"pembacaan_akhir\":{\"waktu\":\"2025-03-17 23:59\",\"volume\":221111},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 21:57:47', '2025-03-19 21:57:47'),
(26, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-18 00:00\",\"volume\":221111},\"pembacaan_akhir\":{\"waktu\":\"2025-03-18 23:59\",\"volume\":221111},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 21:57:47', '2025-03-19 21:57:47'),
(29, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-14T00:00\",\"volume\":123124},\"pembacaan_akhir\":{\"waktu\":\"2025-03-15T23:59\",\"volume\":123344},\"volume_flow_meter\":220}', 897540.18, 'belum_lunas', '2025-03-19 21:59:57', '2025-05-17 20:28:44'),
(31, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-18 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-18 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(32, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-19 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-19 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(33, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-20 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-20 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(34, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-21 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-21 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(35, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-22 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-22 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(36, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-23 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-23 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(37, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-24 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-24 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(38, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-25 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-25 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(39, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-26 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-26 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(40, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-27 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-27 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(41, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-28 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-28 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(42, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-29 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-29 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(43, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-30 00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-03-30 23:59\",\"volume\":333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(44, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-31T00:00\",\"volume\":333},\"pembacaan_akhir\":{\"waktu\":\"2025-04-01T23:59\",\"volume\":665.999},\"volume_flow_meter\":332.999}', 2036004.93, 'belum_lunas', '2025-03-19 22:10:03', '2025-03-19 22:10:03'),
(45, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-04 00:00\",\"volume\":20582.09},\"pembacaan_akhir\":{\"waktu\":\"2025-04-04 23:59\",\"volume\":20582.09},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:15:16', '2025-03-19 22:15:16'),
(46, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-05T00:00\",\"volume\":20582.09},\"pembacaan_akhir\":{\"waktu\":\"2025-04-06T23:59\",\"volume\":111111},\"volume_flow_meter\":90528.91}', 3321440284.74, 'belum_lunas', '2025-03-19 22:15:16', '2025-03-19 22:15:16'),
(47, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-06T00:00\",\"volume\":111111},\"pembacaan_akhir\":{\"waktu\":\"2025-04-07T00:00\",\"volume\":111111},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:28:02', '2025-03-19 23:29:13'),
(48, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-07 00:00\",\"volume\":111111},\"pembacaan_akhir\":{\"waktu\":\"2025-04-07 23:59\",\"volume\":111111},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:28:02', '2025-03-19 22:28:02'),
(49, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-08T00:00\",\"volume\":111111},\"pembacaan_akhir\":{\"waktu\":\"2025-04-09T06:00\",\"volume\":222222},\"volume_flow_meter\":111111}', 4076582292.64, 'belum_lunas', '2025-03-19 22:28:02', '2025-03-19 23:00:22'),
(50, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-07 00:00\",\"volume\":111111},\"pembacaan_akhir\":{\"waktu\":\"2025-04-08 00:00\",\"volume\":111111},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-19 22:46:57', '2025-03-19 22:46:57'),
(54, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-10T06:00\",\"volume\":222222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-11T06:00\",\"volume\":333333},\"volume_flow_meter\":111111}', 4076582292.64, 'belum_lunas', '2025-03-19 22:59:26', '2025-03-19 22:59:26'),
(55, 16, 'Demo User', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-27T04:43\",\"volume\":12000},\"pembacaan_akhir\":{\"waktu\":\"2025-03-28T04:43\",\"volume\":12300},\"volume_flow_meter\":300}', 6046650.00, 'belum_lunas', '2025-03-26 21:44:11', '2025-03-26 21:44:11'),
(56, 17, 'test fob', '{\"waktu\":\"2025-03-27T06:28\",\"volume_sm3\":\"300\",\"keterangan\":null}', 166500.00, 'belum_lunas', '2025-03-26 23:28:48', '2025-05-20 00:49:42'),
(57, 17, 'test fob', '{\"waktu\":\"2025-03-28T02:19\",\"volume_sm3\":\"500\",\"keterangan\":null}', 277500.00, 'belum_lunas', '2025-03-27 19:19:09', '2025-03-27 19:19:09'),
(58, 18, 'test2', '{\"waktu\":\"2025-03-28T02:19\",\"volume_sm3\":\"700\",\"keterangan\":null}', 4200000.00, 'belum_lunas', '2025-03-27 19:19:44', '2025-05-26 23:57:22'),
(59, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-12T00:00\",\"volume\":333333},\"pembacaan_akhir\":{\"waktu\":\"2025-04-13T23:59\",\"volume\":12312312},\"volume_flow_meter\":11978979}', 439500082577.33, 'belum_lunas', '2025-03-27 22:54:08', '2025-03-27 22:54:08'),
(60, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-28T00:00\",\"volume\":665.999},\"pembacaan_akhir\":{\"waktu\":\"2024-11-30T23:59\",\"volume\":777},\"volume_flow_meter\":111.001}', 1357352.92, 'belum_lunas', '2025-03-28 00:17:45', '2025-03-28 00:17:45'),
(62, 17, 'test fob', '{\"waktu\":\"2025-04-08T03:02\",\"volume_sm3\":\"600\",\"keterangan\":null}', 333000.00, 'belum_lunas', '2025-04-07 20:02:39', '2025-04-07 20:02:39'),
(63, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-08T00:00\",\"volume\":5656},\"pembacaan_akhir\":{\"waktu\":\"2025-04-09T23:59\",\"volume\":23222},\"volume_flow_meter\":17566}', 103842067.88, 'belum_lunas', '2025-04-07 22:12:08', '2025-05-17 20:27:22'),
(64, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-12 00:00\",\"volume\":333333},\"pembacaan_akhir\":{\"waktu\":\"2025-04-12 23:59\",\"volume\":333333},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-08 18:11:24', '2025-04-08 18:11:24'),
(65, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-13T00:00\",\"volume\":12312312},\"pembacaan_akhir\":{\"waktu\":\"2025-04-14T23:59\",\"volume\":45456313},\"volume_flow_meter\":33144001}', 1216029444282.60, 'belum_lunas', '2025-04-08 18:11:24', '2025-04-08 18:11:24'),
(66, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-01 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-01 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(67, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-02 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-02 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(68, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-03 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-03 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(69, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-04 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-04 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(70, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-05 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-05 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(71, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-06 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-06 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(72, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-07 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-07 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(73, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-08 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-08 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(74, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-09 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-09 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(75, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-10 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-10 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(76, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-11 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-11 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(77, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-12 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-12 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(78, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-13 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-13 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(79, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-14 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-14 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(80, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-15 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-15 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(81, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-16 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-16 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(82, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-17 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-17 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(83, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-18 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-18 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(84, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-19 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-19 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(85, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-20 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-20 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(86, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-21 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-21 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(87, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-22 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-22 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(88, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-23 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-23 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(89, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-24 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-24 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(90, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-25 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-25 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(91, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-26 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-26 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(92, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-27 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-27 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(93, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-28 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-28 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(94, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-29 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-29 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(95, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-30 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-30 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(96, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-31 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2024-12-31 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(97, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-01 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-01 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(98, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-02 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-02 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(99, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-03 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-03 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(100, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-04 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-04 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(101, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-05 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-05 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(102, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-06 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-06 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(103, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-07 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-07 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(104, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-08 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-08 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(105, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-09 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-09 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(106, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-10 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-10 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(107, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-11 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-11 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(108, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-12 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-12 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(109, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-13 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-13 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(110, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-14 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-14 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(111, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-15 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-15 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(112, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-16 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-16 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(113, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-17 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-17 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(114, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-18 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-18 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(115, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-19 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-19 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(116, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-20 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-20 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(117, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-21 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-21 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(118, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-22 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-22 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(119, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-23 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-23 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(120, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-24 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-24 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(121, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-25 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-25 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(122, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-26 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-26 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(123, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-27 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-27 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(124, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-28 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-28 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(125, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-29 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-29 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(126, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-30 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-30 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(127, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-31 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-01-31 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(128, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-01 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-01 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(129, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-02 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-02 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(130, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-03 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-03 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(131, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-04 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-04 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(132, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-05 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-05 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(133, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-06 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-06 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(134, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-07 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-07 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(135, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-08 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-08 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(136, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-09 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-09 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(137, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-10 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-10 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(138, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-11 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-11 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(139, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-12 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-12 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(140, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-13 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-13 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(141, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-14 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-14 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(142, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-15 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-15 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(143, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-16 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-16 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(144, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-17 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-17 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(145, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-18 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-18 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(146, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-19 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-19 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(147, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-20 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-20 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(148, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-21 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-21 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(149, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-22 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-22 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(150, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-23 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-23 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(151, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-24 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-24 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(152, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-25 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-25 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(153, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-26 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-26 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(154, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-27 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-27 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(155, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-28 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-02-28 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:01:12', '2025-04-14 01:01:12'),
(156, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-01T00:00\",\"volume\":665.999},\"pembacaan_akhir\":{\"waktu\":\"2025-03-02T23:59\",\"volume\":1111},\"volume_flow_meter\":445.001}', 5441603.31, 'belum_lunas', '2025-04-14 01:01:12', '2025-04-14 01:04:46'),
(160, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-04 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-03-04 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:02:46', '2025-04-14 01:02:46'),
(162, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-06 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-03-06 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:02:46', '2025-04-14 01:02:46'),
(163, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-07 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-03-07 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:02:46', '2025-04-14 01:02:46'),
(164, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-08 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-03-08 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:02:46', '2025-04-14 01:02:46'),
(165, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-09 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-03-09 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:02:46', '2025-04-14 01:02:46'),
(166, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-10 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-03-10 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:02:46', '2025-04-14 01:02:46'),
(167, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-11 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-03-11 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:02:46', '2025-04-14 01:02:46'),
(168, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-12 00:00\",\"volume\":777},\"pembacaan_akhir\":{\"waktu\":\"2025-03-12 23:59\",\"volume\":777},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-04-14 01:02:46', '2025-04-14 01:02:46'),
(169, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-13T00:00\",\"volume\":1111},\"pembacaan_akhir\":{\"waktu\":\"2025-03-14T23:59\",\"volume\":2222},\"volume_flow_meter\":1111}', 13585635.26, 'belum_lunas', '2025-04-14 01:02:46', '2025-04-14 01:05:32'),
(170, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-10 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-10 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(171, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-11 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-11 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(172, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-12 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-12 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(173, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-13 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-13 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(174, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-14 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-14 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(175, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-15 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-15 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(176, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-16 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-16 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(177, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-17 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-17 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(178, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-18 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-18 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(179, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-19 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-19 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(180, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-20 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-20 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(181, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-21 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-21 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(182, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-22 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-22 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(183, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-23 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-23 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(184, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-24 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-24 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(185, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-25 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-25 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(186, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-26 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-26 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(187, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-27 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-27 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(188, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-28 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-28 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(189, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-29 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-29 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(190, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-30 00:00\",\"volume\":23222},\"pembacaan_akhir\":{\"waktu\":\"2025-04-30 23:59\",\"volume\":23222},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-04 08:40:55', '2025-05-28 08:04:05'),
(195, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 1535454.62, 'belum_lunas', '2025-05-04 09:35:53', '2025-05-04 09:35:53'),
(196, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 3378639.04, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-04 09:35:54'),
(197, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 2316196.26, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-04 09:35:54'),
(198, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-28 08:04:05'),
(199, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 2640489.76, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-04 09:35:54'),
(200, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 2502301.21, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-04 09:35:54'),
(201, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 1584317.52, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-04 09:35:54'),
(202, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 883242.82, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(203, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 448449.24, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(204, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-28 08:04:05'),
(205, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 1044568.68, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(206, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 572236.83, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(207, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 456311.58, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(208, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 133186.94, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(209, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 492726.65, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(210, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 1116393.86, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(211, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-28 08:04:05'),
(212, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 1242546.07, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(213, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1573710.40, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-28 08:04:05'),
(214, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 1395654.89, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(215, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 1369525.89, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(216, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1560764.13, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22');
INSERT INTO `data_pencatatan` (`id`, `customer_id`, `nama_customer`, `data_input`, `harga_final`, `status_pembayaran`, `created_at`, `updated_at`) VALUES
(217, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 1310824.33, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(218, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-28 08:04:05'),
(219, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1780614.21, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(220, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 1352086.86, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(221, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1678344.61, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(222, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1622066.78, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(223, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 1479539.61, 'belum_lunas', '2025-05-04 09:35:54', '2025-05-17 20:27:22'),
(224, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 1535454.62, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-04 09:36:10'),
(225, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 3378639.04, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-04 09:36:10'),
(226, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 2316196.26, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-04 09:36:10'),
(227, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-28 08:04:05'),
(228, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 2640489.76, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-04 09:36:10'),
(229, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 2502301.21, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-04 09:36:10'),
(230, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 1584317.52, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-04 09:36:10'),
(231, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 883242.82, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(232, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 448449.24, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(233, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-28 08:04:05'),
(234, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 1044568.68, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(235, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 572236.83, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(236, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 456311.58, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(237, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 133186.94, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(238, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 492726.65, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(239, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 1116393.86, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(240, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-28 08:04:05'),
(241, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 1242546.07, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(242, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1573710.40, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-28 08:04:05'),
(243, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 1395654.89, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(244, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 1369525.89, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(245, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1560764.13, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(246, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 1310824.33, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(247, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-28 08:04:05'),
(248, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1780614.21, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(249, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 1352086.86, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(250, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1678344.61, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(251, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1622066.78, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(252, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 1479539.61, 'belum_lunas', '2025-05-04 09:36:10', '2025-05-17 20:27:22'),
(253, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 1535454.62, 'belum_lunas', '2025-05-04 17:05:03', '2025-05-04 17:05:03'),
(254, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 3378639.04, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-04 17:05:04'),
(255, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 2316196.26, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-04 17:05:04'),
(256, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-28 08:04:05'),
(257, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 2640489.76, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-04 17:05:04'),
(258, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 2502301.21, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-04 17:05:04'),
(259, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 1584317.52, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-04 17:05:04'),
(260, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 883242.82, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(261, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 448449.24, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(262, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-28 08:04:05'),
(263, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 1044568.68, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(264, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 572236.83, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(265, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 456311.58, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(266, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 133186.94, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(267, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 492726.65, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(268, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 1116393.86, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(269, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-28 08:04:05'),
(270, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 1242546.07, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(271, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1573710.40, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-28 08:04:05'),
(272, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 1395654.89, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(273, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 1369525.89, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(274, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1560764.13, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(275, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 1310824.33, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(276, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-28 08:04:05'),
(277, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1780614.21, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(278, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 1352086.86, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(279, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1678344.61, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(280, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1622066.78, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(281, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 1479539.61, 'belum_lunas', '2025-05-04 17:05:04', '2025-05-17 20:27:22'),
(282, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 1535454.62, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-04 17:09:07'),
(283, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 3378639.04, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-04 17:09:07'),
(284, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 2316196.26, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-04 17:09:07'),
(285, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-28 08:04:05'),
(286, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 2640489.76, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-04 17:09:07'),
(287, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 2502301.21, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-04 17:09:07'),
(288, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 1584317.52, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-04 17:09:07'),
(289, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 883242.82, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(290, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 448449.24, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(291, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-28 08:04:05'),
(292, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 1044568.68, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(293, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 572236.83, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(294, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 456311.58, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(295, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 133186.94, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(296, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 492726.65, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(297, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 1116393.86, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(298, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-28 08:04:05'),
(299, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 1242546.07, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(300, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1573710.40, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-28 08:04:05'),
(301, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 1395654.89, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(302, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 1369525.89, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(303, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1560764.13, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(304, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 1310824.33, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(305, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-28 08:04:05'),
(306, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1780614.21, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(307, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 1352086.86, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(308, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1678344.61, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(309, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1622066.78, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(310, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 1479539.61, 'belum_lunas', '2025-05-04 17:09:07', '2025-05-17 20:27:22'),
(311, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:13:35', '2025-05-28 08:04:05'),
(312, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 1535454.62, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-04 17:13:36'),
(313, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 3378639.04, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-04 17:13:36'),
(314, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 2316196.26, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-04 17:13:36'),
(315, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-28 08:04:05'),
(316, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 2640489.76, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-04 17:13:36'),
(317, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 2502301.21, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-04 17:13:36'),
(318, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 1584317.52, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-04 17:13:36'),
(319, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 883242.82, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(320, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 448449.24, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(321, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-28 08:04:05'),
(322, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 1044568.68, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(323, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 572236.83, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(324, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 456311.58, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(325, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 133186.94, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(326, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 492726.65, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(327, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 1116393.86, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(328, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-28 08:04:05'),
(329, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 1242546.07, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(330, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1573710.40, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-28 08:04:05'),
(331, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 1395654.89, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(332, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 1369525.89, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(333, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1560764.13, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(334, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 1310824.33, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(335, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-28 08:04:05'),
(336, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1780614.21, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(337, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 1352086.86, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(338, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1678344.61, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(339, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1622066.78, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(340, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 1479539.61, 'belum_lunas', '2025-05-04 17:13:36', '2025-05-17 20:27:22'),
(341, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-28 08:04:05'),
(342, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 1535454.62, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-04 17:14:27'),
(343, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 3378639.04, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-04 17:14:27'),
(344, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 2316196.26, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-04 17:14:27'),
(345, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-28 08:04:05'),
(346, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 2640489.76, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-04 17:14:27'),
(347, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 2502301.21, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-04 17:14:27'),
(348, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 1584317.52, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-04 17:14:27'),
(349, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-09 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-28 08:04:05'),
(350, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 883242.82, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(351, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 448449.24, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(352, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-28 08:04:05'),
(353, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 1044568.68, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(354, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 572236.83, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(355, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 456311.58, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(356, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 133186.94, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(357, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 492726.65, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(358, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 1116393.86, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(359, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-28 08:04:05'),
(360, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 1242546.07, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(361, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1573710.40, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-28 08:04:05'),
(362, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 1395654.89, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(363, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 1369525.89, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(364, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1560764.13, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(365, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 1310824.33, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(366, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-28 08:04:05'),
(367, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1780614.21, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(368, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 1352086.86, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(369, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1678344.61, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(370, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1622066.78, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(371, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 1479539.61, 'belum_lunas', '2025-05-04 17:14:27', '2025-05-17 20:27:22'),
(372, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0,\"periode_input\":\"2025-05\"}', 0.00, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-28 08:04:05'),
(373, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997,\"periode_input\":\"2025-05\"}', 1535454.62, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-04 17:19:21'),
(374, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016,\"periode_input\":\"2025-05\"}', 3378639.04, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-04 17:19:21'),
(375, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998,\"periode_input\":\"2025-05\"}', 2316196.26, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-04 17:19:21'),
(376, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0,\"periode_input\":\"2025-05\"}', 0.00, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-28 08:04:05'),
(377, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984,\"periode_input\":\"2025-05\"}', 2640489.76, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-04 17:19:21'),
(378, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5,\"periode_input\":\"2025-05\"}', 2502301.21, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-04 17:19:21'),
(379, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985,\"periode_input\":\"2025-05\"}', 1584317.52, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-04 17:19:21'),
(380, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-09 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":0,\"periode_input\":\"2025-05\"}', 0.00, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-28 08:04:05'),
(381, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003,\"periode_input\":\"2025-05\"}', 883242.82, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(382, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967,\"periode_input\":\"2025-05\"}', 448449.24, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(383, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0,\"periode_input\":\"2025-05\"}', 0.00, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-28 08:04:05'),
(384, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027,\"periode_input\":\"2025-05\"}', 1044568.68, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(385, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973,\"periode_input\":\"2025-05\"}', 572236.83, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(386, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005,\"periode_input\":\"2025-05\"}', 456311.58, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(387, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002,\"periode_input\":\"2025-05\"}', 133186.94, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(388, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991,\"periode_input\":\"2025-05\"}', 492726.65, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(389, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999,\"periode_input\":\"2025-05\"}', 1116393.86, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22');
INSERT INTO `data_pencatatan` (`id`, `customer_id`, `nama_customer`, `data_input`, `harga_final`, `status_pembayaran`, `created_at`, `updated_at`) VALUES
(390, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0,\"periode_input\":\"2025-05\"}', 0.00, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-28 08:04:05'),
(391, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005,\"periode_input\":\"2025-05\"}', 1242546.07, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(392, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004,\"periode_input\":\"2025-05\"}', 1573710.40, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-28 08:04:05'),
(393, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015,\"periode_input\":\"2025-05\"}', 1395654.89, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(394, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007,\"periode_input\":\"2025-05\"}', 1369525.89, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(395, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995,\"periode_input\":\"2025-05\"}', 1560764.13, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(396, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007,\"periode_input\":\"2025-05\"}', 1310824.33, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(397, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0,\"periode_input\":\"2025-05\"}', 0.00, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-28 08:04:05'),
(398, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991,\"periode_input\":\"2025-05\"}', 1780614.21, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(399, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025,\"periode_input\":\"2025-05\"}', 1352086.86, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(400, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985,\"periode_input\":\"2025-05\"}', 1678344.61, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(401, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003,\"periode_input\":\"2025-05\"}', 1622066.78, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(402, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975,\"periode_input\":\"2025-05\"}', 1479539.61, 'belum_lunas', '2025-05-04 17:19:21', '2025-05-17 20:27:22'),
(403, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0,\"periode_input\":\"2025-02\"}', 0.00, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-28 08:04:05'),
(404, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997,\"periode_input\":\"2025-02\"}', 1535454.62, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-04 17:22:03'),
(405, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016,\"periode_input\":\"2025-02\"}', 3378639.04, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-04 17:22:03'),
(406, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998,\"periode_input\":\"2025-02\"}', 2316196.26, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-04 17:22:03'),
(407, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0,\"periode_input\":\"2025-02\"}', 0.00, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-28 08:04:05'),
(408, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984,\"periode_input\":\"2025-02\"}', 2640489.76, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-04 17:22:03'),
(409, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5,\"periode_input\":\"2025-02\"}', 2502301.21, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-04 17:22:03'),
(410, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985,\"periode_input\":\"2025-02\"}', 1584317.52, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-04 17:22:03'),
(411, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-09 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":0,\"periode_input\":\"2025-02\"}', 0.00, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-28 08:04:05'),
(412, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003,\"periode_input\":\"2025-02\"}', 883242.82, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(413, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967,\"periode_input\":\"2025-02\"}', 448449.24, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(414, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0,\"periode_input\":\"2025-02\"}', 0.00, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-28 08:04:05'),
(415, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027,\"periode_input\":\"2025-02\"}', 1044568.68, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(416, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973,\"periode_input\":\"2025-02\"}', 572236.83, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(417, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005,\"periode_input\":\"2025-02\"}', 456311.58, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(418, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002,\"periode_input\":\"2025-02\"}', 133186.94, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(419, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991,\"periode_input\":\"2025-02\"}', 492726.65, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(420, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999,\"periode_input\":\"2025-02\"}', 1116393.86, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(421, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0,\"periode_input\":\"2025-02\"}', 0.00, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-28 08:04:05'),
(422, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005,\"periode_input\":\"2025-02\"}', 1242546.07, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(423, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004,\"periode_input\":\"2025-02\"}', 1573710.40, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-28 08:04:05'),
(424, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015,\"periode_input\":\"2025-02\"}', 1395654.89, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(425, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007,\"periode_input\":\"2025-02\"}', 1369525.89, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(426, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995,\"periode_input\":\"2025-02\"}', 1560764.13, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(427, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007,\"periode_input\":\"2025-02\"}', 1310824.33, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(428, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0,\"periode_input\":\"2025-02\"}', 0.00, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-28 08:04:05'),
(429, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991,\"periode_input\":\"2025-02\"}', 1780614.21, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(430, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025,\"periode_input\":\"2025-02\"}', 1352086.86, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(431, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985,\"periode_input\":\"2025-02\"}', 1678344.61, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(432, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003,\"periode_input\":\"2025-02\"}', 1622066.78, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(433, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975,\"periode_input\":\"2025-02\"}', 1479539.61, 'belum_lunas', '2025-05-04 17:22:03', '2025-05-17 20:27:22'),
(434, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-01 06:30:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-02 06:30:00\",\"volume\":20449.95},\"volume_flow_meter\":286.3199999999997,\"periode_input\":\"2024-08\"}', 1692591.42, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(435, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-02 06:30:00\",\"volume\":20449.95},\"pembacaan_akhir\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"volume_flow_meter\":132.13999999999942,\"periode_input\":\"2024-08\"}', 781150.57, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(436, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"pembacaan_akhir\":{\"waktu\":\"2024-08-04 07:00:00\",\"volume\":20615.56},\"volume_flow_meter\":33.470000000001164,\"periode_input\":\"2024-08\"}', 197859.16, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(437, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-05 07:00:00\",\"volume\":20615.56},\"pembacaan_akhir\":{\"waktu\":\"2024-08-05 18:15:00\",\"volume\":20659.69},\"volume_flow_meter\":44.12999999999738,\"periode_input\":\"2024-08\"}', 260876.15, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(438, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-06 07:00:00\",\"volume\":20659.69},\"pembacaan_akhir\":{\"waktu\":\"2024-08-06 18:20:00\",\"volume\":20706.7},\"volume_flow_meter\":47.01000000000204,\"periode_input\":\"2024-08\"}', 277901.38, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(439, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-07 06:35:00\",\"volume\":20706.7},\"pembacaan_akhir\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"volume_flow_meter\":260.0699999999997,\"periode_input\":\"2024-08\"}', 1537413.56, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(440, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"pembacaan_akhir\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"volume_flow_meter\":329.6399999999994,\"periode_input\":\"2024-08\"}', 1948679.22, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(441, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"pembacaan_akhir\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"volume_flow_meter\":317.1100000000006,\"periode_input\":\"2024-08\"}', 1874607.66, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(442, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"pembacaan_akhir\":{\"waktu\":\"2024-08-11 07:15:00\",\"volume\":21855.84},\"volume_flow_meter\":242.3199999999997,\"periode_input\":\"2024-08\"}', 1432483.77, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(443, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-12 07:15:00\",\"volume\":21855.84},\"pembacaan_akhir\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"volume_flow_meter\":312.6899999999987,\"periode_input\":\"2024-08\"}', 1848478.66, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(444, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"pembacaan_akhir\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"volume_flow_meter\":341.52000000000044,\"periode_input\":\"2024-08\"}', 2018908.29, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(445, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"pembacaan_akhir\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"volume_flow_meter\":366.08000000000175,\"periode_input\":\"2024-08\"}', 2164095.65, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(446, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"pembacaan_akhir\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"volume_flow_meter\":321.1299999999974,\"periode_input\":\"2024-08\"}', 1898372.04, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(447, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"pembacaan_akhir\":{\"waktu\":\"2024-08-17 06:00:00\",\"volume\":23517.94},\"volume_flow_meter\":320.6800000000003,\"periode_input\":\"2024-08\"}', 1895711.85, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(448, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-19 06:00:00\",\"volume\":23517.94},\"pembacaan_akhir\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"volume_flow_meter\":405.0300000000025,\"periode_input\":\"2024-08\"}', 2394350.04, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(449, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"pembacaan_akhir\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"volume_flow_meter\":433.4499999999971,\"periode_input\":\"2024-08\"}', 2562355.93, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(450, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"pembacaan_akhir\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"volume_flow_meter\":422.4900000000016,\"periode_input\":\"2024-08\"}', 2497565.48, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(451, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"pembacaan_akhir\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"volume_flow_meter\":427.09000000000015,\"periode_input\":\"2024-08\"}', 2524758.55, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(452, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"pembacaan_akhir\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"volume_flow_meter\":432.4500000000007,\"periode_input\":\"2024-08\"}', 2556444.40, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-28 08:04:05'),
(453, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-25 07:00:00\",\"volume\":26034.15},\"volume_flow_meter\":395.7000000000007,\"periode_input\":\"2024-08\"}', 2339195.39, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(454, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-26 07:00:00\",\"volume\":26034.15},\"pembacaan_akhir\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"volume_flow_meter\":373.22999999999956,\"periode_input\":\"2024-08\"}', 2206363.14, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(455, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"pembacaan_akhir\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"volume_flow_meter\":469.1100000000006,\"periode_input\":\"2024-08\"}', 2773161.36, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(456, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"pembacaan_akhir\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"volume_flow_meter\":408.9599999999991,\"periode_input\":\"2024-08\"}', 2417582.38, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(457, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"volume_flow_meter\":393.75,\"periode_input\":\"2024-08\"}', 2327667.89, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(458, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"pembacaan_akhir\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"volume_flow_meter\":438.7999999999993,\"periode_input\":\"2024-08\"}', 2593982.66, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(459, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"pembacaan_akhir\":{\"waktu\":\"2024-09-01 06:00:00\",\"volume\":28505.57},\"volume_flow_meter\":387.5699999999997,\"periode_input\":\"2024-08\"}', 2291134.59, 'belum_lunas', '2025-05-04 17:24:58', '2025-05-17 20:27:22'),
(460, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-01 06:30:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-02 06:30:00\",\"volume\":20449.95},\"volume_flow_meter\":286.3199999999997,\"periode_input\":\"2025-05\"}', 1692591.42, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(461, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-02 06:30:00\",\"volume\":20449.95},\"pembacaan_akhir\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"volume_flow_meter\":132.13999999999942,\"periode_input\":\"2025-05\"}', 781150.57, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(462, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"pembacaan_akhir\":{\"waktu\":\"2024-08-04 07:00:00\",\"volume\":20615.56},\"volume_flow_meter\":33.470000000001164,\"periode_input\":\"2025-05\"}', 197859.16, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(463, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-05 07:00:00\",\"volume\":20615.56},\"pembacaan_akhir\":{\"waktu\":\"2024-08-05 18:15:00\",\"volume\":20659.69},\"volume_flow_meter\":44.12999999999738,\"periode_input\":\"2025-05\"}', 260876.15, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(464, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-06 07:00:00\",\"volume\":20659.69},\"pembacaan_akhir\":{\"waktu\":\"2024-08-06 18:20:00\",\"volume\":20706.7},\"volume_flow_meter\":47.01000000000204,\"periode_input\":\"2025-05\"}', 277901.38, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(465, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-07 06:35:00\",\"volume\":20706.7},\"pembacaan_akhir\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"volume_flow_meter\":260.0699999999997,\"periode_input\":\"2025-05\"}', 1537413.56, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(466, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"pembacaan_akhir\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"volume_flow_meter\":329.6399999999994,\"periode_input\":\"2025-05\"}', 1948679.22, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(467, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"pembacaan_akhir\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"volume_flow_meter\":317.1100000000006,\"periode_input\":\"2025-05\"}', 1874607.66, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(468, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"pembacaan_akhir\":{\"waktu\":\"2024-08-11 07:15:00\",\"volume\":21855.84},\"volume_flow_meter\":242.3199999999997,\"periode_input\":\"2025-05\"}', 1432483.77, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(469, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-12 07:15:00\",\"volume\":21855.84},\"pembacaan_akhir\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"volume_flow_meter\":312.6899999999987,\"periode_input\":\"2025-05\"}', 1848478.66, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(470, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"pembacaan_akhir\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"volume_flow_meter\":341.52000000000044,\"periode_input\":\"2025-05\"}', 2018908.29, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(471, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"pembacaan_akhir\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"volume_flow_meter\":366.08000000000175,\"periode_input\":\"2025-05\"}', 2164095.65, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(472, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"pembacaan_akhir\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"volume_flow_meter\":321.1299999999974,\"periode_input\":\"2025-05\"}', 1898372.04, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(473, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"pembacaan_akhir\":{\"waktu\":\"2024-08-17 06:00:00\",\"volume\":23517.94},\"volume_flow_meter\":320.6800000000003,\"periode_input\":\"2025-05\"}', 1895711.85, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(474, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-19 06:00:00\",\"volume\":23517.94},\"pembacaan_akhir\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"volume_flow_meter\":405.0300000000025,\"periode_input\":\"2025-05\"}', 2394350.04, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(475, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"pembacaan_akhir\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"volume_flow_meter\":433.4499999999971,\"periode_input\":\"2025-05\"}', 2562355.93, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(476, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"pembacaan_akhir\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"volume_flow_meter\":422.4900000000016,\"periode_input\":\"2025-05\"}', 2497565.48, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(477, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"pembacaan_akhir\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"volume_flow_meter\":427.09000000000015,\"periode_input\":\"2025-05\"}', 2524758.55, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(478, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"pembacaan_akhir\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"volume_flow_meter\":432.4500000000007,\"periode_input\":\"2025-05\"}', 2556444.40, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-28 08:04:05'),
(479, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-25 07:00:00\",\"volume\":26034.15},\"volume_flow_meter\":395.7000000000007,\"periode_input\":\"2025-05\"}', 2339195.39, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(480, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-26 07:00:00\",\"volume\":26034.15},\"pembacaan_akhir\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"volume_flow_meter\":373.22999999999956,\"periode_input\":\"2025-05\"}', 2206363.14, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(481, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"pembacaan_akhir\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"volume_flow_meter\":469.1100000000006,\"periode_input\":\"2025-05\"}', 2773161.36, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(482, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"pembacaan_akhir\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"volume_flow_meter\":408.9599999999991,\"periode_input\":\"2025-05\"}', 2417582.38, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(483, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"volume_flow_meter\":393.75,\"periode_input\":\"2025-05\"}', 2327667.89, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(484, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"pembacaan_akhir\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"volume_flow_meter\":438.7999999999993,\"periode_input\":\"2025-05\"}', 2593982.66, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(485, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"pembacaan_akhir\":{\"waktu\":\"2024-09-01 06:00:00\",\"volume\":28505.57},\"volume_flow_meter\":387.5699999999997,\"periode_input\":\"2025-05\"}', 2291134.59, 'belum_lunas', '2025-05-04 17:25:59', '2025-05-17 20:27:22'),
(486, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-02 06:30:00\",\"volume\":20449.95},\"pembacaan_akhir\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"volume_flow_meter\":132.13999999999942}', 3632855.66, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(487, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"pembacaan_akhir\":{\"waktu\":\"2024-08-04 07:00:00\",\"volume\":20615.56},\"volume_flow_meter\":33.470000000001164}', 920173.14, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(488, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-05 07:00:00\",\"volume\":20615.56},\"pembacaan_akhir\":{\"waktu\":\"2024-08-05 18:15:00\",\"volume\":20659.69},\"volume_flow_meter\":44.12999999999738}', 1213242.93, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(489, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-06 07:00:00\",\"volume\":20659.69},\"pembacaan_akhir\":{\"waktu\":\"2024-08-06 18:20:00\",\"volume\":20706.7},\"volume_flow_meter\":47.01000000000204}', 1292421.26, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(490, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-07 06:35:00\",\"volume\":20706.7},\"pembacaan_akhir\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"volume_flow_meter\":260.0699999999997}', 7149968.00, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(491, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"pembacaan_akhir\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"volume_flow_meter\":329.6399999999994}', 9062619.50, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(492, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"pembacaan_akhir\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"volume_flow_meter\":317.1100000000006}', 8718138.78, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(493, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"pembacaan_akhir\":{\"waktu\":\"2024-08-11 07:15:00\",\"volume\":21855.84},\"volume_flow_meter\":242.3199999999997}', 6661976.57, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(494, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-12 07:15:00\",\"volume\":21855.84},\"pembacaan_akhir\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"volume_flow_meter\":312.6899999999987}', 8596622.04, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(495, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"pembacaan_akhir\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"volume_flow_meter\":341.52000000000044}', 9389230.10, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(496, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"pembacaan_akhir\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"volume_flow_meter\":366.08000000000175}', 10064445.29, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(497, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"pembacaan_akhir\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"volume_flow_meter\":321.1299999999974}', 8828658.53, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(498, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"pembacaan_akhir\":{\"waktu\":\"2024-08-17 06:00:00\",\"volume\":23517.94},\"volume_flow_meter\":320.6800000000003}', 8816286.92, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(499, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-19 06:00:00\",\"volume\":23517.94},\"pembacaan_akhir\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"volume_flow_meter\":405.0300000000025}', 11135277.20, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(500, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"pembacaan_akhir\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"volume_flow_meter\":433.4499999999971}', 11916613.34, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(501, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"pembacaan_akhir\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"volume_flow_meter\":422.4900000000016}', 11615295.81, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(502, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"pembacaan_akhir\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"volume_flow_meter\":427.09000000000015}', 11741761.20, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(503, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"pembacaan_akhir\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"volume_flow_meter\":432.4500000000007}', 11889120.86, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(504, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-25 07:00:00\",\"volume\":26034.15},\"volume_flow_meter\":395.7000000000007}', 10878772.40, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(505, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-26 07:00:00\",\"volume\":26034.15},\"pembacaan_akhir\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"volume_flow_meter\":373.22999999999956}', 10261016.49, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(506, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"pembacaan_akhir\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"volume_flow_meter\":469.1100000000006}', 12896995.00, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(507, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"pembacaan_akhir\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"volume_flow_meter\":408.9599999999991}', 11243322.62, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(508, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"volume_flow_meter\":393.75}', 10825162.08, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(509, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"pembacaan_akhir\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"volume_flow_meter\":438.7999999999993}', 12063698.08, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(510, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"pembacaan_akhir\":{\"waktu\":\"2024-09-01 06:00:00\",\"volume\":28505.57},\"volume_flow_meter\":387.5699999999997}', 10655258.58, 'belum_lunas', '2025-05-04 17:30:07', '2025-05-17 20:28:44'),
(512, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-02 06:30:00\",\"volume\":20449.95},\"pembacaan_akhir\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"volume_flow_meter\":132.13999999999942}', 3632855.66, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(513, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"pembacaan_akhir\":{\"waktu\":\"2024-08-04 07:00:00\",\"volume\":20615.56},\"volume_flow_meter\":33.470000000001164}', 920173.14, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(514, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-05 07:00:00\",\"volume\":20615.56},\"pembacaan_akhir\":{\"waktu\":\"2024-08-05 18:15:00\",\"volume\":20659.69},\"volume_flow_meter\":44.12999999999738}', 1213242.93, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(515, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-06 07:00:00\",\"volume\":20659.69},\"pembacaan_akhir\":{\"waktu\":\"2024-08-06 18:20:00\",\"volume\":20706.7},\"volume_flow_meter\":47.01000000000204}', 1292421.26, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(516, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-07 06:35:00\",\"volume\":20706.7},\"pembacaan_akhir\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"volume_flow_meter\":260.0699999999997}', 7149968.00, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(517, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"pembacaan_akhir\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"volume_flow_meter\":329.6399999999994}', 9062619.50, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(518, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"pembacaan_akhir\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"volume_flow_meter\":317.1100000000006}', 8718138.78, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(519, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"pembacaan_akhir\":{\"waktu\":\"2024-08-11 07:15:00\",\"volume\":21855.84},\"volume_flow_meter\":242.3199999999997}', 6661976.57, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(520, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-12 07:15:00\",\"volume\":21855.84},\"pembacaan_akhir\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"volume_flow_meter\":312.6899999999987}', 8596622.04, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(521, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"pembacaan_akhir\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"volume_flow_meter\":341.52000000000044}', 9389230.10, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(522, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"pembacaan_akhir\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"volume_flow_meter\":366.08000000000175}', 10064445.29, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(523, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"pembacaan_akhir\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"volume_flow_meter\":321.1299999999974}', 8828658.53, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(524, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"pembacaan_akhir\":{\"waktu\":\"2024-08-17 06:00:00\",\"volume\":23517.94},\"volume_flow_meter\":320.6800000000003}', 8816286.92, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(525, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-19 06:00:00\",\"volume\":23517.94},\"pembacaan_akhir\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"volume_flow_meter\":405.0300000000025}', 11135277.20, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(526, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"pembacaan_akhir\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"volume_flow_meter\":433.4499999999971}', 11916613.34, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(527, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"pembacaan_akhir\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"volume_flow_meter\":422.4900000000016}', 11615295.81, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(528, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"pembacaan_akhir\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"volume_flow_meter\":427.09000000000015}', 11741761.20, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(529, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"pembacaan_akhir\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"volume_flow_meter\":432.4500000000007}', 11889120.86, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(530, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-25 07:00:00\",\"volume\":26034.15},\"volume_flow_meter\":395.7000000000007}', 10878772.40, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(531, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-26 07:00:00\",\"volume\":26034.15},\"pembacaan_akhir\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"volume_flow_meter\":373.22999999999956}', 10261016.49, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(532, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"pembacaan_akhir\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"volume_flow_meter\":469.1100000000006}', 12896995.00, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(533, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"pembacaan_akhir\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"volume_flow_meter\":408.9599999999991}', 11243322.62, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(534, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"volume_flow_meter\":393.75}', 10825162.08, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(535, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"pembacaan_akhir\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"volume_flow_meter\":438.7999999999993}', 12063698.08, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(536, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"pembacaan_akhir\":{\"waktu\":\"2024-09-01 06:00:00\",\"volume\":28505.57},\"volume_flow_meter\":387.5699999999997}', 10655258.58, 'belum_lunas', '2025-05-04 17:36:57', '2025-05-17 20:28:44'),
(537, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-01 06:30:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-02 06:30:00\",\"volume\":20449.95},\"volume_flow_meter\":286.3199999999997}', 7871645.48, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(538, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-02 06:30:00\",\"volume\":20449.95},\"pembacaan_akhir\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"volume_flow_meter\":132.13999999999942}', 3632855.66, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(539, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-03 07:40:00\",\"volume\":20582.09},\"pembacaan_akhir\":{\"waktu\":\"2024-08-04 07:00:00\",\"volume\":20615.56},\"volume_flow_meter\":33.470000000001164}', 920173.14, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(540, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-04 07:00:00\",\"volume\":20615.56},\"pembacaan_akhir\":{\"waktu\":\"2024-08-04 07:00:00\",\"volume\":20615.56},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(541, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-05 07:00:00\",\"volume\":20615.56},\"pembacaan_akhir\":{\"waktu\":\"2024-08-05 18:15:00\",\"volume\":20659.69},\"volume_flow_meter\":44.12999999999738}', 1213242.93, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(542, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-06 07:00:00\",\"volume\":20659.69},\"pembacaan_akhir\":{\"waktu\":\"2024-08-06 18:20:00\",\"volume\":20706.7},\"volume_flow_meter\":47.01000000000204}', 1292421.26, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(543, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-07 06:35:00\",\"volume\":20706.7},\"pembacaan_akhir\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"volume_flow_meter\":260.0699999999997}', 7149968.00, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(544, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-08 07:05:00\",\"volume\":20966.77},\"pembacaan_akhir\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"volume_flow_meter\":329.6399999999994}', 9062619.50, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(545, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-09 07:00:00\",\"volume\":21296.41},\"pembacaan_akhir\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"volume_flow_meter\":317.1100000000006}', 8718138.78, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(546, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-10 07:56:00\",\"volume\":21613.52},\"pembacaan_akhir\":{\"waktu\":\"2024-08-11 07:15:00\",\"volume\":21855.84},\"volume_flow_meter\":242.3199999999997}', 6661976.57, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(547, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-11 07:15:00\",\"volume\":21855.84},\"pembacaan_akhir\":{\"waktu\":\"2024-08-11 07:15:00\",\"volume\":21855.84},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(548, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-12 07:15:00\",\"volume\":21855.84},\"pembacaan_akhir\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"volume_flow_meter\":312.6899999999987}', 8596622.04, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(549, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-13 06:30:00\",\"volume\":22168.53},\"pembacaan_akhir\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"volume_flow_meter\":341.52000000000044}', 9389230.10, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(550, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-14 06:45:00\",\"volume\":22510.05},\"pembacaan_akhir\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"volume_flow_meter\":366.08000000000175}', 10064445.29, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(551, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-15 06:45:00\",\"volume\":22876.13},\"pembacaan_akhir\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"volume_flow_meter\":321.1299999999974}', 8828658.53, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(552, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-16 06:40:00\",\"volume\":23197.26},\"pembacaan_akhir\":{\"waktu\":\"2024-08-17 06:00:00\",\"volume\":23517.94},\"volume_flow_meter\":320.6800000000003}', 8816286.92, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(553, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-17 06:00:00\",\"volume\":23517.94},\"pembacaan_akhir\":{\"waktu\":\"2024-08-17 06:00:00\",\"volume\":23517.94},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44');
INSERT INTO `data_pencatatan` (`id`, `customer_id`, `nama_customer`, `data_input`, `harga_final`, `status_pembayaran`, `created_at`, `updated_at`) VALUES
(554, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-18 06:00:00\",\"volume\":23517.94},\"pembacaan_akhir\":{\"waktu\":\"2024-08-18 06:00:00\",\"volume\":23517.94},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(555, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-19 06:00:00\",\"volume\":23517.94},\"pembacaan_akhir\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"volume_flow_meter\":405.0300000000025}', 11135277.20, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(556, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-20 06:00:00\",\"volume\":23922.97},\"pembacaan_akhir\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"volume_flow_meter\":433.4499999999971}', 11916613.34, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(557, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-21 06:10:00\",\"volume\":24356.42},\"pembacaan_akhir\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"volume_flow_meter\":422.4900000000016}', 11615295.81, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(558, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-22 06:00:00\",\"volume\":24778.91},\"pembacaan_akhir\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"volume_flow_meter\":427.09000000000015}', 11741761.20, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(559, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-23 06:00:00\",\"volume\":25206},\"pembacaan_akhir\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"volume_flow_meter\":432.4500000000007}', 11889120.86, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(560, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-24 06:00:00\",\"volume\":25638.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-25 07:00:00\",\"volume\":26034.15},\"volume_flow_meter\":395.7000000000007}', 10878772.40, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(561, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-25 07:00:00\",\"volume\":26034.15},\"pembacaan_akhir\":{\"waktu\":\"2024-08-25 07:00:00\",\"volume\":26034.15},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(562, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-26 07:00:00\",\"volume\":26034.15},\"pembacaan_akhir\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"volume_flow_meter\":373.22999999999956}', 10261016.49, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(563, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-27 06:00:00\",\"volume\":26407.38},\"pembacaan_akhir\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"volume_flow_meter\":469.1100000000006}', 12896995.00, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(564, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-28 06:00:00\",\"volume\":26876.49},\"pembacaan_akhir\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"volume_flow_meter\":408.9599999999991}', 11243322.62, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(565, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-29 06:00:00\",\"volume\":27285.45},\"pembacaan_akhir\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"volume_flow_meter\":393.75}', 10825162.08, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(566, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-30 06:00:00\",\"volume\":27679.2},\"pembacaan_akhir\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"volume_flow_meter\":438.7999999999993}', 12063698.08, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(567, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-31 06:00:00\",\"volume\":28118},\"pembacaan_akhir\":{\"waktu\":\"2024-09-01 06:00:00\",\"volume\":28505.57},\"volume_flow_meter\":387.5699999999997}', 10655258.58, 'belum_lunas', '2025-05-04 17:40:39', '2025-05-17 20:28:44'),
(568, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-01 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-01 17:00:00\",\"volume\":6747.03},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(569, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-02 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-02 17:00:00\",\"volume\":6747.03},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(570, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-03 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-03 23:59:00\",\"volume\":7016.43},\"volume_flow_meter\":269.40000000000055}', 1099078.74, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(571, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-04 07:00:00\",\"volume\":7016.43},\"pembacaan_akhir\":{\"waktu\":\"2024-06-04 23:59:00\",\"volume\":7225.67},\"volume_flow_meter\":209.23999999999978}', 853642.30, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(572, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-05 07:00:00\",\"volume\":7225.67},\"pembacaan_akhir\":{\"waktu\":\"2024-06-05 23:59:00\",\"volume\":7514.6},\"volume_flow_meter\":288.9300000000003}', 1178755.83, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(573, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-06 07:00:00\",\"volume\":7514.6},\"pembacaan_akhir\":{\"waktu\":\"2024-06-06 23:59:00\",\"volume\":7694.82},\"volume_flow_meter\":180.21999999999935}', 735248.59, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(574, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-07 07:00:00\",\"volume\":7694.82},\"pembacaan_akhir\":{\"waktu\":\"2024-06-07 23:59:00\",\"volume\":7950.85},\"volume_flow_meter\":256.03000000000065}', 1044532.78, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(575, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-08 07:00:00\",\"volume\":7950.85},\"pembacaan_akhir\":{\"waktu\":\"2024-06-08 23:59:00\",\"volume\":8106.05},\"volume_flow_meter\":155.19999999999982}', 633173.80, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(576, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-09 07:00:00\",\"volume\":8106.05},\"pembacaan_akhir\":{\"waktu\":\"2024-06-09 23:59:00\",\"volume\":8106.05},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(577, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-10 07:00:00\",\"volume\":8106.05},\"pembacaan_akhir\":{\"waktu\":\"2024-06-10 23:59:00\",\"volume\":8328.06},\"volume_flow_meter\":222.0099999999993}', 905740.43, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(578, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-11 07:00:00\",\"volume\":8328.06},\"pembacaan_akhir\":{\"waktu\":\"2024-06-11 23:59:00\",\"volume\":8606.68},\"volume_flow_meter\":278.6200000000008}', 1136693.84, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(579, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-12 07:00:00\",\"volume\":8606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-06-12 23:59:00\",\"volume\":8862.14},\"volume_flow_meter\":255.45999999999913}', 1042207.33, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(580, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-13 07:00:00\",\"volume\":8862.14},\"pembacaan_akhir\":{\"waktu\":\"2024-06-13 23:59:00\",\"volume\":9129.8},\"volume_flow_meter\":267.65999999999985}', 1091980.02, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(581, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-14 07:00:00\",\"volume\":9129.8},\"pembacaan_akhir\":{\"waktu\":\"2024-06-14 23:59:00\",\"volume\":9321.39},\"volume_flow_meter\":191.59000000000015}', 781635.10, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(582, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-15 07:00:00\",\"volume\":9321.39},\"pembacaan_akhir\":{\"waktu\":\"2024-06-15 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":188.3199999999997}', 768294.39, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(583, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-16 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-16 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(584, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-17 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-17 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(585, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-18 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-18 23:59:00\",\"volume\":9679.35},\"volume_flow_meter\":169.64000000000124}', 692085.07, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(586, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-19 07:00:00\",\"volume\":9679.35},\"pembacaan_akhir\":{\"waktu\":\"2024-06-19 23:59:00\",\"volume\":9863.18},\"volume_flow_meter\":183.82999999999993}', 749976.41, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(587, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-20 07:00:00\",\"volume\":9863.18},\"pembacaan_akhir\":{\"waktu\":\"2024-06-20 23:59:00\",\"volume\":10122.82},\"volume_flow_meter\":259.6399999999994}', 1059260.60, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(588, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-21 07:00:00\",\"volume\":10122.82},\"pembacaan_akhir\":{\"waktu\":\"2024-06-21 23:59:00\",\"volume\":10405.24},\"volume_flow_meter\":282.4200000000001}', 1152196.80, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(589, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-22 07:00:00\",\"volume\":10405.24},\"pembacaan_akhir\":{\"waktu\":\"2024-06-22 23:59:00\",\"volume\":10674.89},\"volume_flow_meter\":269.64999999999964}', 1100098.68, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(590, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-23 07:00:00\",\"volume\":10674.89},\"pembacaan_akhir\":{\"waktu\":\"2024-06-23 23:59:00\",\"volume\":10674.89},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(591, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-24 07:00:00\",\"volume\":10674.89},\"pembacaan_akhir\":{\"waktu\":\"2024-06-24 23:59:00\",\"volume\":10959.41},\"volume_flow_meter\":284.52000000000044}', 1160764.23, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(592, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-25 07:00:00\",\"volume\":10959.41},\"pembacaan_akhir\":{\"waktu\":\"2024-06-25 23:59:00\",\"volume\":11222.91},\"volume_flow_meter\":263.5}', 1075008.35, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(593, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-26 07:00:00\",\"volume\":11222.91},\"pembacaan_akhir\":{\"waktu\":\"2024-06-26 23:59:00\",\"volume\":11493.51},\"volume_flow_meter\":270.60000000000036}', 1103974.42, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(594, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-27 07:00:00\",\"volume\":11493.51},\"pembacaan_akhir\":{\"waktu\":\"2024-06-27 23:59:00\",\"volume\":11747.91},\"volume_flow_meter\":254.39999999999964}', 1037882.82, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(595, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-28 07:00:00\",\"volume\":11747.91},\"pembacaan_akhir\":{\"waktu\":\"2024-06-28 23:59:00\",\"volume\":11960.84},\"volume_flow_meter\":212.9300000000003}', 868696.50, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(596, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-29 07:00:00\",\"volume\":11960.84},\"pembacaan_akhir\":{\"waktu\":\"2024-06-29 23:59:00\",\"volume\":12205.49},\"volume_flow_meter\":244.64999999999964}', 998105.47, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(597, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-30 07:00:00\",\"volume\":12205.49},\"pembacaan_akhir\":{\"waktu\":\"2024-06-30 19:00:00\",\"volume\":12205.49},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:45:22', '2025-05-17 20:28:44'),
(598, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-01 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-01 17:00:00\",\"volume\":6747.03},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(599, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-02 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-02 17:00:00\",\"volume\":6747.03},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(600, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-03 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-03 23:59:00\",\"volume\":7016.43},\"volume_flow_meter\":269.40000000000055}', 1099078.74, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(601, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-04 07:00:00\",\"volume\":7016.43},\"pembacaan_akhir\":{\"waktu\":\"2024-06-04 23:59:00\",\"volume\":7225.67},\"volume_flow_meter\":209.23999999999978}', 853642.30, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(602, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-05 07:00:00\",\"volume\":7225.67},\"pembacaan_akhir\":{\"waktu\":\"2024-06-05 23:59:00\",\"volume\":7514.6},\"volume_flow_meter\":288.9300000000003}', 1178755.83, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(603, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-06 07:00:00\",\"volume\":7514.6},\"pembacaan_akhir\":{\"waktu\":\"2024-06-06 23:59:00\",\"volume\":7694.82},\"volume_flow_meter\":180.21999999999935}', 735248.59, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(604, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-07 07:00:00\",\"volume\":7694.82},\"pembacaan_akhir\":{\"waktu\":\"2024-06-07 23:59:00\",\"volume\":7950.85},\"volume_flow_meter\":256.03000000000065}', 1044532.78, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(605, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-08 07:00:00\",\"volume\":7950.85},\"pembacaan_akhir\":{\"waktu\":\"2024-06-08 23:59:00\",\"volume\":8106.05},\"volume_flow_meter\":155.19999999999982}', 633173.80, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(606, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-09 07:00:00\",\"volume\":8106.05},\"pembacaan_akhir\":{\"waktu\":\"2024-06-09 23:59:00\",\"volume\":8106.05},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(607, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-10 07:00:00\",\"volume\":8106.05},\"pembacaan_akhir\":{\"waktu\":\"2024-06-10 23:59:00\",\"volume\":8328.06},\"volume_flow_meter\":222.0099999999993}', 905740.43, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(608, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-11 07:00:00\",\"volume\":8328.06},\"pembacaan_akhir\":{\"waktu\":\"2024-06-11 23:59:00\",\"volume\":8606.68},\"volume_flow_meter\":278.6200000000008}', 1136693.84, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(609, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-12 07:00:00\",\"volume\":8606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-06-12 23:59:00\",\"volume\":8862.14},\"volume_flow_meter\":255.45999999999913}', 1042207.33, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(610, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-13 07:00:00\",\"volume\":8862.14},\"pembacaan_akhir\":{\"waktu\":\"2024-06-13 23:59:00\",\"volume\":9129.8},\"volume_flow_meter\":267.65999999999985}', 1091980.02, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(611, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-14 07:00:00\",\"volume\":9129.8},\"pembacaan_akhir\":{\"waktu\":\"2024-06-14 23:59:00\",\"volume\":9321.39},\"volume_flow_meter\":191.59000000000015}', 781635.10, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(612, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-15 07:00:00\",\"volume\":9321.39},\"pembacaan_akhir\":{\"waktu\":\"2024-06-15 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":188.3199999999997}', 768294.39, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(613, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-16 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-16 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(614, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-17 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-17 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(615, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-18 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-18 23:59:00\",\"volume\":9679.35},\"volume_flow_meter\":169.64000000000124}', 692085.07, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(616, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-19 07:00:00\",\"volume\":9679.35},\"pembacaan_akhir\":{\"waktu\":\"2024-06-19 23:59:00\",\"volume\":9863.18},\"volume_flow_meter\":183.82999999999993}', 749976.41, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(617, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-20 07:00:00\",\"volume\":9863.18},\"pembacaan_akhir\":{\"waktu\":\"2024-06-20 23:59:00\",\"volume\":10122.82},\"volume_flow_meter\":259.6399999999994}', 1059260.60, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(618, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-21 07:00:00\",\"volume\":10122.82},\"pembacaan_akhir\":{\"waktu\":\"2024-06-21 23:59:00\",\"volume\":10405.24},\"volume_flow_meter\":282.4200000000001}', 1152196.80, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(619, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-22 07:00:00\",\"volume\":10405.24},\"pembacaan_akhir\":{\"waktu\":\"2024-06-22 23:59:00\",\"volume\":10674.89},\"volume_flow_meter\":269.64999999999964}', 1100098.68, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(620, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-23 07:00:00\",\"volume\":10674.89},\"pembacaan_akhir\":{\"waktu\":\"2024-06-23 23:59:00\",\"volume\":10674.89},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(621, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-24 07:00:00\",\"volume\":10674.89},\"pembacaan_akhir\":{\"waktu\":\"2024-06-24 23:59:00\",\"volume\":10959.41},\"volume_flow_meter\":284.52000000000044}', 1160764.23, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(622, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-25 07:00:00\",\"volume\":10959.41},\"pembacaan_akhir\":{\"waktu\":\"2024-06-25 23:59:00\",\"volume\":11222.91},\"volume_flow_meter\":263.5}', 1075008.35, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(623, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-26 07:00:00\",\"volume\":11222.91},\"pembacaan_akhir\":{\"waktu\":\"2024-06-26 23:59:00\",\"volume\":11493.51},\"volume_flow_meter\":270.60000000000036}', 1103974.42, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(624, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-27 07:00:00\",\"volume\":11493.51},\"pembacaan_akhir\":{\"waktu\":\"2024-06-27 23:59:00\",\"volume\":11747.91},\"volume_flow_meter\":254.39999999999964}', 1037882.82, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(625, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-28 07:00:00\",\"volume\":11747.91},\"pembacaan_akhir\":{\"waktu\":\"2024-06-28 23:59:00\",\"volume\":11960.84},\"volume_flow_meter\":212.9300000000003}', 868696.50, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(626, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-29 07:00:00\",\"volume\":11960.84},\"pembacaan_akhir\":{\"waktu\":\"2024-06-29 23:59:00\",\"volume\":12205.49},\"volume_flow_meter\":244.64999999999964}', 998105.47, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(627, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-30 07:00:00\",\"volume\":12205.49},\"pembacaan_akhir\":{\"waktu\":\"2024-06-30 19:00:00\",\"volume\":12205.49},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:46:09', '2025-05-17 20:28:44'),
(628, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-01 07:00:00\",\"volume\":12205.49},\"pembacaan_akhir\":{\"waktu\":\"2024-07-02 06:30:00\",\"volume\":12463.4},\"volume_flow_meter\":257.90999999999985}', 7090584.26, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(629, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-02 06:30:00\",\"volume\":12463.4},\"pembacaan_akhir\":{\"waktu\":\"2024-07-03 06:30:00\",\"volume\":12764.3},\"volume_flow_meter\":300.89999999999964}', 8272485.76, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(630, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-03 06:30:00\",\"volume\":12764.3},\"pembacaan_akhir\":{\"waktu\":\"2024-07-04 06:30:00\",\"volume\":12989.78},\"volume_flow_meter\":225.48000000000138}', 6199003.29, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(631, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-04 06:30:00\",\"volume\":12989.78},\"pembacaan_akhir\":{\"waktu\":\"2024-07-05 06:30:00\",\"volume\":13247.93},\"volume_flow_meter\":258.14999999999964}', 7097182.45, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(632, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-05 06:30:00\",\"volume\":13247.93},\"pembacaan_akhir\":{\"waktu\":\"2024-07-06 06:30:00\",\"volume\":13505.92},\"volume_flow_meter\":257.9899999999998}', 7092783.66, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(633, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-06 06:30:00\",\"volume\":13505.92},\"pembacaan_akhir\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"volume_flow_meter\":284.0499999999993}', 7809237.56, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(634, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"pembacaan_akhir\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(635, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-08 06:00:00\",\"volume\":13789.97},\"pembacaan_akhir\":{\"waktu\":\"2024-07-09 07:00:00\",\"volume\":14113.4},\"volume_flow_meter\":323.4300000000003}', 8891891.23, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(636, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-09 07:00:00\",\"volume\":14113.4},\"pembacaan_akhir\":{\"waktu\":\"2024-07-10 06:45:00\",\"volume\":14442.23},\"volume_flow_meter\":328.8299999999999}', 9040350.59, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(637, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-10 06:45:00\",\"volume\":14442.23},\"pembacaan_akhir\":{\"waktu\":\"2024-07-11 06:30:00\",\"volume\":14765.05},\"volume_flow_meter\":322.8199999999997}', 8875120.82, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(638, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-11 06:30:00\",\"volume\":14765.05},\"pembacaan_akhir\":{\"waktu\":\"2024-07-12 06:30:00\",\"volume\":15102.01},\"volume_flow_meter\":336.96000000000095}', 9263864.42, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(639, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-12 06:30:00\",\"volume\":15102.01},\"pembacaan_akhir\":{\"waktu\":\"2024-07-13 06:30:00\",\"volume\":15448.82},\"volume_flow_meter\":346.8099999999995}', 9534665.29, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(640, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-13 06:30:00\",\"volume\":15448.82},\"pembacaan_akhir\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"volume_flow_meter\":270.89999999999964}', 7447711.51, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(641, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"pembacaan_akhir\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(642, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-15 08:00:00\",\"volume\":15719.72},\"pembacaan_akhir\":{\"waktu\":\"2024-07-16 07:00:00\",\"volume\":16070.76},\"volume_flow_meter\":351.0400000000009}', 9650958.46, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(643, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-16 07:00:00\",\"volume\":16070.76},\"pembacaan_akhir\":{\"waktu\":\"2024-07-17 06:45:00\",\"volume\":16460.58},\"volume_flow_meter\":389.8200000000015}', 10717116.65, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(644, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-17 06:45:00\",\"volume\":16460.58},\"pembacaan_akhir\":{\"waktu\":\"2024-07-18 06:15:00\",\"volume\":16757.48},\"volume_flow_meter\":296.8999999999978}', 8162515.86, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(645, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-18 06:15:00\",\"volume\":16757.48},\"pembacaan_akhir\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"volume_flow_meter\":375.77000000000044}', 10330847.37, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(646, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"pembacaan_akhir\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(647, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-20 07:00:00\",\"volume\":17133.25},\"pembacaan_akhir\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"volume_flow_meter\":136.16999999999825}', 3743650.34, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(648, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"pembacaan_akhir\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(649, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-22 06:00:00\",\"volume\":17269.42},\"pembacaan_akhir\":{\"waktu\":\"2024-07-23 06:45:00\",\"volume\":17648.06},\"volume_flow_meter\":378.64000000000306}', 10409750.78, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(650, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-23 06:45:00\",\"volume\":17648.06},\"pembacaan_akhir\":{\"waktu\":\"2024-07-24 06:40:00\",\"volume\":17892.09},\"volume_flow_meter\":244.02999999999884}', 6708988.70, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(651, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-24 06:40:00\",\"volume\":17892.09},\"pembacaan_akhir\":{\"waktu\":\"2024-07-25 06:40:00\",\"volume\":18284.48},\"volume_flow_meter\":392.3899999999994}', 10787772.31, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(652, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-25 06:40:00\",\"volume\":18284.48},\"pembacaan_akhir\":{\"waktu\":\"2024-07-26 07:00:00\",\"volume\":18653.04},\"volume_flow_meter\":368.5600000000013}', 10132626.63, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(653, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-26 07:00:00\",\"volume\":18653.04},\"pembacaan_akhir\":{\"waktu\":\"2024-07-27 07:45:00\",\"volume\":18947.38},\"volume_flow_meter\":294.34000000000015}', 8092135.13, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(654, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-27 07:45:00\",\"volume\":18947.38},\"pembacaan_akhir\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"volume_flow_meter\":303.90999999999985}', 8355238.11, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(655, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"pembacaan_akhir\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(656, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-29 06:30:00\",\"volume\":19251.29},\"pembacaan_akhir\":{\"waktu\":\"2024-07-30 08:15:00\",\"volume\":19543.22},\"volume_flow_meter\":291.9300000000003}', 8025878.26, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(657, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-30 08:15:00\",\"volume\":19543.22},\"pembacaan_akhir\":{\"waktu\":\"2024-07-31 07:30:00\",\"volume\":19837.4},\"volume_flow_meter\":294.1800000000003}', 8087736.33, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(658, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-31 07:30:00\",\"volume\":19837.4},\"pembacaan_akhir\":{\"waktu\":\"2024-08-01 06:30:00\",\"volume\":20163.63},\"volume_flow_meter\":326.22999999999956}', 8968870.16, 'belum_lunas', '2025-05-04 17:48:26', '2025-05-17 20:28:44'),
(689, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-01 07:00:00\",\"volume\":12205.49},\"pembacaan_akhir\":{\"waktu\":\"2024-07-02 06:30:00\",\"volume\":12463.4},\"volume_flow_meter\":257.90999999999985}', 9462531.51, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(690, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-02 06:30:00\",\"volume\":12463.4},\"pembacaan_akhir\":{\"waktu\":\"2024-07-03 06:30:00\",\"volume\":12764.3},\"volume_flow_meter\":300.89999999999964}', 11039803.55, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(691, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-03 06:30:00\",\"volume\":12764.3},\"pembacaan_akhir\":{\"waktu\":\"2024-07-04 06:30:00\",\"volume\":12989.78},\"volume_flow_meter\":225.48000000000138}', 8272698.25, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(692, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-04 06:30:00\",\"volume\":12989.78},\"pembacaan_akhir\":{\"waktu\":\"2024-07-05 06:30:00\",\"volume\":13247.93},\"volume_flow_meter\":258.14999999999964}', 9471336.94, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(693, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-05 06:30:00\",\"volume\":13247.93},\"pembacaan_akhir\":{\"waktu\":\"2024-07-06 06:30:00\",\"volume\":13505.92},\"volume_flow_meter\":257.9899999999998}', 9465466.66, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(694, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-06 06:30:00\",\"volume\":13505.92},\"pembacaan_akhir\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"volume_flow_meter\":284.0499999999993}', 10421589.22, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(695, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"pembacaan_akhir\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(696, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-08 06:00:00\",\"volume\":13789.97},\"pembacaan_akhir\":{\"waktu\":\"2024-07-09 07:00:00\",\"volume\":14113.4},\"volume_flow_meter\":323.4300000000003}', 11866412.96, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(697, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-09 07:00:00\",\"volume\":14113.4},\"pembacaan_akhir\":{\"waktu\":\"2024-07-10 06:45:00\",\"volume\":14442.23},\"volume_flow_meter\":328.8299999999999}', 12064535.06, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(698, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-10 06:45:00\",\"volume\":14442.23},\"pembacaan_akhir\":{\"waktu\":\"2024-07-11 06:30:00\",\"volume\":14765.05},\"volume_flow_meter\":322.8199999999997}', 11844032.51, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(699, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-11 06:30:00\",\"volume\":14765.05},\"pembacaan_akhir\":{\"waktu\":\"2024-07-12 06:30:00\",\"volume\":15102.01},\"volume_flow_meter\":336.96000000000095}', 12362818.89, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(700, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-12 06:30:00\",\"volume\":15102.01},\"pembacaan_akhir\":{\"waktu\":\"2024-07-13 06:30:00\",\"volume\":15448.82},\"volume_flow_meter\":346.8099999999995}', 12724208.27, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(701, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-13 06:30:00\",\"volume\":15448.82},\"pembacaan_akhir\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"volume_flow_meter\":270.89999999999964}', 9939125.23, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(702, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"pembacaan_akhir\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(703, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-15 08:00:00\",\"volume\":15719.72},\"pembacaan_akhir\":{\"waktu\":\"2024-07-16 07:00:00\",\"volume\":16070.76},\"volume_flow_meter\":351.0400000000009}', 12879403.91, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(704, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-16 07:00:00\",\"volume\":16070.76},\"pembacaan_akhir\":{\"waktu\":\"2024-07-17 06:45:00\",\"volume\":16460.58},\"volume_flow_meter\":389.8200000000015}', 14302214.09, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(705, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-17 06:45:00\",\"volume\":16460.58},\"pembacaan_akhir\":{\"waktu\":\"2024-07-18 06:15:00\",\"volume\":16757.48},\"volume_flow_meter\":296.8999999999978}', 10893046.44, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(706, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-18 06:15:00\",\"volume\":16757.48},\"pembacaan_akhir\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"volume_flow_meter\":375.77000000000044}', 13786729.74, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(707, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"pembacaan_akhir\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(708, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-20 07:00:00\",\"volume\":17133.25},\"pembacaan_akhir\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"volume_flow_meter\":136.16999999999825}', 4995978.89, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(709, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"pembacaan_akhir\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(710, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-22 06:00:00\",\"volume\":17269.42},\"pembacaan_akhir\":{\"waktu\":\"2024-07-23 06:45:00\",\"volume\":17648.06},\"volume_flow_meter\":378.64000000000306}', 13892027.97, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(711, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-23 06:45:00\",\"volume\":17648.06},\"pembacaan_akhir\":{\"waktu\":\"2024-07-24 06:40:00\",\"volume\":17892.09},\"volume_flow_meter\":244.02999999999884}', 8953284.35, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(712, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-24 06:40:00\",\"volume\":17892.09},\"pembacaan_akhir\":{\"waktu\":\"2024-07-25 06:40:00\",\"volume\":18284.48},\"volume_flow_meter\":392.3899999999994}', 14396505.53, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(713, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-25 06:40:00\",\"volume\":18284.48},\"pembacaan_akhir\":{\"waktu\":\"2024-07-26 07:00:00\",\"volume\":18653.04},\"volume_flow_meter\":368.5600000000013}', 13522200.05, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(714, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-26 07:00:00\",\"volume\":18653.04},\"pembacaan_akhir\":{\"waktu\":\"2024-07-27 07:45:00\",\"volume\":18947.38},\"volume_flow_meter\":294.34000000000015}', 10799121.89, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(715, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-27 07:45:00\",\"volume\":18947.38},\"pembacaan_akhir\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"volume_flow_meter\":303.90999999999985}', 11150238.27, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(716, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"pembacaan_akhir\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(717, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-29 06:30:00\",\"volume\":19251.29},\"pembacaan_akhir\":{\"waktu\":\"2024-07-30 08:15:00\",\"volume\":19543.22},\"volume_flow_meter\":291.9300000000003}', 10710700.73, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(718, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-30 08:15:00\",\"volume\":19543.22},\"pembacaan_akhir\":{\"waktu\":\"2024-07-31 07:30:00\",\"volume\":19837.4},\"volume_flow_meter\":294.1800000000003}', 10793251.60, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(719, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-31 07:30:00\",\"volume\":19837.4},\"pembacaan_akhir\":{\"waktu\":\"2024-08-01 06:30:00\",\"volume\":20163.63},\"volume_flow_meter\":326.22999999999956}', 11969142.94, 'belum_lunas', '2025-05-04 18:10:08', '2025-05-04 18:10:08'),
(720, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-01 07:00:00\",\"volume\":12205.49},\"pembacaan_akhir\":{\"waktu\":\"2024-07-02 06:30:00\",\"volume\":12463.4},\"volume_flow_meter\":257.90999999999985}', 7901987.68, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(721, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-02 06:30:00\",\"volume\":12463.4},\"pembacaan_akhir\":{\"waktu\":\"2024-07-03 06:30:00\",\"volume\":12764.3},\"volume_flow_meter\":300.89999999999964}', 9219138.82, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(722, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-03 06:30:00\",\"volume\":12764.3},\"pembacaan_akhir\":{\"waktu\":\"2024-07-04 06:30:00\",\"volume\":12989.78},\"volume_flow_meter\":225.48000000000138}', 6908379.60, 'belum_lunas', '2025-05-04 18:42:01', '2025-06-03 23:01:26'),
(723, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-04 06:30:00\",\"volume\":12989.78},\"pembacaan_akhir\":{\"waktu\":\"2024-07-05 06:30:00\",\"volume\":13247.93},\"volume_flow_meter\":258.14999999999964}', 7909340.93, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(724, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-05 06:30:00\",\"volume\":13247.93},\"pembacaan_akhir\":{\"waktu\":\"2024-07-06 06:30:00\",\"volume\":13505.92},\"volume_flow_meter\":257.9899999999998}', 7904438.77, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(725, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-06 06:30:00\",\"volume\":13505.92},\"pembacaan_akhir\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"volume_flow_meter\":284.0499999999993}', 8702879.30, 'belum_lunas', '2025-05-04 18:42:01', '2025-06-03 23:01:26'),
(726, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"pembacaan_akhir\":{\"waktu\":\"2024-07-07 06:00:00\",\"volume\":13789.97},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:42:01', '2025-06-03 23:01:26'),
(727, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-08 06:00:00\",\"volume\":13789.97},\"pembacaan_akhir\":{\"waktu\":\"2024-07-09 07:00:00\",\"volume\":14113.4},\"volume_flow_meter\":323.4300000000003}', 9909425.29, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(728, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-09 07:00:00\",\"volume\":14113.4},\"pembacaan_akhir\":{\"waktu\":\"2024-07-10 06:45:00\",\"volume\":14442.23},\"volume_flow_meter\":328.8299999999999}', 10074873.44, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(729, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-10 06:45:00\",\"volume\":14442.23},\"pembacaan_akhir\":{\"waktu\":\"2024-07-11 06:30:00\",\"volume\":14765.05},\"volume_flow_meter\":322.8199999999997}', 9890735.78, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(730, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-11 06:30:00\",\"volume\":14765.05},\"pembacaan_akhir\":{\"waktu\":\"2024-07-12 06:30:00\",\"volume\":15102.01},\"volume_flow_meter\":336.96000000000095}', 10323964.83, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(731, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-12 06:30:00\",\"volume\":15102.01},\"pembacaan_akhir\":{\"waktu\":\"2024-07-13 06:30:00\",\"volume\":15448.82},\"volume_flow_meter\":346.8099999999995}', 10625754.52, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(732, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-13 06:30:00\",\"volume\":15448.82},\"pembacaan_akhir\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"volume_flow_meter\":270.89999999999964}', 8299982.41, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(733, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"pembacaan_akhir\":{\"waktu\":\"2024-07-14 08:00:00\",\"volume\":15719.72},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:42:01', '2025-06-03 23:01:26'),
(734, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-15 08:00:00\",\"volume\":15719.72},\"pembacaan_akhir\":{\"waktu\":\"2024-07-16 07:00:00\",\"volume\":16070.76},\"volume_flow_meter\":351.0400000000009}', 10755355.57, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(735, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-16 07:00:00\",\"volume\":16070.76},\"pembacaan_akhir\":{\"waktu\":\"2024-07-17 06:45:00\",\"volume\":16460.58},\"volume_flow_meter\":389.8200000000015}', 11943518.43, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(736, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-17 06:45:00\",\"volume\":16460.58},\"pembacaan_akhir\":{\"waktu\":\"2024-07-18 06:15:00\",\"volume\":16757.48},\"volume_flow_meter\":296.8999999999978}', 9096584.63, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(737, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-18 06:15:00\",\"volume\":16757.48},\"pembacaan_akhir\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"volume_flow_meter\":375.77000000000044}', 11513046.84, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(738, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"pembacaan_akhir\":{\"waktu\":\"2024-07-19 07:30:00\",\"volume\":17133.25},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:42:01', '2025-06-03 23:01:26'),
(739, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-20 07:00:00\",\"volume\":17133.25},\"pembacaan_akhir\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"volume_flow_meter\":136.16999999999825}', 4172050.96, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(740, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"pembacaan_akhir\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:42:01', '2025-06-03 23:01:26'),
(741, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-22 06:00:00\",\"volume\":17269.42},\"pembacaan_akhir\":{\"waktu\":\"2024-07-23 06:45:00\",\"volume\":17648.06},\"volume_flow_meter\":378.64000000000306}', 11600979.47, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(742, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-23 06:45:00\",\"volume\":17648.06},\"pembacaan_akhir\":{\"waktu\":\"2024-07-24 06:40:00\",\"volume\":17892.09},\"volume_flow_meter\":244.02999999999884}', 7476724.65, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(743, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-24 06:40:00\",\"volume\":17892.09},\"pembacaan_akhir\":{\"waktu\":\"2024-07-25 06:40:00\",\"volume\":18284.48},\"volume_flow_meter\":392.3899999999994}', 12022259.50, 'belum_lunas', '2025-05-04 18:42:01', '2025-06-03 23:01:26'),
(744, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-25 06:40:00\",\"volume\":18284.48},\"pembacaan_akhir\":{\"waktu\":\"2024-07-26 07:00:00\",\"volume\":18653.04},\"volume_flow_meter\":368.5600000000013}', 11292142.92, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(745, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-26 07:00:00\",\"volume\":18653.04},\"pembacaan_akhir\":{\"waktu\":\"2024-07-27 07:45:00\",\"volume\":18947.38},\"volume_flow_meter\":294.34000000000015}', 9018149.95, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(746, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-27 07:45:00\",\"volume\":18947.38},\"pembacaan_akhir\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"volume_flow_meter\":303.90999999999985}', 9311360.85, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(747, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"pembacaan_akhir\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-04 18:42:01', '2025-06-03 23:01:26'),
(748, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-29 06:30:00\",\"volume\":19251.29},\"pembacaan_akhir\":{\"waktu\":\"2024-07-30 08:15:00\",\"volume\":19543.22},\"volume_flow_meter\":291.9300000000003}', 8944311.06, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(749, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-30 08:15:00\",\"volume\":19543.22},\"pembacaan_akhir\":{\"waktu\":\"2024-07-31 07:30:00\",\"volume\":19837.4},\"volume_flow_meter\":294.1800000000003}', 9013247.79, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(750, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-31 07:30:00\",\"volume\":19837.4},\"pembacaan_akhir\":{\"waktu\":\"2024-08-01 06:30:00\",\"volume\":20163.63},\"volume_flow_meter\":326.22999999999956}', 9995213.22, 'belum_lunas', '2025-05-04 18:42:01', '2025-05-04 18:42:01'),
(753, 17, 'test fob', '{\"waktu\":\"2025-03-07 00:00:00\",\"volume_sm3\":300,\"keterangan\":null}', 166500.00, 'belum_lunas', '2025-04-06 20:19:22', '2025-04-06 20:19:22'),
(754, 17, 'test fob', '{\"waktu\":\"2025-04-22 04:21:00\",\"volume_sm3\":600,\"keterangan\":null}', 333000.00, 'belum_lunas', '2025-04-21 21:22:04', '2025-04-21 21:22:04'),
(755, 18, 'test2', '{\"waktu\":\"2025-04-03 00:00:00\",\"volume_sm3\":400,\"keterangan\":null}', 2400000.00, 'belum_lunas', '2025-04-06 20:32:54', '2025-04-06 20:32:54'),
(756, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-20 07:00:00\",\"volume\":17133.25},\"pembacaan_akhir\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"volume_flow_meter\":136.16999999999825}', 832563.44, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:42'),
(757, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"pembacaan_akhir\":{\"waktu\":\"2024-07-21 06:00:00\",\"volume\":17269.42},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(758, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-22 06:00:00\",\"volume\":17269.42},\"pembacaan_akhir\":{\"waktu\":\"2024-07-23 06:45:00\",\"volume\":17648.06},\"volume_flow_meter\":378.64000000000306}', 2315060.73, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(759, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-23 06:45:00\",\"volume\":17648.06},\"pembacaan_akhir\":{\"waktu\":\"2024-07-24 06:40:00\",\"volume\":17892.09},\"volume_flow_meter\":244.02999999999884}', 1492035.36, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(760, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-24 06:40:00\",\"volume\":17892.09},\"pembacaan_akhir\":{\"waktu\":\"2024-07-25 06:40:00\",\"volume\":18284.48},\"volume_flow_meter\":392.3899999999994}', 2399130.25, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43');
INSERT INTO `data_pencatatan` (`id`, `customer_id`, `nama_customer`, `data_input`, `harga_final`, `status_pembayaran`, `created_at`, `updated_at`) VALUES
(761, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-25 06:40:00\",\"volume\":18284.48},\"pembacaan_akhir\":{\"waktu\":\"2024-07-26 07:00:00\",\"volume\":18653.04},\"volume_flow_meter\":368.5600000000013}', 2253430.12, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(762, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-26 07:00:00\",\"volume\":18653.04},\"pembacaan_akhir\":{\"waktu\":\"2024-07-27 07:45:00\",\"volume\":18947.38},\"volume_flow_meter\":294.34000000000015}', 1799638.11, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(763, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-27 07:45:00\",\"volume\":18947.38},\"pembacaan_akhir\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"volume_flow_meter\":303.90999999999985}', 1858150.50, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(764, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"pembacaan_akhir\":{\"waktu\":\"2024-07-28 06:30:00\",\"volume\":19251.29},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(765, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-29 06:30:00\",\"volume\":19251.29},\"pembacaan_akhir\":{\"waktu\":\"2024-07-30 08:15:00\",\"volume\":19543.22},\"volume_flow_meter\":291.9300000000003}', 1784903.02, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(766, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-30 08:15:00\",\"volume\":19543.22},\"pembacaan_akhir\":{\"waktu\":\"2024-07-31 07:30:00\",\"volume\":19837.4},\"volume_flow_meter\":294.1800000000003}', 1798659.85, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(767, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-07-31 07:30:00\",\"volume\":19837.4},\"pembacaan_akhir\":{\"waktu\":\"2024-08-01 06:30:00\",\"volume\":20163.63},\"volume_flow_meter\":326.22999999999956}', 1994618.27, 'belum_lunas', '2025-05-05 17:53:21', '2025-05-06 17:56:43'),
(768, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-02 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-02 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(769, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-03 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-03 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(770, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-04 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-04 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(771, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-05 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-05 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(772, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-06 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-06 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(773, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-07 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-07 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(774, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-08 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-08 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(775, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-09 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-09 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(776, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-10 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-10 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(777, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-11 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-11 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(778, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-12 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-12 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(779, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-13 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-13 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(780, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-14 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-14 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(781, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-15 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-15 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(782, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-16 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-16 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(783, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-17 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-17 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(784, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-18 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-18 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(785, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-19 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-19 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(786, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-20 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-20 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(787, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-21 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-21 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(788, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-22 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-22 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(789, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-23 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-23 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(790, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-24 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-24 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(791, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-25 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-25 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(792, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-26 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-26 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(793, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-27 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-27 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(794, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-28 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-28 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(795, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-29 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-29 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(796, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-30 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-30 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(797, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-08-31 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-08-31 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(798, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-01 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-01 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(799, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-02 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-02 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(800, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-03 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-03 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(801, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-04 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-04 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(802, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-05 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-05 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(803, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-06 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-06 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(804, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-07 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-07 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(805, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-08 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-08 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:26'),
(806, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-09 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-09 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(807, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-10 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-10 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(808, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-11 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-11 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(809, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-12 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-12 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(810, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-13 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-13 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(811, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-14 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-14 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(812, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-15 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-15 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(813, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-16 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-16 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(814, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-17 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-17 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(815, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-18 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-18 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(816, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-19 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-19 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(817, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-20 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-20 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(818, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-21 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-21 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(819, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-22 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-22 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(820, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-23 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-23 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(821, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-24 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-24 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(822, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-25 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-25 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(823, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-26 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-26 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(824, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-27 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-27 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(825, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-28 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-28 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(826, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-29 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-29 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(827, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-09-30 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-09-30 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(828, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-01 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-01 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:42', '2025-06-03 23:01:27'),
(829, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-02 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-02 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(830, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-03 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-03 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(831, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-04 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-04 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(832, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-05 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-05 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(833, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-06 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-06 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(834, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-07 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-07 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(835, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-08 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-08 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(836, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-09 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-09 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(837, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-10 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-10 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(838, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-11 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-11 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(839, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-12 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-12 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(840, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-13 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-13 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(841, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-14 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-14 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(842, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-15 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-15 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(843, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-16 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-16 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(844, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-17 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-17 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(845, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-18 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-18 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(846, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-19 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-19 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(847, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-20 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-20 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(848, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-21 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-21 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(849, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-22 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-22 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(850, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-23 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-23 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(851, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-24 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-24 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(852, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-25 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-25 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(853, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-26 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-26 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(854, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-27 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-27 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(855, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-28 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-28 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(856, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-29 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-29 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(857, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-30 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-30 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(858, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-10-31 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-10-31 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(859, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-01 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-01 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(860, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-02 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-02 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(861, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-03 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-03 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(862, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-04 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-04 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(863, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-05 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-05 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(864, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-06 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-06 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(865, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-07 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-07 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(866, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-08 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-08 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(867, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-09 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-09 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(868, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-10 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-10 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(869, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-11 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-11 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(870, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-12 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-12 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(871, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-13 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-13 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(872, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-14 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-14 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(873, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-15 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-15 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(874, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-16 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-16 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(875, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-17 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-17 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(876, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-18 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-18 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(877, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-19 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-19 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(878, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-20 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-20 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(879, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-21 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-21 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(880, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-22 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-22 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(881, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-23 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-23 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(882, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-24 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-24 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(883, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-25 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-25 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(884, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-26 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-26 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(885, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-27 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-27 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(886, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-28 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-28 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(887, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-29 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-29 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(888, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-30 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-11-30 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(889, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-01 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-01 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(890, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-02 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-02 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(891, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-03 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-03 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(892, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-04 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-04 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(893, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-05 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-05 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(894, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-06 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-06 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(895, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-07 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-07 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(896, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-08 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-08 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(897, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-09 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-09 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(898, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-10 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-10 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(899, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-11 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-11 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(900, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-12 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-12 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(901, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-13 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-13 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(902, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-14 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-14 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(903, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-15 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-15 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(904, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-16 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-16 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(905, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-17 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-17 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(906, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-18 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-18 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(907, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-19 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-19 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(908, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-20 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-20 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(909, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-21 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-21 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(910, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-22 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-22 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(911, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-23 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-23 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(912, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-24 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-24 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(913, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-25 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-25 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(914, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-26 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-26 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(915, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-27 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-27 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(916, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-28 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-28 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(917, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-29 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-29 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(918, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-30 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-30 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(919, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-12-31 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2024-12-31 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(920, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-01 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-01 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(921, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-02 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-02 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(922, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-03 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-03 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(923, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-04 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-04 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(924, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-05 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-05 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(925, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-06 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-06 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(926, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-07 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-07 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(927, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-08 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-08 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(928, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-09 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-09 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(929, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-10 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-10 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(930, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-11 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-11 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(931, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-12 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-12 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(932, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-13 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-13 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(933, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-14 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-14 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(934, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-15 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-15 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(935, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-16 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-16 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(936, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-17 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-17 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(937, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-18 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-18 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(938, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-19 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-19 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(939, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-20 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-20 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(940, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-21 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-21 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(941, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-22 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-22 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(942, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-23 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-23 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(943, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-24 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-24 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(944, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-25 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-25 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(945, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-26 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-26 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(946, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-27 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-27 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(947, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-28 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-28 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(948, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-29 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-29 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(949, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-30 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-30 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(950, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-31 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-31 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(951, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-01 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-01 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(952, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-02 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-02 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:43', '2025-06-03 23:01:27'),
(953, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-03 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-03 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27');
INSERT INTO `data_pencatatan` (`id`, `customer_id`, `nama_customer`, `data_input`, `harga_final`, `status_pembayaran`, `created_at`, `updated_at`) VALUES
(954, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-04 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-04 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(955, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-05 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-05 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(956, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-06 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-06 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(957, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-07 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-07 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(958, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-08 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-08 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(959, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-09 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-09 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(960, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-10 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-10 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(961, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-11 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-11 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(962, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-12 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-12 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(963, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-13 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-13 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(964, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-14 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-14 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(965, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-15 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-15 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(966, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-16 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-16 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(967, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-17 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-17 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(968, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-18 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-18 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(969, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-19 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-19 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(970, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-20 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-20 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(971, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-21 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-21 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(972, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-22 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-22 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(973, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-23 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-23 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(974, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-24 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-24 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(975, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-25 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-25 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(976, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-26 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-26 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(977, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-27 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-27 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(978, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-28 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-02-28 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(979, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-01 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-01 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(980, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-02 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-02 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(981, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-03 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-03 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(982, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-04 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-04 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(983, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-05 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-05 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(984, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-06 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-06 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(985, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-07 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-07 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(986, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-08 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-08 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(987, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-09 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-09 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(988, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-10 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-10 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(989, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-11 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-11 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(990, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-12 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-12 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(991, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-13 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-13 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(992, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-14 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-14 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(993, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-15 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-15 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(994, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-16 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-16 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(995, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-17 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-17 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(996, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-18 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-18 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(997, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-19 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-19 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(998, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-20 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-20 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(999, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-21 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-21 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1000, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-22 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-22 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1001, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-23 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-23 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1002, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-24 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-24 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1003, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-25 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-25 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1004, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-26 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-26 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1005, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-27 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-27 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1006, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-28 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-28 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1007, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-29 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-29 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1008, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-30 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-30 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1009, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-31 00:00\",\"volume\":20163.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-31 23:59\",\"volume\":20163.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:34:44', '2025-06-03 23:01:27'),
(1010, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-01T07:00\",\"volume\":300},\"pembacaan_akhir\":{\"waktu\":\"2025-04-05T23:59\",\"volume\":400},\"volume_flow_meter\":100}', 3063854.71, 'belum_lunas', '2025-05-06 02:34:44', '2025-05-06 02:34:44'),
(1011, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-06 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-06 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:52', '2025-06-03 23:01:27'),
(1012, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-07 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-07 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:52', '2025-06-03 23:01:27'),
(1013, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-08 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-08 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:52', '2025-06-03 23:01:27'),
(1014, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-09 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-09 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:52', '2025-06-03 23:01:27'),
(1015, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-10 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-10 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:52', '2025-06-03 23:01:27'),
(1016, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-11 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-11 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1017, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-12 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-12 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1018, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-13 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-13 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1019, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-14 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-14 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1020, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-15 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-15 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1021, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-16 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-16 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1022, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-17 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-17 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1023, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-18 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-18 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1024, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-19 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-19 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1025, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-20 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-20 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1026, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-21 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-21 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1027, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-22 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-22 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1028, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-23 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-23 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1029, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-24 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-24 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1030, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-25 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-25 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1031, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-26 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-26 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1032, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-27 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-27 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1033, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-28 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-28 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1034, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-29 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-29 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1035, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-30 00:00\",\"volume\":400},\"pembacaan_akhir\":{\"waktu\":\"2025-04-30 23:59\",\"volume\":400},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 02:35:53', '2025-06-03 23:01:27'),
(1038, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 03:39:30', '2025-06-03 23:01:27'),
(1039, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 3976270.64, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1040, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 8749449.90, 'belum_lunas', '2025-05-06 03:39:30', '2025-06-03 23:01:27'),
(1041, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 5998108.37, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1042, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 03:39:30', '2025-06-03 23:01:27'),
(1043, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 6837910.94, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1044, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 6480052.71, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1045, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 4102807.84, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1046, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-09 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-09 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 03:39:30', '2025-06-03 23:01:27'),
(1047, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 4577705.32, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1048, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 2324240.18, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1049, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 03:39:30', '2025-06-03 23:01:27'),
(1050, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 5413831.27, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1051, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 2965811.36, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1052, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 2364989.45, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1053, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 690286.47, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1054, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 2553722.90, 'belum_lunas', '2025-05-06 03:39:30', '2025-06-03 23:01:27'),
(1055, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 5786089.62, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1056, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 03:39:30', '2025-06-03 23:01:27'),
(1057, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 6439916.22, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1058, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 8156287.62, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1059, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 7233454.59, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1060, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 7098032.21, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1061, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 8089189.21, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1062, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 6793791.43, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1063, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 03:39:30', '2025-06-03 23:01:27'),
(1064, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 9228636.77, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1065, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 7007648.49, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1066, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 8698589.91, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1067, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 8406910.94, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1068, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 7668215.57, 'belum_lunas', '2025-05-06 03:39:30', '2025-05-06 03:39:30'),
(1069, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-16 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-16 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1070, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-17 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-17 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1071, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-18 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-18 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1072, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-19 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-19 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1073, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-20 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-20 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1074, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-21 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-21 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1075, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-22 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-22 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1076, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-23 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-23 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1077, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-24 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-24 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1078, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-25 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-25 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1079, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-26 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-26 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1080, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-27 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-27 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1081, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-28 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-28 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1082, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-29 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-29 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1083, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-30 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-30 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1084, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-31 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-03-31 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1085, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-01 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-01 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1086, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-02 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-02 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1087, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-03 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-03 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1088, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-04 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-04 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1089, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-05 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-05 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1090, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-06 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-06 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1091, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-07 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-07 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1092, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-08 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-08 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1093, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-09 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-09 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1094, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-10 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-10 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1095, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-11 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-11 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1096, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-12 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-12 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1097, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-13 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-13 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1098, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-14 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-14 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1099, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-15 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-15 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1100, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-16 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-16 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1101, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-17 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-17 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1102, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-18 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-18 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1103, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-19 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-19 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1104, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-20 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-20 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1105, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-21 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-21 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1106, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-22 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-22 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1107, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-23 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-23 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1108, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-24 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-24 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1109, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-25 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-25 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1110, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-26 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-26 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1111, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-27 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-27 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1112, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-28 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-28 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1113, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-29 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-29 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1114, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-30 00:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-04-30 23:59\",\"volume\":123344},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-05-06 05:58:32', '2025-05-17 20:28:44'),
(1115, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-01T07:00\",\"volume\":123344},\"pembacaan_akhir\":{\"waktu\":\"2025-05-05T23:59\",\"volume\":1111111},\"volume_flow_meter\":987767}', 4029820756.52, 'belum_lunas', '2025-05-06 05:58:32', '2025-05-06 23:26:07'),
(1116, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1119, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04T07:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04T23:59\",\"volume\":2539.3},\"volume_flow_meter\":195.75}', 798606.77, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 23:09:31'),
(1120, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1121, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 910513.71, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1122, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 862862.49, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1123, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 546316.39, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1124, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-09 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-09 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1125, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 1370272.12, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1126, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 695728.82, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1127, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1128, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 1620554.74, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1129, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 887774.19, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1130, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 314914.21, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1131, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 91916.27, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1132, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 340045.33, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1133, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 770456.65, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1134, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1135, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 857518.04, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1136, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1086064.41, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1137, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 963183.00, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1138, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 945150.60, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1139, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1077129.81, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1140, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 904638.90, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1141, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1142, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1228854.89, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1143, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 933115.40, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1144, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1158275.60, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-17 20:28:44'),
(1145, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1119436.59, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56');
INSERT INTO `data_pencatatan` (`id`, `customer_id`, `nama_customer`, `data_input`, `harga_final`, `status_pembayaran`, `created_at`, `updated_at`) VALUES
(1146, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 1021074.34, 'belum_lunas', '2025-05-06 06:04:56', '2025-05-06 06:04:56'),
(1147, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1148, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 4761534.41, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1149, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 10477356.93, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1150, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 7182659.82, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1151, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1152, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 8188312.91, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1153, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 7759782.15, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1154, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 4913061.13, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1155, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-09 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-09 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1156, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 5481744.92, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1157, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 2783248.58, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1158, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1159, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 6482995.30, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1160, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 3551522.04, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1161, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 2832045.32, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1162, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 826609.42, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1163, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 3058051.26, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1164, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 6928770.02, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1165, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1166, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 7711719.20, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1167, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 9767052.52, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1168, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 8661971.48, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1169, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 8499804.88, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1170, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 9686703.00, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1171, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 8135480.35, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1172, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1173, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 11051177.22, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1174, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 8391571.51, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1175, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 10416452.72, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1176, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 10067170.80, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1177, 5, 'Customer3', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 9182592.33, 'belum_lunas', '2025-05-06 06:20:04', '2025-05-06 06:20:04'),
(1178, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1179, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 396747.02, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1180, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 873008.52, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1181, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 598483.31, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1182, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1183, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 682277.69, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1184, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 646571.07, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1185, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 409372.73, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1186, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-09 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-09 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:55:44'),
(1187, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 913514.75, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:56:43'),
(1188, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 463819.21, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:56:43'),
(1189, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:56:43'),
(1190, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 1080369.82, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:56:43'),
(1191, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 591849.46, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:56:43'),
(1192, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 471951.03, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:56:43'),
(1193, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 137751.74, 'belum_lunas', '2025-05-06 17:55:44', '2025-05-06 17:56:43'),
(1194, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 509614.18, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:43'),
(1195, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 1154656.71, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:43'),
(1196, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:43'),
(1197, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 1285132.62, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1198, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1627647.15, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1199, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 1443489.03, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1200, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 1416464.50, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1201, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1614257.16, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1202, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 1355751.02, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1203, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1204, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1841642.30, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1205, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 1398427.77, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1206, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1735867.55, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1207, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1677660.87, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1208, 20, 'testing excel', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 1530248.78, 'belum_lunas', '2025-05-06 17:55:45', '2025-05-06 17:56:44'),
(1209, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-01 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-01 18:00:00\",\"volume\":1928.2},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1210, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-02 07:00:00\",\"volume\":1928.2},\"pembacaan_akhir\":{\"waktu\":\"2024-05-02 18:00:00\",\"volume\":2057.98},\"volume_flow_meter\":129.77999999999997}', 511992.95, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1211, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-03 07:00:00\",\"volume\":2057.98},\"pembacaan_akhir\":{\"waktu\":\"2024-05-03 23:59:00\",\"volume\":2343.55},\"volume_flow_meter\":285.57000000000016}', 1126597.52, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1212, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-04 07:00:00\",\"volume\":2343.55},\"pembacaan_akhir\":{\"waktu\":\"2024-05-04 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":195.76999999999998}', 772329.01, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1213, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-05 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-05 23:59:00\",\"volume\":2539.32},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1214, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-06 07:00:00\",\"volume\":2539.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-06 23:59:00\",\"volume\":2762.5},\"volume_flow_meter\":223.17999999999984}', 880463.75, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1215, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-07 07:00:00\",\"volume\":2762.5},\"pembacaan_akhir\":{\"waktu\":\"2024-05-07 23:59:00\",\"volume\":2974},\"volume_flow_meter\":211.5}', 834385.18, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1216, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-08 07:00:00\",\"volume\":2974},\"pembacaan_akhir\":{\"waktu\":\"2024-05-08 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":133.90999999999985}', 528286.14, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1217, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-09 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-09 23:59:00\",\"volume\":3107.91},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1218, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-10 07:00:00\",\"volume\":3107.91},\"pembacaan_akhir\":{\"waktu\":\"2024-05-10 23:59:00\",\"volume\":3257.32},\"volume_flow_meter\":149.4100000000003}', 2947174.69, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:13:32'),
(1219, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-11 07:00:00\",\"volume\":3257.32},\"pembacaan_akhir\":{\"waktu\":\"2024-05-11 20:00:00\",\"volume\":3333.18},\"volume_flow_meter\":75.85999999999967}', 1496370.20, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:13:32'),
(1220, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-12 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-12 23:59:00\",\"volume\":3333.18},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:13:32'),
(1221, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-13 07:00:00\",\"volume\":3333.18},\"pembacaan_akhir\":{\"waktu\":\"2024-05-13 23:59:00\",\"volume\":3509.88},\"volume_flow_meter\":176.70000000000027}', 3485481.34, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:13:32'),
(1222, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-14 07:00:00\",\"volume\":3509.88},\"pembacaan_akhir\":{\"waktu\":\"2024-05-14 23:59:00\",\"volume\":3606.68},\"volume_flow_meter\":96.79999999999973}', 1909420.45, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:13:32'),
(1223, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-15 07:00:00\",\"volume\":3606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-05-15 23:59:00\",\"volume\":3683.87},\"volume_flow_meter\":77.19000000000005}', 304521.00, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1224, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-16 07:00:00\",\"volume\":3683.87},\"pembacaan_akhir\":{\"waktu\":\"2024-05-16 23:59:00\",\"volume\":3706.4},\"volume_flow_meter\":22.5300000000002}', 88882.73, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1225, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-17 07:00:00\",\"volume\":3706.4},\"pembacaan_akhir\":{\"waktu\":\"2024-05-17 23:59:00\",\"volume\":3789.75},\"volume_flow_meter\":83.34999999999991}', 328822.72, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1226, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-18 07:00:00\",\"volume\":3789.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-18 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":188.8499999999999}', 745029.03, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1227, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-19 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-19 23:59:00\",\"volume\":3978.6},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1228, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-20 07:00:00\",\"volume\":3978.6},\"pembacaan_akhir\":{\"waktu\":\"2024-05-20 23:59:00\",\"volume\":4188.79},\"volume_flow_meter\":210.19000000000005}', 829217.12, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1229, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-21 07:00:00\",\"volume\":4188.79},\"pembacaan_akhir\":{\"waktu\":\"2024-05-21 23:59:00\",\"volume\":4455},\"volume_flow_meter\":266.21000000000004}', 1050220.70, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1230, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-22 07:00:00\",\"volume\":4455},\"pembacaan_akhir\":{\"waktu\":\"2024-05-22 23:59:00\",\"volume\":4691.09},\"volume_flow_meter\":236.09000000000015}', 931394.78, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1231, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-23 07:00:00\",\"volume\":4691.09},\"pembacaan_akhir\":{\"waktu\":\"2024-05-23 23:59:00\",\"volume\":4922.76},\"volume_flow_meter\":231.67000000000007}', 913957.51, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1232, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-24 07:00:00\",\"volume\":4922.76},\"pembacaan_akhir\":{\"waktu\":\"2024-05-24 23:59:00\",\"volume\":5186.78},\"volume_flow_meter\":264.0199999999995}', 1041580.97, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1233, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-25 07:00:00\",\"volume\":5186.78},\"pembacaan_akhir\":{\"waktu\":\"2024-05-25 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":221.7400000000007}', 874782.83, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1234, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-26 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-26 23:59:00\",\"volume\":5408.52},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1235, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-27 07:00:00\",\"volume\":5408.52},\"pembacaan_akhir\":{\"waktu\":\"2024-05-27 23:59:00\",\"volume\":5709.73},\"volume_flow_meter\":301.2099999999991}', 1188298.63, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1236, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-28 07:00:00\",\"volume\":5709.73},\"pembacaan_akhir\":{\"waktu\":\"2024-05-28 23:59:00\",\"volume\":5938.45},\"volume_flow_meter\":228.72000000000025}', 902319.52, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1237, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-29 07:00:00\",\"volume\":5938.45},\"pembacaan_akhir\":{\"waktu\":\"2024-05-29 23:59:00\",\"volume\":6222.36},\"volume_flow_meter\":283.90999999999985}', 1120048.68, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1238, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-30 07:00:00\",\"volume\":6222.36},\"pembacaan_akhir\":{\"waktu\":\"2024-05-30 23:59:00\",\"volume\":6496.75},\"volume_flow_meter\":274.3900000000003}', 1082491.48, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1239, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-05-31 07:00:00\",\"volume\":6496.75},\"pembacaan_akhir\":{\"waktu\":\"2024-05-31 23:59:00\",\"volume\":6747.03},\"volume_flow_meter\":250.27999999999975}', 987375.52, 'belum_lunas', '2025-05-06 21:09:43', '2025-05-06 21:09:43'),
(1240, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-01 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-01 17:00:00\",\"volume\":6747.03},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1241, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-02 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-02 17:00:00\",\"volume\":6747.03},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1242, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-03 07:00:00\",\"volume\":6747.03},\"pembacaan_akhir\":{\"waktu\":\"2024-06-03 23:59:00\",\"volume\":7016.43},\"volume_flow_meter\":269.40000000000055}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1243, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-04 07:00:00\",\"volume\":7016.43},\"pembacaan_akhir\":{\"waktu\":\"2024-06-04 23:59:00\",\"volume\":7225.67},\"volume_flow_meter\":209.23999999999978}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1244, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-05 07:00:00\",\"volume\":7225.67},\"pembacaan_akhir\":{\"waktu\":\"2024-06-05 23:59:00\",\"volume\":7514.6},\"volume_flow_meter\":288.9300000000003}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1245, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-06 07:00:00\",\"volume\":7514.6},\"pembacaan_akhir\":{\"waktu\":\"2024-06-06 23:59:00\",\"volume\":7694.82},\"volume_flow_meter\":180.21999999999935}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1246, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-07 07:00:00\",\"volume\":7694.82},\"pembacaan_akhir\":{\"waktu\":\"2024-06-07 23:59:00\",\"volume\":7950.85},\"volume_flow_meter\":256.03000000000065}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1247, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-08 07:00:00\",\"volume\":7950.85},\"pembacaan_akhir\":{\"waktu\":\"2024-06-08 23:59:00\",\"volume\":8106.05},\"volume_flow_meter\":155.19999999999982}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1248, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-09 07:00:00\",\"volume\":8106.05},\"pembacaan_akhir\":{\"waktu\":\"2024-06-09 23:59:00\",\"volume\":8106.05},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1249, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-10 07:00:00\",\"volume\":8106.05},\"pembacaan_akhir\":{\"waktu\":\"2024-06-10 23:59:00\",\"volume\":8328.06},\"volume_flow_meter\":222.0099999999993}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1250, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-11 07:00:00\",\"volume\":8328.06},\"pembacaan_akhir\":{\"waktu\":\"2024-06-11 23:59:00\",\"volume\":8606.68},\"volume_flow_meter\":278.6200000000008}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1251, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-12 07:00:00\",\"volume\":8606.68},\"pembacaan_akhir\":{\"waktu\":\"2024-06-12 23:59:00\",\"volume\":8862.14},\"volume_flow_meter\":255.45999999999913}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1252, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-13 07:00:00\",\"volume\":8862.14},\"pembacaan_akhir\":{\"waktu\":\"2024-06-13 23:59:00\",\"volume\":9129.8},\"volume_flow_meter\":267.65999999999985}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1253, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-14 07:00:00\",\"volume\":9129.8},\"pembacaan_akhir\":{\"waktu\":\"2024-06-14 23:59:00\",\"volume\":9321.39},\"volume_flow_meter\":191.59000000000015}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1254, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-15 07:00:00\",\"volume\":9321.39},\"pembacaan_akhir\":{\"waktu\":\"2024-06-15 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":188.3199999999997}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1255, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-16 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-16 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1256, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-17 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-17 23:59:00\",\"volume\":9509.71},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1257, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-18 07:00:00\",\"volume\":9509.71},\"pembacaan_akhir\":{\"waktu\":\"2024-06-18 23:59:00\",\"volume\":9679.35},\"volume_flow_meter\":169.64000000000124}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1258, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-19 07:00:00\",\"volume\":9679.35},\"pembacaan_akhir\":{\"waktu\":\"2024-06-19 23:59:00\",\"volume\":9863.18},\"volume_flow_meter\":183.82999999999993}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1259, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-20 07:00:00\",\"volume\":9863.18},\"pembacaan_akhir\":{\"waktu\":\"2024-06-20 23:59:00\",\"volume\":10122.82},\"volume_flow_meter\":259.6399999999994}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1260, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-21 07:00:00\",\"volume\":10122.82},\"pembacaan_akhir\":{\"waktu\":\"2024-06-21 23:59:00\",\"volume\":10405.24},\"volume_flow_meter\":282.4200000000001}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1261, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-22 07:00:00\",\"volume\":10405.24},\"pembacaan_akhir\":{\"waktu\":\"2024-06-22 23:59:00\",\"volume\":10674.89},\"volume_flow_meter\":269.64999999999964}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1262, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-23 07:00:00\",\"volume\":10674.89},\"pembacaan_akhir\":{\"waktu\":\"2024-06-23 23:59:00\",\"volume\":10674.89},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1263, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-24 07:00:00\",\"volume\":10674.89},\"pembacaan_akhir\":{\"waktu\":\"2024-06-24 23:59:00\",\"volume\":10959.41},\"volume_flow_meter\":284.52000000000044}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1264, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-25 07:00:00\",\"volume\":10959.41},\"pembacaan_akhir\":{\"waktu\":\"2024-06-25 23:59:00\",\"volume\":11222.91},\"volume_flow_meter\":263.5}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1265, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-26 07:00:00\",\"volume\":11222.91},\"pembacaan_akhir\":{\"waktu\":\"2024-06-26 23:59:00\",\"volume\":11493.51},\"volume_flow_meter\":270.60000000000036}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1266, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-27 07:00:00\",\"volume\":11493.51},\"pembacaan_akhir\":{\"waktu\":\"2024-06-27 23:59:00\",\"volume\":11747.91},\"volume_flow_meter\":254.39999999999964}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1267, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-28 07:00:00\",\"volume\":11747.91},\"pembacaan_akhir\":{\"waktu\":\"2024-06-28 23:59:00\",\"volume\":11960.84},\"volume_flow_meter\":212.9300000000003}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1268, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-29 07:00:00\",\"volume\":11960.84},\"pembacaan_akhir\":{\"waktu\":\"2024-06-29 23:59:00\",\"volume\":12205.49},\"volume_flow_meter\":244.64999999999964}', 0.00, 'belum_lunas', '2025-05-06 22:42:14', '2025-05-06 22:42:14'),
(1269, 21, 'test fix', '{\"pembacaan_awal\":{\"waktu\":\"2024-06-30 07:00:00\",\"volume\":12205.49},\"pembacaan_akhir\":{\"waktu\":\"2024-06-30 19:00:00\",\"volume\":12205.49},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-06 22:42:15', '2025-05-06 22:42:15'),
(1275, 17, 'test fob', '{\"waktu\":\"2025-05-08 04:42:00\",\"volume_sm3\":600,\"keterangan\":null}', 333000.00, 'belum_lunas', '2025-05-07 21:43:01', '2025-05-07 21:43:01'),
(1278, 18, 'test2', '{\"waktu\":\"2025-04-07 00:00:00\",\"volume_sm3\":200,\"keterangan\":null}', 1200000.00, 'belum_lunas', '2025-04-06 20:18:23', '2025-04-06 20:18:23'),
(1281, 18, 'test2', '{\"waktu\":\"2025-05-09 03:07:00\",\"volume_sm3\":\"3330\",\"keterangan\":null}', 19980000.00, 'belum_lunas', '2025-05-08 20:08:02', '2025-05-08 20:08:02'),
(1282, 22, 'baruu', '{\"waktu\":\"2024-02-09 03:18:00\",\"volume_sm3\":\"324\",\"keterangan\":null}', 0.00, 'belum_lunas', '2025-05-08 20:18:50', '2025-05-08 20:18:50'),
(1283, 17, 'test fob', '{\"waktu\":\"2025-05-09T05:50\",\"volume_sm3\":\"223\",\"keterangan\":null,\"alamat_pengambilan\":\"23dsdsd\"}', 123765.00, 'belum_lunas', '2025-05-08 22:50:47', '2025-05-08 22:50:47'),
(1284, 17, 'test fob', '{\"waktu\":\"2025-05-07T06:12\",\"volume_sm3\":\"2323\",\"keterangan\":null,\"alamat_pengambilan\":null}', 1289265.00, 'belum_lunas', '2025-05-08 23:12:57', '2025-05-08 23:12:57'),
(1285, 17, 'test fob', '{\"waktu\":\"2025-05-10T06:13\",\"volume_sm3\":\"2323\",\"keterangan\":null,\"alamat_pengambilan\":\"dadd\"}', 1289265.00, 'belum_lunas', '2025-05-08 23:13:21', '2025-05-08 23:13:21'),
(1286, 17, 'test fob', '{\"waktu\":\"2025-05-27 08:15:00\",\"volume_sm3\":\"4000\",\"keterangan\":null}', 2000000.00, 'belum_lunas', '2025-05-27 01:15:56', '2025-05-27 01:15:56'),
(1287, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-17 08:00:00\",\"volume\":652.07},\"pembacaan_akhir\":{\"waktu\":\"2025-05-17 18:00:00\",\"volume\":652.07},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-28 08:04:04', '2025-05-28 08:04:05'),
(1288, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-18 08:00:00\",\"volume\":652.07},\"pembacaan_akhir\":{\"waktu\":\"2025-05-18 18:00:00\",\"volume\":652.07},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-28 08:04:04', '2025-05-28 08:04:05'),
(1289, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-19 08:00:00\",\"volume\":652.07},\"pembacaan_akhir\":{\"waktu\":\"2025-05-19 18:00:00\",\"volume\":652.07},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-28 08:04:04', '2025-05-28 08:04:05'),
(1290, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-20 08:00:00\",\"volume\":652.07},\"pembacaan_akhir\":{\"waktu\":\"2025-05-20 18:00:00\",\"volume\":652.07},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-28 08:04:04', '2025-05-28 08:04:05'),
(1291, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-21 08:00:00\",\"volume\":652.07},\"pembacaan_akhir\":{\"waktu\":\"2025-05-21 18:00:00\",\"volume\":652.07},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-28 08:04:04', '2025-05-28 08:04:05'),
(1292, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-22 08:00:00\",\"volume\":652.07},\"pembacaan_akhir\":{\"waktu\":\"2025-05-22 18:00:00\",\"volume\":652.07},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-05-28 08:04:04', '2025-05-28 08:04:05'),
(1293, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-23 08:00:00\",\"volume\":652.07},\"pembacaan_akhir\":{\"waktu\":\"2025-05-23 18:00:00\",\"volume\":731.01},\"volume_flow_meter\":78.93999999999994}', 933955.83, 'belum_lunas', '2025-05-28 08:04:04', '2025-05-28 08:04:04'),
(1294, 1, 'Test User', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-24 08:00:00\",\"volume\":731.01},\"pembacaan_akhir\":{\"waktu\":\"2025-05-24 18:00:00\",\"volume\":735.65},\"volume_flow_meter\":4.639999999999986}', 54896.82, 'belum_lunas', '2025-05-28 08:04:05', '2025-05-28 08:04:05'),
(1295, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-02 06:00:00\",\"volume\":92135.24},\"pembacaan_akhir\":{\"waktu\":\"2025-05-02 21:00:00\",\"volume\":92385.7},\"volume_flow_meter\":250.45999999999185}', 7673730.51, 'belum_lunas', '2025-06-03 23:01:18', '2025-06-03 23:01:18'),
(1296, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-03 06:00:00\",\"volume\":92385.7},\"pembacaan_akhir\":{\"waktu\":\"2025-05-03 21:00:00\",\"volume\":92652.12},\"volume_flow_meter\":266.41999999999825}', 8162721.72, 'belum_lunas', '2025-06-03 23:01:19', '2025-06-03 23:01:19'),
(1297, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-05 06:00:00\",\"volume\":92652.12},\"pembacaan_akhir\":{\"waktu\":\"2025-05-05 20:30:00\",\"volume\":92878.51},\"volume_flow_meter\":226.38999999999942}', 6936260.68, 'belum_lunas', '2025-06-03 23:01:19', '2025-06-03 23:01:19'),
(1298, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-06 06:00:00\",\"volume\":92878.51},\"pembacaan_akhir\":{\"waktu\":\"2025-05-07 06:00:00\",\"volume\":93286.53},\"volume_flow_meter\":408.0200000000041}', 12501140.00, 'belum_lunas', '2025-06-03 23:01:20', '2025-06-03 23:01:27'),
(1299, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-07 06:00:00\",\"volume\":93286.53},\"pembacaan_akhir\":{\"waktu\":\"2025-05-08 06:00:00\",\"volume\":93699.68},\"volume_flow_meter\":413.1499999999942}', 12658315.74, 'belum_lunas', '2025-06-03 23:01:20', '2025-06-03 23:01:20'),
(1300, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-08 06:00:00\",\"volume\":93699.68},\"pembacaan_akhir\":{\"waktu\":\"2025-05-09 05:30:00\",\"volume\":94100.04},\"volume_flow_meter\":400.3600000000006}', 12266448.72, 'belum_lunas', '2025-06-03 23:01:20', '2025-06-03 23:01:20'),
(1301, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-09 06:00:00\",\"volume\":94100.04},\"pembacaan_akhir\":{\"waktu\":\"2025-05-10 06:00:00\",\"volume\":94528.62},\"volume_flow_meter\":428.58000000000175}', 13131068.52, 'belum_lunas', '2025-06-03 23:01:20', '2025-06-03 23:01:20'),
(1302, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-10 06:00:00\",\"volume\":94528.62},\"pembacaan_akhir\":{\"waktu\":\"2025-05-11 05:00:00\",\"volume\":94841.75},\"volume_flow_meter\":313.13000000000466}', 9593848.26, 'belum_lunas', '2025-06-03 23:01:20', '2025-06-03 23:01:20'),
(1303, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-11 05:00:00\",\"volume\":94841.75},\"pembacaan_akhir\":{\"waktu\":\"2025-05-12 05:00:00\",\"volume\":94841.75},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-06-03 23:01:21', '2025-06-03 23:01:27'),
(1304, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-12 05:00:00\",\"volume\":94841.75},\"pembacaan_akhir\":{\"waktu\":\"2025-05-13 09:00:00\",\"volume\":94865.27},\"volume_flow_meter\":23.520000000004075}', 720618.63, 'belum_lunas', '2025-06-03 23:01:21', '2025-06-03 23:01:21'),
(1305, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-13 09:00:00\",\"volume\":94865.27},\"pembacaan_akhir\":{\"waktu\":\"2025-05-14 06:00:00\",\"volume\":95262.22},\"volume_flow_meter\":396.9499999999971}', 12161971.28, 'belum_lunas', '2025-06-03 23:01:21', '2025-06-03 23:01:21'),
(1306, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-14 06:00:00\",\"volume\":95262.22},\"pembacaan_akhir\":{\"waktu\":\"2025-05-15 06:00:00\",\"volume\":95704.4},\"volume_flow_meter\":442.179999999993}', 13547752.77, 'belum_lunas', '2025-06-03 23:01:22', '2025-06-03 23:01:22'),
(1307, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-15 06:00:00\",\"volume\":95704.4},\"pembacaan_akhir\":{\"waktu\":\"2025-05-16 06:00:00\",\"volume\":96090.84},\"volume_flow_meter\":386.4400000000023}', 11839960.15, 'belum_lunas', '2025-06-03 23:01:22', '2025-06-03 23:01:22'),
(1308, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-16 06:00:00\",\"volume\":96090.84},\"pembacaan_akhir\":{\"waktu\":\"2025-05-17 06:00:00\",\"volume\":96374.12},\"volume_flow_meter\":283.27999999999884}', 8679287.63, 'belum_lunas', '2025-06-03 23:01:22', '2025-06-03 23:01:22'),
(1309, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-17 06:00:00\",\"volume\":96374.12},\"pembacaan_akhir\":{\"waktu\":\"2025-05-18 06:00:00\",\"volume\":96433.04},\"volume_flow_meter\":58.919999999998254}', 1805223.20, 'belum_lunas', '2025-06-03 23:01:23', '2025-06-03 23:01:27'),
(1310, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-18 06:00:00\",\"volume\":96433.04},\"pembacaan_akhir\":{\"waktu\":\"2025-05-18 18:00:00\",\"volume\":96433.04},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-06-03 23:01:23', '2025-06-03 23:01:27'),
(1311, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-19 06:00:00\",\"volume\":96433.04},\"pembacaan_akhir\":{\"waktu\":\"2025-05-19 18:00:00\",\"volume\":96500.09},\"volume_flow_meter\":67.05000000000291}', 2054314.58, 'belum_lunas', '2025-06-03 23:01:23', '2025-06-03 23:01:23'),
(1312, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-20 06:00:00\",\"volume\":96500.09},\"pembacaan_akhir\":{\"waktu\":\"2025-05-21 06:00:00\",\"volume\":96922.39},\"volume_flow_meter\":422.3000000000029}', 12938658.45, 'belum_lunas', '2025-06-03 23:01:24', '2025-06-03 23:01:24'),
(1313, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-21 06:00:00\",\"volume\":96922.39},\"pembacaan_akhir\":{\"waktu\":\"2025-05-22 06:00:00\",\"volume\":97428.55},\"volume_flow_meter\":506.1600000000035}', 15508007.01, 'belum_lunas', '2025-06-03 23:01:24', '2025-06-03 23:01:24'),
(1314, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-22 06:00:00\",\"volume\":97428.55},\"pembacaan_akhir\":{\"waktu\":\"2025-05-23 06:00:00\",\"volume\":97891.02},\"volume_flow_meter\":462.47000000000116}', 14169408.89, 'belum_lunas', '2025-06-03 23:01:25', '2025-06-03 23:01:25'),
(1315, 19, 'test baru', '{\"pembacaan_awal\":{\"waktu\":\"2025-05-23 06:00:00\",\"volume\":97891.02},\"pembacaan_akhir\":{\"waktu\":\"2025-05-24 07:00:00\",\"volume\":98279.22},\"volume_flow_meter\":388.1999999999971}', 11893883.99, 'belum_lunas', '2025-06-03 23:01:25', '2025-06-03 23:01:25');

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

--
-- Dumping data for table `financial_accounts`
--

INSERT INTO `financial_accounts` (`id`, `account_code`, `account_name`, `description`, `account_type`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'KAS001', 'Kas Operasional', 'Kas untuk kegiatan operasional sehari-hari', 'kas', 1, '2025-04-26 00:28:29', '2025-04-26 00:28:29'),
(2, 'KAS002', 'Kas Kecil', 'Kas untuk pengeluaran kecil', 'kas', 1, '2025-04-26 00:28:29', '2025-04-26 00:28:29'),
(3, 'BNK001', 'Bank BCA', 'Rekening Bank BCA', 'bank', 1, '2025-04-26 00:28:29', '2025-04-26 00:28:29'),
(4, 'BNK002', 'Bank Mandiri', 'Rekening Bank Mandiri', 'bank', 1, '2025-04-26 00:28:29', '2025-04-26 00:28:29');

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `id_pelanggan` varchar(15) NOT NULL,
  `invoice_number` varchar(255) NOT NULL,
  `invoice_date` date NOT NULL,
  `due_date` date NOT NULL,
  `total_amount` decimal(20,2) NOT NULL,
  `no_kontrak` varchar(255) NOT NULL,
  `status` enum('paid','unpaid','partial','cancelled') NOT NULL DEFAULT 'unpaid',
  `description` text DEFAULT NULL,
  `period_month` int(11) NOT NULL,
  `period_year` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `customer_id`, `id_pelanggan`, `invoice_number`, `invoice_date`, `due_date`, `total_amount`, `no_kontrak`, `status`, `description`, `period_month`, `period_year`, `created_at`, `updated_at`) VALUES
(4, 5, '03C0005', '003/MPS/INV-APA/04/2025', '2025-04-12', '2025-04-22', 1667019484724.90, '001/PJBG-MPS/I/2025', 'paid', NULL, 4, 2025, '2025-04-11 22:14:22', '2025-04-12 20:23:08'),
(6, 14, '03C0014', '002/MPS/INV-PT MELODI SNACK INDONESIA/04/2025', '2025-04-13', '2025-04-23', 0.00, '001/PJBG-MPS/I/2025', 'unpaid', 'dd', 4, 2025, '2025-04-12 21:19:44', '2025-04-12 21:19:44'),
(7, 14, '03C0014', '003/MPS/INV-PT MELODI SNACK INDONESIA/04/2025', '2025-04-13', '2025-04-23', 0.00, '001/PJBG-MPS/I/2025', 'unpaid', 'Pemakaian CNG', 4, 2025, '2025-04-12 21:22:08', '2025-04-12 21:22:08');

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

--
-- Dumping data for table `kas_transactions`
--

INSERT INTO `kas_transactions` (`id`, `voucher_number`, `account_id`, `transaction_date`, `description`, `credit`, `debit`, `balance`, `year`, `month`, `created_at`, `updated_at`) VALUES
(1, 'KAS0001', 1, '2025-04-01', 'Saldo Awal', 5000000.00, 0.00, 5000000.00, 2025, 4, '2025-04-26 00:28:29', '2025-04-26 00:28:29'),
(3, 'KAS0003', 1, '2025-04-10', 'Penerimaan Kas', 1000000.00, 0.00, 6000000.00, 2025, 4, '2025-04-26 00:28:29', '2025-04-26 05:23:44'),
(5, 'KAS0005', 2, '2025-04-20', 'Pembelian Konsumsi Rapat', 0.00, 150000.00, 5850000.00, 2025, 4, '2025-04-26 00:28:29', '2025-04-26 05:23:44');

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

--
-- Dumping data for table `konfigurasi_lembur`
--

INSERT INTO `konfigurasi_lembur` (`id`, `nama_konfigurasi`, `tarif_per_jam`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Tarif Lembur Standar', 25000.00, 1, '2025-04-24 09:37:49', '2025-04-24 09:37:49');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_03_09_064403_create_data_pencatatans_table', 1),
(5, '2025_03_09_083436_create_sessions_table', 1),
(6, '2025_03_10_080627_add_pricing_columns_to_users_table', 1),
(7, '2025_03_12_050632_deposit', 1),
(8, '2025_03_17_070714_pricing_history', 2),
(9, '2025_03_27_100000_add_fob_role_to_users_table', 3),
(10, '2025_03_28_create_rekap_pengambilan_table', 4),
(11, '2025_04_07_create_nomor_polisi_table', 5),
(12, '2023_05_20_000001_create_invoices_table', 6),
(13, '2023_05_20_000002_create_billings_table', 6);

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
  `status` enum('milik','sewa','disewakan') DEFAULT NULL,
  `iso` enum('ISO - 11439','ISO - 11119') DEFAULT NULL,
  `coi` enum('sudah','belum') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nomor_polisi`
--

INSERT INTO `nomor_polisi` (`id`, `nopol`, `keterangan`, `jenis`, `ukuran_id`, `area_operasi`, `no_gtm`, `status`, `iso`, `coi`, `created_at`, `updated_at`) VALUES
(1, 'B9037SAN', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-07 04:03:27', '2025-04-28 20:48:07'),
(3, 'B9037CCC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-07 19:39:05', '2025-04-28 20:47:36'),
(4, 'B9038BB', NULL, 'ppp', 1, NULL, 'MPS002', 'milik', 'ISO - 11119', 'sudah', '2025-04-07 19:51:57', '2025-04-29 00:50:20'),
(5, 'fewf23', NULL, 'ppp', 1, NULL, 'MPS001', 'milik', 'ISO - 11119', 'belum', '2025-04-29 00:49:38', '2025-04-29 00:50:05'),
(6, 'kjij', NULL, 'ihiy', 2, NULL, NULL, 'sewa', 'ISO - 11119', 'belum', '2025-04-29 00:55:12', '2025-04-29 00:55:12'),
(7, 'edasd', 'dwd', 'saw', 2, 'sffsfs', 'MPS003', 'milik', 'ISO - 11439', 'belum', '2025-04-29 01:09:52', '2025-04-29 01:09:52'),
(8, 'aaaa', 'aaa', 'aaaa', 3, 'aaaa', 'MPS004', 'milik', 'ISO - 11439', 'sudah', '2025-04-29 02:00:31', '2025-04-29 02:00:31');

-- --------------------------------------------------------

--
-- Table structure for table `operator_gtm`
--

CREATE TABLE `operator_gtm` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `gaji_pokok` int(255) NOT NULL,
  `tanggal_bergabung` date DEFAULT NULL,
  `lokasi_kerja` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `operator_gtm`
--

INSERT INTO `operator_gtm` (`id`, `nama`, `gaji_pokok`, `tanggal_bergabung`, `lokasi_kerja`, `created_at`, `updated_at`) VALUES
(2, 'Bagus Arif', 3500000, '2025-03-01', 'tangerang', '2025-04-24 03:01:20', '2025-05-09 09:12:52');

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

--
-- Dumping data for table `operator_gtm_lembur`
--

INSERT INTO `operator_gtm_lembur` (`id`, `operator_gtm_id`, `tanggal`, `jam_masuk_sesi_1`, `jam_keluar_sesi_1`, `jam_masuk_sesi_2`, `jam_keluar_sesi_2`, `jam_masuk_sesi_3`, `jam_keluar_sesi_3`, `total_jam_kerja`, `total_jam_lembur`, `upah_lembur`, `created_at`, `updated_at`) VALUES
(7, 2, '2025-04-26', '23:00:00', '08:00:00', NULL, NULL, NULL, NULL, 540, 60, 25000.00, '2025-05-09 00:20:09', '2025-05-09 00:20:09'),
(8, 2, '2025-04-26', '23:00:00', '12:00:00', NULL, NULL, NULL, NULL, 780, 300, 125000.00, '2025-05-09 01:30:23', '2025-05-09 01:30:23'),
(9, 2, '2025-05-01', '12:00:00', '23:00:00', NULL, NULL, NULL, NULL, 660, 180, 75000.00, '2025-05-09 01:31:05', '2025-05-09 01:31:05'),
(10, 2, '2025-05-13', '23:12:00', '12:12:00', NULL, NULL, NULL, NULL, 780, 300, 125000.00, '2025-05-09 09:02:43', '2025-05-09 09:02:43'),
(11, 2, '2025-03-28', '12:21:00', '22:23:00', NULL, NULL, NULL, NULL, 602, 122, 50833.33, '2025-05-09 09:14:56', '2025-05-09 09:14:56');

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
  `alamat_pengambilan` text DEFAULT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rekap_pengambilan`
--

INSERT INTO `rekap_pengambilan` (`id`, `tanggal`, `customer_id`, `nopol`, `volume`, `alamat_pengambilan`, `keterangan`, `created_at`, `updated_at`) VALUES
(1, '2025-04-07 00:00:00', 18, 'B9037SAN', 200.00, NULL, NULL, '2025-04-06 20:18:23', '2025-04-06 20:18:23'),
(2, '2025-03-07 00:00:00', 17, 'B9037SAN', 300.00, NULL, NULL, '2025-04-06 20:19:22', '2025-04-06 20:19:22'),
(3, '2025-04-03 00:00:00', 18, 'B9037SAN', 400.00, NULL, NULL, '2025-04-06 20:32:54', '2025-04-06 20:32:54'),
(4, '2025-04-08 03:02:00', 17, 'B9038BB', 600.00, NULL, NULL, '2025-04-07 20:02:39', '2025-04-07 20:02:39'),
(5, '2025-04-08 03:16:00', 14, 'B9038BB', 500.00, NULL, NULL, '2025-04-07 20:16:58', '2025-04-19 20:37:27'),
(6, '2025-04-22 04:21:00', 17, 'B9037CCC', 600.00, 'Jl.marunda baru', NULL, '2025-04-21 21:22:04', '2025-04-21 21:22:04'),
(7, '2025-04-29 14:29:00', 5, 'B9037SAN', 21212.00, 'sdsd', 'asdasd', '2025-04-29 07:29:27', '2025-04-29 07:29:27'),
(11, '2025-05-08 03:48:00', 5, 'B9037CCC', 3333.00, NULL, NULL, '2025-05-07 20:48:48', '2025-05-07 20:48:48'),
(12, '2025-05-08 04:42:00', 17, 'B9037CCC', 600.00, NULL, NULL, '2025-05-07 21:43:01', '2025-05-07 21:43:01'),
(15, '2025-05-09 03:07:00', 18, 'B9037CCC', 3330.00, NULL, NULL, '2025-05-08 20:08:02', '2025-05-08 20:08:02'),
(16, '2024-02-09 03:18:00', 22, 'B9037SAN', 324.00, 'wd', NULL, '2025-05-08 20:18:50', '2025-05-08 20:18:50'),
(17, '2025-05-09 05:50:00', 17, 'B9037CCC', 223.00, '23dsdsd', NULL, '2025-05-08 22:50:47', '2025-05-08 22:50:47'),
(18, '2025-05-07 06:12:00', 17, 'B9037CCC', 2323.00, NULL, NULL, '2025-05-08 23:12:57', '2025-05-08 23:12:57'),
(19, '2025-05-10 06:13:00', 17, 'B9037CCC', 2323.00, 'dadd', NULL, '2025-05-08 23:13:21', '2025-05-08 23:13:21'),
(20, '2025-05-27 08:15:00', 17, 'B9037SAN', 4000.00, 'asdasd', NULL, '2025-05-27 01:15:56', '2025-05-27 01:15:56');

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

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('7vNJHkZ4O0GH9PuoqxrCJ0OC00KP6ZRh9iX5LjZY', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiZ3g0NzBXS2k2OFNQQkNpUnV1SmsxSmFZRGlqZUhTTkNQeWhvaUZ5eiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozNDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL25vbW9yLXBvbGlzaSI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjM5OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvcmVrYXAtcGVuZ2FtYmlsYW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=', 1745937331),
('o7NK5OAL4J1X034Z5XMuX0pXu1O692Ia8pFNR1PY', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUlhsN0NRZUlqSFh3eHRoZnV5cDV3Wkl5TVRXMEVJbVk0bVJGNkxFbyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1746371275),
('vgkE9V7mNiumThnuqAUJUSGCBDmlx1JVVZGcY615', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZXVENDdtYkZRa2RWTHpkNEVlSGdwUDBJUktVcDhoeE5MMnNReElvbSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9ub21vci1wb2xpc2kiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=', 1745917231);

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

--
-- Dumping data for table `transaction_descriptions`
--

INSERT INTO `transaction_descriptions` (`id`, `description`, `is_active`, `category`, `created_at`, `updated_at`) VALUES
(1, 'Pembayaran Gaji Karyawan', 1, 'both', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(2, 'Pembayaran Listrik', 1, 'both', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(3, 'Pembayaran Air', 1, 'both', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(4, 'Pembayaran Internet', 1, 'both', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(5, 'Pembayaran Sewa Kantor', 1, 'both', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(6, 'Penerimaan Pembayaran Invoice', 1, 'both', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(7, 'Setoran Kas ke Bank', 1, 'both', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(8, 'Penarikan Kas dari Bank', 1, 'both', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(9, 'Pembelian ATK', 1, 'kas', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(10, 'Biaya Transportasi', 1, 'kas', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(12, 'Transfer Antar Bank', 1, 'bank', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(13, 'Biaya Admin Bank', 1, 'bank', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(14, 'Penerimaan Bunga Bank', 1, 'bank', '2025-04-26 12:47:05', '2025-04-26 12:47:05'),
(15, 'bensin', 1, 'kas', '2025-04-26 05:47:26', '2025-04-26 05:47:26');

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

--
-- Dumping data for table `ukuran`
--

INSERT INTO `ukuran` (`id`, `nama_ukuran`, `created_at`, `updated_at`) VALUES
(1, '22', '2025-04-29 00:49:38', '2025-04-29 00:49:38'),
(2, '44', '2025-04-29 00:55:12', '2025-04-29 00:55:12'),
(3, '111', '2025-04-29 02:00:31', '2025-04-29 02:00:31');

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
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','superadmin','customer','fob','demo') DEFAULT 'customer',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `harga_per_meter_kubik` decimal(10,2) DEFAULT 0.00 COMMENT 'Harga per meter kubik',
  `tekanan_keluar` decimal(10,3) DEFAULT NULL COMMENT 'Tekanan keluar dalam Bar',
  `suhu` decimal(10,2) DEFAULT NULL COMMENT 'Suhu dalam Celsius',
  `koreksi_meter` decimal(16,14) DEFAULT NULL COMMENT 'Faktor koreksi meter'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `total_deposit`, `total_purchases`, `deposit_history`, `monthly_balances`, `pricing_history`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`, `harga_per_meter_kubik`, `tekanan_keluar`, `suhu`, `koreksi_meter`) VALUES
(1, 'Test User', 'test@example.com', 0.00, 487219845.33, NULL, '{\"2025-03\":-382388924.7,\"2025-04\":-486230992.58,\"2025-05\":-487219845.23,\"2024-03\":0,\"2024-04\":0,\"2024-05\":-283761542.32,\"2024-06\":-283761542.32,\"2024-07\":-283761542.32,\"2024-08\":-382388924.7,\"2024-09\":-382388924.7,\"2024-10\":-382388924.7,\"2024-11\":-382388924.7,\"2024-12\":-382388924.7,\"2025-01\":-382388924.7,\"2025-02\":-382388924.7,\"2025-10\":-487219845.23,\"2021-05\":0,\"2021-06\":0,\"2021-07\":0,\"2021-08\":0,\"2021-09\":0,\"2021-10\":0,\"2021-11\":0,\"2021-12\":0,\"2022-01\":0,\"2022-02\":0,\"2022-03\":0,\"2022-04\":0,\"2022-05\":0,\"2022-06\":0,\"2022-07\":0,\"2022-08\":0,\"2022-09\":0,\"2022-10\":0,\"2022-11\":0,\"2022-12\":0,\"2023-01\":0,\"2023-02\":0,\"2023-03\":0,\"2023-04\":0,\"2023-05\":0,\"2023-06\":0,\"2023-07\":0,\"2023-08\":0,\"2023-09\":0,\"2023-10\":0,\"2023-11\":0,\"2023-12\":0,\"2024-01\":0,\"2024-02\":0,\"2025-06\":-487219845.23,\"2025-07\":-487219845.23,\"2025-08\":-487219845.23,\"2025-09\":-487219845.23,\"2025-11\":-487219845.23,\"2025-12\":-487219845.23,\"2026-01\":-487219845.23,\"2026-02\":-487219845.23,\"2026-03\":-487219845.23,\"2026-04\":-487219845.23,\"2026-05\":-487219845.23,\"2026-06\":-487219845.33}', '[{\"date\":\"2025-04-01 00:00:00\",\"year_month\":\"2025-04\",\"harga_per_meter_kubik\":2900,\"tekanan_keluar\":3,\"suhu\":20,\"koreksi_meter\":4.07972807},{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":2900,\"tekanan_keluar\":2,\"suhu\":20,\"koreksi_meter\":3.05707364},{\"type\":\"custom_period\",\"start_date\":\"2024-05-10 00:00:00\",\"end_date\":\"2025-05-13 23:59:59\",\"harga_per_meter_kubik\":2900,\"tekanan_keluar\":1,\"suhu\":20,\"koreksi_meter\":2.03846121}]', '2025-03-12 06:30:45', '$2y$12$zPctpAp8xDCPMMNYhExG.OJlrm/v1OuAY.Gp5VhKVDr3yII3VvCFK', 'customer', 'OP9VPDuO2P', '2025-03-12 06:30:45', '2025-06-03 22:37:06', 2900.00, 3.000, 20.00, 4.07972807400910),
(2, 'Super Administrator', 'superadmin@example.com', 0.00, 0.00, NULL, NULL, NULL, NULL, '$2y$12$i9AfftwMoerCSLwsqKCGiea4KS0ZcbwaumTvsFnWGsLu2h.k32VPy', 'superadmin', NULL, '2025-03-12 06:30:45', '2025-03-12 06:30:45', 0.00, 0.000, 0.00, 1.00000000000000),
(3, 'Administrator', 'admin@example.com', 0.00, 0.00, NULL, NULL, NULL, NULL, '$2y$12$H0GcLLTZK6Eu0FWMmOdTo.utnOZH/Cu2GSVvriYK8CsorC54vlmuG', 'admin', NULL, '2025-03-12 06:30:46', '2025-03-12 06:30:46', 0.00, 0.000, 0.00, 1.00000000000000),
(4, 'Customer 1', 'customer1@example.com', 0.00, 4986828173.53, NULL, '{\"2024-03\":0,\"2024-04\":0,\"2024-05\":-20504403.2559167,\"2024-06\":-65042468.26162814,\"2024-07\":-283831434.18127245,\"2024-08\":-956109876.8383412,\"2024-09\":-956109876.8383412,\"2024-10\":-956109876.8383412,\"2024-11\":-956109876.8383412,\"2024-12\":-956109876.8383412,\"2025-01\":-956109876.8383412,\"2025-02\":-956109876.8383412,\"2025-03\":-957007417.0183412,\"2025-04\":-957007417.0183412,\"2025-05\":-4986828173.5383415}', '[{\"date\":\"2024-08-01 00:00:00\",\"year_month\":\"2024-08\",\"harga_per_meter_kubik\":9300,\"tekanan_keluar\":2,\"suhu\":30,\"koreksi_meter\":2.95618012},{\"date\":\"2024-07-01 00:00:00\",\"year_month\":\"2024-07\",\"harga_per_meter_kubik\":9300,\"tekanan_keluar\":2,\"suhu\":30,\"koreksi_meter\":2.95618012},{\"date\":\"2025-05-01 00:00:00\",\"year_month\":\"2025-05\",\"harga_per_meter_kubik\":1000,\"tekanan_keluar\":3,\"suhu\":20,\"koreksi_meter\":4.07972807},{\"date\":\"2024-05-01 00:00:00\",\"year_month\":\"2024-05\",\"harga_per_meter_kubik\":1000,\"tekanan_keluar\":3,\"suhu\":20,\"koreksi_meter\":4.07972807},{\"type\":\"custom_period\",\"start_date\":\"2024-05-10 00:00:00\",\"end_date\":\"2024-05-14 23:59:59\",\"harga_per_meter_kubik\":3000,\"tekanan_keluar\":2,\"suhu\":20,\"koreksi_meter\":3.05707364}]', NULL, '$2y$12$C8A8CF1j..AAXPPUI/yOyOUKTJGMTn.RTCijSxgGvlh9b6qnTyf4m', 'customer', NULL, '2025-03-12 06:30:46', '2025-05-17 20:28:44', 1000.00, 3.000, 20.00, 4.07972807400910),
(5, 'Customer3', 'customer3@example.com', 94152715.31, 2108209196595.90, '[{\"date\":\"2025-03-05 14:04:00\",\"amount\":71930493.31,\"description\":null},{\"date\":\"2025-03-18 07:05:00\",\"amount\":22222222,\"description\":null}]', '{\"2025-03\":-441095559155.6103,\"2025-04\":-2108115043880.547,\"2025-05\":-2108115043880.547,\"2024-03\":0,\"2024-04\":0,\"2024-05\":-176799390.24236608,\"2024-06\":-176799390.24236608,\"2024-07\":-468777795.67758244,\"2024-08\":-468777795.67758244,\"2024-09\":-468777795.67758244,\"2024-10\":-468777795.67758244,\"2024-11\":-468777795.67758244,\"2024-12\":-468777795.67758244,\"2025-01\":-468777795.67758244,\"2025-02\":-468777795.67758244}', '[{\"date\":\"2025-01-01 00:00:00\",\"year_month\":\"2025-01\",\"harga_per_meter_kubik\":9300,\"tekanan_keluar\":1,\"suhu\":30,\"koreksi_meter\":1.97118526},{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":9300,\"tekanan_keluar\":3,\"suhu\":30,\"koreksi_meter\":3.94508358}]', NULL, '$2y$12$ven/iFTUTcgfhbs.y4LeSOrcyPJsHbx03a0KTZgh/0DvQ.qKGT/Ve', 'customer', NULL, '2025-03-12 06:30:46', '2025-05-06 06:20:04', 9300.00, 3.000, 30.00, 3.94508358311770),
(14, 'PT Melodi Snack Indonesia', 'melodi@mps.com', 225614233.00, 24456601.35, '[{\"date\":\"2025-04-15 04:03:00\",\"amount\":23123123,\"description\":null},{\"date\":\"2025-04-15 04:11:00\",\"amount\":22223,\"description\":null},{\"date\":\"2025-04-15 04:11:00\",\"amount\":1111,\"description\":null},{\"date\":\"2025-02-14 04:11:00\",\"amount\":333333,\"description\":null},{\"date\":\"2025-02-01 04:24:00\",\"amount\":2134443,\"description\":null},{\"date\":\"2025-04-01 04:24:00\",\"amount\":100000000,\"description\":null},{\"date\":\"2025-01-01 04:41:00\",\"amount\":100000000,\"description\":null}]', '{\"2025-02\":101110423.08,\"2025-03\":80047179.58,\"2025-04\":203193636.58,\"2025-05\":203193636.58,\"2024-11\":-1357352.92,\"2024-12\":-1357352.92,\"2025-01\":98642647.08,\"2021-05\":0,\"2021-06\":0,\"2021-07\":0,\"2021-08\":0,\"2021-09\":0,\"2021-10\":0,\"2021-11\":0,\"2021-12\":0,\"2022-01\":0,\"2022-02\":0,\"2022-03\":0,\"2022-04\":0,\"2022-05\":0,\"2022-06\":0,\"2022-07\":0,\"2022-08\":0,\"2022-09\":0,\"2022-10\":0,\"2022-11\":0,\"2022-12\":0,\"2023-01\":0,\"2023-02\":0,\"2023-03\":0,\"2023-04\":0,\"2023-05\":0,\"2023-06\":0,\"2023-07\":0,\"2023-08\":0,\"2023-09\":0,\"2023-10\":0,\"2023-11\":0,\"2023-12\":0,\"2024-01\":0,\"2024-02\":0,\"2024-03\":0,\"2024-04\":0,\"2024-05\":0,\"2024-06\":0,\"2024-07\":0,\"2024-08\":0,\"2024-09\":0,\"2024-10\":0,\"2025-06\":203193636.58,\"2025-07\":203193636.58,\"2025-08\":203193636.58,\"2025-09\":203193636.58,\"2025-10\":203193636.58,\"2025-11\":203193636.58,\"2025-12\":203193636.58,\"2026-01\":203193636.58,\"2026-02\":203193636.58,\"2026-03\":203193636.58,\"2026-04\":203193636.58,\"2026-05\":203193636.58,\"2026-06\":201157631.65}', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":4000,\"tekanan_keluar\":2,\"suhu\":20,\"koreksi_meter\":3.05707364},{\"date\":\"2025-02-01 00:00:00\",\"year_month\":\"2025-02\",\"harga_per_meter_kubik\":3000,\"tekanan_keluar\":2,\"suhu\":20,\"koreksi_meter\":3.05707364}]', NULL, '$2y$12$7fQrcXCq3wf9GVQ7IdSCJORsiduA5dfVLJO3wEkau1B5JryF6g6lm', 'customer', NULL, '2025-03-18 00:13:24', '2025-06-03 22:36:31', 4000.00, 2.000, 20.00, 3.05707363778060),
(16, 'Demo User', 'demo@example.com', 5000000.00, 6046650.00, '\"[{\\\"date\\\":\\\"2025-03-27 04:22:37\\\",\\\"amount\\\":5000000,\\\"description\\\":\\\"Initial deposit for demo account\\\"}]\"', NULL, '\"[{\\\"date\\\":\\\"2025-03-27 04:22:37\\\",\\\"year_month\\\":\\\"2025-03\\\",\\\"harga_per_meter_kubik\\\":5000,\\\"tekanan_keluar\\\":3,\\\"suhu\\\":25,\\\"koreksi_meter\\\":4.0311}]\"', NULL, '$2y$12$1.G.eocg64t3xRDrVcJrC.93DdSjwaoVyIz4YMCsx5Yvbmodd9UF.', 'demo', NULL, '2025-03-26 21:22:37', '2025-03-26 21:44:12', 5000.00, 3.000, 25.00, 4.03110000000000),
(17, 'test fob', 'testfob@example.com', 49357247.00, 6311795.00, '[{\"date\":\"2025-03-27 09:32:00\",\"amount\":2222,\"description\":null},{\"date\":\"2025-04-18 07:10:00\",\"amount\":123123,\"description\":null},{\"date\":\"2025-05-09 09:39:00\",\"amount\":12344123,\"description\":null},{\"date\":\"2025-03-14 09:51:00\",\"amount\":2342344,\"description\":null},{\"date\":\"2025-02-18 09:53:00\",\"amount\":23434324,\"description\":null},{\"date\":\"2025-05-27 08:16:00\",\"amount\":11111111,\"description\":null}]', '{\"2025-04\":24625513,\"2025-05\":43045452,\"2025-03\":25168390,\"2025-02\":23434324,\"2025-06\":43045452,\"2025-07\":43045452,\"2025-08\":43045452,\"2025-09\":43045452,\"2025-10\":43045452,\"2025-11\":43045452,\"2025-12\":43045452,\"2026-01\":43045452,\"2026-02\":43045452,\"2026-03\":43045452,\"2026-04\":43045452,\"2026-05\":43045452,\"2025-01\":0,\"2022-05\":0,\"2022-06\":0,\"2022-07\":0,\"2022-08\":0,\"2022-09\":0,\"2022-10\":0,\"2022-11\":0,\"2022-12\":0,\"2023-01\":0,\"2023-02\":0,\"2023-03\":0,\"2023-04\":0,\"2023-05\":0,\"2023-06\":0,\"2023-07\":0,\"2023-08\":0,\"2023-09\":0,\"2023-10\":0,\"2023-11\":0,\"2023-12\":0,\"2024-01\":0,\"2024-02\":0,\"2024-03\":0,\"2024-04\":0,\"2024-05\":0,\"2024-06\":0,\"2024-07\":0,\"2024-08\":0,\"2024-09\":0,\"2024-10\":0,\"2024-11\":0,\"2024-12\":0,\"2021-05\":0,\"2021-06\":0,\"2021-07\":0,\"2021-08\":0,\"2021-09\":0,\"2021-10\":0,\"2021-11\":0,\"2021-12\":0,\"2022-01\":0,\"2022-02\":0,\"2022-03\":0,\"2022-04\":0}', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":555},{\"date\":\"2025-05-01 00:00:00\",\"year_month\":\"2025-05\",\"harga_per_meter_kubik\":500}]', NULL, '$2y$12$IUiOTDwZpHr5S.eiTA25c.ZunCqUaf0sqYeuQBCWSOYxOPtFBVCkS', 'fob', NULL, '2025-03-26 23:22:32', '2025-05-27 01:16:48', 500.00, 8.000, 8.00, 9.64880317993000),
(18, 'test2', 'test2@example.com', 500000.00, 27780000.00, '[{\"date\":\"2025-03-28 02:19:00\",\"amount\":500000,\"description\":null}]', '{\"2025-02\":0,\"2025-03\":-3700000,\"2025-04\":-7300000,\"2025-05\":-27280000,\"2025-06\":-27280000,\"2025-07\":-27280000,\"2025-08\":-27280000,\"2025-09\":-27280000,\"2025-10\":-27280000,\"2025-11\":-27280000,\"2025-12\":-27280000,\"2026-01\":-27280000,\"2026-02\":-27280000,\"2026-03\":-27280000,\"2026-04\":-27280000,\"2026-05\":-27280000,\"2021-05\":0,\"2021-06\":0,\"2021-07\":0,\"2021-08\":0,\"2021-09\":0,\"2021-10\":0,\"2021-11\":0,\"2021-12\":0,\"2022-01\":0,\"2022-02\":0,\"2022-03\":0,\"2022-04\":0,\"2022-05\":0,\"2022-06\":0,\"2022-07\":0,\"2022-08\":0,\"2022-09\":0,\"2022-10\":0,\"2022-11\":0,\"2022-12\":0,\"2023-01\":0,\"2023-02\":0,\"2023-03\":0,\"2023-04\":0,\"2023-05\":0,\"2023-06\":0,\"2023-07\":0,\"2023-08\":0,\"2023-09\":0,\"2023-10\":0,\"2023-11\":0,\"2023-12\":0,\"2024-01\":0,\"2024-02\":0,\"2024-03\":0,\"2024-04\":0,\"2024-05\":0,\"2024-06\":0,\"2024-07\":0,\"2024-08\":0,\"2024-09\":0,\"2024-10\":0,\"2024-11\":0,\"2024-12\":0,\"2025-01\":0}', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":6000}]', NULL, '$2y$12$kGuFa6YsunaKfmBacspuA.VgsNFqpqFFZ5Qy3ASldbT.s2Se/H3hG', 'fob', NULL, '2025-03-27 00:16:44', '2025-05-26 23:57:22', 6000.00, 0.000, 0.00, 1.00000000000000),
(19, 'test baru', 'baru@mps.com', 0.00, 582774272.60, '\"[]\"', '{\"2025-03\":-391467797.14,\"2025-04\":-394531651.85,\"2025-05\":-582774272.58,\"2024-03\":0,\"2024-04\":0,\"2024-05\":-147641949.93,\"2024-06\":-147641949.93,\"2024-07\":-391467797.14,\"2024-08\":-391467797.14,\"2024-09\":-391467797.14,\"2024-10\":-391467797.14,\"2024-11\":-391467797.14,\"2024-12\":-391467797.14,\"2025-01\":-391467797.14,\"2025-02\":-391467797.14,\"2021-06\":0,\"2021-07\":0,\"2021-08\":0,\"2021-09\":0,\"2021-10\":0,\"2021-11\":0,\"2021-12\":0,\"2022-01\":0,\"2022-02\":0,\"2022-03\":0,\"2022-04\":0,\"2022-05\":0,\"2022-06\":0,\"2022-07\":0,\"2022-08\":0,\"2022-09\":0,\"2022-10\":0,\"2022-11\":0,\"2022-12\":0,\"2023-01\":0,\"2023-02\":0,\"2023-03\":0,\"2023-04\":0,\"2023-05\":0,\"2023-06\":0,\"2023-07\":0,\"2023-08\":0,\"2023-09\":0,\"2023-10\":0,\"2023-11\":0,\"2023-12\":0,\"2024-01\":0,\"2024-02\":0,\"2025-06\":-582774272.58,\"2025-07\":-582774272.58,\"2025-08\":-582774272.58,\"2025-09\":-582774272.58,\"2025-10\":-582774272.58,\"2025-11\":-582774272.58,\"2025-12\":-582774272.58,\"2026-01\":-582774272.58,\"2026-02\":-582774272.58,\"2026-03\":-582774272.58,\"2026-04\":-582774272.58,\"2026-05\":-582774272.58,\"2026-06\":-582774272.6}', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":3000,\"tekanan_keluar\":5,\"suhu\":30,\"koreksi_meter\":5.93461633},{\"date\":\"2025-04-01 00:00:00\",\"year_month\":\"2025-04\",\"harga_per_meter_kubik\":6000,\"tekanan_keluar\":4,\"suhu\":20,\"koreksi_meter\":5.10642452},{\"date\":\"2025-05-01 00:00:00\",\"year_month\":\"2025-05\",\"harga_per_meter_kubik\":6000,\"tekanan_keluar\":4,\"suhu\":20,\"koreksi_meter\":5.10642452}]', NULL, '$2y$12$/7bidFGPG.KP0lxL4vP3iuyAhm0AkC/4uQtc0NIMMgFLzak2unZVC', 'customer', NULL, '2025-04-19 21:27:05', '2025-06-03 23:01:27', 6000.00, 4.000, 20.00, 5.10642451679070),
(20, 'testing excel', 'excel@mps.com', 0.00, 55509823.47, '\"[]\"', '{\"2024-06\":-14731518.1686412,\"2024-07\":-14731518.1686412,\"2024-08\":-14731518.1686412,\"2024-09\":-14731518.1686412,\"2024-10\":-14731518.1686412,\"2024-11\":-14731518.1686412,\"2024-12\":-14731518.1686412,\"2025-01\":-14731518.1686412,\"2025-02\":-14731518.1686412,\"2025-03\":-14731518.1686412,\"2025-04\":-14731518.1686412,\"2025-05\":-14731518.1686412,\"2024-03\":0,\"2024-04\":0,\"2024-05\":-14731518.1686412}', '[{\"date\":\"2024-05-01 00:00:00\",\"year_month\":\"2024-05\",\"harga_per_meter_kubik\":1000,\"tekanan_keluar\":2,\"suhu\":20,\"koreksi_meter\":3.05707364},{\"type\":\"custom_period\",\"start_date\":\"2024-05-10 00:00:00\",\"end_date\":\"2025-05-14 23:59:59\",\"harga_per_meter_kubik\":2000,\"tekanan_keluar\":2,\"suhu\":20,\"koreksi_meter\":3.05707364}]', NULL, '$2y$12$BQsjayPnyHBWFYmaJ05l8e5CkZAWN.B7aaWJPyVobLhFjGSNLaPe2', 'customer', NULL, '2025-05-05 17:52:54', '2025-05-06 17:56:44', 0.00, NULL, NULL, 1.00000000000000),
(21, 'test fix', 'testfix@mps.com', 0.00, 19010687.11, '\"[]\"', '{\"2025-03\":-26881444.456597794,\"2025-04\":-26881444.456597794,\"2025-05\":-26881444.456597794,\"2024-04\":0,\"2024-05\":-26881444.456597794,\"2024-06\":-26881444.456597794,\"2024-07\":-26881444.456597794,\"2024-08\":-26881444.456597794,\"2024-09\":-26881444.456597794,\"2024-10\":-26881444.456597794,\"2024-11\":-26881444.456597794,\"2024-12\":-26881444.456597794,\"2025-01\":-26881444.456597794,\"2025-02\":-26881444.456597794}', '[{\"date\":\"2024-05-01 00:00:00\",\"year_month\":\"2024-05\",\"harga_per_meter_kubik\":1000,\"tekanan_keluar\":3,\"suhu\":30,\"koreksi_meter\":3.94508358},{\"type\":\"custom_period\",\"start_date\":\"2024-05-10 00:00:00\",\"end_date\":\"2024-05-14 23:59:59\",\"harga_per_meter_kubik\":5000,\"tekanan_keluar\":3,\"suhu\":30,\"koreksi_meter\":3.94508358}]', NULL, '$2y$12$Dw9tkN5K4PDwUB6R93L5BOhCIYrHNiwJZ6bWkVxcc40RMGEKCObEC', 'customer', NULL, '2025-05-06 21:06:15', '2025-05-06 23:06:23', 0.00, NULL, NULL, 1.00000000000000),
(22, 'baruu', 'asd@asd.com', 0.00, 2268000.00, NULL, '{\"2025-04\":-2268000,\"2025-05\":-2268000,\"2024-01\":0,\"2024-02\":-2268000,\"2024-03\":-2268000,\"2024-04\":-2268000,\"2024-05\":-2268000,\"2024-06\":-2268000,\"2024-07\":-2268000,\"2024-08\":-2268000,\"2024-09\":-2268000,\"2024-10\":-2268000,\"2024-11\":-2268000,\"2024-12\":-2268000,\"2025-01\":-2268000,\"2025-02\":-2268000,\"2025-03\":-2268000,\"2025-06\":-2268000,\"2025-07\":-2268000,\"2025-08\":-2268000,\"2025-09\":-2268000,\"2025-10\":-2268000,\"2025-11\":-2268000,\"2025-12\":-2268000,\"2026-01\":-2268000,\"2026-02\":-2268000,\"2026-03\":-2268000,\"2026-04\":-2268000,\"2026-05\":-2268000}', '[{\"date\":\"2024-02-01 00:00:00\",\"year_month\":\"2024-02\",\"harga_per_meter_kubik\":7000}]', NULL, '$2y$12$zF/qWEJdS4PT2PovPHE2yO9eQQzQEAOKW3j02YWlrrbxFDvMEfEtu', 'fob', NULL, '2025-05-08 20:18:20', '2025-05-18 02:26:48', 0.00, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

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
  ADD KEY `billings_customer_id_foreign` (`customer_id`);

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
  ADD KEY `invoices_customer_id_foreign` (`customer_id`);

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
-- Indexes for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rekap_pengambilan_customer_id_foreign` (`customer_id`),
  ADD KEY `rekap_pengambilan_nopol_foreign` (`nopol`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

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
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bank_transactions`
--
ALTER TABLE `bank_transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `billings`
--
ALTER TABLE `billings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `data_pencatatan`
--
ALTER TABLE `data_pencatatan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1316;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `financial_accounts`
--
ALTER TABLE `financial_accounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kas_transactions`
--
ALTER TABLE `kas_transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `konfigurasi_lembur`
--
ALTER TABLE `konfigurasi_lembur`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `nomor_polisi`
--
ALTER TABLE `nomor_polisi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `operator_gtm`
--
ALTER TABLE `operator_gtm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `operator_gtm_lembur`
--
ALTER TABLE `operator_gtm_lembur`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `transaction_descriptions`
--
ALTER TABLE `transaction_descriptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `ukuran`
--
ALTER TABLE `ukuran`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

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
  ADD CONSTRAINT `billings_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `data_pencatatan`
--
ALTER TABLE `data_pencatatan`
  ADD CONSTRAINT `data_pencatatan_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `kas_transactions`
--
ALTER TABLE `kas_transactions`
  ADD CONSTRAINT `kas_transactions_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `financial_accounts` (`id`);

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
-- Constraints for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  ADD CONSTRAINT `rekap_pengambilan_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `rekap_pengambilan_nopol_foreign` FOREIGN KEY (`nopol`) REFERENCES `nomor_polisi` (`nopol`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
