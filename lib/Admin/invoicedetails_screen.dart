import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
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
  String? fullName;
  double? totalPrice;
  String? createdAt;
  String? address;
  String? alternateNumber;
  List<Map<String, dynamic>> cartItems = [];
  String? contactNumber;
  String? city;
  String? emailAddress;
  String? pinCode;
  String? state;
  String? status;

  @override
  void initState() {
    super.initState();
    _fetchInvoiceDetails();
  }

  Future<void> _fetchInvoiceDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('approved_orders')
          .doc(widget.orderId)
          .get();

      if (doc.exists) {
        setState(() {
          fullName = doc['fullName'] ?? 'Unknown';
          totalPrice = doc['totalPrice'] ?? 0.0;
          createdAt = doc['createdAt'] != null ? doc['createdAt'].toDate().toString() : 'Unknown';
          address = "${doc['city'] ?? 'Unknown'}, ${doc['state'] ?? 'Unknown'}, ${doc['pinCode'] ?? 'Unknown'}";
          alternateNumber = doc['alternateNumber'] ?? 'Unknown';
          cartItems = List<Map<String, dynamic>>.from(doc['cartItems'] ?? []);
          contactNumber = doc['contactNumber'] ?? 'Unknown';
          city = doc['city'] ?? 'Unknown';
          emailAddress = doc['emailAddress'] ?? 'Unknown';
          pinCode = doc['pinCode'] ?? 'Unknown';
          state = doc['state'] ?? 'Unknown';
          status = doc['status'] ?? 'Unknown';
        });
      } else {
        setState(() {
          fullName = 'No data found';
        });
      }
    } catch (e) {
      print('Error fetching document: $e');
      setState(() {
        fullName = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient container
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 110, 102, 188), // Darker purple
                  Colors.white, // Light center
                ],
                radius: 2,
                center: Alignment(2.8, -1.0),
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Row(
              children: [
                Image.asset(
                  'assets/logo.png', // Replace with your logo asset path
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 10),
                const Text(
                  'MBA International Pharma',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 110, 102, 188),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 100.0),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white, // Light color
                        Color.fromARGB(255, 143, 133, 230), // Darker purple
                      ],
                      stops: [0.3, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: _buildInvoiceDetails(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Invoice Details for Order ID: ${widget.orderId}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildDetailText('Full Name', fullName ?? 'Loading...'),
            _buildDetailText('Contact Number', contactNumber ?? 'Loading...'),
            _buildDetailText('Alternate Number', alternateNumber ?? 'Loading...'),
            _buildDetailText('Email Address', emailAddress ?? 'Loading...'),
            _buildDetailText('Address', address ?? 'Loading...'),
            _buildDetailText('Pincode', pinCode ?? 'Loading...'),
            _buildDetailText('City', city ?? 'Loading...'),
            _buildDetailText('State', state ?? 'Loading...'),
            _buildDetailText('Total Price', totalPrice?.toStringAsFixed(2) ?? 'Loading...'),
            _buildDetailText('Status', status ?? 'Loading...'),
            _buildDetailText('Created At', createdAt ?? 'Loading...'),
            SizedBox(height: 20),
            Text(
              'Cart Items:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            cartItems.isEmpty
                ? Text('Loading...')
                : Column(
                    children: cartItems.map((item) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailText('Medicine Name', item['medicineName']),
                          _buildDetailText('Generic Name', item['genericName']),
                          _buildDetailText('Price', '\$${item['price']}'),
                          _buildDetailText('Quantity', '${item['quantity']}'),
                          SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _downloadPDF();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Download PDF with Image',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Invoices'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPDF() async {
    final pdf = pw.Document();

    final ByteData bytes = await rootBundle.load('assets/logo.png');
    final Uint8List byteList = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                color: PdfColors.blue,
                padding: pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Medicine Shop Bill', style: pw.TextStyle(color: PdfColors.white, fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Shop Name: MBA International Pharma', style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                        pw.Text('Invoice No: ${widget.orderId}', style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                      ],
                    ),
                    pw.Text('GSTIN No: 1234567890', style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                  ],
                ),
              ),
              pw.Image(pw.MemoryImage(byteList), height: 100),
              pw.SizedBox(height: 20),
              pw.Text('Invoice Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildPdfDetailText('Customer Name', fullName ?? 'Unknown'),
              _buildPdfDetailText('Contact Number', contactNumber ?? 'Unknown'),
              _buildPdfDetailText('Alternate Number', alternateNumber ?? 'Unknown'),
              _buildPdfDetailText('Email', emailAddress ?? 'Unknown'),
              _buildPdfDetailText('Address', address ?? 'Unknown'),
              _buildPdfDetailText('City', city ?? 'Unknown'),
              _buildPdfDetailText('State', state ?? 'Unknown'),
              _buildPdfDetailText('Pincode', pinCode ?? 'Unknown'),
              _buildPdfDetailText('Total Price', '\$${totalPrice?.toStringAsFixed(2) ?? 'Unknown'}'),
              _buildPdfDetailText('Status', status ?? 'Unknown'),
              _buildPdfDetailText('Created At', createdAt ?? 'Unknown'),
              pw.SizedBox(height: 20),
              pw.Text('Cart Items', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return pw.Container(
                    margin: pw.EdgeInsets.symmetric(vertical: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildPdfDetailText('Medicine Name', item['medicineName'] ?? 'Unknown'),
                        _buildPdfDetailText('Generic Name', item['genericName'] ?? 'Unknown'),
                        _buildPdfDetailText('Price', '\$${item['price'] ?? 'Unknown'}'),
                        _buildPdfDetailText('Quantity', '${item['quantity'] ?? 'Unknown'}'),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/invoice_${widget.orderId}.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  pw.Widget _buildPdfDetailText(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('$label:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }
}
