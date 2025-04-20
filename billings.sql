-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 15, 2025 at 06:16 AM
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
(5, 14, '004/MPS/BIL-PT M/04/2025', '2025-04-14', 5774.81, 23099248.42, 22222222.00, 4312154.77, 3435128.35, 0.00, 3, 2025, 'unpaid', '2025-04-14 01:05:53', '2025-04-14 01:05:53');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `billings`
--
ALTER TABLE `billings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `billings_customer_id_foreign` (`customer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `billings`
--
ALTER TABLE `billings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billings`
--
ALTER TABLE `billings`
  ADD CONSTRAINT `billings_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
