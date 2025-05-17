import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacksprint_mandya/auth/auth_service.dart';
import 'package:hacksprint_mandya/pages/fertilizer.dart';
import 'package:hacksprint_mandya/languages/bengali/crop_recommendation(npk)/crop_prediction_screen_be.dart';
import 'package:hacksprint_mandya/languages/english/crop_recommendation(npk)/crop_prediction_screen.dart';
import 'package:hacksprint_mandya/languages/gujarati/crop_recommendation(npk)/crop_prediction_screen_gu.dart';
import 'package:hacksprint_mandya/languages/hindi/crop_recommendation(npk)/crop_prediction_screen_hi.dart';
import 'package:hacksprint_mandya/languages/kannada/crop_recommendation(npk)/crop_prediction_screen_ka.dart';
import 'package:hacksprint_mandya/languages/malayalam/crop_recommendation(npk)/crop_prediction_screen_ma.dart';
import 'package:hacksprint_mandya/languages/marathi/crop_recommendation(npk)/crop_prediction_screen_mar.dart';
import 'package:hacksprint_mandya/languages/tamil/crop_recommendation(npk)/crop_prediction_screen_tam.dart';
import 'package:hacksprint_mandya/languages/telugu/crop_recommendation(npk)/crop_prediction_screen_tel.dart';
import 'package:hacksprint_mandya/languages/urdu/crop_recommendation(npk)/crop_prediction_screen_ur.dart';
import 'package:hacksprint_mandya/utils/model.dart';
import 'package:hacksprint_mandya/utils/home_navigators.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null, backgroundColor: Colors.green.shade100),
      backgroundColor: Colors.green.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Select your Language",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 25),
            // Row 1: Buttons 1-3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStyledButton(
                  context,
                  'English',
                  'E',
                  CropPredictionScreen(),
                ),
                _buildStyledButton(
                  context,
                  'हिंदी',
                  'ह',
                  CropPredictionScreenHI(),
                ),
                _buildStyledButton(
                  context,
                  'ಕನ್ನಡ',
                  'ಕ',
                  CropPredictionScreenKA(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Row 2: Buttons 4-6
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStyledButton(
                  context,
                  'मराठी',
                  'म',
                  CropPredictionScreenMR(),
                ),
                _buildStyledButton(
                  context,
                  'తెలుగు',
                  'త',
                  CropPredictionScreenTE(),
                ),
                _buildStyledButton(
                  context,
                  'தமிழ்',
                  'த',
                  CropPredictionScreenTA(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Row 3: Buttons 7-9
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStyledButton(
                  context,
                  'বাংলা',
                  'ব',
                  CropPredictionScreenBE(),
                ), // Bengali
                _buildStyledButton(
                  context,
                  'മലയാളം',
                  'മ',
                  CropPredictionScreenMA(),
                ), // Malayalam
                _buildStyledButton(
                  context,
                  'ગુજરાતી',
                  'ગ',
                  CropPredictionScreenGU(),
                ), // Gujarati
              ],
            ),
            const SizedBox(height: 20),
            // Row 4: Button 10
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStyledButton(
                  context,
                  'اُردُو',
                  'ا',
                  CropPredictionScreenUR(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Modified helper method to use text instead of icon
  Widget _buildStyledButton(
    BuildContext context,
    String label,
    String firstLetter,
    Widget page,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade600, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade200.withAlpha(128),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              firstLetter,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep your existing page classes (Page1 to Page10) unchanged
// Example pages for navigation
class Page1 extends StatelessWidget {
  const Page1({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 1')));
}

class Page2 extends StatelessWidget {
  const Page2({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 2')));
}

class Page3 extends StatelessWidget {
  const Page3({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 3')));
}

class Page4 extends StatelessWidget {
  const Page4({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 4')));
}

class Page5 extends StatelessWidget {
  const Page5({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 5')));
}

class Page6 extends StatelessWidget {
  const Page6({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 6')));
}

class Page7 extends StatelessWidget {
  const Page7({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 7')));
}

class Page8 extends StatelessWidget {
  const Page8({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 8')));
}

class Page9 extends StatelessWidget {
  const Page9({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 9')));
}

class Page10 extends StatelessWidget {
  const Page10({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Page 10')));
}
