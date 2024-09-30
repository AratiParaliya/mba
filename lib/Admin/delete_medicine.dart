import 'package:flutter/material.dart';
import 'package:mba/Admin/add_medicine.dart';

class DeleteMedicine extends StatefulWidget {
  const DeleteMedicine({super.key});

  @override
  State<DeleteMedicine> createState() => _DeleteMedicineState();
}

class _DeleteMedicineState extends State<DeleteMedicine> {
  int itemCount = 5; // Example item count

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
                  Color.fromARGB(255, 110, 102, 188), // Darker purple
                  Colors.white, // Light center
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
              const SizedBox(
                height: 100.0, // Space for the header area
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              return _buildDeleteMedicineItem();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPlaceOrderButton(),
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

  // Method to build each DeleteMedicine item with delete and edit functionality
  Widget _buildDeleteMedicineItem() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners for the card
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and delete icon
          children: [
            // Medicine details on the left
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Coreg (Carvedilol)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 110, 102, 188), // Matching purple text
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "SGRSG", // Replace with relevant product details
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  "Price", // Replace with the actual price
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // Edit and delete icons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color.fromARGB(255, 110, 102, 188)),
                  onPressed: () {
                    // Handle edit functionality here
                    print('Edit button clicked');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color.fromARGB(255, 110, 102, 188)),
                  onPressed: () {
                    // Handle delete functionality here
                    setState(() {
                      if (itemCount > 0) {
                        itemCount--; // Decrease item count when deleted
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the Place Order button
  Widget _buildPlaceOrderButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMedicine()), // Corrected ForgotPassword
                          );
        // Handle place order functionality
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: const Color(0xFF8A7FDB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        "Add",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
