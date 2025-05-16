import 'package:flutter/material.dart';
import 'package:hacksprint_mandya/fertilizer.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor: Colors.green.shade800, // Set AppBar color to green
      ),
      backgroundColor:
      Colors.green.shade50, // Set page background color to light green
      body: Padding(
        padding: const EdgeInsets.all(16), // Add padding around the buttons
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row 1: Buttons 1-3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStyledButton(
                  context,
                  'English',
                  Icons.language,
                  const FertilizerForm(),
                ),
                _buildStyledButton(
                  context,
                  'हिंदी',
                  Icons.language,
                  const Page2(),
                ),
                _buildStyledButton(
                  context,
                  'বাংলা',
                  Icons.language,
                  const Page3(),
                ), // Bengali
              ],
            ),
            const SizedBox(height: 20), // Add spacing between rows
            // Row 2: Buttons 4-6
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStyledButton(
                  context,
                  'मराठी',
                  Icons.language,
                  const Page4(),
                ),
                _buildStyledButton(
                  context,
                  'తెలుగు',
                  Icons.language,
                  const Page5(),
                ),
                _buildStyledButton(
                  context,
                  'தமிழ்',
                  Icons.language,
                  const Page6(),
                ),
              ],
            ),
            const SizedBox(height: 20), // Add spacing between rows
            // Row 3: Buttons 7-9
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStyledButton(
                  context,
                  'ಕನ್ನಡ',
                  Icons.language,
                  const Page7(),
                ),
                _buildStyledButton(
                  context,
                  'മലയാളം',
                  Icons.language,
                  const Page8(),
                ), // Malayalam
                _buildStyledButton(
                  context,
                  'ગુજરાતી',
                  Icons.language,
                  const Page9(),
                ), // Gujarati
              ],
            ),
            const SizedBox(height: 20), // Add spacing between rows
            // Row 4: Button 10
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStyledButton(
                  context,
                  'اُردُو',
                  Icons.language,
                  const Page10(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a styled button
  Widget _buildStyledButton(
      BuildContext context,
      String label,
      IconData icon,
      Widget page,
      ) {
    return InkWell(
      onTap: () {
        // Navigate to the respective page
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      borderRadius: BorderRadius.circular(20), // Rounded corners
      child: Container(
        width: 100, // Fixed width for consistency
        height: 100, // Fixed height for consistency
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade600,
              Colors.green.shade400,
            ], // Gradient effect
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade200.withAlpha(
                128,
              ), // Use .withAlpha() instead of .withOpacity()
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white), // Icon
            const SizedBox(height: 8), // Spacing between icon and text
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
