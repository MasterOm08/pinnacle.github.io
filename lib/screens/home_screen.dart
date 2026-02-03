import 'package:flutter/material.dart';
import '../widgets/big_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BigButton(
              title: 'English',
              color: Colors.blue,
              onTap: () {},
            ),
            BigButton(
              title: 'Math',
              color: Colors.green,
              onTap: () {},
            ),
            BigButton(
              title: 'Science',
              color: Colors.orange,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}