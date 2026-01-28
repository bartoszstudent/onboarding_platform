import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../data/services/auth_service.dart';
import '../../ui/badge.dart' as app_ui;
import 'course_player_screen.dart';
import 'course_create_screen.dart';
import 'widgets/course_card.dart';
import '../../../data/services/course_service.dart';
import '../../../data/models/course_model.dart';


class CoursesListScreen extends StatefulWidget {
  final String? role; // np. "admin", "hr", "employee"

  const CoursesListScreen({super.key, this.role});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  String? _role;

  List<Course> _courses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _role = widget.role;
    if (_role == null) {
      _loadRole();
    }
    _loadCourses();
  }

  Future<void> _loadRole() async {
    final role = await AuthService.getRole();
    if (!mounted) return;
    setState(() {
      _role = role ?? 'employee';
    });
  }

  Future<void> _loadCourses() async {
    try {
      final data = await CourseService.fetchCourses();
      if (!mounted) return;
      setState(() {
        _courses = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Błąd ładowania kursów: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final role = _role ?? 'employee';

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Text('Kursy'),
          const SizedBox(width: 8),
          if (role != 'employee') const app_ui.Badge(text: 'Admin')
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CourseCreateScreen()),
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
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
            return CourseCard(
              title: course.title,
              description: course.description ?? '',
              thumbnail: course.thumbnail ?? '',
              progress: 0,
              duration: course.duration ?? '',
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
