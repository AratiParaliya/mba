import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
// For PDF generation
// For PDF structure
import 'package:pdf/widgets.dart' as pw; // For building PDF content
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // For saving files



class InvoiceDetailsScreen extends StatelessWidget {
  final String orderId;

  InvoiceDetailsScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Invoice Details for Order ID: $orderId',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              // Sample Invoice Details
              Text('Customer: John Doe'),
              Text('Amount: \$100.00'),
              Text('Date: 2024-10-16'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Invoices'),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  await _downloadPDF(); // Download PDF with image
                },
                child: Text('Download PDF with Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadInvoiceAsPdf(BuildContext context) async {
    final pdf = pw.Document();

    // Build the PDF content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Invoice Details for Order ID: $orderId',
                    style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 20),
                pw.Text('Customer: John Doe'),
                pw.Text('Amount: \$100.00'),
                pw.Text('Date: 2024-10-16'),
              ],
            ),
          );
        },
      ),
    );

    // Get the appropriate path for saving the PDF
    final downloadPath = await _getDownloadPath();

    try {
      // Construct the file path
      final filePath = '$downloadPath/invoice_$orderId.pdf';
      final file = File(filePath);

      // Write the PDF file to the constructed path
      await file.writeAsBytes(await pdf.save());

      // Notify the user of successful download
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice PDF downloaded to $filePath')),
      );
    } catch (e) {
      print("Error saving PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading invoice: ${e.toString()}')),
      );
    }
  }

  Future<String> _getDownloadPath() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // This path ensures the PDF is saved on the Desktop for desktop platforms
      final homeDirectory = Platform.isWindows
          ? Platform.environment['USERPROFILE']
          : Platform.environment['HOME'];

      return '$homeDirectory/Desktop'; // Saving on the Desktop
    } else {
      // For mobile platforms
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  // The new method for downloading a PDF with an image
  Future<void> _downloadPDF() async {
    final pdf = pw.Document();

    // Load image from assets

    // Add page to PDF with the image and text
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text('Item Details'), // Customize as needed
              ),
            ],
          );
        },
      ),
    );

    // Get the appropriate directory to save the PDF
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/item_details.pdf");

    // Save the PDF
    await file.writeAsBytes(await pdf.save());

    // Open the file for the user
    OpenFile.open(file.path);
  }
}
