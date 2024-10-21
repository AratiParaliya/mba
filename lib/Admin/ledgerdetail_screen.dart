import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LedgerDetailsScreen extends StatelessWidget {
  final String fullName;
  final List<Map<String, dynamic>> orders;

  LedgerDetailsScreen(
      {super.key, required this.fullName, required this.orders});

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
          // Back button at the top left corner
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white), // Back icon
              onPressed: () => Navigator.pop(context), // Navigate back
            ),
          ),
          // Grey container with rounded corners at the top
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0,
                          top: 20.0,
                          right: 16.0), // Add left margin and top padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add Full Name Text
                          Text(
                            'Ledger for: $fullName',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6F48EB),
                            ),
                          ),
                          const SizedBox(height: 20), // Space after the name
                          ...orders.map((orderData) {
                            List<dynamic> cartItems =
                                orderData['cartItems'] ?? [];
                            // Format the createdAt date if it's present
                            DateTime createdAt =
                                (orderData['createdAt'] as Timestamp).toDate();
                            String formattedDate =
                                "${createdAt.day}/${createdAt.month}/${createdAt.year}"; // Change format as needed
                            String orderId = orderData['orderId'] ?? 'N/A';

                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0), // Space between orders
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order ID: $orderId',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Text('Created At: $formattedDate',
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Total Price: \$${orderData['totalPrice'] ?? 0}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Delivery Address: ${orderData['address'] ?? 'N/A'}'),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Contact: ${orderData['contactNumber'] ?? 'N/A'}'),
                                  const SizedBox(height: 10),
                                  const Text('Cart Items:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  ...cartItems.map((item) {
                                    return ListTile(
                                      title: Text(
                                          item['medicineName'] ?? 'Unknown'),
                                      subtitle: Text(
                                        "Generic Name: ${item['genericName'] ?? 'N/A'}\n"
                                        "Price: \$${item['price'] ?? 0} x ${item['quantity'] ?? 1} = \$${((item['price'] ?? 0) * (item['quantity'] ?? 1)).toStringAsFixed(2)}",
                                      ),
                                    );
                                  }).toList(),
                                  const Divider(),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
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
}
