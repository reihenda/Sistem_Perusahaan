<?php

namespace App\Http\Controllers;

use App\Models\KasTransaction;
use App\Models\FinancialAccount;
use App\Jobs\ProcessKasExcelImport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;
use Carbon\Carbon;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;

class KasExcelController extends Controller
{
    /**
     * Parse number dari Excel dengan handling berbagai format
     */
    private function parseNumber($value)
    {
        // Jika null atau kosong, return 0
        if (is_null($value) || $value === '' || $value === false) {
            return 0;
        }

        // Jika sudah numeric, langsung return
        if (is_numeric($value)) {
            return (float)$value;
        }

        // Jika string, bersihkan dari format ribuan
        if (is_string($value)) {
            // Hapus spasi dan currency symbol
            $cleaned = preg_replace('/[^\d.,-]/', '', trim($value));

            // Handle format Indonesia (250.000,50) vs International (250,000.50)
            // Urutan pengecekan penting: decimal dulu, baru thousand

            // 1. Format Indonesia dengan desimal: 250.000,50 (HARUS ada titik DAN koma)
            if (preg_match('/^\d{1,3}(\.\d{3})+,\d+$/', $cleaned)) {
                // Format Indonesia: 250.000,50 -> 250000.50
                $parts = explode(',', $cleaned);
                $integerPart = str_replace('.', '', $parts[0]);
                $decimalPart = $parts[1];
                $cleaned = $integerPart . '.' . $decimalPart;
            }
            // 2. Format International dengan desimal: 250,000.50 (HARUS ada koma DAN titik)
            elseif (preg_match('/^\d{1,3}(,\d{3})+\.\d+$/', $cleaned)) {
                // Format International: 250,000.50 -> 250000.50
                $parts = explode('.', $cleaned);
                $integerPart = str_replace(',', '', $parts[0]);
                $decimalPart = $parts[1];
                $cleaned = $integerPart . '.' . $decimalPart;
            }
            // 3. Format Indonesia ribuan tanpa desimal: 250.000 (hanya titik untuk ribuan)
            elseif (preg_match('/^\d{1,3}(\.\d{3})+$/', $cleaned)) {
                // Format Indonesia ribuan: 250.000 -> 250000
                $cleaned = str_replace('.', '', $cleaned);
            }
            // 4. Format International ribuan tanpa desimal: 250,000 (hanya koma untuk ribuan)
            elseif (preg_match('/^\d{1,3}(,\d{3})+$/', $cleaned)) {
                // Format International ribuan: 250,000 -> 250000
                $cleaned = str_replace(',', '', $cleaned);
            }

            if (is_numeric($cleaned)) {
                return (float)$cleaned;
            }
        }

        // Fallback: coba convert ke float
        return (float)$value;
    }

    /**
     * Parse date dari string dengan format DD/MM/YYYY atau berbagai format lainnya
     */
    private function parseDate($value)
    {
        if (empty($value) && !is_numeric($value) && !($value instanceof \DateTime)) {
            throw new \Exception('Tanggal tidak boleh kosong');
        }

        // Handle DateTime object atau Carbon (dari Excel)
        if ($value instanceof \DateTime) {
            return Carbon::instance($value);
        }

        // Handle Carbon object directly
        if ($value instanceof Carbon) {
            return $value;
        }

        // Handle ISO datetime string from Excel (like "2025-05-01T16:59:48.000Z")
        if (is_string($value) && preg_match('/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/', $value)) {
            try {
                $date = Carbon::parse($value);
                if ($date && $date->year >= 2000 && $date->year <= 2100) {
                    \Log::info("Parsed ISO datetime from Excel: {$value} -> {$date->toDateString()}");
                    return $date;
                }
            } catch (\Exception $e) {
                // Continue to other parsing methods
            }
        }

        // Handle special case: jika value adalah string "Date" (header)
        if (is_string($value) && strtolower(trim($value)) === 'date') {
            throw new \Exception('Baris ini adalah header, bukan data tanggal');
        }

        // Jika numeric (Excel date serial number)
        if (is_numeric($value) && $value > 0) {
            try {
                // Excel date serial number (days since 1900-01-01)
                $unixTimestamp = ($value - 25569) * 86400;
                return Carbon::createFromTimestamp($unixTimestamp);
            } catch (\Exception $e) {
                // Continue to other parsing methods
            }
        }

        // Convert to string and trim
        $stringValue = trim(strval($value));

        if (empty($stringValue) || strtolower($stringValue) === 'date') {
            throw new \Exception('Format tanggal tidak valid atau merupakan header');
        }

        // Try parsing berbagai format tanggal

        // SPECIAL: Handle Excel formatted dates like "02-May-25" or "2-May-25"
        if (preg_match('/^(\d{1,2})-(\w{3})-(\d{2})$/', $stringValue, $matches)) {
            $day = str_pad($matches[1], 2, '0', STR_PAD_LEFT); // Ensure 2 digits
            $monthName = $matches[2];
            $year2digit = $matches[3];

            // Convert 2-digit year to 4-digit
            // Rule: 00-30 = 2000-2030, 31-99 = 1931-1999 (but we'll use 2000+ for business context)
            $yearInt = intval($year2digit);
            if ($yearInt <= 30) {
                $year = 2000 + $yearInt;
            } else {
                $year = 2000 + $yearInt; // For business context, assume all years are 2000+
            }

            try {
                // Try multiple format variations
                $formatVariations = [
                    'd-M-Y',   // 02-May-2025
                    'j-M-Y',   // 2-May-2025
                ];

                foreach ($formatVariations as $format) {
                    try {
                        $testDateString = $day . '-' . $monthName . '-' . $year;
                        $date = Carbon::createFromFormat($format, $testDateString);

                        if ($date && $date->year >= 2000 && $date->year <= 2100) {
                            \Log::info("Successfully parsed Excel date: {$stringValue} -> {$date->toDateString()} using format {$format}");
                            return $date;
                        }
                    } catch (\Exception $e) {
                        continue; // Try next format
                    }
                }

                // Fallback: Try with original string and let Carbon parse it
                $fullDateString = $day . '-' . $monthName . '-' . $year;
                $date = Carbon::parse($fullDateString);
                if ($date && $date->year >= 2000 && $date->year <= 2100) {
                    \Log::info("Parsed Excel date with Carbon::parse fallback: {$stringValue} -> {$date->toDateString()}");
                    return $date;
                }
            } catch (\Exception $e) {
                \Log::warning("Failed to parse Excel date format {$stringValue}: " . $e->getMessage());
                // Continue to other parsing methods
            }
        }

        // 1. Try parsing ISO datetime format first (Excel exports)
        if (preg_match('/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/', $stringValue)) {
            try {
                return Carbon::parse($stringValue);
            } catch (\Exception $e) {
                // Continue to other formats
            }
        }

        // 2. Try parsing standard datetime formats
        $dateFormats = [
            'Y-m-d H:i:s',
            'Y-m-d',
            'd/m/Y H:i:s',
            'd/m/Y',
            'd-m-Y H:i:s',
            'd-m-Y',
            'm/d/Y',
            'Y/m/d',
            'd-M-Y',      // 02-May-2025
            'j-M-Y',      // 2-May-2025
            'd-M-y',      // 02-May-25 (with 2-digit year handling)
            'j-M-y',      // 2-May-25 (with 2-digit year handling)
            'j M Y',      // 2 May 2025
            'M j, Y'      // May 2, 2025
        ];

        foreach ($dateFormats as $format) {
            try {
                $date = Carbon::createFromFormat($format, $stringValue);
                if ($date) {
                    // Handle 2-digit year formats specially
                    if (strpos($format, '-y') !== false || strpos($format, '/y') !== false) {
                        // If year is less than 50, assume 20xx, otherwise 19xx
                        // But for business context, we'll assume 20xx
                        if ($date->year < 1950) {
                            $date->addYears(100); // Convert 1925 to 2025
                        }
                    }

                    if ($date->year > 1900 && $date->year < 2100) {
                        \Log::info("Parsed date using format {$format}: {$stringValue} -> {$date->toDateString()}");
                        return $date;
                    }
                }
            } catch (\Exception $e) {
                continue;
            }
        }

        // 3. Try parsing DD/MM/YYYY format (Indonesian format)
        if (preg_match('/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/', $stringValue, $matches)) {
            $day = $matches[1];
            $month = $matches[2];
            $year = $matches[3];

            // Validate date components
            if (!checkdate($month, $day, $year)) {
                throw new \Exception('Tanggal tidak valid');
            }

            return Carbon::createFromFormat('d/m/Y', $stringValue);
        }

        // 4. Try parsing DD-MM-YYYY format
        if (preg_match('/^(\d{1,2})-(\d{1,2})-(\d{4})$/', $stringValue, $matches)) {
            $day = $matches[1];
            $month = $matches[2];
            $year = $matches[3];

            if (!checkdate($month, $day, $year)) {
                throw new \Exception('Tanggal tidak valid');
            }

            return Carbon::createFromFormat('d-m-Y', $stringValue);
        }

        // 5. Try parsing YYYY-MM-DD format (fallback for international format)
        if (preg_match('/^(\d{4})-(\d{1,2})-(\d{1,2})$/', $stringValue, $matches)) {
            $year = $matches[1];
            $month = $matches[2];
            $day = $matches[3];

            if (!checkdate($month, $day, $year)) {
                throw new \Exception('Tanggal tidak valid');
            }

            return Carbon::createFromFormat('Y-m-d', $stringValue);
        }

        // Last resort: try Carbon parse
        try {
            $parsed = Carbon::parse($stringValue);
            if ($parsed && $parsed->year > 1900 && $parsed->year < 2100) {
                return $parsed;
            }
        } catch (\Exception $e) {
            // Continue to error
        }

        throw new \Exception('Format tanggal tidak didukung: "' . $stringValue . '". Gunakan format DD/MM/YYYY atau format standar Excel');
    }

    /**
     * Download template Excel untuk kas
     */
    public function downloadTemplate()
    {
        // Get accounts untuk template
        $accounts = FinancialAccount::active()->ofType('kas')->orderBy('account_name')->get();

        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();



        // Set header
        $headers = ['Date', 'Voucher', 'Account', 'Description', 'Credit', 'Debit'];
        $sheet->fromArray($headers, null, 'A1');

        // Format header
        $sheet->getStyle('A1:F1')->getFont()->setBold(true);
        $sheet->getStyle('A1:F1')->getFill()
            ->setFillType(Fill::FILL_SOLID)
            ->getStartColor()->setRGB('E2E8F0');
        $sheet->getStyle('A1:F1')->getBorders()->getAllBorders()
            ->setBorderStyle(Border::BORDER_THIN);

        // Set contoh data dengan account yang sebenarnya dari database
        $sampleAccount = $accounts->isNotEmpty() ? $accounts->first()->account_name : 'Kas Operasional';
        $exampleData = [
            ['04/06/2025', '', $sampleAccount, 'Pembelian ATK', '50000', ''],
            ['04-june-25', '', $sampleAccount, 'Pembayaran Transport', '', '25000'],
            ['05-june-25', '', $sampleAccount, 'Penerimaan dari Bank', '1000000', ''],
        ];
        $sheet->fromArray($exampleData, null, 'A2');

        // Format data example
        $sheet->getStyle('A2:F4')->getBorders()->getAllBorders()
            ->setBorderStyle(Border::BORDER_THIN);

        // Auto width
        foreach (range('A', 'F') as $col) {
            $sheet->getColumnDimension($col)->setAutoSize(true);
        }

        // Set instruksi
        $sheet->setCellValue('L3', 'INSTRUKSI:');
        $sheet->getStyle('L3')->getFont()->setBold(true);

        $instructions = [
            '1. Voucher: Kosongkan, akan di-generate otomatis oleh sistem',
            '2. Account: Nama account yang tersedia di sistem',
            '3. Deskripsi: Keterangan transaksi (opsional)',
            '4. Credit: Nominal kredit (masuk), kosongkan jika debit',
            '5. Debit: Nominal debit (keluar), kosongkan jika kredit',
            '6. Hapus baris contoh ini sebelum upload',
            '7. Pastikan minimal salah satu Credit atau Debit terisi',
        ];

        $row = 4;
        foreach ($instructions as $instruction) {
            $sheet->setCellValue('L' . $row, $instruction);
            $row++;
        }

        // Set list account yang tersedia
        $sheet->setCellValue('H3', 'DAFTAR ACCOUNT TERSEDIA:');
        $sheet->getStyle('H3')->getFont()->setBold(true);

        $row = 4;
        foreach ($accounts as $account) {
            $sheet->setCellValue('H' . $row, $account->account_name);
            $row++;
        }

        // Save file
        $filename = 'template_kas_' . date('Y-m-d') . '.xlsx';
        $writer = new Xlsx($spreadsheet);

        // Set headers untuk download
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="' . $filename . '"');
        header('Cache-Control: max-age=0');

        $writer->save('php://output');
        exit;
    }

    /**
     * Upload dan proses Excel secara langsung (simplified version menggunakan pendekatan customer-detail)
     */
    public function uploadExcel(Request $request)
    {
        $request->validate([
            'excel_file' => 'required|file|mimes:xlsx,xls|max:5120', // 5MB max
        ]);

        try {
            $file = $request->file('excel_file');
            $spreadsheet = IOFactory::load($file->getPathname());
            $worksheet = $spreadsheet->getActiveSheet();

            // Simple approach - get all rows as array
            $rows = $worksheet->toArray();

            \Log::info('Excel loaded successfully, total rows: ' . count($rows));

            // Skip header row (first row)
            $dataStartRow = 1; // Start from second row (index 1)

            $importedCount = 0;
            $errors = [];

            DB::beginTransaction();

            // Process each row starting from data rows
            for ($i = $dataStartRow; $i < count($rows); $i++) {
                $rowNumber = $i + 1; // Excel row number for error messages
                $dataRow = $rows[$i];

                // Skip empty rows
                if (empty($dataRow[0]) && empty($dataRow[1]) && empty($dataRow[2])) {
                    continue;
                }

                try {
                    // Check if row has enough columns (Date, Voucher, Account, Description, Credit, Debit)
                    if (count($dataRow) < 6) {
                        $errors[] = "Baris {$rowNumber}: Format data tidak valid, kurang dari 6 kolom";
                        continue;
                    }

                    // Extract data from row
                    $tanggal = $dataRow[0] ?? null;     // Date
                    $voucher = $dataRow[1] ?? null;     // Voucher
                    $account = $dataRow[2] ?? null;     // Account
                    $description = $dataRow[3] ?? null; // Description
                    $credit = $dataRow[4] ?? null;      // Credit
                    $debit = $dataRow[5] ?? null;       // Debit

                    \Log::info("Processing row {$rowNumber}: Date=" . json_encode($tanggal));

                    // Parse tanggal - handle both DateTime objects and strings
                    try {
                        $transactionDate = $this->parseDate($tanggal);
                    } catch (\Exception $e) {
                        $errors[] = "Baris {$rowNumber}: Error parsing tanggal - " . $e->getMessage();
                        continue;
                    }

                    // Validate account
                    if (empty($account)) {
                        $errors[] = "Baris {$rowNumber}: Account tidak boleh kosong";
                        continue;
                    }

                    // Parse credit and debit amounts
                    $creditAmount = $this->parseNumber($credit);
                    $debitAmount = $this->parseNumber($debit);

                    // Validate that at least one of credit or debit is filled
                    if ($creditAmount == 0 && $debitAmount == 0) {
                        $errors[] = "Baris {$rowNumber}: Minimal salah satu dari Credit atau Debit harus diisi";
                        continue;
                    }

                    // Find account (case-insensitive)
                    $accountModel = FinancialAccount::whereRaw('LOWER(account_name) = ?', [strtolower(trim($account))])->first();
                    if (!$accountModel) {
                        $errors[] = "Baris {$rowNumber}: Account '{$account}' tidak ditemukan";
                        continue;
                    }

                    // Generate voucher number if empty
                    if (!empty($voucher)) {
                        $voucherNumber = trim($voucher);
                    } else {
                        $voucherNumber = KasTransaction::generateVoucherNumber();

                        // Ensure uniqueness
                        $suffix = 1;
                        while (KasTransaction::where('voucher_number', $voucherNumber)->exists()) {
                            $voucherNumber = KasTransaction::generateVoucherNumber() . '_' . $suffix;
                            $suffix++;
                            if ($suffix > 100) {
                                $errors[] = "Baris {$rowNumber}: Tidak dapat generate voucher number yang unik";
                                continue 2;
                            }
                        }
                    }

                    // Check for duplicate voucher
                    if (KasTransaction::where('voucher_number', $voucherNumber)->exists()) {
                        $errors[] = "Baris {$rowNumber}: Voucher number '{$voucherNumber}' sudah ada";
                        continue;
                    }

                    // Calculate balance
                    $previousTransaction = KasTransaction::where(function ($query) use ($transactionDate) {
                        $query->where('transaction_date', '<', $transactionDate)
                            ->orWhere(function ($q) use ($transactionDate) {
                                $q->where('transaction_date', $transactionDate)
                                    ->where('id', '<', DB::raw('(SELECT COALESCE(MAX(id), 0) FROM kas_transactions)'));
                            });
                    })
                        ->orderBy('transaction_date', 'desc')
                        ->orderBy('id', 'desc')
                        ->first();

                    $previousBalance = $previousTransaction ? $previousTransaction->balance : 0;
                    $newBalance = $previousBalance + $creditAmount - $debitAmount;

                    // Save transaction
                    $transaction = new KasTransaction([
                        'voucher_number' => $voucherNumber,
                        'account_id' => $accountModel->id,
                        'transaction_date' => $transactionDate,
                        'description' => !empty($description) ? trim($description) : null,
                        'credit' => $creditAmount,
                        'debit' => $debitAmount,
                        'balance' => $newBalance,
                        'year' => $transactionDate->year,
                        'month' => $transactionDate->month,
                    ]);

                    $transaction->save();

                    // Update future balances
                    $this->updateFutureBalances($transaction);

                    $importedCount++;
                } catch (\Exception $e) {
                    $errors[] = "Baris {$rowNumber}: " . $e->getMessage();
                    \Log::error("Error processing row {$rowNumber}: " . $e->getMessage());
                }
            }

            // Check if we have any errors
            if (!empty($errors)) {
                DB::rollBack();
                return redirect()->back()
                    ->withErrors(['excel_file' => 'Terdapat error pada beberapa baris:'])
                    ->with('excel_errors', $errors);
            }

            // If we have successful imports
            if ($importedCount > 0) {
                DB::commit();
                return redirect()->route('keuangan.kas.index')
                    ->with('success', "Berhasil mengimpor {$importedCount} transaksi kas dari file Excel.");
            } else {
                DB::rollBack();
                return redirect()->back()
                    ->withErrors(['excel_file' => 'Tidak ada data valid yang ditemukan dalam file Excel.']);
            }
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error processing Excel file: ' . $e->getMessage());
            return redirect()->back()
                ->withErrors(['excel_file' => 'Error saat memproses file: ' . $e->getMessage()]);
        }
    }

    /**
     * Update balances for all future transactions after a transaction is added or modified.
     */
    private function updateFutureBalances(KasTransaction $transaction)
    {
        $laterTransactions = KasTransaction::where(function ($query) use ($transaction) {
            $query->where('transaction_date', '>', $transaction->transaction_date)
                ->orWhere(function ($q) use ($transaction) {
                    $q->where('transaction_date', $transaction->transaction_date)
                        ->where('id', '>', $transaction->id);
                });
        })
            ->orderBy('transaction_date')
            ->orderBy('id')
            ->get();

        if ($laterTransactions->count() > 0) {
            $runningBalance = $transaction->balance;

            foreach ($laterTransactions as $laterTransaction) {
                $runningBalance = $runningBalance + $laterTransaction->credit - $laterTransaction->debit;
                $laterTransaction->balance = $runningBalance;
                $laterTransaction->save();
            }
        }
    }
}
