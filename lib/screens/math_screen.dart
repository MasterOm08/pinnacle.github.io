import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test1/models/question_model.dart';

class MathScreen extends StatelessWidget {
  const MathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maths")),
    // Inside the build method of your MathScreen
    body: StreamBuilder<QuerySnapshot>(
      // 1. The Filtered Query
      stream: FirebaseFirestore.instance
          .collection('questions')
          .where('category', isEqualTo: 'Maths') // This is the magic line
          .snapshots(),
  
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Error loading Math questions');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Convert the snapshot into your List of Questions
        final docs = snapshot.data!.docs;
        final mathQuestions = docs.map((doc) => 
          Question.fromMap(doc.id, doc.data() as Map<String, dynamic>)
        ).toList();

        // 3. If no math questions exist yet
        if (mathQuestions.isEmpty) {
          return const Center(child: Text("No Math questions found."));
        }

        return ListView.builder(
          itemCount: mathQuestions.length,
          itemBuilder: (context, index) {
            final q = mathQuestions[index];
            return ListTile(
              title: Text(q.text),
              subtitle: Text("${q.options.length} options"),
              onTap: () {
            // This is where you'll eventually start the actual quiz logic
          },
        );
      },
    );
  },
),
    );
  }
}