// Import your add medicine screen

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mba/Admin/add_medicine.dart';
import 'package:mba/Admin/edit_medicine_details.dart';

class FetchMedicines extends StatefulWidget {
  const FetchMedicines({super.key});

  @override
  State<FetchMedicines> createState() => _FetchMedicinesState();
}

class _FetchMedicinesState extends State<FetchMedicines> {
  final CollectionReference medicinesCollection =
      FirebaseFirestore.instance.collection('product');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 110, 102, 188), //color
                  Colors.white,
                ],
                radius: 2,
                center: Alignment(2.8, -1.0),
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          // Logo and Title
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
              const SizedBox(height: 100.0), // Space for the header area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230), //255
                      ],
                      stops: [0.6, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: medicinesCollection.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text('No medicines found.'));
                              } else {
                                final medicines = snapshot.data!.docs;
                                return ListView.builder(
                                  itemCount: medicines.length,
                                  itemBuilder: (context, index) {
                                    return _buildMedicineItem(medicines[index]);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                     
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0), 
                          child: ElevatedButton(
                            onPressed: () {
                             
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddMedicine()),
                              );
                            },
                            child: const Text('Add Medicine',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 57, 38, 128), // Button color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Rounded corners for the button
                              ),
                            ),
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

  // Method to build each medicine item
  Widget _buildMedicineItem(QueryDocumentSnapshot medicineDoc) {
    final medicineData = medicineDoc.data() as Map<String, dynamic>;

    String medicineName = medicineData['medicineName'] ?? 'Unknown Medicine';
    String genericName = medicineData['genericName'] ?? 'Unknown Generic Name';
    double price = (medicineData['price'] is double)
        ? medicineData['price']
        : (medicineData['price'] is int)
            ? (medicineData['price'] as int).toDouble()
            : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adds margin to the container
      decoration: BoxDecoration(
        color: Colors.white, // Set background color to white
        borderRadius: BorderRadius.circular(20), // Rounded corners for the container
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 8, // Blur radius
            offset: const Offset(0, 5), // Changes position of the shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Medicine details on the left
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicineName, // Medicine name
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 110, 102, 188),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  genericName, // Display generic name
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${price.toStringAsFixed(2)}', // Display price
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // Edit and delete icons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit,
                      color: Color.fromARGB(255, 110, 102, 188)),
                  onPressed: () {
                    // Navigate to the EditMedicineDetails screen, passing the product ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMedicineDetails(
                          productId: medicineDoc.id, // Pass the document ID (medicine ID) to the edit screen
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: Color.fromARGB(255, 110, 102, 188)),
                  onPressed: () {
                    // Handle delete functionality here
                    _deleteMedicine(medicineDoc.id); // Call delete function
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to delete a medicine
  Future<void> _deleteMedicine(String medicineId) async {
    try {
      await medicinesCollection.doc(medicineId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting medicine: $e')),
      );
    }
  }
}
