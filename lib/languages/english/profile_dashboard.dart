import 'package:flutter/material.dart';
import 'package:hacksprint_mandya/auth/auth_wrapper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Card Below the AppBar
          Card(
            elevation: 4, // Add shadow for depth
            margin: const EdgeInsets.all(16), // Add margin around the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Icon
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.green.shade700, // Match the app bar color
                  ),
                  const SizedBox(
                    height: 16,
                  ), // Add spacing between icon and button
                  // Sign In / Log In Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to AuthWrapper when the button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthWrapper()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button background color
                      foregroundColor: Colors.white, // Button text color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Rounded button
                      ),
                    ),
                    child: const Text(
                      'Sign In / Log In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add more widgets here if needed
        ],
      ),
    );
  }
}
