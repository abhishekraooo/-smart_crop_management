import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hacksprint_mandya/auth/auth_service.dart';
import 'package:hacksprint_mandya/languages/english/crop_dashboard.dart';
import 'package:hacksprint_mandya/languages/english/profile_dashboard.dart';
import 'package:hacksprint_mandya/languages/english/sensor_dashboard.dart';

class MainNavigation extends StatefulWidget {
  final AuthService authService;

  const MainNavigation({super.key, required this.authService});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Your existing home screen (Pre)
    SensorDashboard(), // New screen for Post
    ProfilePage(), // New screen for Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.seedling),
            activeIcon: FaIcon(FontAwesomeIcons.seedling),
            label: 'Crop',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.wifi),
            activeIcon: FaIcon(FontAwesomeIcons.wifi),
            label: 'IOT',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userLarge),
            activeIcon: FaIcon(FontAwesomeIcons.userLarge),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
