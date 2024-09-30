import 'package:flutter/material.dart';
import 'package:mba/Admin/orderlist.dart';

class OrderApprovel extends StatelessWidget {
  const OrderApprovel({super.key, required Order order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
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
              const SizedBox(
                height: 100.0, // Space for the header area
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                     stops: [0.4, 1.0], // Adjust stops to control color spread
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Order Confirmations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6F48EB),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Product Details
                          _buildSectionTitle('Product Details'),
                          _buildDetailRow('Medicine Name', 'Paracetamol 500mg'),
                          _buildDetailRow('Generic Name', 'Paracetamol'),
                          _buildDetailRow('Brand', 'XYZ Pharmaceuticals'),
                          _buildDetailRow('Type', 'Tablet'),
                          _buildDetailRow('Price', 'Product Details'),

                          const SizedBox(height: 20),

                          // Contact Details
                          _buildSectionTitle('Contact Details'),
                          _buildDetailRow('Full Name', 'ab'),
                          _buildDetailRow('Contact Number', '12345'),
                          _buildDetailRow('Alternate Number', '12345'),
                          _buildDetailRow('Email Address', 'ab@gmail.com'),
                          _buildDetailRow('Address', 'sagdvbash'),
                          _buildDetailRow('Pincode', '360360'),
                          _buildDetailRow('City', 'Rjk'),

                          const SizedBox(height: 30),

                          // Save & Continue button
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle Save & Continue functionality
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor:   Color.fromARGB(255, 113, 101, 228), 
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Confirm Order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  // Helper method to build a section title (e.g., "Product Details", "Contact Details")
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
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

  // Helper method to build each detail row (label and value pair)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Label (left side)
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
          // Value (right side)
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
