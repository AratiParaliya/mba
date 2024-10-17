
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; 
 

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN_USER_ID';

    return Scaffold(
      body: Stack(
        children: [
 
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
              const SizedBox(height: 100.0), 
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white, 
                        Color.fromARGB(255, 143, 133, 230), 
                      ],
                      stops: const [0.3, 1.0], 
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
                            stream: FirebaseFirestore.instance.collection('users').doc(userId).collection('order').snapshots(),
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
                                  final createdAt = (orderData['createdAt'] as Timestamp?)?.toDate();

                                  
                                  bool canCancel = createdAt != null && DateTime.now().difference(createdAt).inHours < 12;

                                  return Card(
                                    child: ListTile(
                                      title: Text('Order ID: ${orderData['orderId']}'),
                                      subtitle: Text('Status: ${orderData['status']}'),
                                      trailing: orderData['status'] == 'approved'
                                          ? const Icon(Icons.check, color: Colors.green)
                                          : const Icon(Icons.close, color: Colors.red),
                                      onTap: () => _showOrderDetails(context, orderData, cartItems, canCancel),
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
void _showOrderDetails(BuildContext context, Map<String, dynamic> orderData, List<Map<String, dynamic>> cartItems, bool canCancel) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Order ID: ${orderData['orderId']}'),
        content: Column(
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
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (canCancel) 
              ElevatedButton(
                onPressed: () {
                  _cancelOrder(orderData['orderId'], orderData); 
                  Navigator.pop(context); 
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red, 
                ),
                child: const Text('Cancel Order'),
              ),
              if (canCancel) // Show close button only if cancel option is available
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

  Future<void> _cancelOrder(String orderId, Map<String, dynamic> orderData) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN_USER_ID';

    
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .delete();

   
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order')
        .doc(orderId)
        .delete();

   
    Fluttertoast.showToast(
      msg: "Order canceled successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
