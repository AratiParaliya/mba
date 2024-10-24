import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMedicineDetails extends StatefulWidget {
  final String productId; // Accept product ID as a parameter

  const EditMedicineDetails({super.key, required this.productId});

  @override
  State<EditMedicineDetails> createState() => _EditMedicineDetailsState();
}

class _EditMedicineDetailsState extends State<EditMedicineDetails> {
  // Controllers for TextFields
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController genericNameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductData(); // Fetch product data on initialization
  }

  // Fetch data from Firestore using the product ID
  Future<void> fetchProductData() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.productId)
          .get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          medicineNameController.text = data['medicineName'] ?? '';
          genericNameController.text = data['genericName'] ?? '';
          brandController.text = data['brand'] ?? '';
          typeController.text = data['type'] ?? '';
          sizeController.text = data['size'] ?? '';
          priceController.text = data['price'] != null ? data['price'].toString() : '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Document does not exist'); // Debugging
      }
    } catch (e) {
      print('Error fetching product data: $e'); // Debugging
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

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
                  Color.fromARGB(255, 110, 102, 188),
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
                  height: 100.0), // Adjust height to fit below the logo
              Expanded(
                child: Container(
                  width: double.infinity, // Make it full width
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                      stops: [0.3, 1.0], // Adjust stops to control color spread
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              _buildSectionTitle('Product Details'),
                              _buildTextField('Medicine Name',
                                  medicineNameController, 'Paracetamol 500mg'),
                              _buildTextField('Generic Name',
                                  genericNameController, 'Paracetamol'),
                              _buildTextField('Brand', brandController,
                                  'XYZ Pharmaceuticals'),
                              _buildTextField('Type', typeController, 'Tablet'),
                              _buildTextField(
                                  'Size', sizeController, 'Enter size'),
                              _buildTextField(
                                  'Price', priceController, 'Enter price'),
                              const SizedBox(height: 30),
                              // Save button to update the product
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Handle update logic
                                        updateProductDetails();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        backgroundColor: const Color.fromARGB(
                                            255, 113, 101, 228),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text(
                                        'Update Product',
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

  // Helper method to build a section title
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
  Widget _buildTextField(
      String label, TextEditingController controller, String hintText) {
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
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
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

  Future<void> updateProductDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.productId)
          .update({
        'medicineName': medicineNameController.text,
        'genericName': genericNameController.text,
        'brand': brandController.text,
        'type': typeController.text,
        'size': sizeController.text,
        'price': double.parse(priceController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product: $e')),
      );
    }
  }
}
