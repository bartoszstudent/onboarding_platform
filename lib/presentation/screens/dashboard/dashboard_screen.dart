import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Text("Witaj w Onboardly!"),
        SizedBox(height: 16),
        Text("Tutaj pojawią się kursy, postępy i statystyki."),
      ],
    );
  }
}
