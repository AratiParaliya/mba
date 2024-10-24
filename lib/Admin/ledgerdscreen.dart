import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mba/Admin/ledgerdetail_screen.dart'; // Import the new screen

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  _LedgerScreenState createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          Column(
            children: [
              const SizedBox(height: 100.0), // Adjust height as needed
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 16.0), // Add top margin for space
                  width: double.infinity, // Make it full width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white, // Light color
                        const Color.fromARGB(255, 143, 133, 230), // Darker purple
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // Search bar inside the container
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by full name',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // ListView inside the same container as the search bar
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('orders')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('No orders found'));
                              }

                              final orders = snapshot.data!.docs;

                              // Use a Set to track unique full names
                              Set<String> uniqueNames = {};
                              Map<String, List<Map<String, dynamic>>> groupedOrders = {};

                              // Loop through the orders to filter unique names and group orders by fullName
                              for (var order in orders) {
                                final fullName = order['fullName'].toLowerCase(); // Convert to lowercase for search
                                final orderData = order.data() as Map<String, dynamic>;

                                // If the full name matches the search query or the query is empty
                                if (fullName.contains(_searchQuery)) {
                                  if (!uniqueNames.contains(fullName)) {
                                    uniqueNames.add(fullName);
                                    groupedOrders[fullName] = [orderData]; // Initialize a new list for this name
                                  } else {
                                    groupedOrders[fullName]!.add(orderData); // Add to the existing list for this name
                                  }
                                }
                              }

                              if (uniqueNames.isEmpty) {
                                return const Center(child: Text('No matching results'));
                              }

                              return ListView.builder(
                                itemCount: uniqueNames.length,
                                itemBuilder: (context, index) {
                                  final fullName = uniqueNames.elementAt(index);

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 16,
                                    ), // Adjust margin as needed
                                    decoration: BoxDecoration(
                                      color: Colors.white, // White background
                                      borderRadius: BorderRadius.circular(10), // Rounded corners
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5), // Shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: const Offset(0, 3), // Changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        'Name: $fullName',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
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
}
