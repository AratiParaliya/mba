import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mba/Admin/delete_medicine.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController genericNameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final CollectionReference medicinesCollection =
      FirebaseFirestore.instance.collection('product');

  // Function to add medicine to Firestore
  Future<void> _addMedicine() async {
    if (medicineNameController.text.isEmpty ||
        genericNameController.text.isEmpty ||
        brandController.text.isEmpty ||
        typeController.text.isEmpty ||
        sizeController.text.isEmpty ||
        priceController.text.isEmpty) {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Step 1: Generate a new product ID
      String newProductId = await _generateNewProductId();

      // Prepare medicine data
      final medicineData = {
        'productId': newProductId,
        'medicineName': medicineNameController.text.trim(),
        'genericName': genericNameController.text.trim(),
        'brand': brandController.text.trim(),
        'type': typeController.text.trim(),
        'size': double.tryParse(sizeController.text.trim()) ?? 0.0,
        'price': double.tryParse(priceController.text.trim()) ?? 0.0,
      };

      // Add medicine data to Firestore
      await medicinesCollection.doc(newProductId).set(medicineData);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicine added successfully!')),
      );

      // Optionally, navigate to another page after adding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FetchMedicines()),
      );

      // Clear the text fields
      medicineNameController.clear();
      genericNameController.clear();
      brandController.clear();
      typeController.clear();
      sizeController.clear();
      priceController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding medicine: $e')),
      );
    }
  }

  // Method to generate a new custom product ID like P001, P002, etc.
  Future<String> _generateNewProductId() async {
    // Step 1: Get the last product document from Firestore and extract the productId
    QuerySnapshot querySnapshot = await medicinesCollection
        .orderBy('productId', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Extract the last product ID (e.g., "P001")
      String lastProductId = querySnapshot.docs.first['productId'];
      // Extract the numeric part and increment it
      int lastIdNumber = int.parse(lastProductId.substring(1));
      int newIdNumber = lastIdNumber + 1;

      // Format the new ID as "P001", "P002", etc.
      return 'P${newIdNumber.toString().padLeft(3, '0')}';
    } else {
      // If no products exist, start with "P001"
      return 'P001';
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
                height:
                    100.0, // This height should be slightly less than the blue container's height
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20,),
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
                        _buildTextField('Medicine Name', medicineNameController,
                            'Paracetamol 500mg'),
                        _buildTextField('Generic Name', genericNameController,
                            'Paracetamol'),
                        _buildTextField(
                            'Brand', brandController, 'XYZ Pharmaceuticals'),
                        _buildTextField('Type', typeController, 'Tablet'),
                        _buildTextField('Size', sizeController, 'Enter size'),
                        _buildTextField(
                            'Price', priceController, 'Enter price'),

                        const SizedBox(height: 30),

                        // Add to Cart button
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    _addMedicine, // Call add medicine function
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor:
                                      const Color(0xFF6F48EB), // Purple color
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
      padding: const EdgeInsets.symmetric(vertical: 10,),
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
       
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
