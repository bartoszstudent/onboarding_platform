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
  // Przechowujemy Future, aby zapobiec ponownemu pobieraniu przy każdym rebuildzie
  late Future<Quiz> _quizFuture;

  @override
  void initState() {
    super.initState();
    // Odpalamy zapytanie do serwera podczas inicjalizacji ekranu
    _quizFuture = QuizService.fetchQuizForCourse(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title)),
      body: FutureBuilder<Quiz>(
        future: _quizFuture,
        builder: (context, snapshot) {
          // 1. Ładowanie
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Obsługa błędu (np. kod 404, gdy brak przypisanego quizu)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Brak quizów w tym kursie lub wystąpił błąd:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            );
          }

          // 3. Sprawdzenie czy quiz ma jakieś pytania
          if (!snapshot.hasData || snapshot.data!.questions.isEmpty) {
            return const Center(child: Text("Ten quiz nie ma jeszcze żadnych pytań."));
          }

          final quiz = snapshot.data!;

          // 4. Renderowanie pojedynczego QuizWidget (który sam wyświetli wszystkie pytania)
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: QuizWidget(
              quiz: quiz,
              onCompleted: (QuizResult result) {
                // Ta funkcja odpali się po wciśnięciu "Prześlij odpowiedzi" 
                // i zwróceniu wyniku z serwera Django.
                
                // Ustawiamy próg zaliczenia na np. 80%
                if (result.score >= 80.0) { 
                  const badge = BadgeModel(
                    id: 'b_course_completed',
                    name: 'Mistrz Wiedzy 🎓',
                    description: 'Ukończono quiz i wykazano się wiedzą merytoryczną.',
                    icon: 'trophy',
                    category: 'Nauka',
                    rarity: BadgeRarity.rare,
                    xpReward: 150,
                  );
                  
                  // Pokaż modal z nagrodą
                  BadgeAwardDialog.show(
                    context,
                    badge,
                    () {
                      // Po zamknięciu dialogu wróć do dashboardu
                      context.go('/dashboard');
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Aby zaliczyć kurs i zdobyć odznakę, musisz zdobyć co najmniej 80%.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}