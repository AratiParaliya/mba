import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mba/Admin/ledgerdetail_screen.dart';
// Import the new screen

class LedgerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ledger Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!.docs;

          // Use a Set to track unique full names
          Set<String> uniqueNames = {};
          Map<String, List<Map<String, dynamic>>> groupedOrders = {};

          // Loop through the orders to filter unique names and group orders by fullName
          for (var order in orders) {
            final fullName = order['fullName'];
            final orderData = order.data() as Map<String, dynamic>;

            // If the full name is not already in the set, add it to both the set and the unique orders list
            if (!uniqueNames.contains(fullName)) {
              uniqueNames.add(fullName);
              groupedOrders[fullName] = [
                orderData
              ]; // Initialize a new list for this name
            } else {
              groupedOrders[fullName]!
                  .add(orderData); // Add to the existing list for this name
            }
          }
// group
          return ListView.builder(
            itemCount: uniqueNames.length,
            itemBuilder: (context, index) {
              final fullName = uniqueNames.elementAt(index);

              return ListTile(
                title: Text(fullName),
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
              );
            },
          );
        },
      ),
    );
  }
}
