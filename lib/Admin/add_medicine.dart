import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'delete_medicine.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final TextEditingController medicineNameController = TextEditingController();

 
  final TextEditingController hsnController = TextEditingController();
  final TextEditingController packController = TextEditingController();
  final TextEditingController mfgController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController fqController = TextEditingController();
  final TextEditingController mrpController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController discController = TextEditingController();
  final TextEditingController schController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController taxableController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final CollectionReference medicinesCollection =
      FirebaseFirestore.instance.collection('product');

  Future<void> _addMedicine() async {
    if (medicineNameController.text.isEmpty ||
       
        hsnController.text.isEmpty ||
        packController.text.isEmpty ||
        mfgController.text.isEmpty ||
        qtyController.text.isEmpty ||
        fqController.text.isEmpty ||
        mrpController.text.isEmpty ||
        batchController.text.isEmpty ||
        expController.text.isEmpty ||
        rateController.text.isEmpty ||
        discController.text.isEmpty ||
        gstController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      String newProductId = await _generateNewProductId();
      double mrp = double.tryParse(mrpController.text.trim()) ?? 0.0;
      double disc = double.tryParse(discController.text.trim()) ?? 0.0;
      double gst = double.tryParse(gstController.text.trim()) ?? 0.0;
      double taxable = mrp - (mrp * disc / 100);
      double amount = taxable + (taxable * gst / 100);

      final medicineData = {
        'productId': newProductId,
        'medicineName': medicineNameController.text.trim(),
     
        'hsn': hsnController.text.trim(),
        'pack': packController.text.trim(),
        'mfg': mfgController.text.trim(),
        'qty': qtyController.text.trim(),
        'mrp': mrp,
        'batch': batchController.text.trim(),
        'exp': expController.text.trim(),
        'rate': rateController.text.trim(),
        'disc': disc,
        'sch': schController.text.trim(),
        'taxable': taxable,
        'gst': gst,
        'amount': amount,
      };

      await medicinesCollection.doc(newProductId).set(medicineData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine added successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FetchMedicines()),
      );

      medicineNameController.clear();
   
      hsnController.clear();
      packController.clear();
      mfgController.clear();
      qtyController.clear();
      fqController.clear();
      mrpController.clear();
      batchController.clear();
      expController.clear();
      rateController.clear();
      discController.clear();
      schController.clear();
      taxableController.clear();
      gstController.clear();
      amountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding medicine: $e')),
      );
    }
  }

  Future<String> _generateNewProductId() async {
    QuerySnapshot querySnapshot = await medicinesCollection
        .orderBy('productId', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String lastProductId = querySnapshot.docs.first['productId'];
      int lastIdNumber = int.parse(lastProductId.substring(1));
      int newIdNumber = lastIdNumber + 1;
      return 'P${newIdNumber.toString().padLeft(3, '0')}';
    } else {
      return 'P001';
    }
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6F48EB),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: isEnabled,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF6F48EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF6F48EB), width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: isEnabled ? Colors.white : Colors.grey[200],
            ),
            keyboardType: (label == 'Disc' || label == 'GST%') ? TextInputType.number : TextInputType.text,
          ),
        ],
      ),
    );
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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                      stops: [0.6, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildCustomTextField(
                          label: 'Medicine Name',
                          controller: medicineNameController,
                          hintText: 'Enter medicine name',
                        ),
                   
                        _buildCustomTextField(
                          label: 'HSN',
                          controller: hsnController,
                          hintText: 'Enter HSN code',
                        ),
                        _buildCustomTextField(
                          label: 'Pack',
                          controller: packController,
                          hintText: 'Enter pack size',
                        ),
                        _buildCustomTextField(
                          label: 'MFG',
                          controller: mfgController,
                          hintText: 'Enter manufacturer',
                        ),
                        _buildCustomTextField(
                          label: 'QTY',
                          controller: qtyController,
                          hintText: 'Enter quantity',
                        ),
                        _buildCustomTextField(
                          label: 'FQ',
                          controller: fqController,
                          hintText: 'Enter FQ',
                        ),
                        _buildCustomTextField(
                          label: 'MRP',
                          controller: mrpController,
                          hintText: 'Enter MRP',
                        ),
                        _buildCustomTextField(
                          label: 'Batch',
                          controller: batchController,
                          hintText: 'Enter batch',
                        ),
                        _buildCustomTextField(
                          label: 'Exp',
                          controller: expController,
                          hintText: 'Enter expiry date',
                        ),
                        _buildCustomTextField(
                          label: 'Rate',
                          controller: rateController,
                          hintText: 'Enter rate',
                        ),
                        _buildCustomTextField(
                          label: 'Disc',
                          controller: discController,
                          hintText: 'Enter discount (%)',
                        ),
                        _buildCustomTextField(
                          label: 'Sch.',
                          controller: schController,
                          hintText: 'Enter scheme',
                        ),
                        _buildCustomTextField(
                          label: 'Taxable',
                          controller: taxableController,
                          hintText: 'Calculated automatically',
                          isEnabled: false,
                        ),
                        _buildCustomTextField(
                          label: 'GST%',
                          controller: gstController,
                          hintText: 'Enter GST (%)',
                        ),
                        _buildCustomTextField(
                          label: 'Amount',
                          controller: amountController,
                          hintText: 'Calculated automatically',
                          isEnabled: false,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _addMedicine,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: const Color(0xFF6F48EB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Add Product',
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
                        const SizedBox(height: 20),
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
}
