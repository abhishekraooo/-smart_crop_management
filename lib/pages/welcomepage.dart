import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'languageselect.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.jpg',
                ), // Path to your background image
                fit: BoxFit.cover, // Ensures the image covers the entire screen
              ),
            ),
          ),
          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.gif', // Path to your logo
                  width: 400,
                  height: 400,
                ),
                Text(
                  "Chiguru",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                Text(
                  "AI and IOT based App",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.green.shade900,
                  ),
                ),
                SizedBox(height: 10),
                // Circular Button with Right Arrow Icon
                ElevatedButton(
                  onPressed: () {
                    // Navigate to SensorScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LanguageSelectionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade50, // White background
                    foregroundColor: Colors.green.shade900, // Icon color
                    shape: CircleBorder(), // Makes the button circular
                    padding: EdgeInsets.all(15), // Padding for size
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 30,
                  ), // Green arrow icon
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
