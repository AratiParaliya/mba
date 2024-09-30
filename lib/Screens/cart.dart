import 'package:flutter/material.dart';
import 'package:mba/Screens/contactdetail_screen.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int itemCount = 4; // Example item count
  int totalPrice = 400; // Example total price

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Purple gradient background
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
              SizedBox(
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
                              return _buildCartItem();
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildPriceDetails(),
                        SizedBox(height: 16),
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

  Widget _buildCartItem() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Medicine details and quantity controller in the same row
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Medicine Name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Price: e.g 100 * 3 = 300",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Quantity controller
            _buildQuantityController(),
            // Delete button
            IconButton(
              icon: Icon(Icons.delete_outline, color: Color.fromARGB(255, 110, 102, 188)),
              onPressed: () {
                // Handle delete functionality
                setState(() {
                  if (itemCount > 0) {
                    itemCount--; // Decrease item count when deleted
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityController() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Color(0xFF8A7FDB)),
          onPressed: () {
            // Handle decrement functionality
          },
        ),
        Text(
          "3", // Example quantity
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline, color: Color(0xFF8A7FDB)),
          onPressed: () {
            // Handle increment functionality
          },
        ),
      ],
    );
  }

  Widget _buildPriceDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Price Details ($itemCount Items)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildPriceRow("Total Product Price", "/400Rs."),
            SizedBox(height: 4),
            _buildPriceRow("Order Total", "/400Rs."),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactdetailScreen()),);
        // Handle place order functionality
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Color(0xFF8A7FDB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        "Place Order",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


