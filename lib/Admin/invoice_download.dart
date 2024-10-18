import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mba/Admin/invoicedetails_screen.dart'; // Make sure you have this screen
import 'package:open_file/open_file.dart'; // For opening PDFs

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
            Image.asset('assets/logo.png', height: 40), // Replace with your logo image
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
                stream: FirebaseFirestore.instance.collection('approved_orders').snapshots(),
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
                          (orderData['createdAt'] as Timestamp).toDate().toString();
                      String orderId = orderData.id; // Get the document ID as orderId

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
