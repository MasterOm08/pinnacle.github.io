enum QuestionType {
  mcq,
  trueFalse,
  fillBlank,
}

class Question {
  final String questionText;
  final QuestionType type;
  final List<String>? options;
  final String answer;

  Question({
    required this.questionText,
    required this.type,
    this.options,
    required this.answer,
  });
}