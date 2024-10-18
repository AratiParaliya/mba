import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mba/Admin/invoicedetails_screen.dart'; // Make sure this path is correct

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blue background container
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
          // Grey container with rounded corners at the top
          Column(
            children: [
              SizedBox(
                height: 100.0, // This height should be slightly less than the blue container's height
              ),
              Expanded(
                child: Container(
                  width: double.infinity, // Make it full width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white, // Light color
                        Color.fromARGB(255, 143, 133, 230), // Darker purple
                      ],
                      stops: [0.3, 3.0], // Adjust stops to control color spread
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
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
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text('Bill No.',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text('Actions',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
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
                                        _showInvoiceDetails(context, orderId); // Navigate to details
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
                ),
              ),
            ],
          ),
        ],
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
                  onPressed: onViewDetails, // View details on click
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
