import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mba/Admin/ledgerdetail_screen.dart'; // Import the new screen

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background container
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 110, 102, 188),
                  Colors.white,
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
                  'assets/logo.png',
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
          // Container for the list
          Column(
            children: [
              SizedBox(
                height:
                    100.0, // This height should be slightly less than the blue container's height
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 16.0), // Add top margin for space
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
                    // Use Padding to create space above the ListView
                    padding: const EdgeInsets.only(
                        top: 16.0), // Adjust the top padding as needed
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No orders found'));
                        }

                        final orders = snapshot.data!.docs;

                        // Use a Set to track unique full names
                        Set<String> uniqueNames = {};
                        Map<String, List<Map<String, dynamic>>> groupedOrders =
                            {};

                        // Loop through the orders to filter unique names and group orders by fullName
                        for (var order in orders) {
                          final fullName = order['fullName'];
                          final orderData =
                              order.data() as Map<String, dynamic>;

                          // If the full name is not already in the set, add it to both the set and the unique orders list
                          if (!uniqueNames.contains(fullName)) {
                            uniqueNames.add(fullName);
                            groupedOrders[fullName] = [
                              orderData
                            ]; // Initialize a new list for this name
                          } else {
                            groupedOrders[fullName]!.add(
                                orderData); // Add to the existing list for this name
                          }
                        }

                        return ListView.builder(
                          itemCount: uniqueNames.length,
                          itemBuilder: (context, index) {
                            final fullName = uniqueNames.elementAt(index);

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 16), // Adjust margin as needed
                              decoration: BoxDecoration(
                                color: Colors.white, // White background
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 2, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: const Offset(
                                        0, 3), // Changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text('Name: $fullName',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold) // Dark text color
                                    ),
                                onTap: () {
                                  // Navigate to LedgerDetailsScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LedgerDetailsScreen(
                                        fullName: fullName,
                                        orders: groupedOrders[fullName]!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
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
