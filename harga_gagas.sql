-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 17, 2025 at 12:07 PM
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
-- Table structure for table `harga_gagas`
--

CREATE TABLE `harga_gagas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `harga_usd` decimal(10,2) NOT NULL COMMENT 'Harga dalam USD',
  `rate_konversi_idr` decimal(10,2) NOT NULL COMMENT 'Rate konversi USD ke IDR',
  `kalori` decimal(10,2) NOT NULL COMMENT 'Nilai kalori untuk konversi ke MMBTU',
  `periode_tahun` int(11) NOT NULL COMMENT 'Tahun periode berlaku',
  `periode_bulan` int(11) NOT NULL COMMENT 'Bulan periode berlaku',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `harga_gagas`
--

INSERT INTO `harga_gagas` (`id`, `harga_usd`, `rate_konversi_idr`, `kalori`, `periode_tahun`, `periode_bulan`, `created_at`, `updated_at`) VALUES
(4, 11.70, 16264.78, 23.00, 2025, 8, '2025-08-13 01:33:09', '2025-08-13 01:57:11'),
(5, 12.00, 16264.78, 26.00, 2025, 6, '2025-08-13 02:32:43', '2025-08-13 02:32:43');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `harga_gagas`
--
ALTER TABLE `harga_gagas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_periode_harga_gagas` (`periode_tahun`,`periode_bulan`),
  ADD KEY `harga_gagas_periode_tahun_periode_bulan_index` (`periode_tahun`,`periode_bulan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `harga_gagas`
--
ALTER TABLE `harga_gagas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
