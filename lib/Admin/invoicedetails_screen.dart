import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
      appBar: AppBar(
        title: Text('Invoice Details'),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade50,
              Colors.purple.shade100,
              Colors.purple.shade200,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      title: Text(item['itemName']),
                      subtitle: Text('Quantity: ${item['quantity']}, Price: ${item['price']}'),
                    );
                  },
                ),
              ],
            ),
          ),
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
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
