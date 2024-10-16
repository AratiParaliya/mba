
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mba/Screens/profile_screen.dart';
import 'cart.dart'; // Import your Cart screen
import 'medicin_search.dart'; // Import your MedicinSearch screen
import 'package:flutter/material.dart'; // Necessary import for the new screen

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID from FirebaseAuth
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN_USER_ID';

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
          // Main content
          Column(
            children: [
              const SizedBox(height: 100.0), // Height for spacing below the header
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
                      stops: const [0.3, 3.0], // Adjust stops to control color spread
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
                          'Order List',
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
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('No orders found.'));
                              }

                              final orders = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  final orderData = orders[index].data() as Map<String, dynamic>;
                                  final cartItems = List<Map<String, dynamic>>.from(orderData['cartItems'] ?? []);
                                  return Card(
                                    child: ListTile(
                                      title: Text('Order ID: ${orderData['orderId']}'),
                                      subtitle: Text('User: ${orderData['fullName']} | Total: \$${orderData['totalPrice']}'),
                                      onTap: () => _showOrderDetails(context, orderData, cartItems, userId),
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
        currentIndex: 2, // Assuming this is the index for OrderScreen
        onTap: (index) {
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
              // Already on OrderScreen
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage(user: FirebaseAuth.instance.currentUser!)),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey), // Gray icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.grey), // Gray icon
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_outer_outlined, color: Colors.grey), // Gray icon
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey), // Gray icon
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(
    BuildContext context,
    Map<String, dynamic> orderData,
    List<Map<String, dynamic>> cartItems,
    String userId,
  ) {
    try {
      final Timestamp? createdAt = orderData['createdAt'] as Timestamp?;

      if (createdAt == null) {
        throw 'Order created time is missing.';
      }

      final DateTime orderTime = createdAt.toDate();
      final DateTime currentTime = DateTime.now();
      final Duration difference = currentTime.difference(orderTime);

      final bool canCancel = difference.inHours < 12;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Order ID: ${orderData['orderId']}'),
            content: Column(
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
                ...cartItems.map((item) => ListTile(
                      title: Text(item['medicineName'] ?? 'Unknown'),
                      subtitle: Text(
                        "Price: \$${item['price']} x ${item['quantity']} = \$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                      ),
                    )),
              ],
            ),
            actions: [
              if (canCancel)
                ElevatedButton(
                  onPressed: () => _cancelOrder(context, orderData['orderId'], userId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white, // Button color
                  ),
                  child: const Text('Cancel Order'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing order details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load order details: $e')),
      );
    }
  }

  void _cancelOrder(BuildContext context, String orderId, String userId) {
    final batch = FirebaseFirestore.instance.batch();

    final userOrderRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('order').doc(orderId);
    final ordersRef = FirebaseFirestore.instance.collection('orders').doc(orderId);
    final pendingBillRef = FirebaseFirestore.instance.collection('pendingbill').doc(orderId);

    batch.delete(userOrderRef);
    batch.delete(ordersRef);
    batch.delete(pendingBillRef);

    batch.commit().then((_) {
      Navigator.pop(context); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled successfully.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel order: $error')),
      );
    });
  }
}
