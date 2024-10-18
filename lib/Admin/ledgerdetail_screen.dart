import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // material

class LedgerDetailsScreen extends StatelessWidget {
  final String fullName;
  final List<Map<String, dynamic>> orders;

  LedgerDetailsScreen({required this.fullName, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$fullName - Ledger Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: orders.map((orderData) {
            List<dynamic> cartItems = orderData['cartItems'] ?? [];
            // Format the createdAt date if it's present
            DateTime createdAt = (orderData['createdAt'] as Timestamp).toDate();
            String formattedDate =
                "${createdAt.day}/${createdAt.month}/${createdAt.year}"; // Change format as needed
            String orderId = orderData['orderId'] ?? 'N/A';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: $orderId',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Created At: $formattedDate',
                      style: TextStyle(fontSize: 14)),
                  SizedBox(height: 10),
                  Text('Total Price: \$${orderData['totalPrice'] ?? 0}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Delivery Address: ${orderData['address'] ?? 'N/A'}'),
                  SizedBox(height: 10),
                  Text('Contact: ${orderData['contactNumber'] ?? 'N/A'}'),
                  SizedBox(height: 10),
                  Text('Cart Items:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...cartItems.map((item) {
                    return ListTile(
                      title: Text(item['medicineName'] ?? 'Unknown'),
                      subtitle: Text(
                        "GenericName: ${item['genericName'] ?? 'N/A'}\n"
                        "Price: \$${item['price'] ?? 0} x ${item['quantity'] ?? 1} = \$${(item['price'] * item['quantity'] ?? 0).toStringAsFixed(2)}",
                      ),
                    );
                  }).toList(),
                  Divider(),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
