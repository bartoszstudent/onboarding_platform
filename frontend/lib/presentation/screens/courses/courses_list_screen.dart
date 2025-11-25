import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/design_tokens.dart';
import '../../ui/badge.dart' as app_ui;
import 'course_mock_data.dart';
import 'course_player_screen.dart';
import 'course_create_screen.dart';
import 'widgets/course_card.dart';

class CoursesListScreen extends StatelessWidget {
  final String role; // np. "admin", "hr", "employee"
  const CoursesListScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final courses = mockCourses;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Text('Kursy'),
          const SizedBox(width: 8),
          if (role != 'employee') const app_ui.Badge(text: 'Admin')
        ]),
        actions: [
          if (role == 'admin' || role == 'hr')
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CourseCreateScreen()),
                  );
                },
                icon: SvgPicture.asset('assets/icons/plus.svg',
                    width: 18, height: 18, color: Colors.white),
                label: const Text('Dodaj kurs'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Tokens.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Tokens.radius)),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        int columns = 1;
        final width = constraints.maxWidth;
        if (width >= 1100) {
          columns = 3;
        } else if (width >= 700) {
          columns = 2;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.9,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(
              title: course['title'],
              description: course['description'],
              thumbnail: course['thumbnail'],
              progress: course.containsKey('progress')
                  ? (course['progress'] as int)
                  : 0,
              duration: course.containsKey('duration')
                  ? course['duration'] as String?
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoursePlayerScreen(course: course),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
