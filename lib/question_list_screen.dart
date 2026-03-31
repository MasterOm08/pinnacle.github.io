import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Don't forget this import!
import 'models/question_model.dart';

class QuestionListScreen extends StatefulWidget {
  final String category;
  final String topic;

  const QuestionListScreen({super.key, required this.category, required this.topic});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Questions")),
      
      // --- TYPE THE STREAMBUILDER HERE ---
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('questions').where('category', isEqualTo: widget.category).where('topic', isEqualTo: widget.topic).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();

          // 1. Get the list of documents
          final docs = snapshot.data!.docs;

          // 2. Convert them into our Question objects
          final questions = docs.map((doc) => 
          Question.fromMap(doc.id, doc.data() as Map<String, dynamic>)
          ).toList();

          // 3. Build the list on screen
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. The Question Text
                      Text(
                        q.text,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),

                      // 2. The Options (The "Buttons")
                      // This loops through each option in your list [2, 4, 3, 5]
                      ...q.options.map((optionValue) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: double.infinity, // Makes buttons full width
                            child: ElevatedButton(
                              onPressed: () {
                                // Check if the answer is correct
                                if (q.options.indexOf(optionValue) == q.correctIndex) {
                                  print("Correct!");
                                } else {
                                  print("Try Again!");
                                }
                              },
                              child: Text(optionValue),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }
          );
            },
          )
    );
  }
}