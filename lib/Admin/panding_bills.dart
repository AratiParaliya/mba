import 'package:flutter/material.dart';
import 'package:mba/Admin/bill_number.dart';

class PandingBills extends StatelessWidget {
  const PandingBills({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
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
          // Top logo and title
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

          // Grey container with rounded corners and table layout
          Column(
            children: [
              const SizedBox(
                height: 100.0, // Space for logo area
              ),
              Expanded(
                child: Container(
                  width: double.infinity, // Full width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white, // Light color
                        const Color.fromARGB(255, 143, 133, 230), // Darker purple
                      ],
                      stops: [0.6, 1.0], // Adjust stops to control color spread
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
                      children: [
                        // Search bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: const Color.fromARGB(255, 110, 102, 188), width: 1.5),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Pending Bill',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Table header with borders around labels
                        Row(
                          children: [
                            Expanded(flex: 2, child: headerTextWithBorder('Date')),
                            const SizedBox(width: 10), // Space between Date and Bill No.
                            Expanded(flex: 2, child: headerTextWithBorder('Bill No.')),
                            const SizedBox(width: 10), // Space between Bill No. and Contact No.
                            Expanded(flex: 2, child: headerTextWithBorder('Contact No.')),
                            const SizedBox(width: 10), // Space between Contact No. and Delete
                            Expanded(flex: 1, child: headerTextWithBorder('Delete')), // Flex for Delete // Flex for Delete
                          ],
                        ),
                        const SizedBox(height: 10.0),

                        // Table data in a ListView
                        Expanded(
                          child: ListView.builder(
                            itemCount: 8, // Number of rows
                            itemBuilder: (context, index) {
                              String billNo = '1111'; // You can dynamically change this as per your logic
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding between rows
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: tableCell('03/08/2024')),
                                     const SizedBox(width: 10), // Date
                                    
                                    // Bill No with InkWell for Navigation
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: () {
                                          // Navigate to BillDetailsPage with the bill number
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BillNumber(billNo: billNo),
                                            ),
                                          );
                                        },
                                        child: tableCell(billNo),
                                      ),
                                    ),
                                    
                                     const SizedBox(width: 10), // Bill No.
                                    Expanded(flex: 2, child: tableCell('123-456-7890')), 
                                     const SizedBox(width: 10),// Contact No.
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete, color: Color.fromARGB(255, 110, 102, 188)),
                                        onPressed: () {
                                          // Action to delete the item
                                        },
                                      ),
                                    ), // Delete Icon Button
                                  ],
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
        ],
      ),
    );
  }

  // Function to create table header text with border
  Widget headerTextWithBorder(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 110, 102, 188), // Border color
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 110, 102, 188), // Updated header color
        ),
      ),
    );
  }

  // Function to create a table cell
  Widget tableCell(String text) {
    return Container(
      height: 40.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color.fromARGB(255, 206, 203, 234)), // Updated border color
      ),
      child: Text(
        text,
        textAlign: TextAlign.center, // Center align text in the cell
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
