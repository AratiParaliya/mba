import 'package:flutter/material.dart';
import 'package:mba/Admin/order_approvel.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  // Controllers for TextFields
  final TextEditingController MedicineNameController = TextEditingController();
  final TextEditingController GenericNameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController  priceController = TextEditingController();
 

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
          // Grey container with rounded corners at the top
          Column(
            children: [
              const SizedBox(
                height: 100.0, // This height should be slightly less than the blue container's height
              ),
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
                        _buildTextField('Medicine Name', MedicineNameController, 'Paracetamol 500mg'),
                        _buildTextField('Generic Name', GenericNameController, 'Paracetamol'),
                        _buildTextField('Brand', brandController, 'XYZ Pharmaceuticals'),
                        _buildTextField('Type',typeController, 'Tablet'),
                        _buildTextField('Size', sizeController, 'Enter size'),
                        _buildTextField('Price', priceController, 'enter price'),

                        const SizedBox(height: 30),

                        // Add to Cart button
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {

                                  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderApprovel()),);
                                  // Handle Add to Cart functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: const Color(0xFF6F48EB), // Purple color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Add Product',
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
                        const SizedBox(height: 20),
                        // Buy Now button
                       
                        const SizedBox(height: 20),
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

  // Helper method to build each TextField for user input
  Widget _buildTextField(String label, TextEditingController controller, String hintText) {
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
          // TextField (right side)
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                
                  border: InputBorder.none,
                  hintText: hintText,
                ),
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