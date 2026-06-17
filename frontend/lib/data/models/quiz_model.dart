class Quiz {
  final int id;
  final String title;
  final List<Question> questions;

  Quiz({required this.id, required this.title, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Question {
  final int id;
  final String questionText;
  final String? questionType;
  final String? imageUrl;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionText,
    this.questionType,
    this.imageUrl,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['question_text'] ?? '',
      questionType: json['question_type'],
      imageUrl: json['image_url'],
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => Answer.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Answer {
  final int id;
  final String answerText;

  Answer({required this.id, required this.answerText});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answerText: json['answer_text'] ?? '',
    );
  }
}

class QuizResult {
  final int quizId;
  final int totalQuestions;
  final int correctAnswers;
  final double score;

  QuizResult({
    required this.quizId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quiz_id'],
      totalQuestions: json['total_questions'],
      correctAnswers: json['correct_answers'],
      score: (json['score'] as num).toDouble(),
    );
  }
}