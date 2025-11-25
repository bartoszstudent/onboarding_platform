import 'package:flutter/material.dart';

class QuizWidget extends StatefulWidget {
  final Map<String, dynamic> quiz;
  const QuizWidget({super.key, required this.quiz});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int? selected;
  bool answered = false;

  @override
  Widget build(BuildContext context) {
    final answers = widget.quiz['answers'] as List;
    final correct = widget.quiz['correct'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.quiz['question'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...List.generate(answers.length, (i) {
              final color = answered
                  ? (i == correct
                      ? Colors.green.shade200
                      : (i == selected ? Colors.red.shade200 : null))
                  : null;

              return Card(
                color: color,
                child: InkWell(
                  onTap: answered ? null : () => setState(() => selected = i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        // custom radio indicator to avoid deprecated Radio API
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: selected == i
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade400,
                                width: 2),
                          ),
                          child: selected == i
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(answers[i])),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (!answered)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: selected == null
                      ? null
                      : () => setState(() => answered = true),
                  child: const Text("Sprawdź"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
