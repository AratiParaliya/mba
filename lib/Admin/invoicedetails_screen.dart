import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final String orderId;

  InvoiceDetailsScreen({required this.orderId});

  @override
  _InvoiceDetailsScreenState createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  String? customerName;
  double? amount;
  String? date;

  @override
  void initState() {
    super.initState();
    _fetchInvoiceDetails();
  }

  Future<void> _fetchInvoiceDetails() async {
    // Fetch invoice details from Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('invoices')
        .doc(widget.orderId)
        .get();

    setState(() {
      customerName = doc['customerName']; // Make sure to match your Firestore field names
      amount = doc['amount'];
      date = doc['date'];
    });
  }

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
              Text('Invoice Details for Order ID: ${widget.orderId}',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              // Display fetched invoice details
              Text('Customer: ${customerName ?? 'Loading...'}'),
              Text('Amount: \$${amount?.toStringAsFixed(2) ?? 'Loading...'}'),
              Text('Date: ${date ?? 'Loading...'}'),
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
                  await _downloadPDF();
                },
                child: Text('Download PDF with Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadPDF() async {
    final pdf = pw.Document();

    // Build the PDF content using fetched details
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice Details for Order ID: ${widget.orderId}'),
              pw.Text('Customer: $customerName'),
              pw.Text('Amount: \$${amount?.toStringAsFixed(2)}'),
              pw.Text('Date: $date'),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text('Thank you for your business!'),
              ),
            ],
          );
        },
      ),
    );

    // Get the appropriate directory to save the PDF
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/invoice_${widget.orderId}.pdf");

    // Save the PDF
    await file.writeAsBytes(await pdf.save());

    // Open the file for the user
    OpenFile.open(file.path);
  }
}
