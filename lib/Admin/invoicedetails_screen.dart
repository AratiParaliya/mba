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
          totalPrice =
              doc['totalPrice']?.toDouble() ?? 0.0; // Ensure this is double
          createdAt = doc['createdAt'] != null
              ? doc['createdAt'].toDate().toString()
              : 'Unknown';
          address =
              "${doc['city'] ?? 'Unknown'}, ${doc['state'] ?? 'Unknown'}, ${doc['pinCode'] ?? 'Unknown'}";
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
                  Color.fromARGB(255, 110, 102, 188),
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

            // Customer Details Section
            _buildCustomerDetails(),
            SizedBox(height: 20),

            // Cart Items Table
            Text(
              'Cart Items:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            _buildCartItemsTable(),

            SizedBox(height: 20),
            Text(
              'Total Price: \$${totalPrice?.toStringAsFixed(2) ?? 'Loading...'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildCustomerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailText('Full Name', fullName ?? 'Loading...'),
        _buildDetailText('Contact Number', contactNumber ?? 'Loading...'),
        _buildDetailText('Alternate Number', alternateNumber ?? 'Loading...'),
        _buildDetailText('Email Address', emailAddress ?? 'Loading...'),
        _buildDetailText('Address', address ?? 'Loading...'),
        _buildDetailText('Pincode', pinCode ?? 'Loading...'),
        _buildDetailText('City', city ?? 'Loading...'),
        _buildDetailText('State', state ?? 'Loading...'),
        _buildDetailText('Status', status ?? 'Loading...'),
        _buildDetailText('Created At', createdAt ?? 'Loading...'),
      ],
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            // Make the label flexible
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Handle overflow
            ),
          ),
          Flexible(
            // Make the value flexible
            child: Text(
              value,
              overflow: TextOverflow.ellipsis, // Handle overflow
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsTable() {
    if (cartItems.isEmpty) {
      return Text('No items found.');
    }

    return SingleChildScrollView(
      // Added SingleChildScrollView for horizontal scrolling
      scrollDirection: Axis.horizontal, // Set horizontal scrolling
      child: DataTable(
        columns: const [
          DataColumn(label: Text('S.No')),
          DataColumn(label: Text('Medicine Description')),
          DataColumn(label: Text('HSN')),
          DataColumn(label: Text('QTY')),
          DataColumn(label: Text('MRP')),
          DataColumn(label: Text('Amount')),
        ],
        rows: List<DataRow>.generate(
          cartItems.length,
          (index) {
            final item = cartItems[index];
            return DataRow(
              cells: [
                DataCell(Text((index + 1).toString())),
                DataCell(Text(item['medicineName'] ?? 'Unknown')),
                DataCell(Text('HSN123')),
                DataCell(Text(item['quantity'].toString())),
                DataCell(Text(item['price'].toString())),
                DataCell(Text((item['quantity'] * item['price']).toString())),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _downloadPDF() async {
    final pdf = pw.Document();
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(logoImage, width: 100, height: 100),
              pw.SizedBox(height: 20),
              pw.Text('Invoice Details for Order ID: ${widget.orderId}',
                  style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Customer Name: $fullName'),
              pw.Text(
                  'Total Price: \$${totalPrice?.toStringAsFixed(2) ?? '0.00'}'),
              pw.SizedBox(height: 20),
              pw.Text('Cart Items:'),
              pw.ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(item['medicineName'] ?? 'Unknown'),
                      pw.Text('QTY: ${item['quantity']}'),
                      pw.Text('MRP: \$${item['price']}'),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    // Get the temporary directory to save the PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice_${widget.orderId}.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    await OpenFile.open(file.path);
  }
}
