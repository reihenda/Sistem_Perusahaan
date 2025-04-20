-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 09, 2025 at 02:54 AM
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
-- Table structure for table `rekap_pengambilan`
--

CREATE TABLE `rekap_pengambilan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tanggal` datetime DEFAULT NULL,
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

INSERT INTO `rekap_pengambilan` (`id`, `tanggal`, `customer_id`, `nopol`, `volume`, `keterangan`, `created_at`, `updated_at`) VALUES
(1, '2025-04-07 00:00:00', 18, 'B9037SAN', 200.00, NULL, '2025-04-06 20:18:23', '2025-04-06 20:18:23'),
(2, '2025-03-07 00:00:00', 17, 'B9037SAN', 300.00, NULL, '2025-04-06 20:19:22', '2025-04-06 20:19:22'),
(3, '2025-04-03 00:00:00', 18, 'B9037SAN', 400.00, NULL, '2025-04-06 20:32:54', '2025-04-06 20:32:54'),
(4, '2025-04-08 03:02:00', 17, 'B9038AAA', 600.00, NULL, '2025-04-07 20:02:39', '2025-04-07 20:02:39'),
(5, '2025-04-08 03:16:00', 14, 'B9037DDD', 500.00, NULL, '2025-04-07 20:16:58', '2025-04-07 20:16:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rekap_pengambilan_customer_id_foreign` (`customer_id`),
  ADD KEY `rekap_pengambilan_nopol_foreign` (`nopol`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `rekap_pengambilan`
--
ALTER TABLE `rekap_pengambilan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

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
