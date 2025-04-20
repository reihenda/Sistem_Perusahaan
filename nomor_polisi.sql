-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 09, 2025 at 02:56 AM
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
-- Table structure for table `nomor_polisi`
--

CREATE TABLE `nomor_polisi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nopol` varchar(20) NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nomor_polisi`
--

INSERT INTO `nomor_polisi` (`id`, `nopol`, `keterangan`, `created_at`, `updated_at`) VALUES
(1, 'B9037SAN', NULL, '2025-04-07 04:03:27', '2025-04-07 04:03:27'),
(2, 'B9037SDE', NULL, '2025-04-06 21:10:33', '2025-04-06 21:10:33'),
(3, 'B9037DDD', NULL, '2025-04-07 19:39:05', '2025-04-07 19:39:05'),
(4, 'B9038AAA', NULL, '2025-04-07 19:51:57', '2025-04-07 19:51:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `nomor_polisi`
--
ALTER TABLE `nomor_polisi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nomor_polisi_nopol_unique` (`nopol`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `nomor_polisi`
--
ALTER TABLE `nomor_polisi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
