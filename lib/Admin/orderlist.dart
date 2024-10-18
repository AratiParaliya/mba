import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For displaying notifications

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({Key? key}) : super(key: key);

  @override
  _AdminOrderScreenState createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  final Set<String> _approvedOrders = {};
  final Set<String> _declinedOrders = {};
  String _searchQuery = ''; // Store the search query

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
                          'Order List',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F48EB),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery =
                                    value.toLowerCase(); // Update search query
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search by Order ID or User Name',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 143, 133,
                                      230)), // Set the hint text color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 143, 133, 230)),
                              ),
                              prefixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collectionGroup('orders')
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

                              // Filter orders based on the search query
                              final filteredOrders = orders.where((order) {
                                final orderData =
                                    order.data() as Map<String, dynamic>;
                                final orderId = orderData['orderId']
                                    .toString()
                                    .toLowerCase();
                                final userName =
                                    orderData['fullName']?.toLowerCase() ?? '';
                                return orderId.contains(_searchQuery) ||
                                    userName.contains(_searchQuery);
                              }).toList();

                              return ListView.builder(
                                itemCount: filteredOrders.length,
                                itemBuilder: (context, index) {
                                  final orderData = filteredOrders[index].data()
                                      as Map<String, dynamic>;
                                  final cartItems =
                                      List<Map<String, dynamic>>.from(
                                          orderData['cartItems'] ?? []);
                                  final orderId = orderData['orderId'];
                                  final userId = orderData[
                                      'userId']; // Assuming you have userId in your orderData

                                  // Check if the order has been approved or declined
                                  final isApproved =
                                      _approvedOrders.contains(orderId);
                                  final isDeclined =
                                      _declinedOrders.contains(orderId);
                                  final status = orderData['status'];

                                  return Card(
                                    child: ListTile(
                                      title: Text('Order ID: $orderId'),
                                      subtitle: Text(
                                          'User: ${orderData['fullName']} | Total: \$${orderData['totalPrice']}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.check,
                                                color: Colors.green),
                                            onPressed: (status == 'approved' ||
                                                    isDeclined)
                                                ? null
                                                : () => _approveOrder(
                                                    orderData, userId),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.red),
                                            onPressed: (status == 'declined' ||
                                                    isApproved)
                                                ? null
                                                : () => _declineOrder(
                                                    userId, orderId),
                                          ),
                                        ],
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

  Future<void> _approveOrder(
      Map<String, dynamic> orderData, String userId) async {
    try {
      // Check if the order has already been approved
      if (orderData['status'] == 'approved') {
        Fluttertoast.showToast(
          msg: "Order has already been approved.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
        );
        return;
      }

      // Update the order status to approved in the original orders collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('order')
          .doc(orderData['orderId'])
          .update({'status': 'approved'});

      // Move to approved_orders collection only if not already present
      await FirebaseFirestore.instance
          .collection('approved_orders')
          .doc(orderData['orderId'])
          .set(orderData);

      // Update the state to disable buttons
      setState(() {
        _approvedOrders.add(orderData['orderId']);
      });

      // Show notification
      Fluttertoast.showToast(
        msg: "Order approved successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print("Error approving order: $e");
      Fluttertoast.showToast(
        msg: "Failed to approve order: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _declineOrder(String userId, String orderId) async {
    try {
      // Check if the order has already been declined
      if (_declinedOrders.contains(orderId)) {
        Fluttertoast.showToast(
          msg: "Order has already been declined.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
        );
        return;
      }

      // Update the order status to declined in the original orders collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('order')
          .doc(orderId)
          .update({'status': 'declined'});

      // Remove from approved_orders collection if it exists there
      await FirebaseFirestore.instance
          .collection('approved_orders')
          .doc(orderId)
          .delete();

      // Update the state to disable buttons
      setState(() {
        _declinedOrders.add(orderId);
      });

      // Show notification
      Fluttertoast.showToast(
        msg: "Order declined successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (e) {
      print("Error declining order: $e");
      Fluttertoast.showToast(
        msg: "Failed to decline order: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> orderData,
      List<Map<String, dynamic>> cartItems) {
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
