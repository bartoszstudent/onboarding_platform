import 'package:flutter/material.dart';
import '../../../../../data/models/quiz_model.dart';
import '../../../../../data/services/quiz_service.dart';

class QuizWidget extends StatefulWidget {
  final Quiz quiz;
  final ValueChanged<QuizResult>? onCompleted;

  const QuizWidget({
    super.key,
    required this.quiz,
    this.onCompleted,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  // Przechowuje zmapowane [id_pytania] -> [id_odpowiedzi]
  final Map<int, int> _selectedAnswers = {};
  bool _isSubmitting = false;
  QuizResult? _result;

  void _submitAnswers() async {
    // Prosta walidacja – blokuje przesłanie jeśli brakuje jakiejś odpowiedzi
    if (_selectedAnswers.length < widget.quiz.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Odpowiedz na wszystkie pytania przed przesłaniem.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final answerIds = _selectedAnswers.values.toList();
      final result = await QuizService.submitQuiz(widget.quiz.id, answerIds);
      
      setState(() {
        _result = result;
      });
      
      if (widget.onCompleted != null) {
        widget.onCompleted!(result);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.quiz.title.isNotEmpty ? widget.quiz.title : "Sprawdź swoją wiedzę",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            // Przełączanie widoku: jeśli mamy rezultat - pokaż wynik, jeśli nie - pokaż pytania
            if (_result != null) _buildResultView() else _buildQuestionsView(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    // Możesz zdefiniować próg zaliczenia np. na 80% lub przenieść go do backendu
    final isPassed = _result!.score >= 80.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          isPassed ? Icons.check_circle : Icons.cancel,
          color: isPassed ? Colors.green : Colors.red,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          'Twój wynik: ${_result!.score.toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Poprawne odpowiedzi: ${_result!.correctAnswers} z ${_result!.totalQuestions}',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 24),
        if (!isPassed)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _result = null;
                _selectedAnswers.clear();
              });
            },
            child: const Text('Spróbuj ponownie'),
          )
      ],
    );
  }

  Widget _buildQuestionsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...widget.quiz.questions.map((question) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.questionText,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                if (question.imageUrl != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(question.imageUrl!),
                  ),
                ],
                const SizedBox(height: 12),
                ...question.answers.map((answer) {
                  final isSelected = _selectedAnswers[question.id] == answer.id;
                  final primaryColor = Theme.of(context).colorScheme.primary;
                  
                  return Card(
                    elevation: 0,
                    color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? primaryColor : Colors.grey.shade300,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAnswers[question.id] = answer.id;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? primaryColor : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(answer.answerText)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitAnswers,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text("Prześlij odpowiedzi"),
          ),
        ),
      ],
    );
  }
}