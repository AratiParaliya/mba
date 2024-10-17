
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mba/Screens/contactdetail_screen.dart';
import 'package:mba/Screens/medicin_search.dart';
import 'package:mba/Screens/order_screen.dart';
import 'package:mba/Screens/profile_screen.dart';

class Cart extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const Cart({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> cartItems = [];
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  
  Future<void> _loadCartItems() async {
    if (user != null) {
      String uid = user!.uid;

      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cart')
            .get();

        setState(() {
          cartItems = snapshot.docs.map((doc) {
            return {
              'documentId': doc.id,
              'medicineName': doc['medicineName'],
              'genericName': doc['genericName'],
              'price': doc['price'],
              'quantity': doc['quantity'],
            };
          }).toList();
        });
      } catch (e) {
        print('Error loading cart items: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 130, 122, 202),
                  Colors.white,
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
                  'assets/logo.png',
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
              const SizedBox(height: 100.0),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                      stops: [0.4, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.only(
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
                          child: cartItems.isEmpty
                              ? const Center(child: Text('Your cart is empty'))
                              : ListView.builder(
                                  itemCount: cartItems.length,
                                  itemBuilder: (context, index) {
                                    return _buildCartItem(cartItems[index], index);
                                  },
                                ),
                        ),
                        const SizedBox(height: 16),
                        _buildPriceDetails(),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xff73544C),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicinSearch(),
                ),
              );
              break;
            case 1:
             
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderScreen(),
                ),
              );
              break;
            case 3:
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(user: user!),
                  ),
                );
              } else {
                
                print("User is not logged in.");
              }
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart_rounded),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> cartItem, int index) {
    final medicineName = cartItem['medicineName'] ?? 'Unknown';
    final price = cartItem['price'] ?? 0.0;
    final quantity = cartItem['quantity'] ?? 1;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Price: \$${price.toStringAsFixed(2)} x $quantity = \$${(price * quantity).toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            _buildQuantityController(cartItem, index),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color.fromARGB(255, 110, 102, 188)),
              onPressed: () {
                setState(() {
                  _removeItemFromCart(cartItem['documentId']);
                  cartItems.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityController(Map<String, dynamic> cartItem, int index) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF8A7FDB)),
          onPressed: () {
            setState(() {
              if (cartItem['quantity'] != null && cartItem['quantity'] > 1) {
                cartItem['quantity']--;
                _updateCartItemQuantity(cartItem['documentId'], cartItem['quantity']);
              } else {
                _removeItemFromCart(cartItem['documentId']);
                cartItems.removeAt(index);
              }
            });
          },
        ),
        Text(
          "${cartItem['quantity'] ?? 1}",
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF8A7FDB)),
          onPressed: () {
            setState(() {
              cartItem['quantity'] = (cartItem['quantity'] ?? 0) + 1;
              _updateCartItemQuantity(cartItem['documentId'], cartItem['quantity']);
            });
          },
        ),
      ],
    );
  }

  Widget _buildPriceDetails() {
    double total = 0;

    for (var item in cartItems) {
      final price = item['price'] ?? 0.0;
      final quantity = item['quantity'] ?? 1;
      total += price * quantity;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Price Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Total Price: \$${total.toStringAsFixed(2)}"),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactDetailScreen(cartItems: cartItems),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: const Color.fromARGB(255, 113, 101, 228),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        "Continue",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  
  Future<void> _removeItemFromCart(String documentId) async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('cart')
          .doc(documentId)
          .delete();
    }
  }

  // Update item quantity in Firestore
  Future<void> _updateCartItemQuantity(String documentId, int newQuantity) async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('cart')
          .doc(documentId)
          .update({'quantity': newQuantity});
    }
  }
}
