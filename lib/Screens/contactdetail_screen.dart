import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mba/Screens/orderconfirmation_page.dart';

class ContactDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const ContactDetailScreen({Key? key, required this.cartItems})
      : super(key: key);

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController alternateNumberController =
      TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  bool isSaving = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkForExistingOrder();
  }

  Future<void> _checkForExistingOrder() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN_USER_ID';

    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order')
        .get();

    if (ordersSnapshot.docs.isNotEmpty) {
      DocumentSnapshot orderDoc = ordersSnapshot.docs.last;
      final orderData = orderDoc.data() as Map<String, dynamic>;

      fullNameController.text = orderData['fullName'] ?? '';
      contactNameController.text = orderData['contactNumber'] ?? '';
      alternateNumberController.text = orderData['alternateNumber'] ?? '';
      emailAddressController.text = orderData['emailAddress'] ?? '';
      addressController.text = orderData['address'] ?? '';
      pincodeController.text = orderData['pinCode'] ?? '';
      cityController.text = orderData['city'] ?? '';
      stateController.text = orderData['state'] ?? '';
    }

    setState(() {
      isLoading = false;
    });
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in widget.cartItems) {
      final price = item['price'] ?? 0.0;
      final quantity = item['quantity'] ?? 1;
      totalPrice += price * quantity;
    }
    return totalPrice;
  }

  Future<void> _saveOrderDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      String userId =
          FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN_USER_ID';
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      final orderData = {
        'userId': userId,
        'orderId': orderId,
        'fullName': fullNameController.text,
        'contactNumber': contactNameController.text,
        'alternateNumber': alternateNumberController.text,
        'emailAddress': emailAddressController.text,
        'address': addressController.text,
        'pinCode': pincodeController.text,
        'city': cityController.text,
        'state': stateController.text,
        'cartItems': widget.cartItems,
        'totalPrice': _calculateTotalPrice(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('order')
          .doc(orderId)
          .set(orderData);
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderData);
      await FirebaseFirestore.instance
          .collection('pending_bills')
          .doc(orderId)
          .set(orderData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order saved successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderConfirmationPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to save order. Please try again.")),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                      stops: [0.3, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildSectionTitle('Your Cart Items'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.cartItems.length,
                            itemBuilder: (context, index) {
                              final item = widget.cartItems[index];
                              final medicineName =
                                  item['medicineName'] ?? 'Unknown';
                              final price = item['price'] ?? 0.0;
                              final quantity = item['quantity'] ?? 1;
                              return ListTile(
                                title: Text(medicineName),
                                subtitle: Text(
                                  "Price: \$${price.toStringAsFixed(2)} x $quantity = \$${(price * quantity).toStringAsFixed(2)}",
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Total Price'),
                          Text(
                            "\$${_calculateTotalPrice().toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6F48EB),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Contact Details'),
                          _buildCustomTextFormField(
                              'Full Name', fullNameController),
                          _buildCustomTextFormField(
                              'Contact Number', contactNameController),
                          _buildCustomTextFormField(
                              'Alternate Number', alternateNumberController),
                          _buildCustomTextFormField(
                              'Email Address', emailAddressController),
                          _buildCustomTextFormField(
                              'Address', addressController),
                          _buildCustomTextFormField(
                              'Pincode', pincodeController),
                          _buildCustomTextFormField('City', cityController),
                          _buildCustomTextFormField('State', stateController),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isSaving ? null : _saveOrderDetails,
                            child: isSaving
                                ? const CircularProgressIndicator()
                                : const Text("place order"),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6F48EB),
        ),
      ),
    );
  }

  Widget _buildCustomTextFormField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FD),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6F48EB),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10), // Space between label and text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FD),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter $label',
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
