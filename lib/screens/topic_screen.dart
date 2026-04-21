import 'package:flutter/material.dart';
import '../question_list_screen.dart'; // Import the screen that shows the actual questions

class TopicScreen extends StatelessWidget {
  final String category; // e.g., "Maths"
  
  const TopicScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // List of topics for this category
    final List<String> mathTopics = ["Arithmetic", "Fractions", "Geometry"];

    return Scaffold(
      appBar: AppBar(title: Text("$category Topics")),
      body: ListView.builder(
        itemCount: mathTopics.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mathTopics[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to the questions, passing BOTH category and topic
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionScreen(
                    category: category,
                    topic: mathTopics[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}