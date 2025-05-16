import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/welcomepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url:
        'https://ndmabmidylalbwmsyxet.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5kbWFibWlkeWxhbGJ3bXN5eGV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0MDI1MzMsImV4cCI6MjA2Mjk3ODUzM30.uyoukqvbNZqK7GsH1cwkJVLWGaMLlma7s8MeVFHmGOQ', // Replace with your anon public key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(), // Set WelcomeScreen as the home page
    );
  }
}
