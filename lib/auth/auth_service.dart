import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  final Logger _logger = Logger();

  // Sign Up with Email
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _logger.i('Sign up successful!');
        return true;
      } else {
        _logger.e('Sign up failed.');
        return false;
      }
    } catch (e) {
      _logger.e('Error signing up: $e');
      return false;
    }
  }

  // Log In with Email
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _logger.i('Login successful!');
        return true;
      } else {
        _logger.e('Login failed.');
        return false;
      }
    } catch (e) {
      _logger.e('Error signing in: $e');
      return false;
    }
  }

  // Send OTP for Phone Authentication
  Future<bool> sendOTP(String phoneNumber) async {
    try {
      await supabase.auth.signInWithOtp(phone: phoneNumber);
      _logger.i('OTP sent successfully!');
      return true;
    } catch (e) {
      _logger.e('Error sending OTP: $e');
      return false;
    }
  }

  // Verify OTP for Phone Authentication
  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    try {
      final response = await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms, // Add the required 'type' parameter
      );
      if (response.user != null) {
        _logger.i('OTP verification successful!');
        return true;
      } else {
        _logger.e('OTP verification failed.');
        return false;
      }
    } catch (e) {
      _logger.e('Error verifying OTP: $e');
      return false;
    }
  }

  // Log Out
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      _logger.i('User logged out');
    } catch (e) {
      _logger.e('Error logging out: $e');
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return supabase.auth.currentSession != null;
  }
}
