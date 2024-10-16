import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'cart.dart'; // Import your Cart screen
import 'medicin_search.dart'; // Import your MedicinSearch screen
import 'order_screen.dart'; // Import your Order screen

class UserProfilePage extends StatefulWidget {
  final User user; // Firebase User object

  UserProfilePage({required this.user});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _currentIndex = 3; // Assuming this is the index for UserProfilePage

  Future<Map<String, dynamic>> _getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();

    return snapshot.data() ?? {};
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

          // Profile Content
          FutureBuilder<Map<String, dynamic>>(
            future: _getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading profile data'));
              } else {
                final userData = snapshot.data ?? {};

                return Column(
                  children: [
                    // Profile header section
                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 120),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userData['username'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Add space between header and profile information
                    // Profile information tiles
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          _buildProfileTile(
                            icon: Icons.phone,
                            iconColor: Colors.amber,
                            title: userData['phone'] ?? 'N/A',
                          ),
                          const SizedBox(height: 10),
                          _buildProfileTile(
                            icon: Icons.email,
                            iconColor: Colors.amber,
                            title: widget.user.email ?? 'N/A',
                          ),
                          const SizedBox(height: 10),
                          _buildProfileTile(
                            icon: Icons.location_on,
                            iconColor: Colors.amber,
                            title: userData['address'] ?? 'Fill in the address',
                          ),
                          const SizedBox(height: 10),
                          _buildProfileTile(
                            icon: Icons.notes,
                            iconColor: Colors.red,
                            title: userData['notes'] ?? 'none',
                          ),
                          const SizedBox(height: 10),
                          // Log out tile
                          GestureDetector(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacementNamed('/login'); // Update navigation
                            },
                            child: _buildProfileTile(
                              icon: Icons.logout,
                              iconColor: Colors.red,
                              title: 'Log out',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          // DotNavigationBar for bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: DotNavigationBar(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                currentIndex: _currentIndex,
                dotIndicatorColor: const Color(0xff73544C),
                unselectedItemColor: Colors.grey[300],
                splashBorderRadius: 50,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });

                  switch (index) {
                    case 0:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MedicinSearch()),
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cart(cartItems: [],)),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderScreen( )),
                      );
                      break;
                    case 3:
                      // Already on Profile Page
                      break;
                  }
                },
                items: [
                  DotNavigationBarItem(
                    icon: const Icon(Icons.home),
                    selectedColor: const Color(0xff73544C),
                  ),
                  DotNavigationBarItem(
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    selectedColor: const Color(0xff73544C),
                  ),
                  DotNavigationBarItem(
                    icon: const Icon(Icons.border_outer_outlined),
                    selectedColor: const Color(0xff73544C),
                  ),
                  DotNavigationBarItem(
                    icon: const Icon(Icons.person),
                    selectedColor: const Color(0xff73544C),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build Profile Tile with icon and text
  Widget _buildProfileTile({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
