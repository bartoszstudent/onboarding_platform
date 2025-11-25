import 'package:flutter/material.dart';
import '../../ui/app_card.dart';
import '../../ui/input.dart';
import '../../ui/app_button.dart';
// design tokens not required directly here

class CourseCreateScreen extends StatelessWidget {
  const CourseCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Nowy kurs")),
      body: Center(
        child: SizedBox(
          width: 720,
          child: AppCard(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Stwórz kurs',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  AppInput(
                      controller: titleController, labelText: 'Tytuł kursu'),
                  const SizedBox(height: 12),
                  AppInput(controller: descController, labelText: 'Opis kursu'),
                  const SizedBox(height: 12),
                  const AppInput(labelText: 'Miniaturka (URL)'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Kurs zapisany (mock)!')));
                              Navigator.pop(context);
                            }
                          },
                          label: 'Zapisz kurs',
                          primary: true,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
