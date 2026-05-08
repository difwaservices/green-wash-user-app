import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../data/models/food_models.dart';

class PdfGenerator {
  static Future<void> generateWalletStatement({
    required List<WalletTransaction> transactions,
    required String userName,
  }) async {
    final pdf = pw.Document();

    final totalCredit = transactions
        .where((t) => t.type == 'Credit')
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalDebit = transactions
        .where((t) => t.type == 'Debit')
        .fold(0.0, (sum, t) => sum + t.amount);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('DIFWA WALLET STATEMENT',
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.cyan900)),
                    pw.SizedBox(height: 8),
                    pw.Text('User: $userName', style: const pw.TextStyle(fontSize: 12)),
                    pw.Text('Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                        style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
                pw.PdfLogo(),
              ],
            ),
            pw.SizedBox(height: 32),

            // Summary Card
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem('Total Added', '+ Rs. ${totalCredit.toStringAsFixed(0)}', PdfColors.green700),
                  _summaryItem('Total Expense', '- Rs. ${totalDebit.toStringAsFixed(0)}', PdfColors.red700),
                ],
              ),
            ),
            pw.SizedBox(height: 32),

            // Transaction Table
            pw.TableHelper.fromTextArray(
              border: null,
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.cyan800),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
              headers: ['Date', 'Description', 'Amount', 'Balance'],
              data: transactions.map((tx) {
                final isCredit = tx.type == 'Credit';
                return [
                  DateFormat('dd/MM/yy').format(tx.createdAt),
                  tx.description.isNotEmpty ? tx.description : (isCredit ? 'Wallet Top-up' : 'Order Payment'),
                  '${isCredit ? '+' : '-'} Rs. ${tx.amount.toStringAsFixed(0)}',
                  'Rs. ${tx.balanceAfter.toStringAsFixed(0)}',
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    // Share/Save PDF using Printing package
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Difwa_Wallet_Statement_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static pw.Widget _summaryItem(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(value,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }
}
