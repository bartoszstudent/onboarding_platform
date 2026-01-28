class Quiz {
  final int id;
  final String title;
  final List<Question> questions;

  Quiz({required this.id, required this.title, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }
}

class Question {
  final int id;
  final String questionText;
  final String questionType;
  final String? imageUrl;
  final List<Answer> answers;
  final int? correct;

  Question({
    required this.id,
    required this.questionText,
    required this.questionType,
    this.imageUrl,
    required this.answers,
    this.correct,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['question_text'],
      questionType: json['question_type'],
      imageUrl: json['image_url'],
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e))
          .toList(),
       correct: json['correct'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'question': questionText,
      'answers': answers.map((a) => a.answerText).toList(),
      'correct': correct,
    };
  }
}

class Answer {
  final int id;
  final String answerText;

  Answer({required this.id, required this.answerText});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answerText: json['answer_text'],
    );
  }
}
