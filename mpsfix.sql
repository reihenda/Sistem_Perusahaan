-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 07, 2025 at 05:57 AM
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
(29, 4, 'Customer 1', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-14T00:00\",\"volume\":123124},\"pembacaan_akhir\":{\"waktu\":\"2025-03-15T23:59\",\"volume\":123344},\"volume_flow_meter\":220}', 0.00, 'belum_lunas', '2025-03-19 21:59:57', '2025-03-19 21:59:57'),
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
(56, 17, 'test fob', '{\"waktu\":\"2025-03-27T06:28\",\"volume_sm3\":\"300\",\"keterangan\":null}', 0.00, 'belum_lunas', '2025-03-26 23:28:48', '2025-03-26 23:28:48'),
(57, 17, 'test fob', '{\"waktu\":\"2025-03-28T02:19\",\"volume_sm3\":\"500\",\"keterangan\":null}', 277500.00, 'belum_lunas', '2025-03-27 19:19:09', '2025-03-27 19:19:09'),
(58, 18, 'test2', '{\"waktu\":\"2025-03-28T02:19\",\"volume_sm3\":\"700\",\"keterangan\":null}', 0.00, 'belum_lunas', '2025-03-27 19:19:44', '2025-03-27 19:19:44'),
(59, 5, 'Customer 2', '{\"pembacaan_awal\":{\"waktu\":\"2025-04-12T00:00\",\"volume\":333333},\"pembacaan_akhir\":{\"waktu\":\"2025-04-13T23:59\",\"volume\":12312312},\"volume_flow_meter\":11978979}', 439500082577.33, 'belum_lunas', '2025-03-27 22:54:08', '2025-03-27 22:54:08'),
(60, 14, 'PT Melodi Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2024-11-28T00:00\",\"volume\":665.999},\"pembacaan_akhir\":{\"waktu\":\"2024-11-30T23:59\",\"volume\":777},\"volume_flow_meter\":111.001}', 1357352.92, 'belum_lunas', '2025-03-28 00:17:45', '2025-03-28 00:17:45'),
(61, 18, 'test2', '{\"waktu\":\"2025-04-07T01:21\",\"volume_sm3\":\"200\",\"keterangan\":null}', 1200000.00, 'belum_lunas', '2025-04-06 18:22:08', '2025-04-06 18:22:08');

-- --------------------------------------------------------

--
-- Table structure for table `data_pencatatans`
--

CREATE TABLE `data_pencatatans` (
  `id` bigint(20) UNSIGNED NOT NULL,
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
(11, '2025_04_07_create_nomor_polisi_table', 5);

-- --------------------------------------------------------

--
-- Table structure for table `nomor_polisi`
--

CREATE TABLE `nomor_polisi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nopol` varchar(20) NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rekap_pengambilan`
--

CREATE TABLE `rekap_pengambilan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `waktu` time DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `nopol` varchar(20) NOT NULL,
  `volume` decimal(10,2) NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rekap_pengambilan`
--

INSERT INTO `rekap_pengambilan` (`id`, `tanggal`, `waktu`, `customer_id`, `nopol`, `volume`, `keterangan`, `created_at`, `updated_at`) VALUES
(1, '2025-04-07', NULL, 18, 'B9037SAN', 200.00, NULL, '2025-04-06 20:18:23', '2025-04-06 20:18:23'),
(2, '2025-03-07', NULL, 17, 'B9037SAN', 300.00, NULL, '2025-04-06 20:19:22', '2025-04-06 20:19:22'),
(3, '2025-04-03', NULL, 18, 'B9037SAN', 400.00, NULL, '2025-04-06 20:32:54', '2025-04-06 20:32:54');

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
('lT7kSmyX9MyiBybbqvw5fWNM9QmKsZfgLAI7KDGl', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiR2U1d29PdVJiUTVSRklTbENqMXZMNmM2YmdRd3pPQ3phVXdGbHZQYSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9yZWthcC1wZW5nYW1iaWxhbi9jcmVhdGUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=', 1743998167);

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

INSERT INTO `users` (`id`, `name`, `email`, `total_deposit`, `total_purchases`, `deposit_history`, `pricing_history`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`, `harga_per_meter_kubik`, `tekanan_keluar`, `suhu`, `koreksi_meter`) VALUES
(1, 'Test User', 'test@example.com', 0.00, 0.00, NULL, NULL, '2025-03-12 06:30:45', '$2y$12$zPctpAp8xDCPMMNYhExG.OJlrm/v1OuAY.Gp5VhKVDr3yII3VvCFK', 'customer', 'OP9VPDuO2P', '2025-03-12 06:30:45', '2025-03-12 06:30:45', 0.00, 0.000, 0.00, 1.00000000000000),
(2, 'Super Administrator', 'superadmin@example.com', 0.00, 0.00, NULL, NULL, NULL, '$2y$12$i9AfftwMoerCSLwsqKCGiea4KS0ZcbwaumTvsFnWGsLu2h.k32VPy', 'superadmin', NULL, '2025-03-12 06:30:45', '2025-03-12 06:30:45', 0.00, 0.000, 0.00, 1.00000000000000),
(3, 'Administrator', 'admin@example.com', 0.00, 0.00, NULL, NULL, NULL, '$2y$12$H0GcLLTZK6Eu0FWMmOdTo.utnOZH/Cu2GSVvriYK8CsorC54vlmuG', 'admin', NULL, '2025-03-12 06:30:46', '2025-03-12 06:30:46', 0.00, 0.000, 0.00, 1.00000000000000),
(4, 'Customer 1', 'customer1@example.com', 0.00, 0.00, NULL, NULL, NULL, '$2y$12$C8A8CF1j..AAXPPUI/yOyOUKTJGMTn.RTCijSxgGvlh9b6qnTyf4m', 'customer', NULL, '2025-03-12 06:30:46', '2025-03-12 06:30:46', 0.00, 0.000, 0.00, 1.00000000000000),
(5, 'Customer 2', 'customer2@example.com', 94152715.31, 891710974517.57, '[{\"date\":\"2025-03-05 14:04:00\",\"amount\":71930493.31,\"description\":null},{\"date\":\"2025-03-18 07:05:00\",\"amount\":22222222,\"description\":null}]', '[{\"date\":\"2025-01-01 00:00:00\",\"year_month\":\"2025-01\",\"harga_per_meter_kubik\":9300,\"tekanan_keluar\":1,\"suhu\":30,\"koreksi_meter\":1.97118526},{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":9300,\"tekanan_keluar\":3,\"suhu\":30,\"koreksi_meter\":3.94508358}]', NULL, '$2y$12$ven/iFTUTcgfhbs.y4LeSOrcyPJsHbx03a0KTZgh/0DvQ.qKGT/Ve', 'customer', NULL, '2025-03-12 06:30:46', '2025-03-27 23:31:54', 9300.00, 3.000, 30.00, 3.94508358311770),
(6, '1111', '111@111', 0.00, 0.00, NULL, NULL, NULL, '$2y$12$jn2XVLGyqkC9zlRErRohJObxLIVGdvhDrT6spcOsdp6zYo0wNWDNq', 'admin', NULL, '2025-03-17 20:14:37', '2025-03-17 20:14:37', 0.00, 0.000, 0.00, 1.00000000000000),
(14, 'PT Melodi Snack Indonesia', 'melodi@mps.com', 11111111.00, 5429362.78, '[{\"date\":\"2025-03-19 03:28:00\",\"amount\":11111111,\"description\":null}]', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":4000,\"tekanan_keluar\":2,\"suhu\":20,\"koreksi_meter\":3.05707364},{\"date\":\"2025-02-01 00:00:00\",\"year_month\":\"2025-02\",\"harga_per_meter_kubik\":3000,\"tekanan_keluar\":2,\"suhu\":20,\"koreksi_meter\":3.05707364}]', NULL, '$2y$12$7fQrcXCq3wf9GVQ7IdSCJORsiduA5dfVLJO3wEkau1B5JryF6g6lm', 'customer', NULL, '2025-03-18 00:13:24', '2025-03-28 00:17:45', 4000.00, 2.000, 20.00, 3.05707363778060),
(16, 'Demo User', 'demo@example.com', 5000000.00, 6046650.00, '\"[{\\\"date\\\":\\\"2025-03-27 04:22:37\\\",\\\"amount\\\":5000000,\\\"description\\\":\\\"Initial deposit for demo account\\\"}]\"', '\"[{\\\"date\\\":\\\"2025-03-27 04:22:37\\\",\\\"year_month\\\":\\\"2025-03\\\",\\\"harga_per_meter_kubik\\\":5000,\\\"tekanan_keluar\\\":3,\\\"suhu\\\":25,\\\"koreksi_meter\\\":4.0311}]\"', NULL, '$2y$12$1.G.eocg64t3xRDrVcJrC.93DdSjwaoVyIz4YMCsx5Yvbmodd9UF.', 'demo', NULL, '2025-03-26 21:22:37', '2025-03-26 21:44:12', 5000.00, 3.000, 25.00, 4.03110000000000),
(17, 'test fob', 'testfob@example.com', 2222.00, 444000.00, '[{\"date\":\"2025-03-27 09:32:00\",\"amount\":2222,\"description\":null}]', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":555}]', NULL, '$2y$12$IUiOTDwZpHr5S.eiTA25c.ZunCqUaf0sqYeuQBCWSOYxOPtFBVCkS', 'fob', NULL, '2025-03-26 23:22:32', '2025-03-27 19:19:10', 555.00, 8.000, 8.00, 9.64880317993000),
(18, 'test2', 'test2@example.com', 500000.00, 5400000.00, '[{\"date\":\"2025-03-28 02:19:00\",\"amount\":500000,\"description\":null}]', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":6000}]', NULL, '$2y$12$kGuFa6YsunaKfmBacspuA.VgsNFqpqFFZ5Qy3ASldbT.s2Se/H3hG', 'fob', NULL, '2025-03-27 00:16:44', '2025-04-06 18:22:08', 6000.00, 0.000, 0.00, 1.00000000000000);

--
-- Indexes for dumped tables
--

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
-- Indexes for table `data_pencatatans`
--
ALTER TABLE `data_pencatatans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

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
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nomor_polisi`
--
ALTER TABLE `nomor_polisi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nomor_polisi_nopol_unique` (`nopol`);

--
-- Indexes for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rekap_pengambilan_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

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
-- AUTO_INCREMENT for table `data_pencatatan`
--
ALTER TABLE `data_pencatatan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `data_pencatatans`
--
ALTER TABLE `data_pencatatans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `nomor_polisi`
--
ALTER TABLE `nomor_polisi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `data_pencatatan`
--
ALTER TABLE `data_pencatatan`
  ADD CONSTRAINT `data_pencatatan_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  ADD CONSTRAINT `rekap_pengambilan_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
