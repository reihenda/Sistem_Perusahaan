-- SQL Script untuk membuat tabel proforma_invoices
-- Jalankan script ini jika ingin membuat tabel secara langsung tanpa migration

CREATE TABLE `proforma_invoices` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `proforma_number` varchar(255) NOT NULL,
  `proforma_date` date NOT NULL,
  `due_date` date NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `total_volume` decimal(10,3) NOT NULL DEFAULT 0.000,
  `status` enum('draft','sent','expired','converted') NOT NULL DEFAULT 'draft',
  `description` text DEFAULT NULL,
  `no_kontrak` varchar(255) NOT NULL,
  `id_pelanggan` varchar(255) NOT NULL,
  `period_start_date` date NOT NULL,
  `period_end_date` date NOT NULL,
  `validity_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `proforma_invoices_customer_id_foreign` (`customer_id`),
  KEY `proforma_invoices_customer_id_proforma_date_index` (`customer_id`,`proforma_date`),
  KEY `proforma_invoices_status_index` (`status`),
  CONSTRAINT `proforma_invoices_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
