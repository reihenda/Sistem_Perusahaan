<?php

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use App\Models\FinancialAccount;

// Create template Excel for Kas transactions
$spreadsheet = new Spreadsheet();
$sheet = $spreadsheet->getActiveSheet();

// Set judul
$sheet->setCellValue('A1', 'TEMPLATE UPLOAD KAS TRANSAKSI');
$sheet->mergeCells('A1:F1');
$sheet->getStyle('A1')->getFont()->setBold(true)->setSize(14);
$sheet->getStyle('A1')->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

// Set header
$headers = ['Tanggal', 'Voucher', 'Account', 'Deskripsi', 'Credit', 'Debit'];
$sheet->fromArray($headers, null, 'A3');

// Format header
$sheet->getStyle('A3:F3')->getFont()->setBold(true);
$sheet->getStyle('A3:F3')->getFill()
    ->setFillType(Fill::FILL_SOLID)
    ->getStartColor()->setRGB('E2E8F0');
$sheet->getStyle('A3:F3')->getBorders()->getAllBorders()
    ->setBorderStyle(Border::BORDER_THIN);

// Set contoh data
$exampleData = [
    ['2025-06-04', '', 'Kas Kecil', 'Pembelian ATK', '50000', ''],
    ['2025-06-04', '', 'Kas Kecil', 'Pembayaran Transport', '', '25000'],
    ['2025-06-05', '', 'Kas Besar', 'Penerimaan dari Bank', '1000000', ''],
];
$sheet->fromArray($exampleData, null, 'A4');

// Format data example
$sheet->getStyle('A4:F6')->getBorders()->getAllBorders()
    ->setBorderStyle(Border::BORDER_THIN);

// Auto width
foreach (range('A', 'F') as $col) {
    $sheet->getColumnDimension($col)->setAutoSize(true);
}

// Set instruksi
$sheet->setCellValue('A8', 'INSTRUKSI:');
$sheet->getStyle('A8')->getFont()->setBold(true);

$instructions = [
    '1. Tanggal: Format YYYY-MM-DD (contoh: 2025-06-04)',
    '2. Voucher: Kosongkan, akan di-generate otomatis oleh sistem',
    '3. Account: Nama account yang tersedia di sistem',
    '4. Deskripsi: Keterangan transaksi (opsional)',
    '5. Credit: Nominal kredit (masuk), kosongkan jika debit',
    '6. Debit: Nominal debit (keluar), kosongkan jika kredit',
    '7. Hapus baris contoh ini sebelum upload',
    '8. Pastikan minimal salah satu Credit atau Debit terisi'
];

$row = 9;
foreach ($instructions as $instruction) {
    $sheet->setCellValue('A' . $row, $instruction);
    $row++;
}

// Set list account yang tersedia (hardcoded untuk template)
$sheet->setCellValue('H3', 'CONTOH ACCOUNT TERSEDIA:');
$sheet->getStyle('H3')->getFont()->setBold(true);

$sampleAccounts = [
    'Kas Kecil',
    'Kas Besar', 
    'Kas Operasional',
    'Petty Cash'
];

$row = 4;
foreach ($sampleAccounts as $account) {
    $sheet->setCellValue('H' . $row, $account);
    $row++;
}

// Save file
$filename = 'template_kas_' . date('Y-m-d') . '.xlsx';
$writer = new Xlsx($spreadsheet);
$writer->save(__DIR__ . '/../public/templates/kas/' . $filename);

echo "Template Excel berhasil dibuat: " . $filename . PHP_EOL;
