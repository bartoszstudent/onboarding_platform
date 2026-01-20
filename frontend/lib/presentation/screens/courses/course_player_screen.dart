import 'package:flutter/material.dart';
import '../../ui/app_card.dart';
import 'widgets/quiz_widget.dart';
import '../../../data/models/course_model.dart';
import '../../../data/services/quiz_service.dart';
import '../../../data/models/quiz_model.dart';

class CoursePlayerScreen extends StatefulWidget {
  final Course course;
  const CoursePlayerScreen({super.key, required this.course});

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  int currentSection = 0;
  bool _loading = true;
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuiz(); 
  }

  Future<void> _loadQuiz() async {
    try {
      final quizData = await QuizService.fetchQuizForCourse(widget.course.id);
      setState(() {
        _questions = quizData.questions;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Błąd ładowania quizu: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title)),
      body: _loading//sections.isEmpty
          ? const Center(child: Text("Brak treści w kursie."))
          : _questions.isEmpty
        ? const Center(child: Text("Brak quizów w tym kursie."))
        : Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return QuizWidget(quiz: question.toJson());
              },
            ),
          ),
    );
  }
}
