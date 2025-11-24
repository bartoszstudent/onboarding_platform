import 'package:flutter/material.dart';
import '../../ui/app_card.dart';
import 'widgets/quiz_widget.dart';

class CoursePlayerScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  const CoursePlayerScreen({super.key, required this.course});

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  int currentSection = 0;

  @override
  Widget build(BuildContext context) {
    final sections = widget.course['sections'] as List;

    return Scaffold(
      appBar: AppBar(title: Text(widget.course['title'])),
      body: sections.isEmpty
          ? const Center(child: Text("Brak treści w kursie."))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sections[currentSection]['title'],
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          (sections[currentSection]['content'] as List).length,
                      itemBuilder: (context, index) {
                        final item = sections[currentSection]['content'][index];
                        if (item['type'] == 'text') {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AppCard(child: Text(item['data'])),
                          );
                        } else if (item['type'] == 'image') {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 720),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(item['data'],
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          );
                        } else if (item['type'] == 'quiz') {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: QuizWidget(quiz: item['data']),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
