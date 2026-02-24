import 'package:flutter/material.dart';

class MathScreen extends StatelessWidget {
  const MathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Math")),
      body: const Center(
        child: Text(
          "Math Questions Coming Soon",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}