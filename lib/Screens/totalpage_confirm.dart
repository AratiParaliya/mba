import 'package:flutter/material.dart';
import 'package:mba/Screens/lastpage.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({super.key});

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  int quantity = 1;
  double pricePerItem = 400.0; // Example price

  @override
  Widget build(BuildContext context) {
    double totalPrice = quantity * pricePerItem;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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
          // Positioned logo and title
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
              const SizedBox(height: 100.0), // Space at the top
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Medicine details with rounded border and shadow
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 130),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: Colors.grey.shade300),
                          
                          color: Colors.white, // Background color
                        ),
                        child: const Text(
                          'Medicine Company Name\nMedicine Name\nPrice',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F48EB),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quantity selector with rounded border and shadow
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 130),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildQuantityButton(Icons.remove, () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            }),
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6F48EB),
                              ),
                            ),
                            _buildQuantityButton(Icons.add, () {
                              setState(() {
                                quantity++;
                              });
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Price details
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Price Details ($quantity ${quantity > 1 ? "Items" : "Item"})',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6F48EB),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildPriceRow('Total Product Price', 'Rs. ${totalPrice.toStringAsFixed(2)}'),
                            const Divider(),
                            _buildPriceRow('Order Total', 'Rs. ${totalPrice.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Confirm order button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Lastpage()),);
                            // Confirm order action
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF6F48EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Confirm Order',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for the quantity buttons
  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF6F48EB), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        child: Icon(
          icon,
          color: const Color(0xFF6F48EB),
        ),
      ),
    );
  }

  // Widget for the price row
  Widget _buildPriceRow(String label, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6F48EB),
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6F48EB),
          ),
        ),
      ],
    );
  }
}
