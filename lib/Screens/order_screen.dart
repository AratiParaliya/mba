import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For displaying notifications
import 'package:mba/Screens/profile_screen.dart';
import 'cart.dart'; // Import your Cart screen
import 'medicin_search.dart'; // Import your MedicinSearch screen

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _currentIndex = 2; // Set current index to Orders

  @override
  Widget build(BuildContext context) {
    final String userId =
        FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN_USER_ID';

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
                          'My Orders',
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
                                .collection('users')
                                .doc(userId)
                                .collection('order')
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
                                  final createdAt =
                                      (orderData['createdAt'] as Timestamp?)
                                          ?.toDate();

                                  // Check if the order is within the cancelable timeframe (12 hours)
                                  bool canCancel = createdAt != null &&
                                      DateTime.now()
                                              .difference(createdAt)
                                              .inHours <
                                          12;

                                  return Card(
                                    color:
                                        Colors.white, // Set card color to white
                                    elevation: 4, // Add shadow
                                    margin: const EdgeInsets.symmetric(
                                        vertical:
                                            8), // Vertical margin for spacing
                                    child: ListTile(
                                      title: Text(
                                          'Order ID: ${orderData['orderId']}'),
                                      subtitle: Text(
                                          'Status: ${orderData['status']}'),
                                      trailing:
                                          orderData['status'] == 'approved'
                                              ? const Icon(Icons.check,
                                                  color: Colors.green)
                                              : const Icon(Icons.close,
                                                  color: Colors.red),
                                      onTap: () => _showOrderDetails(context,
                                          orderData, cartItems, canCancel),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MedicinSearch()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Cart(cartItems: [])),
              );
              break;
            case 2:
              // Already on Orders Page
              break;
            case 3:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfilePage(user: user)),
                );
              } else {
                // Handle the case where the user is null (e.g., show a login screen or error message)
                Fluttertoast.showToast(
                  msg:
                      "User not logged in. Please log in to view your profile.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey), 
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart_rounded,
                color: Colors.grey), 
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_outer_outlined,
                color: Colors.grey), // Gray icon
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey), // Gray icon
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> orderData,
      List<Map<String, dynamic>> cartItems, bool canCancel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order ID: ${orderData['orderId']}'),
          content: SingleChildScrollView(
            // Use SingleChildScrollView to prevent overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Status: ${orderData['status']}'),
                Text('Total Price: \$${orderData['totalPrice']}'),
                const SizedBox(height: 10),
                Text('Delivery Address: ${orderData['address']}'),
                const SizedBox(height: 10),
                Text('Contact: ${orderData['contactNumber']}'),
                const SizedBox(height: 10),
                const Text('Cart Items:'),
                ...cartItems.map((item) => ListTile(
                      title: Text(item['medicineName'] ?? 'Unknown'),
                      subtitle: Text(
                        "Price: \$${item['price']} x ${item['quantity']} = \$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                      ),
                    )),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (canCancel) // Only show cancel button if within 12 hours
                  ElevatedButton(
                    onPressed: () {
                      _cancelOrder(orderData['orderId'],
                          orderData); // Pass order data for cancellation
                      Navigator.pop(context); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Text color
                    ),
                    child: const Text('Cancel Order'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelOrder(
      String orderId, Map<String, dynamic> orderData) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN_USER_ID';

    // Delete the order from the 'orders' collection
    await FirebaseFirestore.instance
        .collection('orders') // Change to your orders collection name
        .doc(orderId)
        .delete();

    // Delete the order from the 'users/order' subcollection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order')
        .doc(orderId)
        .delete();

    // Show notification
    Fluttertoast.showToast(
      msg: "Order canceled successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
