import 'package:flutter/material.dart';
import 'package:mba/Screens/add_to_cart_screen.dart';
import 'package:mba/Screens/cart.dart';

class MedicinSearch extends StatefulWidget {
  const MedicinSearch({super.key});

  @override
  State<MedicinSearch> createState() => _MedicinSearchState();
}

class _MedicinSearchState extends State<MedicinSearch> {
  // Example list of medicines with name, ID, and price
  final List<Map<String, dynamic>> medicines = [
    {"id": 1, "name": "Coreg (Carvedilol)", "description": "Beta-blocker", "price": 20.0},
    {"id": 2, "name": "Lipitor (Atorvastatin)", "description": "Cholesterol medication", "price": 30.0},
    {"id": 3, "name": "Plavix (Clopidogrel)", "description": "Blood thinner", "price": 25.0},
    {"id": 4, "name": "Zestril (Lisinopril)", "description": "Blood pressure medication", "price": 18.0},
    {"id": 5, "name": "Synthroid (Levothyroxine)", "description": "Thyroid medication", "price": 22.0},
    {"id": 6, "name": "Ventolin (Albuterol)", "description": "Asthma inhaler", "price": 15.0},
  ];

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
          // Positioned logo and text
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
                height: 100.0,
              ),
              Expanded(
                child: Container(
                  width: double.infinity, // Make it full width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                      stops: [0.1, 2.0], // Adjust stops to control color spread
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Search bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search medicines...',
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Medicine list
                        Expanded(
                          child: ListView.builder(
                            itemCount: medicines.length, // Number of medicines
                            itemBuilder: (context, index) {
                              final medicine = medicines[index];
                              return Align(
                                alignment: Alignment.center, // Center-align cards
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.90, // Reduce width to 90% of screen
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            medicine['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(medicine['description']),
                                          Text('Price: \$${medicine['price']}'),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Color.fromARGB(255, 143, 133, 230),
                                          size: 45,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddToCartScreen(
                                                medicineId: medicine['id'],
                                                medicineName: medicine['name'],
                                                medicinePrice: medicine['price'],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
          // Shopping cart floating button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                );
              },
              backgroundColor: const Color.fromARGB(255, 239, 236, 236),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
    );
  }
}
