import 'package:flutter/material.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Science")),
      body: const Center(
        child: Text(
          "Science Questions Coming Soon",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}