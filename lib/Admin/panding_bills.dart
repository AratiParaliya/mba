import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PandingBills extends StatelessWidget {
  const PandingBills({Key? key}) : super(key: key);

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
                  Color.fromARGB(255, 110, 102, 188), //color
                  Colors.white,
                ],
                radius: 2, //radius
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
          // Main content
          Column(
            children: [
              const SizedBox(
                  height: 100.0), // Height for spacing below the header
              Expanded(
                child: Container(
                  width: double.infinity, // Full width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white, // Light color
                        Color.fromARGB(255, 143, 133, 230), // Darker purple
                      ],
                      stops: const [
                        0.3,
                        1.0
                      ], // Adjust stops to control color spread
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Pending bills',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F48EB),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('pending_bills')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text('No orders found.'));
                              }

                              final orders = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  final orderData = orders[index].data()
                                      as Map<String, dynamic>;
                                  final cartItems =
                                      List<Map<String, dynamic>>.from(
                                          orderData['cartItems'] ?? []);
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(
                                              0, 3), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                          'Order ID: ${orderData['orderId']}'),
                                      subtitle: Text(
                                          'User: ${orderData['fullName']} | Total: \$${orderData['totalPrice']}'),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              context,
                                              orders[index]
                                                  .id); // Use the document ID
                                        },
                                      ),
                                      onTap: () => _showOrderDetails(
                                          context, orderData, cartItems),
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

  void _showOrderDetails(BuildContext context, Map<String, dynamic> orderData,
      List<Map<String, dynamic>> cartItems) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order ID: ${orderData['orderId']}'),
          content: SingleChildScrollView(
            // Wrap the content with SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('User: ${orderData['fullName']}'),
                Text('Total Price: \$${orderData['totalPrice']}'),
                const SizedBox(height: 10),
                Text('Delivery Address: ${orderData['address']}'),
                const SizedBox(height: 10),
                Text('Contact: ${orderData['contactNumber']}'),
                const SizedBox(height: 10),
                const Text('Cart Items:'),
                const SizedBox(height: 10),
                Column(
                  children: cartItems.map((item) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(item['medicineName'] ?? 'Unknown'),
                        subtitle: Text(
                          "Price: \$${item['price']} x ${item['quantity']} = \$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteOrder(orderId);
                Navigator.pop(context); // Close the confirmation dialog
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteOrder(String orderId) {
    // Reference to the pending bill document to delete
    final pendingBillRef = FirebaseFirestore.instance
        .collection('pending_bills')
        .doc(orderId); // Correct collection name

    // Delete the order from the pending bill
    pendingBillRef.delete().then((_) {
      // Show a confirmation message
      print('Order deleted successfully.');
    }).catchError((error) {
      print('Failed to delete order: $error');
    });
  }
}
