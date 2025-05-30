import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; // Add this import
import '../languages/english/crop_recommendation(npk)/crop_prediction_screen.dart';
import '../languages/english/chatbot.dart';
import 'languageselect.dart';
import 'governmentschemes.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Replace Image.asset with Lottie animation
                Lottie.asset(
                  'assets/animations/splash_farmer.json', // Path to your Lottie JSON file
                  width: 400,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                Text(
                  "Chiguru",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade900,
                  ),
                ),
                Text(
                  "AI and IOT based App",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.brown.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                // Circular Button with Right Arrow Icon
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LanguageSelectionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    foregroundColor: Colors.purple.shade900,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Icon(Icons.arrow_forward, size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
