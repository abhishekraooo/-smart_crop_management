import 'package:flutter/material.dart';
import 'package:hacksprint_mandya/utils/home_navigators.dart';
import 'auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({super.key, required this.authService});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isEmailLogin = true; // Toggle between email and phone login

  Future<void> _signInWithEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainNavigation(authService: widget.authService),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid credentials')));
      }
    }
  }

  Future<void> _sendOTP(BuildContext context) async {
    final success = await widget.authService.sendOTP(
      _phoneController.text.trim(),
    );
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('OTP sent successfully!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send OTP')));
    }
  }

  Future<void> _verifyOTP(BuildContext context) async {
    final success = await widget.authService.verifyOTP(
      _phoneController.text.trim(),
      _otpController.text.trim(),
    );
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(authService: widget.authService),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_isEmailLogin)
                Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator:
                          (value) => value!.isEmpty ? 'Enter an email' : null,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator:
                          (value) => value!.isEmpty ? 'Enter a password' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _signInWithEmail(context),
                      child: Text('Log In with Email'),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Enter a phone number' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _sendOTP(context),
                      child: Text('Send OTP'),
                    ),
                    TextFormField(
                      controller: _otpController,
                      decoration: InputDecoration(labelText: 'OTP'),
                      validator:
                          (value) => value!.isEmpty ? 'Enter the OTP' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _verifyOTP(context),
                      child: Text('Verify OTP'),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Text(
                'OR',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEmailLogin =
                        !_isEmailLogin; // Toggle between email and phone login
                  });
                },
                child: Text(
                  _isEmailLogin ? 'Login with OTP' : 'Log in with Email',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => SignupScreen(authService: widget.authService),
                    ),
                  );
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
