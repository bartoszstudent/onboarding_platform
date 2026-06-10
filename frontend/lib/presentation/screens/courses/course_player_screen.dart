import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/quiz_widget.dart';
import '../../../data/models/course_model.dart';
import '../../../data/services/quiz_service.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/models/badge_model.dart';
import '../../components/widgets/badge_award_dialog.dart';

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
  final Set<int> _answeredIndices = {};

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
    final allAnswered = _answeredIndices.length == _questions.length && _questions.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? const Center(child: Text("Brak quizów w tym kursie."))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            final question = _questions[index];
                            return QuizWidget(
                              quiz: question.toJson(),
                              onAnswered: (correct) {
                                setState(() {
                                  _answeredIndices.add(index);
                                });
                              },
                            );
                          },
                        ),
                      ),
                      if (allAnswered) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              const badge = BadgeModel(
                                id: 'b_course_completed',
                                name: 'Mistrz Wiedzy 🎓',
                                description: 'Ukończono quiz i wykazano się wiedzą merytoryczną.',
                                icon: 'trophy',
                                category: 'Nauka',
                                rarity: BadgeRarity.rare,
                                xpReward: 150,
                              );
                              BadgeAwardDialog.show(
                                context,
                                badge,
                                () {
                                  context.go('/dashboard');
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Zakończ kurs i odbierz nagrodę 🏆',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
