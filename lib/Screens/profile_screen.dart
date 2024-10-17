import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart.dart'; // Import your Cart screen
import 'medicin_search.dart'; // Import your MedicinSearch screen

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

  Future<void> _updateUserData(Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update(updatedData);
    // Optionally show a success message or feedback
  }

  void _editProfile() async {
    final userData = await _getUserData();

    final usernameController = TextEditingController(text: userData['username']);
    final phoneController = TextEditingController(text: userData['phone']);
    final addressController = TextEditingController(text: userData['address']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedData = {
                  'username': usernameController.text,
                  'phone': phoneController.text,
                  'address': addressController.text,
                };
                _updateUserData(updatedData);
                Navigator.pop(context);
                setState(() {}); // Refresh the user data
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
                   
                    const SizedBox(height: 20), // Add space between header and profile information
                    // Profile information tiles
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                         
                          const SizedBox(height: 80),
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              userData['username'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                           TextButton(
                            onPressed: _editProfile, // Edit profile button
                            child: const Text('Edit Profile'),
                          ),
                            const SizedBox(height: 10),
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

          // Orders screen Section
          if (_currentIndex == 2) _buildOrdersScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Cart(cartItems: [])),
              );
              break;
            case 2:
              setState(() {
                // Show orders screen without navigating away
                _currentIndex = 2;
              });
              break;
            case 3:
              // Already on Profile Page
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey), // Gray icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.grey), // Gray icon
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_outer_outlined, color: Colors.grey), // Gray icon
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey), // Gray icon
            label: 'Profile',
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

  // Method to build Orders screen
  Widget _buildOrdersScreen() {
    return Positioned.fill(
      child: Column(
        children: [
          SizedBox(height: 100.0), // Space for the header
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white, // Light color
                    Color.fromARGB(255, 143, 133, 230), // Darker purple
                  ],
                  stops: [0.3, 1.0], // Adjust stops to control color spread
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Center(
                child: Text(
                  'Orders Screen', // Placeholder for orders content
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
