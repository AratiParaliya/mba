import 'package:flutter/material.dart';

class InvoiceDownload extends StatelessWidget {
  const InvoiceDownload({super.key});

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
                              hintText: 'Search with date',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Table header with borders around labels
                        Row(
                          children: [
                            headerTextWithBorder('Date'),
                            const SizedBox(width: 20.0), // Space between Date and Bill No.
                            headerTextWithBorder('Bill No.'),
                            const SizedBox(width: 20.0), // Space between Bill No. and Download
                            headerTextWithBorder('Download'),
                          ],
                        ),
                        const SizedBox(height: 10.0),

                        // Table data in a ListView
                        Expanded(
                          child: ListView.builder(
                            itemCount: 8, // Number of rows
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding between rows
                                child: Row(
                                  children: [
                                    // Date cell
                                    tableCell('03/08/2024'),
                                    const SizedBox(width: 20.0), // Space between Date and Bill No.
                                    // Bill No. cell
                                    tableCell('1111'),
                                    const SizedBox(width: 20.0), // Space between Bill No. and Download
                                    
                                    // Download button
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 40.0,
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Action for download
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(255, 199, 194, 246), // Updated button color
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'Download',
                                            style: TextStyle(color: Color.fromARGB(255, 110, 102, 188)),
                                          ),
                                        ),
                                      ),
                                    ),
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
    return Expanded(
      flex: 1,
      child: Container(
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
      ),
    );
  }

  // Function to create a table cell
  Widget tableCell(String text) {
    return Expanded(
      flex: 1,
      child: Container(
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
      ),
    );
  }
}
