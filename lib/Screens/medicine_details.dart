import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicineDetails extends StatefulWidget {
  final String documentId; // Document ID passed dynamically

  const MedicineDetails({
    super.key,
    required this.documentId, required String genericName, required String medicineName, required double price, required void Function() addToCart,
  });

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  // Firestore reference
  final CollectionReference medicinesCollection =
      FirebaseFirestore.instance.collection('product');

  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');

  int _quantity = 1; // Default quantity is 1

  // Function to fetch medicine details from Firestore
  Future<DocumentSnapshot> _fetchMedicineDetails(String documentId) async {
    return await medicinesCollection.doc(documentId).get();
  }

  // Method to add item to the cart
  Future<void> _addToCart(Map<String, dynamic> medicineData) async {
    await cartCollection.add({
      'medicineName': medicineData['medicineName'],
      'genericName': medicineData['genericName'],
      'price': medicineData['price'],
      'quantity': _quantity, // Adding selected quantity
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Cart')),
    );
  }

  // Function to manage quantity state
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
          Column(
            children: [
              const SizedBox(height: 100.0), // Adjust to match the blue container
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
                        Color.fromARGB(255, 143, 133, 230), // Darker purple
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return const Text('No data available');
                            }

                            // Extract data from the document
                            var medicineData = snapshot.data!.data() as Map<String, dynamic>;
                            String medicineName = medicineData['medicineName'] ?? 'Unknown';
                            String genericName = medicineData['genericName'] ?? 'Unknown';
                            String brand = medicineData['brand'] ?? 'Unknown';
                            String type = medicineData['type'] ?? 'Unknown';
                            String size = medicineData['size'] ?? 'Unknown';
                            double price = (medicineData['price'] is double)
                                ? medicineData['price']
                                : (medicineData['price'] is int)
                                    ? (medicineData['price'] as int).toDouble()
                                    : 0.0;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Medicine Name', medicineName),
                                _buildDetailRow('Generic Name', genericName),
                                _buildDetailRow('Brand', brand),
                                _buildDetailRow('Type', type),
                                _buildDetailRow('Size', size),
                                _buildDetailRow('Price', '\$${price.toStringAsFixed(2)}'),

                                // Quantity management
                                const SizedBox(height: 20),
                                Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Quantity : ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6F48EB),
                                        ),
                                      ),
                                       _buildQuantityRow(),
                                    ],
                                  ),
                                ),
                                // Updated quantity row

                                // Add to Cart Button
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _addToCart(medicineData); // Add to cart action
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal:80),
                                      backgroundColor: const Color(0xFF6F48EB),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
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

  // Helper method to build a section title (e.g., "Product Details")
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

  // Helper method to build a detail row
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

  // Helper method to build the quantity row with increment and decrement buttons
  Widget _buildQuantityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            _updateQuantity(-1); // Decrease quantity
          },
          icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF6F48EB)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding for spacing
          child: Text(
            '$_quantity',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6F48EB)),
          ),
        ),
        IconButton(
          onPressed: () {
            _updateQuantity(1); // Increase quantity
          },
          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF6F48EB)),
        ),
      ],
    );
  }
}
