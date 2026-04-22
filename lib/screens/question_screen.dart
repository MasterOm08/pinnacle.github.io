import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class QuestionScreen extends StatelessWidget {
  final String category;
  final String topic;

  const QuestionScreen({super.key, required this.category, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text("$topic Quiz"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      // --- PART 1: DATA FETCHING ---
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .where('category', isEqualTo: category)
            .where('topic', isEqualTo: topic)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No questions found for $topic"));
          }

          // Pass the live data to the QuizView widget
          return QuizView(
            docs: snapshot.data!.docs, 
            topic: topic, 
            category: category
          );
        },
      ),
    );
  }
}

// --- PART 2: THE QUIZ LOGIC & UI ---
class QuizView extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;
  final String topic;
  final String category;

  const QuizView({
    super.key, 
    required this.docs, 
    required this.topic, 
    required this.category
  });

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late PageController _pageController;
  int _currentIndex = 0;
  int _score = 0;
  late List<bool> _hasMadeMistake;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _hasMadeMistake = List.generate(widget.docs.length, (index) => false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // SAVE PROGRESS TO FIREBASE
  Future<void> _saveProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final double percentage = (_score / widget.docs.length) * 100;

    await FirebaseFirestore.instance.collection('user_stats').add({
      'userId': user.uid,
      'topic': widget.topic,
      'category': widget.category,
      'score': _score,
      'total': widget.docs.length,
      'percentage': percentage.toInt(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.docs.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _saveProgress(); // Save to database when finished
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    double percentage = (_score / widget.docs.length) * 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Quiz Complete! 🎉", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Score: $_score / ${widget.docs.length}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Accuracy: ${percentage.toInt()}%"),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to topics
              },
              child: const Text("Finish"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_currentIndex + 1) / widget.docs.length;

    return Column(
      children: [
        // Progress Bar & Live Score
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Question ${_currentIndex + 1} of ${widget.docs.length}"),
                  Text("Score: $_score", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ],
          ),
        ),

        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: widget.docs.length,
            itemBuilder: (context, index) {
              var data = widget.docs[index].data() as Map<String, dynamic>;
              List options = data['options'] ?? [];
              int correctIdx = data['correctIndex'] ?? 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['questionText'] ?? "No question text available",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    ...List.generate(options.length, (optIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {
                            if (optIndex == correctIdx) {
                              HapticFeedback.lightImpact(); // Success tap
                              if (!_hasMadeMistake[index]) {
                                setState(() => _score++);
                              }
                              _nextQuestion();
                            } else {
                              HapticFeedback.vibrate(); // Error buzz
                              setState(() => _hasMadeMistake[index] = true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Incorrect! Try again."),
                                  duration: Duration(milliseconds: 1500),
                                ),
                              );
                            }
                          },
                          child: Text(
                            options[optIndex].toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}