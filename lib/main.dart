import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/welcomepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url:
    'https://yejipyydwdmiqzymlhon.supabase.co', // Replace with your Supabase URL
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllamlweXlkd2RtaXF6eW1saG9uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3NjI5MDEsImV4cCI6MjA2MTMzODkwMX0.aowVO0uS-N5bS_2wYjjhFlW4ctEyxxHkE3EovN2ymYg', // Replace with your anon public key
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
