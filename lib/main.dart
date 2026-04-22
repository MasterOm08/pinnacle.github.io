import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_test1/screens/auth_screen.dart'; // Ensure this path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // FIX: Just call MyApp() without any arguments here
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The 'home' parameter lives inside MaterialApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PadhoPlay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthScreen(), // This is where you set the starting screen
    );
  }
}