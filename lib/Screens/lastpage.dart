import 'package:flutter/material.dart';

class Lastpage extends StatelessWidget {
  const Lastpage({super.key});

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
          // Grey container with rounded corners at the top
          Column(
            children: [
              SizedBox(
                height: 100.0, // This height should be slightly less than the blue container's height
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity, // Make it full width
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                           begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 143, 133, 230),
                      ],
                      stops: [0.4, 1.0], // Adjust stops to control color spread
                      tileMode: TileMode.clamp,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                    ),
                    // Centered text with image above
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Confirm.png', // Add the image asset path
                            width: 300, // Set the size of the image
                            height: 300,
                          ),
                          const SizedBox(height: 20), // Space between image and text
                          const Text(
                            'Thank you !!!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 100, 12, 5), // Red color for the text
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10), // Space between the two texts
                          const Text(
                            'For any further proceedings, \nwe will be in touch with you directly.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 100, 12, 5), // Grey color for the additional text
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
