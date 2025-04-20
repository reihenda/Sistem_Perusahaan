-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 15, 2025 at 06:18 AM
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
(2, 14, '', '001/MPS/INV-PT M/04/2025', '2025-04-12', '2025-04-22', 0.00, '', 'unpaid', 'hgjhgjy', 4, 2025, '2025-04-11 20:31:27', '2025-04-11 20:31:27'),
(4, 5, '03C0005', '003/MPS/INV-APA/04/2025', '2025-04-12', '2025-04-22', 1667019484724.90, '001/PJBG-MPS/I/2025', 'paid', NULL, 4, 2025, '2025-04-11 22:14:22', '2025-04-12 20:23:08'),
(6, 14, '03C0014', '002/MPS/INV-PT MELODI SNACK INDONESIA/04/2025', '2025-04-13', '2025-04-23', 0.00, '001/PJBG-MPS/I/2025', 'unpaid', 'dd', 4, 2025, '2025-04-12 21:19:44', '2025-04-12 21:19:44'),
(7, 14, '03C0014', '003/MPS/INV-PT MELODI SNACK INDONESIA/04/2025', '2025-04-13', '2025-04-23', 0.00, '001/PJBG-MPS/I/2025', 'unpaid', 'Pemakaian CNG', 4, 2025, '2025-04-12 21:22:08', '2025-04-12 21:22:08');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoices_customer_id_foreign` (`customer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
