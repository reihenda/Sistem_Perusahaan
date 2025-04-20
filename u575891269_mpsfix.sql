-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 09, 2025 at 12:55 AM
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
(13, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-01T06:00\",\"volume\":69525.72},\"pembacaan_akhir\":{\"waktu\":\"2025-01-02T18:00\",\"volume\":69525.72},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-18 07:38:40', '2025-03-18 07:38:40'),
(14, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-02T06:00\",\"volume\":69525.72},\"pembacaan_akhir\":{\"waktu\":\"2025-01-03T02:00\",\"volume\":69914.95},\"volume_flow_meter\":389.23}', 0.00, 'belum_lunas', '2025-03-18 07:57:29', '2025-03-18 07:57:29'),
(15, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-03T06:00\",\"volume\":69914.95},\"pembacaan_akhir\":{\"waktu\":\"2025-01-04T06:00\",\"volume\":70394.58},\"volume_flow_meter\":479.63}', 0.00, 'belum_lunas', '2025-03-18 08:02:06', '2025-03-18 08:02:06'),
(16, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-04T06:00\",\"volume\":70394.58},\"pembacaan_akhir\":{\"waktu\":\"2025-01-05T06:00\",\"volume\":70882.77},\"volume_flow_meter\":488.19}', 0.00, 'belum_lunas', '2025-03-18 08:06:22', '2025-03-18 08:06:22'),
(17, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-06T06:00\",\"volume\":70882.77},\"pembacaan_akhir\":{\"waktu\":\"2025-01-07T06:00\",\"volume\":71307.58},\"volume_flow_meter\":424.81}', 0.00, 'belum_lunas', '2025-03-18 08:11:28', '2025-03-18 08:11:28'),
(18, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-07T06:00\",\"volume\":71307.58},\"pembacaan_akhir\":{\"waktu\":\"2025-01-07T18:00\",\"volume\":71615.41},\"volume_flow_meter\":307.83}', 0.00, 'belum_lunas', '2025-03-18 08:11:46', '2025-03-18 08:11:46'),
(19, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-11T06:00\",\"volume\":71615.41},\"pembacaan_akhir\":{\"waktu\":\"2025-01-11T18:00\",\"volume\":71706.45},\"volume_flow_meter\":91.04}', 0.00, 'belum_lunas', '2025-03-18 08:15:32', '2025-03-18 08:15:32'),
(20, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-13T06:00\",\"volume\":71706.45},\"pembacaan_akhir\":{\"waktu\":\"2025-01-13T18:00\",\"volume\":71921.72},\"volume_flow_meter\":215.27}', 0.00, 'belum_lunas', '2025-03-18 08:16:45', '2025-03-18 08:16:45'),
(21, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-14T06:00\",\"volume\":71921.72},\"pembacaan_akhir\":{\"waktu\":\"2025-01-14T18:00\",\"volume\":72079.22},\"volume_flow_meter\":157.5}', 0.00, 'belum_lunas', '2025-03-18 08:18:31', '2025-03-18 08:18:31'),
(22, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-15T06:00\",\"volume\":72079.22},\"pembacaan_akhir\":{\"waktu\":\"2025-01-15T18:00\",\"volume\":72233.63},\"volume_flow_meter\":154.41}', 0.00, 'belum_lunas', '2025-03-18 08:20:04', '2025-03-18 08:20:04'),
(23, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-16T06:00\",\"volume\":72233.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-16T18:00\",\"volume\":72380.55},\"volume_flow_meter\":146.92}', 0.00, 'belum_lunas', '2025-03-18 08:21:23', '2025-03-18 08:21:23'),
(24, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-18T06:00\",\"volume\":72523.36},\"pembacaan_akhir\":{\"waktu\":\"2025-01-18T18:00\",\"volume\":72542.36},\"volume_flow_meter\":19}', 0.00, 'belum_lunas', '2025-03-18 08:23:55', '2025-03-18 08:23:55'),
(25, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-17T06:00\",\"volume\":72380.55},\"pembacaan_akhir\":{\"waktu\":\"2025-01-17T18:00\",\"volume\":72523.36},\"volume_flow_meter\":142.81}', 0.00, 'belum_lunas', '2025-03-18 08:24:17', '2025-03-18 08:24:17'),
(29, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-05T06:00\",\"volume\":70882.77},\"pembacaan_akhir\":{\"waktu\":\"2025-01-06T06:00\",\"volume\":70882.77},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 07:00:11', '2025-03-19 07:15:33'),
(30, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-08T06:00\",\"volume\":71615.41},\"pembacaan_akhir\":{\"waktu\":\"2025-01-09T06:00\",\"volume\":71615.41},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 07:14:15', '2025-03-19 07:16:48'),
(31, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-09T06:00\",\"volume\":71615.41},\"pembacaan_akhir\":{\"waktu\":\"2025-01-10T06:00\",\"volume\":71615.41},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 07:18:00', '2025-03-19 07:18:00'),
(32, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-10T06:00\",\"volume\":71615.41},\"pembacaan_akhir\":{\"waktu\":\"2025-01-11T06:00\",\"volume\":71615.41},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 07:19:27', '2025-03-19 07:19:27'),
(33, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-12T06:00\",\"volume\":71706.45},\"pembacaan_akhir\":{\"waktu\":\"2025-01-13T06:00\",\"volume\":71706.45},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 07:22:13', '2025-03-19 07:22:13'),
(34, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-01T07:00\",\"volume\":16133.04},\"pembacaan_akhir\":{\"waktu\":\"2025-03-01T16:00\",\"volume\":16133.04},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 07:33:15', '2025-03-19 07:33:15'),
(35, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-02T07:00\",\"volume\":16133.04},\"pembacaan_akhir\":{\"waktu\":\"2025-03-02T16:00\",\"volume\":16133.04},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 07:41:16', '2025-03-19 07:41:16'),
(36, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-03T07:00\",\"volume\":16133.04},\"pembacaan_akhir\":{\"waktu\":\"2025-03-03T16:00\",\"volume\":16133.04},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 08:03:23', '2025-03-19 08:03:23'),
(37, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-04T07:00\",\"volume\":16133.04},\"pembacaan_akhir\":{\"waktu\":\"2025-03-04T14:53\",\"volume\":16236.01},\"volume_flow_meter\":102.97}', 2602317.25, 'belum_lunas', '2025-03-19 08:04:58', '2025-03-19 08:04:58'),
(38, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-05T07:00\",\"volume\":16236.01},\"pembacaan_akhir\":{\"waktu\":\"2025-03-05T14:25\",\"volume\":16328.53},\"volume_flow_meter\":92.52}', 2338218.82, 'belum_lunas', '2025-03-19 08:07:09', '2025-03-19 08:07:09'),
(39, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-06T07:00\",\"volume\":16328.53},\"pembacaan_akhir\":{\"waktu\":\"2025-03-06T16:24\",\"volume\":16432.93},\"volume_flow_meter\":104.4}', 2638457.04, 'belum_lunas', '2025-03-19 08:28:47', '2025-03-19 08:28:47'),
(40, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-07T07:00\",\"volume\":16432.93},\"pembacaan_akhir\":{\"waktu\":\"2025-03-07T14:22\",\"volume\":16529.62},\"volume_flow_meter\":96.69}', 2443605.47, 'belum_lunas', '2025-03-19 08:32:59', '2025-03-19 08:32:59'),
(41, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-08T07:00\",\"volume\":16529.62},\"pembacaan_akhir\":{\"waktu\":\"2025-03-08T15:25\",\"volume\":16621.53},\"volume_flow_meter\":91.91}', 2322802.55, 'belum_lunas', '2025-03-19 08:34:17', '2025-03-19 08:34:17'),
(42, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-09T07:00\",\"volume\":16621.53},\"pembacaan_akhir\":{\"waktu\":\"2025-03-09T16:00\",\"volume\":16621.53},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 08:38:15', '2025-03-19 08:38:15'),
(43, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-10T07:00\",\"volume\":16621.53},\"pembacaan_akhir\":{\"waktu\":\"2025-03-10T12:57\",\"volume\":16712.29},\"volume_flow_meter\":90.76}', 2293739.09, 'belum_lunas', '2025-03-19 08:48:46', '2025-03-19 08:48:46'),
(44, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-11T07:00\",\"volume\":16712.29},\"pembacaan_akhir\":{\"waktu\":\"2025-03-11T12:53\",\"volume\":16774.22},\"volume_flow_meter\":61.93}', 1565130.69, 'belum_lunas', '2025-03-19 08:55:54', '2025-03-19 08:55:54'),
(45, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-12T07:00\",\"volume\":16774.22},\"pembacaan_akhir\":{\"waktu\":\"2025-03-12T16:00\",\"volume\":16774.22},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-19 08:58:15', '2025-03-19 08:58:15'),
(46, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-13T07:00\",\"volume\":16774.22},\"pembacaan_akhir\":{\"waktu\":\"2025-03-13T14:49\",\"volume\":16855.9},\"volume_flow_meter\":81.68}', 2064264.09, 'belum_lunas', '2025-03-19 08:59:25', '2025-03-19 08:59:25'),
(47, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-14T07:00\",\"volume\":16855.9},\"pembacaan_akhir\":{\"waktu\":\"2025-03-14T15:00\",\"volume\":16918.85},\"volume_flow_meter\":62.95}', 1590908.72, 'belum_lunas', '2025-03-19 09:00:44', '2025-03-19 09:00:44'),
(48, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-15T07:00\",\"volume\":16918.85},\"pembacaan_akhir\":{\"waktu\":\"2025-03-15T15:23\",\"volume\":16980.55},\"volume_flow_meter\":61.7}', 1559318.00, 'belum_lunas', '2025-03-19 09:02:56', '2025-03-19 09:02:56'),
(49, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-16T07:00\",\"volume\":16980.55},\"pembacaan_akhir\":{\"waktu\":\"2025-03-16T16:00\",\"volume\":16980.55},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-20 04:37:11', '2025-03-20 04:37:11'),
(50, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-17T07:00\",\"volume\":16980.55},\"pembacaan_akhir\":{\"waktu\":\"2025-03-17T14:55\",\"volume\":17050.97},\"volume_flow_meter\":70.42}', 1779694.87, 'belum_lunas', '2025-03-20 04:39:48', '2025-03-20 04:39:48'),
(51, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-18T07:00\",\"volume\":17050.97},\"pembacaan_akhir\":{\"waktu\":\"2025-03-18T14:57\",\"volume\":17121.41},\"volume_flow_meter\":70.44}', 1780200.32, 'belum_lunas', '2025-03-20 04:42:23', '2025-03-20 04:43:00'),
(52, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-19T07:00\",\"volume\":17121.41},\"pembacaan_akhir\":{\"waktu\":\"2025-03-19T14:06\",\"volume\":17190.63},\"volume_flow_meter\":69.22}', 1749367.78, 'belum_lunas', '2025-03-20 04:47:38', '2025-03-20 04:47:38'),
(62, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-19T06:00\",\"volume\":72542.36},\"pembacaan_akhir\":{\"waktu\":\"2025-01-19T18:00\",\"volume\":72660.41},\"volume_flow_meter\":118.05}', 4757876.53, 'belum_lunas', '2025-03-20 05:56:40', '2025-03-20 05:56:40'),
(80, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-20 00:00\",\"volume\":72660.41},\"pembacaan_akhir\":{\"waktu\":\"2025-01-20 23:59\",\"volume\":72660.41},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 06:37:30', '2025-03-20 06:37:30'),
(81, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-21T06:00\",\"volume\":72660.41},\"pembacaan_akhir\":{\"waktu\":\"2025-01-22T06:00\",\"volume\":72879.52},\"volume_flow_meter\":219.11}', 8830989.63, 'belum_lunas', '2025-03-20 06:37:30', '2025-03-20 06:37:30'),
(82, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-21 00:00\",\"volume\":72660.41},\"pembacaan_akhir\":{\"waktu\":\"2025-01-21 23:59\",\"volume\":72660.41},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 06:39:12', '2025-03-20 06:39:12'),
(83, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-22T06:00\",\"volume\":72879.52},\"pembacaan_akhir\":{\"waktu\":\"2025-01-23T07:00\",\"volume\":73107.58},\"volume_flow_meter\":228.06}', 9191709.62, 'belum_lunas', '2025-03-20 06:39:12', '2025-03-20 06:39:12'),
(84, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-23T07:00\",\"volume\":73107.58},\"pembacaan_akhir\":{\"waktu\":\"2025-01-24T07:00\",\"volume\":73369.64},\"volume_flow_meter\":262.06}', 10562042.55, 'belum_lunas', '2025-03-20 06:40:32', '2025-03-20 06:40:32'),
(85, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-24T07:00\",\"volume\":73369.64},\"pembacaan_akhir\":{\"waktu\":\"2025-01-25T07:30\",\"volume\":73621.4},\"volume_flow_meter\":251.76}', 10146912.28, 'belum_lunas', '2025-03-20 06:41:24', '2025-03-20 06:41:24'),
(86, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-25T07:30\",\"volume\":73621.4},\"pembacaan_akhir\":{\"waktu\":\"2025-01-26T07:00\",\"volume\":73921.82},\"volume_flow_meter\":300.42}', 12108100.52, 'belum_lunas', '2025-03-20 06:43:43', '2025-03-20 06:43:43'),
(87, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-26T07:00\",\"volume\":73921.82},\"pembacaan_akhir\":{\"waktu\":\"2025-01-27T06:00\",\"volume\":74214.42},\"volume_flow_meter\":292.6}', 11792923.95, 'belum_lunas', '2025-03-20 06:45:00', '2025-03-20 06:45:00'),
(88, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-27T06:00\",\"volume\":74214.42},\"pembacaan_akhir\":{\"waktu\":\"2025-01-31T07:00\",\"volume\":74497.74},\"volume_flow_meter\":283.32}', 11418903.67, 'belum_lunas', '2025-03-20 06:47:32', '2025-03-20 06:47:32'),
(89, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-28 00:00\",\"volume\":74214.42},\"pembacaan_akhir\":{\"waktu\":\"2025-01-28 23:59\",\"volume\":74214.42},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 06:49:07', '2025-03-20 06:49:07'),
(90, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-29 00:00\",\"volume\":74214.42},\"pembacaan_akhir\":{\"waktu\":\"2025-01-29 23:59\",\"volume\":74214.42},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 06:49:07', '2025-03-20 06:49:07'),
(91, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-30 00:00\",\"volume\":74214.42},\"pembacaan_akhir\":{\"waktu\":\"2025-01-30 23:59\",\"volume\":74214.42},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 06:49:07', '2025-03-20 06:49:07'),
(92, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-31T07:00\",\"volume\":74497.74},\"pembacaan_akhir\":{\"waktu\":\"2025-02-01T07:00\",\"volume\":74745.54},\"volume_flow_meter\":247.8}', 9987308.80, 'belum_lunas', '2025-03-20 06:49:07', '2025-03-20 06:49:07'),
(94, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-01T00:00\",\"volume\":74745.54},\"pembacaan_akhir\":{\"waktu\":\"2025-02-02T07:00\",\"volume\":75044.05},\"volume_flow_meter\":298.51}', 12031120.06, 'belum_lunas', '2025-03-20 08:04:28', '2025-03-20 08:04:28'),
(96, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-03T07:00\",\"volume\":75044.05},\"pembacaan_akhir\":{\"waktu\":\"2025-02-04T03:17\",\"volume\":75393.62},\"volume_flow_meter\":349.57}', 14089037.68, 'lunas', '2025-03-20 08:37:53', '2025-03-20 13:52:24'),
(97, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-04T07:00\",\"volume\":75393.62},\"pembacaan_akhir\":{\"waktu\":\"2025-02-05T02:15\",\"volume\":75783.57},\"volume_flow_meter\":389.95}', 15716509.55, 'belum_lunas', '2025-03-20 08:37:53', '2025-03-20 08:37:53'),
(98, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-05T07:00\",\"volume\":75783.57},\"pembacaan_akhir\":{\"waktu\":\"2025-02-06T03:15\",\"volume\":76152.71},\"volume_flow_meter\":369.14}', 14877785.19, 'belum_lunas', '2025-03-20 08:40:13', '2025-03-20 08:40:13'),
(99, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-06T07:00\",\"volume\":76152.71},\"pembacaan_akhir\":{\"waktu\":\"2025-02-07T03:00\",\"volume\":76545.82},\"volume_flow_meter\":393.11}', 15843869.91, 'belum_lunas', '2025-03-20 08:41:42', '2025-03-20 08:41:42'),
(100, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-07T07:00\",\"volume\":76545.82},\"pembacaan_akhir\":{\"waktu\":\"2025-02-08T03:15\",\"volume\":76989.48},\"volume_flow_meter\":443.66}', 17881232.54, 'belum_lunas', '2025-03-20 08:42:56', '2025-03-20 08:42:56'),
(101, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-07T00:00\",\"volume\":76989.48},\"pembacaan_akhir\":{\"waktu\":\"2025-02-08T03:20\",\"volume\":77399.71},\"volume_flow_meter\":410.23}', 16533872.84, 'belum_lunas', '2025-03-20 09:00:15', '2025-03-20 09:00:15'),
(102, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-08T07:00\",\"volume\":77399.71},\"pembacaan_akhir\":{\"waktu\":\"2025-02-10T17:50\",\"volume\":77816.72},\"volume_flow_meter\":417.01}', 16807133.35, 'belum_lunas', '2025-03-20 09:01:48', '2025-03-20 09:01:48'),
(103, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-09 00:00\",\"volume\":77399.71},\"pembacaan_akhir\":{\"waktu\":\"2025-02-09 23:59\",\"volume\":77399.71},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 09:02:45', '2025-03-20 09:02:45'),
(104, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-10T07:00\",\"volume\":77816.72},\"pembacaan_akhir\":{\"waktu\":\"2025-02-11T16:00\",\"volume\":78239.26},\"volume_flow_meter\":422.54}', 17030013.97, 'belum_lunas', '2025-03-20 09:02:45', '2025-03-20 09:02:45'),
(105, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-11T07:00\",\"volume\":78239.26},\"pembacaan_akhir\":{\"waktu\":\"2025-02-12T15:30\",\"volume\":78647.29},\"volume_flow_meter\":408.03}', 16445204.24, 'belum_lunas', '2025-03-20 09:04:17', '2025-03-20 09:04:17'),
(106, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-13T07:00\",\"volume\":78647.29},\"pembacaan_akhir\":{\"waktu\":\"2025-02-14T16:00\",\"volume\":79059.48},\"volume_flow_meter\":412.19}', 16612868.50, 'belum_lunas', '2025-03-20 09:08:18', '2025-03-20 09:08:18'),
(107, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-13 00:00\",\"volume\":78647.29},\"pembacaan_akhir\":{\"waktu\":\"2025-02-13 23:59\",\"volume\":78647.29},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 09:09:28', '2025-03-20 09:09:28'),
(108, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-14T07:00\",\"volume\":79059.48},\"pembacaan_akhir\":{\"waktu\":\"2025-02-15T15:30\",\"volume\":79349.7},\"volume_flow_meter\":290.22}', 11697000.65, 'belum_lunas', '2025-03-20 09:09:28', '2025-03-20 09:09:28'),
(109, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-15T07:00\",\"volume\":79349.7},\"pembacaan_akhir\":{\"waktu\":\"2025-02-16T15:30\",\"volume\":79635.84},\"volume_flow_meter\":286.14}', 11532560.70, 'belum_lunas', '2025-03-20 09:10:26', '2025-03-20 09:18:40'),
(110, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-16 00:00\",\"volume\":79349.7},\"pembacaan_akhir\":{\"waktu\":\"2025-02-16 23:59\",\"volume\":79349.7},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 09:11:45', '2025-03-20 09:11:45'),
(111, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-17T07:00\",\"volume\":79635.84},\"pembacaan_akhir\":{\"waktu\":\"2025-02-18T16:30\",\"volume\":80146.07},\"volume_flow_meter\":510.23}', 20564263.80, 'belum_lunas', '2025-03-20 09:11:45', '2025-03-20 09:11:45'),
(112, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-17 00:00\",\"volume\":79349.7},\"pembacaan_akhir\":{\"waktu\":\"2025-02-17 23:59\",\"volume\":79349.7},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 09:13:39', '2025-03-20 09:13:39'),
(113, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-18T07:00\",\"volume\":80146.07},\"pembacaan_akhir\":{\"waktu\":\"2025-02-18T22:15\",\"volume\":80527.77},\"volume_flow_meter\":381.7}', 15384002.30, 'belum_lunas', '2025-03-20 09:13:39', '2025-03-20 09:13:39'),
(114, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-19T07:00\",\"volume\":80527.77},\"pembacaan_akhir\":{\"waktu\":\"2025-02-20T03:00\",\"volume\":80925.31},\"volume_flow_meter\":397.54}', 16022416.23, 'belum_lunas', '2025-03-20 09:14:32', '2025-03-20 09:14:32'),
(115, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-19 00:00\",\"volume\":80527.77},\"pembacaan_akhir\":{\"waktu\":\"2025-02-19 23:59\",\"volume\":80527.77},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 09:15:37', '2025-03-20 09:15:37'),
(116, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-20T00:00\",\"volume\":80925.31},\"pembacaan_akhir\":{\"waktu\":\"2025-02-21T04:30\",\"volume\":81306.32},\"volume_flow_meter\":381.01}', 15356192.60, 'belum_lunas', '2025-03-20 09:15:37', '2025-03-20 09:19:10'),
(117, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-21T07:00\",\"volume\":81306.32},\"pembacaan_akhir\":{\"waktu\":\"2025-02-22T16:30\",\"volume\":81699.93},\"volume_flow_meter\":393.61}', 15864021.86, 'belum_lunas', '2025-03-20 09:16:31', '2025-03-20 09:16:31'),
(118, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-21 00:00\",\"volume\":75044.05},\"pembacaan_akhir\":{\"waktu\":\"2025-02-21 23:59\",\"volume\":75044.05},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 09:18:08', '2025-03-20 09:18:08'),
(119, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-22T07:00\",\"volume\":81699.93},\"pembacaan_akhir\":{\"waktu\":\"2025-02-23T16:00\",\"volume\":82042.64},\"volume_flow_meter\":342.71}', 13812552.86, 'belum_lunas', '2025-03-20 09:18:08', '2025-03-20 09:18:08'),
(120, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-24T07:00\",\"volume\":82042.64},\"pembacaan_akhir\":{\"waktu\":\"2025-02-25T16:00\",\"volume\":82549.62},\"volume_flow_meter\":506.98}', 20433276.09, 'belum_lunas', '2025-03-20 09:22:54', '2025-03-20 09:22:54'),
(121, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-24 00:00\",\"volume\":82042.64},\"pembacaan_akhir\":{\"waktu\":\"2025-02-24 23:59\",\"volume\":82042.64},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-20 09:24:14', '2025-03-20 09:24:14'),
(122, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-25T07:00\",\"volume\":82549.62},\"pembacaan_akhir\":{\"waktu\":\"2025-02-26T17:30\",\"volume\":82972.95},\"volume_flow_meter\":423.33}', 17061854.05, 'belum_lunas', '2025-03-20 09:24:14', '2025-03-20 09:24:14'),
(123, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-26T07:00\",\"volume\":82972.95},\"pembacaan_akhir\":{\"waktu\":\"2025-02-27T17:30\",\"volume\":83352.34},\"volume_flow_meter\":379.39}', 15290900.27, 'belum_lunas', '2025-03-20 09:25:38', '2025-03-20 09:25:38'),
(124, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-27T07:00\",\"volume\":83352.34},\"pembacaan_akhir\":{\"waktu\":\"2025-02-28T19:40\",\"volume\":83424.08},\"volume_flow_meter\":71.74}', 2891402.48, 'belum_lunas', '2025-03-20 09:26:39', '2025-03-20 09:26:39'),
(125, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-28T07:00\",\"volume\":83424.08},\"pembacaan_akhir\":{\"waktu\":\"2025-03-01T07:00\",\"volume\":83472.6},\"volume_flow_meter\":48.52}', 1955545.69, 'belum_lunas', '2025-03-20 09:27:12', '2025-03-21 06:08:08'),
(126, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-02-02T07:00\",\"volume\":75044.05},\"pembacaan_akhir\":{\"waktu\":\"2025-02-03T07:00\",\"volume\":75044.05},\"volume_flow_meter\":0}', 0.00, 'belum_lunas', '2025-03-20 13:54:39', '2025-03-20 13:54:39'),
(131, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-01T07:00\",\"volume\":83472.6},\"pembacaan_akhir\":{\"waktu\":\"2025-03-01T18:00\",\"volume\":83513.63},\"volume_flow_meter\":41.03}', 1653669.41, 'belum_lunas', '2025-03-21 05:49:03', '2025-03-21 05:49:03'),
(132, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-02 00:00\",\"volume\":83513.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-02 23:59\",\"volume\":83513.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-22 09:47:43', '2025-03-22 09:47:43'),
(133, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-03 00:00\",\"volume\":83513.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-03 23:59\",\"volume\":83513.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-22 09:47:43', '2025-03-22 09:47:43'),
(134, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-04T07:00\",\"volume\":83513.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-04T17:00\",\"volume\":83556.63},\"volume_flow_meter\":43}', 1733068.11, 'belum_lunas', '2025-03-22 09:47:43', '2025-03-22 09:47:43'),
(135, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-05T07:00\",\"volume\":83556.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-05T17:00\",\"volume\":83596.01},\"volume_flow_meter\":39.38}', 1587167.96, 'belum_lunas', '2025-03-22 09:49:07', '2025-03-22 09:53:51'),
(136, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-05 00:00\",\"volume\":83556.63},\"pembacaan_akhir\":{\"waktu\":\"2025-03-05 23:59\",\"volume\":83556.63},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-22 09:50:42', '2025-03-22 09:50:42'),
(137, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-06T07:00\",\"volume\":83596.01},\"pembacaan_akhir\":{\"waktu\":\"2025-03-06T17:00\",\"volume\":83636.53},\"volume_flow_meter\":40.52}', 1633114.42, 'belum_lunas', '2025-03-22 09:50:42', '2025-03-22 09:50:42'),
(139, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-07T07:00\",\"volume\":83636.53},\"pembacaan_akhir\":{\"waktu\":\"2025-03-07T17:00\",\"volume\":83686.28},\"volume_flow_meter\":49.75}', 2005119.50, 'belum_lunas', '2025-03-22 09:55:03', '2025-03-22 09:55:03'),
(140, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-08T07:00\",\"volume\":83686.28},\"pembacaan_akhir\":{\"waktu\":\"2025-03-08T16:40\",\"volume\":83724.7},\"volume_flow_meter\":38.42}', 1548476.21, 'belum_lunas', '2025-03-22 09:56:15', '2025-03-22 09:56:15'),
(141, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-09 00:00\",\"volume\":83724.7},\"pembacaan_akhir\":{\"waktu\":\"2025-03-09 23:59\",\"volume\":83724.7},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-22 09:57:04', '2025-03-22 09:57:04'),
(142, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-10T07:00\",\"volume\":83724.7},\"pembacaan_akhir\":{\"waktu\":\"2025-03-10T15:40\",\"volume\":83756.44},\"volume_flow_meter\":31.74}', 1279246.09, 'belum_lunas', '2025-03-22 09:57:04', '2025-03-22 09:57:04'),
(143, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-11 00:00\",\"volume\":83756.44},\"pembacaan_akhir\":{\"waktu\":\"2025-03-11 23:59\",\"volume\":83756.44},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-22 09:58:30', '2025-03-22 09:58:30'),
(144, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-12T07:00\",\"volume\":83756.44},\"pembacaan_akhir\":{\"waktu\":\"2025-03-12T15:45\",\"volume\":83757.9},\"volume_flow_meter\":1.46}', 58843.71, 'belum_lunas', '2025-03-22 09:58:30', '2025-03-22 09:58:30'),
(145, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-13T07:00\",\"volume\":83757.9},\"pembacaan_akhir\":{\"waktu\":\"2025-03-13T16:00\",\"volume\":83759.21},\"volume_flow_meter\":1.31}', 52798.12, 'belum_lunas', '2025-03-22 09:59:37', '2025-03-22 09:59:37'),
(146, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-14T07:00\",\"volume\":83759.21},\"pembacaan_akhir\":{\"waktu\":\"2025-03-14T16:30\",\"volume\":83802.96},\"volume_flow_meter\":43.75}', 1763296.05, 'belum_lunas', '2025-03-22 10:00:44', '2025-03-22 10:00:44'),
(147, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-15T07:00\",\"volume\":83802.96},\"pembacaan_akhir\":{\"waktu\":\"2025-03-15T16:40\",\"volume\":83843.89},\"volume_flow_meter\":40.93}', 1649639.02, 'belum_lunas', '2025-03-22 10:01:41', '2025-03-22 10:01:41'),
(148, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-16 00:00\",\"volume\":83843.89},\"pembacaan_akhir\":{\"waktu\":\"2025-03-16 23:59\",\"volume\":83843.89},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-22 10:02:54', '2025-03-22 10:02:54'),
(149, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-17T07:00\",\"volume\":83843.89},\"pembacaan_akhir\":{\"waktu\":\"2025-03-17T16:00\",\"volume\":83885.68},\"volume_flow_meter\":41.79}', 1684300.38, 'belum_lunas', '2025-03-22 10:02:54', '2025-03-22 10:02:54'),
(150, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-18T07:00\",\"volume\":83885.68},\"pembacaan_akhir\":{\"waktu\":\"2025-03-19T05:00\",\"volume\":84293.99},\"volume_flow_meter\":408.31}', 16456489.33, 'belum_lunas', '2025-03-22 10:03:44', '2025-03-22 10:03:44'),
(151, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-19T07:00\",\"volume\":84293.99},\"pembacaan_akhir\":{\"waktu\":\"2025-03-20T05:45\",\"volume\":84730.17},\"volume_flow_meter\":436.18}', 17579759.29, 'belum_lunas', '2025-03-22 10:05:01', '2025-03-22 10:05:01'),
(152, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-20T07:00\",\"volume\":84730.17},\"pembacaan_akhir\":{\"waktu\":\"2025-03-21T04:00\",\"volume\":85065.75},\"volume_flow_meter\":335.58}', 13525185.98, 'belum_lunas', '2025-03-22 10:05:58', '2025-03-22 10:05:58'),
(153, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-21T07:00\",\"volume\":85065.75},\"pembacaan_akhir\":{\"waktu\":\"2025-03-21T18:00\",\"volume\":85135.26},\"volume_flow_meter\":69.51}', 2801524.76, 'belum_lunas', '2025-03-22 10:07:27', '2025-03-22 10:07:27'),
(154, 12, 'Demo User', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-27T04:52\",\"volume\":12000},\"pembacaan_akhir\":{\"waktu\":\"2025-03-28T04:52\",\"volume\":12300},\"volume_flow_meter\":300}', 10830445.90, 'belum_lunas', '2025-03-27 04:52:19', '2025-03-27 04:52:19'),
(155, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-22T07:00\",\"volume\":85135.26},\"pembacaan_akhir\":{\"waktu\":\"2025-03-22T17:30\",\"volume\":85177.18},\"volume_flow_meter\":41.92}', 1689539.89, 'belum_lunas', '2025-03-27 07:23:19', '2025-03-27 07:23:19'),
(156, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-23 00:00\",\"volume\":85177.18},\"pembacaan_akhir\":{\"waktu\":\"2025-03-23 23:59\",\"volume\":85177.18},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 07:24:24', '2025-03-27 07:24:24'),
(157, 8, 'PT Nomi Bogasari Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-03-24T07:00\",\"volume\":85177.18},\"pembacaan_akhir\":{\"waktu\":\"2025-03-24T17:40\",\"volume\":85231.97},\"volume_flow_meter\":54.79}', 2208251.21, 'belum_lunas', '2025-03-27 07:24:24', '2025-03-27 07:24:24'),
(158, 10, 'PT Raja Roti Cemerlang', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-01T11:20\",\"volume\":183056.95},\"pembacaan_akhir\":{\"waktu\":\"2025-03-02T11:20\",\"volume\":183112.74},\"volume_flow_meter\":55.79}', 1409957.07, 'belum_lunas', '2025-03-27 07:48:36', '2025-03-27 07:48:36'),
(159, 10, 'PT Raja Roti Cemerlang', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-02T11:20\",\"volume\":183112.74},\"pembacaan_akhir\":{\"waktu\":\"2025-01-03T11:45\",\"volume\":183207.15},\"volume_flow_meter\":94.41}', 2385983.99, 'belum_lunas', '2025-03-27 07:51:29', '2025-03-27 07:51:29'),
(160, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-03T06:00\",\"volume\":12544.83},\"pembacaan_akhir\":{\"waktu\":\"2025-01-03T16:16\",\"volume\":12678.98},\"volume_flow_meter\":134.15}', 3390316.20, 'belum_lunas', '2025-03-27 07:55:59', '2025-03-27 07:55:59'),
(161, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-04T06:00\",\"volume\":12678.98},\"pembacaan_akhir\":{\"waktu\":\"2025-01-04T16:36\",\"volume\":12784.46},\"volume_flow_meter\":105.48}', 2665751.42, 'belum_lunas', '2025-03-27 07:57:40', '2025-03-27 07:57:40'),
(162, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-05 00:00\",\"volume\":12784.46},\"pembacaan_akhir\":{\"waktu\":\"2025-01-05 23:59\",\"volume\":12784.46},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 07:59:24', '2025-03-27 07:59:24'),
(163, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-06T06:00\",\"volume\":12784.46},\"pembacaan_akhir\":{\"waktu\":\"2025-01-06T15:06\",\"volume\":12881.07},\"volume_flow_meter\":96.61}', 2441583.66, 'belum_lunas', '2025-03-27 07:59:24', '2025-03-27 07:59:24'),
(164, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-07 00:00\",\"volume\":12881.07},\"pembacaan_akhir\":{\"waktu\":\"2025-01-07 23:59\",\"volume\":12881.07},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:08:22', '2025-03-27 08:08:22'),
(165, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-08 00:00\",\"volume\":12881.07},\"pembacaan_akhir\":{\"waktu\":\"2025-01-08 23:59\",\"volume\":12881.07},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:08:22', '2025-03-27 08:08:22'),
(166, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-09 00:00\",\"volume\":12881.07},\"pembacaan_akhir\":{\"waktu\":\"2025-01-09 23:59\",\"volume\":12881.07},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:08:22', '2025-03-27 08:08:22'),
(167, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-10 00:00\",\"volume\":12881.07},\"pembacaan_akhir\":{\"waktu\":\"2025-01-10 23:59\",\"volume\":12881.07},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:08:22', '2025-03-27 08:08:22'),
(168, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-11 00:00\",\"volume\":12881.07},\"pembacaan_akhir\":{\"waktu\":\"2025-01-11 23:59\",\"volume\":12881.07},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:08:22', '2025-03-27 08:08:22'),
(169, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-12 00:00\",\"volume\":12881.07},\"pembacaan_akhir\":{\"waktu\":\"2025-01-12 23:59\",\"volume\":12881.07},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:08:22', '2025-03-27 08:08:22'),
(170, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-13 00:00\",\"volume\":12881.07},\"pembacaan_akhir\":{\"waktu\":\"2025-01-13 23:59\",\"volume\":12881.07},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:08:22', '2025-03-27 08:08:22'),
(171, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-14T06:00\",\"volume\":12881.07},\"pembacaan_akhir\":{\"waktu\":\"2025-01-14T18:00\",\"volume\":13014.56},\"volume_flow_meter\":133.49}', 3373636.30, 'belum_lunas', '2025-03-27 08:08:22', '2025-03-27 08:08:22'),
(172, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-15T06:00\",\"volume\":13014.56},\"pembacaan_akhir\":{\"waktu\":\"2025-01-15T20:03\",\"volume\":13142.28},\"volume_flow_meter\":127.72}', 3227813.53, 'belum_lunas', '2025-03-27 08:11:04', '2025-03-27 08:11:04'),
(173, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-16T06:00\",\"volume\":13142.28},\"pembacaan_akhir\":{\"waktu\":\"2025-01-16T17:42\",\"volume\":13253.63},\"volume_flow_meter\":111.35}', 2814101.44, 'belum_lunas', '2025-03-27 08:12:39', '2025-03-27 08:12:39'),
(174, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-17T06:00\",\"volume\":13253.63},\"pembacaan_akhir\":{\"waktu\":\"2025-01-17T16:47\",\"volume\":13362.45},\"volume_flow_meter\":108.82}', 2750161.82, 'belum_lunas', '2025-03-27 08:13:42', '2025-03-27 08:13:42'),
(175, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-18T06:00\",\"volume\":13362.45},\"pembacaan_akhir\":{\"waktu\":\"2025-01-18T17:24\",\"volume\":13474.22},\"volume_flow_meter\":111.77}', 2824715.93, 'belum_lunas', '2025-03-27 08:14:56', '2025-03-27 08:14:56'),
(176, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-19 00:00\",\"volume\":13474.22},\"pembacaan_akhir\":{\"waktu\":\"2025-01-19 23:59\",\"volume\":13474.22},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:16:24', '2025-03-27 08:16:24'),
(177, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-20 00:00\",\"volume\":13474.22},\"pembacaan_akhir\":{\"waktu\":\"2025-01-20 23:59\",\"volume\":13474.22},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:16:24', '2025-03-27 08:16:24'),
(178, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-21 00:00\",\"volume\":13474.22},\"pembacaan_akhir\":{\"waktu\":\"2025-01-21 23:59\",\"volume\":13474.22},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:16:24', '2025-03-27 08:16:24'),
(179, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-22T06:00\",\"volume\":13474.22},\"pembacaan_akhir\":{\"waktu\":\"2025-01-22T17:48\",\"volume\":13594.72},\"volume_flow_meter\":120.5}', 3045345.52, 'belum_lunas', '2025-03-27 08:16:24', '2025-03-27 08:16:24'),
(180, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-23T06:00\",\"volume\":13594.72},\"pembacaan_akhir\":{\"waktu\":\"2025-01-23T15:24\",\"volume\":13662.76},\"volume_flow_meter\":68.04}', 1719546.14, 'belum_lunas', '2025-03-27 08:17:30', '2025-03-27 08:17:30'),
(181, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-24T06:00\",\"volume\":13662.76},\"pembacaan_akhir\":{\"waktu\":\"2025-01-24T17:47\",\"volume\":13748.26},\"volume_flow_meter\":85.5}', 2160805.33, 'belum_lunas', '2025-03-27 08:18:34', '2025-03-27 08:18:54'),
(182, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-25T06:00\",\"volume\":13748.26},\"pembacaan_akhir\":{\"waktu\":\"2025-01-25T16:00\",\"volume\":13839.88},\"volume_flow_meter\":91.62}', 2315473.50, 'belum_lunas', '2025-03-27 08:20:37', '2025-03-27 08:20:37'),
(183, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-26T06:00\",\"volume\":13839.88},\"pembacaan_akhir\":{\"waktu\":\"2025-01-26T14:53\",\"volume\":13930.6},\"volume_flow_meter\":90.72}', 2292728.18, 'belum_lunas', '2025-03-27 08:21:38', '2025-03-27 08:21:38'),
(184, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-27 00:00\",\"volume\":13930.6},\"pembacaan_akhir\":{\"waktu\":\"2025-01-27 23:59\",\"volume\":13930.6},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:22:54', '2025-03-27 08:22:54'),
(185, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-28 00:00\",\"volume\":13930.6},\"pembacaan_akhir\":{\"waktu\":\"2025-01-28 23:59\",\"volume\":13930.6},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:22:54', '2025-03-27 08:22:54'),
(186, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-29 00:00\",\"volume\":13930.6},\"pembacaan_akhir\":{\"waktu\":\"2025-01-29 23:59\",\"volume\":13930.6},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:22:54', '2025-03-27 08:22:54'),
(187, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-30 00:00\",\"volume\":13930.6},\"pembacaan_akhir\":{\"waktu\":\"2025-01-30 23:59\",\"volume\":13930.6},\"volume_flow_meter\":0}', 0.00, 'lunas', '2025-03-27 08:22:54', '2025-03-27 08:22:54'),
(188, 9, 'PT Melody Snack Indonesia', '{\"pembacaan_awal\":{\"waktu\":\"2025-01-31T06:00\",\"volume\":13930.6},\"pembacaan_akhir\":{\"waktu\":\"2025-01-31T15:53\",\"volume\":14053.21},\"volume_flow_meter\":122.61}', 3098670.66, 'belum_lunas', '2025-03-27 08:22:54', '2025-03-27 08:22:54');

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
(8, '2025_03_17_070714_pricing_history', 2);

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
('0wR1NrlNZmsvgBOtrovsDqG2yUi00c9aQQsZS4ez', NULL, '35.90.214.221', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiemVTbGJ0Q21hbVRURWo0UE5rM0h2RHA5SVo3WWF0SVpxWTdISGx1RyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743792146),
('20oazafOEs7f2lvWRooiQZYUT55MN7edkS1W8YyJ', NULL, '35.87.126.83', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieGFhVVlhZnRyeGpZcnF3Mk95RnNuY3l1U2NzZ3NPaVZYYVdIWjR1YSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743590931),
('31ytRvqObBlPLvzYhblWiaBnllgOjqaIpZvFQv0x', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYnJGZHRoNE9vOUlIY1ptYm1rcjRNSVdnbHd1SVc2NWVhblVzV1dGMyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743836122),
('3z9GTgoqGzaLrkqBEgZhQreEl7VGDn6XAdd4ebHl', NULL, '18.237.35.241', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidjNINGxIZnV5ZmRHd1RXSTJwYWZCYW9pYzhFVkxzOGozWE9DRG82cyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743408382),
('6FC8zYWC9foA0if8MhkS7abjsEGCFdjNZKSoFHlb', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibUdjRmVuSkJ2V2lyVHBISmM1RHI4eFRHSURnSzdWV05tNkYyVm1iOSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743383716),
('6GBIW9FWBpNJlBEGyhz5n1kUxSpYIrzvSOcs84JK', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVVpVZ3RsdFZWeGp5ZEMwbk8wTlJSOTNnclpiaklPekxLSUEySW9pViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743493915),
('72GKrItdZHVkODN1s8ZloMKLTHYEH5pxBCYT7d9Q', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTkR0eFY4T1M5S1A1MFlBR2FRR09MQlNKUnBPTk1hYXZDbFhNY3dEbyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743339509),
('7azFCgYUExdbYtZkaSvHXCSFQZh63fZlqBwHmJ1N', NULL, '54.213.224.129', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWFM5Y1N4MWI5ejhQVUIzbE11dnp0RTFFS3V4VGlNdHJSWmd5d2RDOCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743516054),
('7Sdo9vKTk6V07i3bcCEoxX53KmT0XljkKNmPxbl2', NULL, '54.218.117.171', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS2lrcUtuZ3NkV1kySUd4RElJNXlGZExSdEVpbnVWbGVjTFdublRQMCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743718655),
('7T8DCycVTlqqUVC4vFiM2WAbllit2MeB804ukjZb', NULL, '34.217.106.96', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWjZvcmtCQkdTb0hTNTJHbTlSMkU5eTRpY1NGY1A2d0tweUE3RzdWOCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743516931),
('95QJKJOGpe0ig0IqzKocg6C4XQW8SKVDADm2QfzQ', NULL, '35.91.171.91', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWk8xSkpLZ0N6amw0SlNTOUpXVElxZWl2RDVmTnVKRmt1SnN6RFFyZSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743582373),
('9pWgTljFVxv3URzrSvsYaLm8BJZcme38ercqoj3i', NULL, '35.163.210.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQno0dkJRczFvSEZDblR2WXBmT0Z0OG9CZjNvQThoRVlESm1NS2NTViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743829867),
('a6FeGXZXJmUdbnMiAOLhYiAaxa6H1rYGzWBwUG7J', NULL, '35.95.37.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWlRJczFVZVBHcEFodWRBdnRSNUVjam1NVEN2VE93Z3B3amlFWlFzOSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743993420),
('A6KQo577ICH0uCy430FATXrdfDVAb71FtyQLKxv4', NULL, '34.221.45.208', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOWxmRGttUDlsV1I5VHlxbWJJOVJXNnA1czVJMkJyajNGUWR5emV3USI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1744100096),
('AesJV3RYfHpNzsUMy3WTXbyJbpnuO3wuXzgDobl2', NULL, '44.244.71.83', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQnVzWGNGS3VFaUxtWURkVzhKV3UzYkFwTkYxOXduNU1NUUhhSEpjdyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743922856),
('b1Gls0hua7h4sdSjC9xzGG9yORLcoyMMx69n420O', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSTNqQ2JVTkY3ZWJyR2RaYkdHME9UTWxEMlhodUM4SUZDS1kzRkIzeSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743988015),
('bFLZD3inPSgLZOoCxi96aDrDK9ca3IO3D4q0YIUx', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRjhyWmdIZzJCWHBlaXRYdm1aUE9oMkFnaUJhamlxQTBjeGlsOHFoZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1744105713),
('C25zDd1Tng2FVYjJHpFtq49cvRaq0uU5abO8yXzC', NULL, '35.89.115.89', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicWd6RHdaSFU0ZG5VUjJ1RGkyOWk2SlpsbjBBRk5oWmFCZHd2cnJneCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743394361),
('dDMnzU3fUvSmMQ0JJYqCmczAXY8AAtqjEhtOYGkC', NULL, '34.222.219.179', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYlpNRWwzbWdXaUJXZ1RZZm5YN0VFRk5qNWZoZ0lwRWlyWU9teXNRcSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743493477),
('DoEHcJC325kA9ipInb5aFxfUBPagvftf5eRGqHmy', NULL, '18.236.204.122', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiallCZmNEUzl1bjRERlVvcnV4TmVPU0FrZ08yV3d1M0NUc25QRmNnSSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743516639),
('dpMNijxmOOsRtjydwWBrdeipUxjMyKy4WU08yMS5', NULL, '205.169.39.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.132 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUWNGWjF6dzBUc3NFdjRsWjVYRGU0SkJOVTMzcnIzdkJqZGJKSjZ3eSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1744009433),
('EkMJei2DEY4Dy7sNpT7p3LN2M2OTU3lhOIqZFr8V', NULL, '104.152.52.72', 'curl/7.61.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTTBpQk1CNHpQUmJ6Q3lvcDRXR01kYnZGeEN1ajYwRjJiMmlwZGhiSCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743614523),
('eLRhIXslkxm4U1LpPf2IztrcFk2TWNSvSLkwHyFz', NULL, '35.95.37.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVkdzS0tpb3JFWGliTVQ0Q0NvSXI2eDdHcGpTRUFlbzJDSVdsZTY1TSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743685436),
('ex4mNi16rzss1AY4F4JzpdPXYVNb6KFmBx6OiLiF', NULL, '35.91.171.91', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTXNnTzVNeGlzWE42cG9Pem55Qjc3dDJjM0RqQ3hobmV2MDVVZUlUaSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743582373),
('g8XYB51dooZwB5Cg3118R7YAYKUVL1PJC42QIvF3', NULL, '34.221.45.208', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibW1zVG9GNnpCU09SN3A3ZUpneUVNek9EQWNkRnllV3BUWHY3SllWeCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1744106647),
('GRCBWLIMICfq5ZkHf4KCRwut4h96ZcYFAfAHhyMK', NULL, '110.138.92.222', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNXpLdldOa0RMMnNmZW1OZDU5ODN5NUF3MG91THowbFVRbGVrMWlYaSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743312314),
('gTGO6xRZlgCrCKy72demxb0P5NEoDV45bxkVrxAH', NULL, '34.221.45.208', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGxJTnBDaDZSdXhJeVlNNW9kVmxQRFZ1QTRYSHNIcWx1TThQVHZ5aSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743293896),
('gZ3BytVpwvXYxJEdcBy2JXHZZsLrj4btNaFzFKk3', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN0FqdDBQRlJ6OGJVQTR4dVh3U3Q0SmhqZTl2WEpLS05XVGxoR1JiRCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743601353),
('ipQkQEs7BJkbVgBbnCEQwtk3S0NVl4TRYdV67SSf', NULL, '35.90.154.38', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibkw2d3VxbEd6cmd2UEpYYWxOTzRRWVNobkVlN0lrTVhlVjdPTkZmMSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1744001040),
('iWIw88Yo1bA3ij6ryDhgkMpf8Ex8FOnK6x6WSXkS', NULL, '44.244.202.68', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT2Jrd0dveWNDQ0M2U2J4dlZZQ1Y3enJVR3V0TTZ5SnNBWUFCZkZTWCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1744021553),
('IxAdUYps4M4uvNCo4XuaaZa8eUwLHziFYgwmr1fl', NULL, '54.213.241.79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic0xWNENDNzNxWnFXdTVha0xUZ2hyekFpOTFxOHpNdTc1NjNscDlFRyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743724312),
('IZfiG7hBrmAHaHda8OND1aEFoJ4WMOaBttTUva6u', NULL, '34.222.213.190', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSzNUTXhHQ0UyY3NUdmtSR1hNNW1UWjVhWmpUVFY2eGJ1N3Fxd2RTcyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743895491),
('k72Q8CSq4nzQP76Nrg4ShAjPjFmFDagXVuSxc05S', NULL, '54.190.168.64', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRzQxT1VweHo5SERoOTZXSEhnM1ltYkdSUU5DcjRXeWNpSXlabDNCRiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1744131907),
('kzXQqqD5b0Lt4m5uXxG50zBFHtQZL4ZWVMJ00Mou', NULL, '104.248.52.226', 'Mozilla/5.0 (compatible)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia2VHVWJnV0o3NjA5Qm43eVU1V3owUWNDYzBRMVBXTm9JaHRiV2pzSSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1744078330),
('L2VyIzblneFy4MOv4wlrjuwSakC1oTjMtSOWnHYv', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY0xjeUdTZkFMbFM5UXVmY2pBUTNJODhySkw5dE40b0tIbExkYXd1dSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743601353),
('M1RBPBSKYEpPRTmxhWzQVWJxjY71XErOlVQQ9k1H', NULL, '34.219.239.106', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRzhvVGV6R1NESW1KTTZRNXptTDFPcmJSaTQ1SzRxVmJkUjNraDNudSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743803826),
('M2vNWHnsx2EzvycwOsxEgVX0qDJHVo5w6wYTrk7F', NULL, '35.95.37.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaDZuVllzMnc5NUQwTjhpVVZzUXBwQ0xZN0NQN1ZMZnAxOWd4eUxjVCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743685437),
('mdI1u7KQ1ZwRvGf9CpOUiUmcoROOcx9KpLH0vkNR', NULL, '44.244.202.68', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibms3QUJraWlQSjJnRW9QNHNDbnFIelNSQjNITW4xS0Qxc0xWM0d0QSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1744021552),
('MShNvvtFFoqDNz4Omcjdo2Y4BO4T3A8xCDeiV2Hv', NULL, '34.216.125.143', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSVlYcTFFcFN6eG9PTU1yMTVNQnEzZkczVVRPUFlrVVd5QmlFWlRVYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743822085),
('mvZocuLs56a2YdtRiuvEIoK7fgy25WDNwxJETXj0', NULL, '34.222.219.179', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidWtMVm1lSzhyTXdqcTZqVG1qc2E3QW1nY2g4dXNwVHpINHZPRmdmbiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743493477),
('nwM9srTKvy4RQbbuukgli9oVYCp1yhSVjJnp0KMp', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicEQyZU1MY2JVMlN6cTZNVE9scEZJU0lSdDNQODBxVEl4WWIxRzNlZCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743755512),
('OJyM8O9X8V3KtyGo8wi7v4fbkrT2QvV6IPnkKUGe', NULL, '34.219.154.115', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRWRESElUSEQwVjFSeHJJZWVTOU1LU2ltN0YyZ3VDcHUxNW83eFZrbyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743605230),
('olHjkViydeV6h0SPylKCBRyeHkRVoz8329Okmr7x', NULL, '104.248.52.226', 'Mozilla/5.0 (compatible)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQm9nVWt4cXpMc0dTN252Z2sxMXdnZWVMWFVHaWNOcXhhdnFBcDVHeSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1744078338),
('OLu9ND49Vu0M1gvKKa0jRHZHJ8EkIRuEvcZtAnvc', NULL, '54.213.224.129', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMlBQamJ1NlhIeU1iTGdhVzF5WW5PNjROSXRibk9tWDZ6VzNqNTNLdSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743516053),
('Oots48urfjIpOFWOMVxKAk6jdrfGLmpjrjgFMz7v', NULL, '35.95.37.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY0E2RmZFRndGa09lSXlPalZ1a2RYUXBRazFBTExRdnNHaG5sSHJUaiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743993420),
('oX8y1FGn3R2ElTaGlx75NFVtJbyr3OqPSXlXfXHq', NULL, '35.89.115.89', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVkdwQjZKVll3dnJadFc3U2daNGhDZjZQS3F0dVhFODBKM0REVmRlUiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743394362),
('oysvSFvjyQQsIfpKyX7759GMFD7LLAiZ9bQhml4r', NULL, '35.90.214.221', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidEVtMnd4SzdiNEhrZG11anRTUVUycW9LVjNGVXpoSjhiemtCYzdTVSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743792145),
('p3gcboud0kH8x5g7i8iRkEAWTAk2I4jht2jxGDZK', NULL, '35.160.124.77', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTkNRRlBQbE9PVDhaanFLSFNvZngxQVJYd21zU3JOd2U1TUp5U1RqZSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1744022165),
('pOI9EdRcOatTg99dufMPTSMLmRjA24KWmsmvH1O2', NULL, '34.222.213.190', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOTN6RmMwSUpkRk1GWEdyYlQxaU9hYWRMa1RqMkJ3NnhhRjBrWmpXVSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743895491),
('PX1PZ3ujPUTSUI0KcWFW0JRmiQb5dXeHUrk7hvch', NULL, '167.99.206.36', 'Mozilla/5.0 (compatible)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic3ZZREhEUzdTUThybTNXdlFXZmE1b0ZwVHU1ejQ3T3phWmNoNWFpbCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743867002),
('q1oWx5z79k4Jh3JwFYaHvLmBJ7fKbcMr4ABQ0wPh', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibUdSRXR6eXBUM0JxOUZpZ2VSMmZBRzllcGxzcWhjSjdzZHVsRzQ3TyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743339509),
('qae28RIwqPKldusGPfPNqTncJRJEi6UQKAHOWEYo', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWWRwb0hUMzlJUVdLdU9vdGZvZ1l5UDg0SkJ1SUlWaEw1QjJBd201aSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743949407),
('qcw3AboWTe3EfEkPhMzrnVetRABTreehLlCni1ko', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZWRLbEd0aldFa1lNVzdVVzAzY3hlYldNVHMyTFVPTUY5UXQ0QmxmRiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743675186),
('qfMXkR7tcvW9DK4kyKGNcefE9o8tTJe9QIPqBG7N', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibDhCRnVPaWdJckhXNG5odDNXVVdkZ2NVNGRoRTVFbEt5WkpwWjZwYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743836122),
('qPKqoLp1M3a0PVCcbBFcqcrPtZXlRRLfwS90eqpS', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZkdxTWNVZktObjV4SnBlNEJFdkVud2NndDhZWmcwTkRGb1RGWGlsVCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743675186),
('R8eYUslCBOEViVK9zM2GW5H1yRyHieLCuaKwsvfC', NULL, '54.218.240.44', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNDNLSFVQcDBqcWlQRFdVNzliNm95aTdLQXhkWVNYc1lyTW9SR3JyUCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743353198),
('r9Z6junvkIddLdQL5yfpaOUwwGQu3Z6nrM0ibta7', NULL, '34.221.45.208', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVlNla3NySGJadGN1R213QTZEd2hmOG5kZ0draU4ydDJMdXBwbTA2SyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1744100097),
('rgVkzQKz7pdjhnLYklHGXolEhIxbQc2pwdvTyMvp', NULL, '198.235.24.169', '', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR3R4Sko1azNiakw1MHc5S2FETVdSNWJnVkVlUHpnREdnQTlod24wSCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743290905),
('SDj8CIaHMnYOtQAMg2x6yLmvNaZRqVtCjso4Qdgv', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMDFCS0JBdjBNbXdMeTVGekhRc0xqZW9YSzNVRzdZckpHM3h6VmdtSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743949407),
('sUhG3Ul19Hj5hDFlBByGrVELMXwyLbwx4NYhR1v5', NULL, '54.245.209.215', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWlg2dXRFdVFsb2ppRldPblNyY0VxeTFaNG5iRVpLTnIzMUFZNU5zMyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743926246),
('szNt6bLjLTPk0ABbxuzA1XzlZaKydCUUt99bazbu', NULL, '34.216.125.143', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibThPdFg2SUJkRmNyT004Rk01UTZsTGlrUHFlajVQREh5Vk5vRTF2MiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743822086),
('t8yDOzMpWm2A1ijAJbFWs4T0J7n84KjPTWrTZ5TA', NULL, '18.246.35.134', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ2tmdldSZk5JdXNWbkhqUHRBOGVQeEhBaTR2V1VQR2p3amdwcHFmNiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743895998),
('TaiNss9Bt0zEjTlp3gGIV0a7fZo6UNp93E49LJs2', NULL, '35.90.154.38', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRnd4Y1Y2UEh3U3ZYZGFxRWlJZFZ0WEdHVVJIRDZZSXBBQ0dVWmI5RSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743625977),
('TIPPxXKhaWMFw2ZVyYKpISAq9s7VSHWoOEY5Mb2s', NULL, '54.218.240.44', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid3VGY1pNNU0xc2lMdmtCQnZIbjd3aUdtNFFnTWp1MG9iUjZNUnY0RyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743353199),
('tYCdH6yPrpaunfMD0eEWzqbk3RRMX0ZxoPkLP9Ah', NULL, '18.236.242.124', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib2MzZGY1bDlsWTR0QTBoYjllT2Y5ZHpCcmVEUlZtQWtpeFBQRTBJOSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743381027),
('uDqG6UZUNXq1JTyuclvv64OrvB5LA39NXilFKVt5', NULL, '167.99.206.36', 'Mozilla/5.0 (compatible)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibnpoMU1VMDBHbEJqM0taYUcwZlo4eXMxTUQxRVE4Zkt5NXBtbU16NyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743867003),
('Ugacu0OU9VGxlR4hRiNpDqnVBPFRWjlL43ylqhpr', NULL, '44.243.104.220', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYTJLcXBkYVBROW5SRDh3TlpNNlRzWjRZblB4cThyOHNDeHhEOWNiWCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743494287),
('UpCOZTjT2lrinqkl6ZLAt61BWSqzMK3iLa0rZUPA', NULL, '52.48.11.71', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUxNNHhPR1c3MWFIU0hxTTBRSnpQa2xGeUtPVDZRc3VlUUpqT1FFViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743856463),
('uu6UhWSeswG1qHEQckfpBZ1VFmdbu9CnYKJLt6rm', NULL, '18.237.197.10', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiemNUQjFhYWt4d1RTcW40dWdLeURxblM3YmFuQ2ZXbHd5Rm04WnJWdyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1744118158),
('V2i7sF3X2K76yKgnjrbGfTP1nvZtpsLskNHQJhwf', NULL, '34.219.154.115', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRG4xVU53Z2ZpNmN0MmNTaERuVVUxaXNKNERnYmZSYVdudFV3ZUJMNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743605231),
('vg3nXuUmqBiGkUYJJdlQlapm2aSsAwRc2JrffsN4', NULL, '52.48.11.71', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibDVKWHFOUmROM3E5WHBMZGVrVTRrekV6d09MbWNXMU9HOEVwUmx2QiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743856459),
('VmwP07wCbUOy1FnLCgQKmZDzg3TTcGPpwESmXPDQ', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVHE0NmFmTVh5Nm93YUQ3dVBnMlpMeTVrbGg2OGtXcVdtOFJCVFE1ayI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDI6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743755512),
('vrlhKo3MtleMEu3ICPlrD4Y9iTs7bRV7hIbbKeaH', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaXVWeXVXZlpjR2xLRzBHRTVTdFB1RjEzUHhBbVNXSDlFSU91V2dvYSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743493915),
('VU0UGRXRQq888unuAfxeOnXrqmwbhge7zvoTkRfx', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMXA2S3ZVeVJVSzF1cXNISEtjSHE4V0VHNW1mN1VaMUZKa0M1QmZ1VSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743988015),
('XnyZzeokZypyVUTsHNFIPW9DFejBdUAn0AAAffhn', NULL, '18.237.197.10', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibmxHN1Vnb2pUSzM3eWU2S2JNaGVlR2Q4R2llaDdUNTF0TUpSZTMxeCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1744118157),
('y4lfH4LpvDOvfEGrTGEQsJRWxLXALSiFxncVOzSc', NULL, '54.218.117.171', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVXBvY1ZOTmxETklLOWo0VExUUUN5cDY5OFhFZ1VnblJCcHBSRHlBMiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743718655),
('YIKOyheswg9AkIigaogJKsXqMVt5l7MYlBFQBzG8', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS1hRMFk4YkdBeUNsR2Z0dVFnYTJ0SVVVeTlOaWJDZHc1MkE3b1oxZyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1744105713),
('yUTqS9BkPV9OTaheKVX0qWbQTtJ1vnBZlQwX88Qw', NULL, '198.235.24.169', '', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYWZZSTMydkM2bUY3Nm1RUVJVNFZteXJYakI3ME50R1ZOZUkwVHJ6QSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743290905),
('YUwOug4C47KPNTobQvvT1mZ9g6mbmFz2KDUHn6V7', NULL, '2a02:4780:6:c0de::10', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibzdqVlZWYjBRVzd3N2Zsem94bkwwRUVFTHNwQkFEd2Nmd29vUjlSYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743383716),
('zHFTtqZmHlJ4oMWotc6KaCNi1zjirn0Fz3KSirfx', NULL, '35.90.171.130', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZFhRRFlWQW8yZ1lxaERrSDQ0elRVdVk2UHQ3ZWhiZGFQR0tEcGlObCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vd3d3LmNuZy5tb3NhZmFwcmltYXNpbmVyZ2kuY28uaWQvbG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1743698305),
('ZoszOGloc5mFFAawFcQ3WL5LcDdXFoyzAtWcf2bM', NULL, '44.244.71.83', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibkxEU29vWVFGQVVXQ2MxWkhIQlp3RXhWSnlDbGU0d05IQmZWZEtLcyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vY25nLm1vc2FmYXByaW1hc2luZXJnaS5jby5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1743922855);

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
  `role` enum('admin','superadmin','customer','demo','fob') NOT NULL DEFAULT 'customer',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `harga_per_meter_kubik` decimal(10,2) DEFAULT 0.00 COMMENT 'Harga per meter kubik',
  `tekanan_keluar` decimal(10,3) DEFAULT 0.000 COMMENT 'Tekanan keluar dalam Bar',
  `suhu` decimal(10,2) DEFAULT 0.00 COMMENT 'Suhu dalam Celsius',
  `koreksi_meter` decimal(16,14) DEFAULT 1.00000000000000 COMMENT 'Faktor koreksi meter'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `total_deposit`, `total_purchases`, `deposit_history`, `pricing_history`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`, `harga_per_meter_kubik`, `tekanan_keluar`, `suhu`, `koreksi_meter`) VALUES
(2, 'Super Administrator', 'superadmin@example.com', 0.00, 0.00, NULL, NULL, NULL, '$2y$12$i9AfftwMoerCSLwsqKCGiea4KS0ZcbwaumTvsFnWGsLu2h.k32VPy', 'superadmin', NULL, '2025-03-12 06:30:45', '2025-03-12 06:30:45', 0.00, 0.000, 0.00, 1.00000000000000),
(3, 'Administrator', 'admin@example.com', 0.00, 0.00, NULL, NULL, NULL, '$2y$12$H0GcLLTZK6Eu0FWMmOdTo.utnOZH/Cu2GSVvriYK8CsorC54vlmuG', 'admin', NULL, '2025-03-12 06:30:46', '2025-03-12 06:30:46', 0.00, 0.000, 0.00, 1.00000000000000),
(7, 'Hendri', 'hendri9275@gmail.com', 0.00, 0.00, NULL, NULL, NULL, '$2y$12$FGdz9ksBuEHYc23pUpXArONdE3.1VsXTt5ogUCSEqNfJfostlkDHi', 'admin', NULL, '2025-03-18 06:52:21', '2025-03-18 06:52:21', 0.00, 0.000, 0.00, 1.00000000000000),
(8, 'PT Nomi Bogasari Indonesia', 'nomi@mps.com', 721965696.00, 633023280.16, '[{\"date\":\"2025-01-01 06:00:00\",\"amount\":83565696,\"description\":\"Saldo dari bulan desember 2024\"},{\"date\":\"2025-01-04 19:00:00\",\"amount\":91200000,\"description\":\"Top up\"},{\"date\":\"2025-01-17 17:00:00\",\"amount\":91200000,\"description\":\"Top up\"},{\"date\":\"2025-02-03 13:41:00\",\"amount\":91200000,\"description\":\"Top Up\"},{\"date\":\"2025-02-08 13:43:00\",\"amount\":91200000,\"description\":\"Top Up\"},{\"date\":\"2025-02-15 13:43:00\",\"amount\":91200000,\"description\":\"Top Up\"},{\"date\":\"2025-02-21 13:44:00\",\"amount\":91200000,\"description\":\"Top Up\"},{\"date\":\"2025-03-07 10:08:00\",\"amount\":91200000,\"description\":\"Top Up\"}]', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":9500,\"tekanan_keluar\":3.3,\"suhu\":30,\"koreksi_meter\":4.2425168},{\"date\":\"2025-01-01 00:00:00\",\"year_month\":\"2025-01\",\"harga_per_meter_kubik\":9500,\"tekanan_keluar\":3.3,\"suhu\":30,\"koreksi_meter\":4.2425168},{\"date\":\"2025-02-01 00:00:00\",\"year_month\":\"2025-02\",\"harga_per_meter_kubik\":9500,\"tekanan_keluar\":3.3,\"suhu\":30,\"koreksi_meter\":4.2425168}]', NULL, '$2y$12$PMt/6tpZhMUpgo9C1RCvZudkigM51gjuVH2/xwLtBgVzjeAHOW8be', 'customer', NULL, '2025-03-18 06:54:11', '2025-03-27 07:24:24', 9500.00, 3.300, 30.00, 4.24251680090290),
(9, 'PT Melody Snack Indonesia', 'melody@mps.com', 121574360.00, 64848674.29, '[{\"date\":\"2025-03-01 07:33:00\",\"amount\":81674360,\"description\":\"saldo bulan Februari 2025\"},{\"date\":\"2025-03-20 10:41:00\",\"amount\":39900000,\"description\":\"Deposit\"}]', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":9500,\"tekanan_keluar\":1.7,\"suhu\":30,\"koreksi_meter\":2.66027126}]', NULL, '$2y$12$x0okLhxZmbTF3IpQRoXOUebaYuszBf82iVvR0T8D932jmHewgaOXC', 'customer', NULL, '2025-03-18 07:14:09', '2025-03-27 08:22:54', 9500.00, 1.700, 30.00, 2.66027125732560),
(10, 'PT Raja Roti Cemerlang', 'rrc@mps.com', 0.00, 3795941.06, '\"[]\"', '[{\"date\":\"2025-01-01 00:00:00\",\"year_month\":\"2025-01\",\"harga_per_meter_kubik\":9500,\"tekanan_keluar\":1.7,\"suhu\":30,\"koreksi_meter\":2.66027126}]', NULL, '$2y$12$RYxIc8TfZpvkIXV2qCR76ekrDOM78kmfZc8qQ5oR/IQpuemu.9oyi', 'customer', NULL, '2025-03-18 07:14:43', '2025-03-27 07:51:29', 9500.00, 1.700, 30.00, 2.66027125732560),
(11, 'PT SUI ZHI JIE Indonesia', 'sui@mps.com', 0.00, 0.00, '\"[]\"', '\"[]\"', NULL, '$2y$12$190BEnDXTYYDmrwnmDfc1.GBKi6lyoIFYP0UOsgWMA30s2rHQj2i2', 'customer', NULL, '2025-03-18 07:17:02', '2025-03-18 07:17:02', 0.00, 0.000, 0.00, 1.00000000000000),
(12, 'Demo User', 'demo@mps.com', 10000000.00, 10830445.90, '[{\"date\":\"2025-03-27 04:51:00\",\"amount\":10000000,\"description\":null}]', '[{\"date\":\"2025-03-01 00:00:00\",\"year_month\":\"2025-03\",\"harga_per_meter_kubik\":9000,\"tekanan_keluar\":3,\"suhu\":25,\"koreksi_meter\":4.01127626}]', NULL, '$2y$12$Wge53lqDifbogoOd6zEqIe20Lo9sMMIL2Tu7W1r09UYk0qYop6KUm', 'demo', NULL, NULL, '2025-03-27 04:52:19', 9000.00, 3.000, 25.00, 4.01127626000000);

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=189;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `data_pencatatan`
--
ALTER TABLE `data_pencatatan`
  ADD CONSTRAINT `data_pencatatan_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
