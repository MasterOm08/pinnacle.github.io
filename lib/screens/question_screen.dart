import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {

  int currentIndex = 0;
  int score = 0;
  Color? feedbackColor;

  final TextEditingController controller = TextEditingController();

  final List<Question> questions = [

    Question(
      questionText: "2 + 2 = ?",
      type: QuestionType.mcq,
      options: ["2", "3", "4", "5"],
      answer: "4",
    ),

    Question(
      questionText: "The Sun is a planet.",
      type: QuestionType.trueFalse,
      options: ["True", "False"],
      answer: "False",
    ),

    Question(
      questionText: "5 + __ = 8",
      type: QuestionType.fillBlank,
      answer: "3",
    ),
  ];

  void checkAnswer(String answer) {
    bool isCorrect =
        answer.trim().toLowerCase() ==
        questions[currentIndex].answer.toLowerCase();

    setState(() {
      feedbackColor = isCorrect ? Colors.green : Colors.red;
      if (isCorrect) score++;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          currentIndex++;
          feedbackColor = null;
          controller.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // 🔥 When quiz is finished
    if (currentIndex >= questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text("Result")),
        body: Center(
          child: Text(
            "Your Score: $score / ${questions.length}",
            style: const TextStyle(fontSize: 24),
          ),
        ),
      );
    }

    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Score: $score"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 Progress Bar
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 20),

            // 🔥 Animated Question Card
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: feedbackColor?.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 MCQ & True/False
                  if (question.type == QuestionType.mcq ||
                      question.type == QuestionType.trueFalse)

                    ...question.options!.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () => checkAnswer(option),
                          child: Text(option),
                        ),
                      ),
                    ),

                  // 🔥 Fill in the Blank
                  if (question.type == QuestionType.fillBlank)
                    Column(
                      children: [
                        TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter answer",
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () =>
                              checkAnswer(controller.text),
                          child: const Text("Submit"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}