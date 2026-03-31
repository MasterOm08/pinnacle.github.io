class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id, 
    required this.text, 
    required this.options, 
    required this.correctIndex
  });

  // This "factory" takes the Firestore data and turns it into a Question object
  factory Question.fromMap(String id, Map<String, dynamic> data) {
    return Question(
      id: id.toString(),
      text: data['questionText']?.toString() ?? '',
      options: (data['options'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ?? [],
      correctIndex: data['correctIndex'] ?? 0,
    );
  }
}