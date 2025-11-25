import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/checkbox.dart';
import '../../../ui/label.dart';

class AssignCoursesScreen extends StatefulWidget {
  final Map<String, dynamic> user; 

  const AssignCoursesScreen({super.key, required this.user});

  @override
  State<AssignCoursesScreen> createState() => _AssignCoursesScreenState();
}

class _AssignCoursesScreenState extends State<AssignCoursesScreen> {
  final List<Map<String, String>> _allCourses = [
    {'id': '1', 'title': 'Wprowadzenie do React'},
    {'id': '2', 'title': 'TypeScript Podstawy'},
    {'id': '3', 'title': 'Git i GitHub'},
    {'id': '4', 'title': 'CSS Advanced'},
    {'id': '5', 'title': 'Node.js Backend'},
    {'id': '6', 'title': 'UI/UX Design Principles'},
  ];

  final Set<String> _selectedCourses = {};

  @override
  void initState() {
    super.initState();
    if (widget.user['assignedCourses'] != null) {
      _selectedCourses.addAll(List<String>.from(widget.user['assignedCourses']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLabel(
                    'Przypisz kursy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Tokens.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Użytkownik: ${widget.user['name']}',
                    style: const TextStyle(fontSize: 14, color: Tokens.textMuted2),
                  ),
                  const SizedBox(height: 12),

                  // Courses
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Tokens.gray200),
                      color: Tokens.surface,
                    ),
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _allCourses.length,
                      itemBuilder: (ctx, i) {
                        final course = _allCourses[i];
                        final selected = _selectedCourses.contains(course['id']);
                        return AppCheckbox(
                          value: selected,
                          label: course['title']!,
                          onChanged: (v) => setState(() {
                            if (v == true) {
                              _selectedCourses.add(course['id']!);
                            } else {
                              _selectedCourses.remove(course['id']!);
                            }
                          }),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Tokens.gray50,
                            side: BorderSide(color: Tokens.gray200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Anuluj', style: TextStyle(color: Tokens.textMuted2)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _assignCourses,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Tokens.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Przypisz kursy', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _assignCourses() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Przypisano ${_selectedCourses.length} kursów do ${widget.user['name']}',
        ),
      ),
    );

    Navigator.of(context).pop();
  }
}
