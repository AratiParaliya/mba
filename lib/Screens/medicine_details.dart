import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for user management
import 'package:mba/Screens/medicin_search.dart';

class MedicineDetails extends StatefulWidget {
  final String documentId;

  const MedicineDetails({
    super.key,
    required this.documentId,
    required String genericName,
    required String medicineName,
    required double price,
    required void Function() addToCart,
  });

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  final CollectionReference medicinesCollection =
      FirebaseFirestore.instance.collection('product');

  int _quantity = 1;

  // Fetch the current user's ID using FirebaseAuth
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<DocumentSnapshot> _fetchMedicineDetails(String documentId) async {
    return await medicinesCollection.doc(documentId).get();
  }

  // Function to add items to the cart under users/{userId}/cart
  Future<void> _addToCart(Map<String, dynamic> medicineData) async {
    User? user = getCurrentUser(); // Get the current authenticated user

    if (user != null) {
      String userId = user.uid; // Fetch the current user's ID

      // Create a reference to the user's cart collection
      CollectionReference userCartCollection =
          FirebaseFirestore.instance.collection('users').doc(userId).collection('cart');

      // Add the medicine data to the user's cart
      await userCartCollection.add({
        'medicineName': medicineData['medicineName'],
        'genericName': medicineData['genericName'],
        'price': medicineData['price'],
        'quantity': _quantity,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to Cart')),
      );

      // Redirect to the medicine search screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MedicinSearch()),
      );
    } else {
      // Handle case where the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
    }
  }

  void _updateQuantity(int change) {
    setState(() {
      _quantity += change;
      if (_quantity < 1) _quantity = 1; // Ensure quantity doesn't go below 1
    });
  }

  @override
  Widget build(BuildContext context) {
    final String documentId = widget.documentId;

    return Scaffold(
      body: Stack(
        children: [
          // Add the rest of your UI here
          // For example, the gradient, image, etc.
          Column(
            children: [
              const SizedBox(height: 100.0),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                      stops: [0.6, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildSectionTitle('Product Details'),
                        FutureBuilder<DocumentSnapshot>(
                          future: _fetchMedicineDetails(documentId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return const Text('No data available');
                            }

                            var medicineData = snapshot.data!.data()
                                as Map<String, dynamic>;
                            String medicineName =
                                medicineData['medicineName'] ?? 'Unknown';
                            String genericName =
                                medicineData['genericName'] ?? 'Unknown';
                            String brand = medicineData['brand'] ?? 'Unknown';
                            String type = medicineData['type'] ?? 'Unknown';
                            double size = (medicineData['size'] is double)
                                ? medicineData['size']
                                : (medicineData['size'] is int)
                                    ? (medicineData['size'] as int).toDouble()
                                    : 0.0;

                            double price = (medicineData['price'] is double)
                                ? medicineData['price']
                                : (medicineData['price'] is int)
                                    ? (medicineData['price'] as int).toDouble()
                                    : 0.0;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                    'Medicine Name', medicineName),
                                _buildDetailRow('Generic Name', genericName),
                                _buildDetailRow('Brand', brand),
                                _buildDetailRow('Type', type),
                                _buildDetailRow(
                                    'Size', '${size.toStringAsFixed(2)}'),
                                _buildDetailRow('Price',
                                    '\$${price.toStringAsFixed(2)}'),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _addToCart(medicineData);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 80),
                                      backgroundColor:
                                          const Color(0xFF6F48EB),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      'Add to cart',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 30),
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

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF6F48EB),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F48EB),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6F48EB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
