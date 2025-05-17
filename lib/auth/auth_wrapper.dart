import 'package:flutter/material.dart';
import 'package:hacksprint_mandya/auth/auth_service.dart';
import 'package:hacksprint_mandya/utils/home_navigators.dart';
import 'package:hacksprint_mandya/utils/session_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService authService = AuthService();
  final SessionManager sessionManager = SessionManager();

  AuthWrapper({super.key}); // Made constructor const

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          // Handle error case
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final isLoggedIn = authService.isLoggedIn();
        return isLoggedIn
            ? MainNavigation(authService: authService) // Fixed parameter name
            : LoginScreen(authService: authService);
      },
    );
  }

  Future<bool> _checkSession() async {
    try {
      final token = await sessionManager.getSession();
      if (token != null) {
        await Supabase.instance.client.auth.recoverSession(token);
        return true;
      }
      return false;
    } catch (e) {
      // Handle any errors during session recovery
      return false;
    }
  }
}
