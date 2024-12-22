import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMedicineDetails extends StatefulWidget {
  final String productId;

  const EditMedicineDetails({super.key, required this.productId});

  @override
  State<EditMedicineDetails> createState() => _EditMedicineDetailsState();
}

class _EditMedicineDetailsState extends State<EditMedicineDetails> {
  // Variables to hold product details
  String medicineName = '';
  String hsn = '';
  String pack = '';
  String mfg = '';
  String qty = '';
  String fq = '';
  String mrp = '';
  String batch = '';
  String exp = '';
  String rate = '';
  String disc = '';
  String sch = '';
  String gst = '';
  String taxable = '';
  String amount = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.productId)
          .get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          medicineName = data['medicineName'] ?? 'N/A';
          hsn = data['hsn']?.toString() ?? 'N/A';
          pack = data['pack'] ?? 'N/A';
          mfg = data['mfg'] ?? 'N/A';
          qty = data['qty']?.toString() ?? 'N/A';
          fq = data['fq']?.toString() ?? 'N/A';
          mrp = data['mrp']?.toString() ?? 'N/A';
          batch = data['batch'] ?? 'N/A';
          exp = data['exp'] ?? 'N/A';
          rate = data['rate']?.toString() ?? 'N/A';
          disc = data['disc']?.toString() ?? 'N/A';
          sch = data['sch']?.toString() ?? 'N/A';
          gst = data['gst']?.toString() ?? 'N/A';
          taxable = data['taxable']?.toString() ?? 'N/A';
          amount = data['amount']?.toString() ?? 'N/A';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching product data: $e');
      setState(() {
        isLoading = false;
      });
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
                  Color.fromARGB(255, 110, 102, 188),
                  Colors.white,
                ],
                radius: 2,
                center: Alignment(2.8, -1.0),
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
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              _buildDetailItem('Medicine Name', medicineName),
                              _buildDetailItem('HSN', hsn),
                              _buildDetailItem('Pack', pack),
                              _buildDetailItem('MFG', mfg),
                              _buildDetailItem('Quantity', qty),
                              _buildDetailItem('FQ', fq),
                              _buildDetailItem('MRP', mrp),
                              _buildDetailItem('Batch', batch),
                              _buildDetailItem('Expiry', exp),
                              _buildDetailItem('Rate', rate),
                              _buildDetailItem('Discount', disc),
                              _buildDetailItem('Scheme', sch),
                              _buildDetailItem('GST (%)', gst),
                              _buildDetailItem('Taxable Amount', taxable),
                              _buildDetailItem('Total Amount', amount),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16,horizontal: 100),
                                    backgroundColor:
                                        const Color.fromARGB(255, 113, 101, 228),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back',
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
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        // Label with border
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 110, 102, 188), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 110, 102, 188),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 8), // Space between label and value
        // Value with border
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}