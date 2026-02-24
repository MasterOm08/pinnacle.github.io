import 'package:flutter/material.dart';

class EnglishScreen extends StatelessWidget {
  const EnglishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("English")),
      body: const Center(
        child: Text(
          "English Questions Coming Soon",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}