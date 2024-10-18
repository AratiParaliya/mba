import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
// For PDF generation
import 'package:pdf/pdf.dart'; // For PDF structure
import 'package:pdf/widgets.dart' as pw; // For building PDF content
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // For saving files
import 'package:flutter/services.dart'; // For loading assets
// For opening files

void main() {
  runApp(MaterialApp(
    home: InvoiceScreen(),
  ));
}

class InvoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Row(
          children: [
            Image.asset('assets/logo.png',
                height: 40), // Replace with your logo image
            SizedBox(width: 10),
            Text('MBA International Pharma', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.deepPurple[50],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search with date',
                  icon: Icon(Icons.search, color: Colors.deepPurple),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Table Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Center(
                        child: Text('Date',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text('Bill No.',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text('Actions',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
            Divider(),

            // List of invoices
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('orders').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data.'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No orders available.'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var orderData = snapshot.data!.docs[index];
                      String dateOfCreation =
                          (orderData['createdAt'] as Timestamp)
                              .toDate()
                              .toString();
                      String orderId = orderData['orderId'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InvoiceItem(
                          dateOfCreation: dateOfCreation,
                          orderId: orderId,
                          onViewDetails: () {
                            _showInvoiceDetails(context, orderId);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvoiceDetails(BuildContext context, String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceDetailsScreen(orderId: orderId),
      ),
    );
  }
}

class InvoiceItem extends StatelessWidget {
  final String dateOfCreation;
  final String orderId;
  final VoidCallback onViewDetails;

  InvoiceItem({
    required this.dateOfCreation,
    required this.orderId,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurple[50], // white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Date
          Expanded(child: Center(child: Text(dateOfCreation))),

          // Bill Number
          Expanded(child: Center(child: Text(orderId))),

          // Actions: View
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_red_eye, color: Colors.deepPurple),
                  onPressed: onViewDetails,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
