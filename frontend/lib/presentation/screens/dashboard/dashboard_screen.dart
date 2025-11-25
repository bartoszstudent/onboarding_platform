import 'package:flutter/material.dart';
import '../../ui/stat_card.dart';
import '../../../core/constants/design_tokens.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Witaj w Onboardly!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text("Tutaj pojawią się kursy, postępy i statystyki.",
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 20),

        // Stats row
        const Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
                width: 300,
                child: StatCard(
                    icon: Icons.school,
                    title: 'Kursy dostępne',
                    value: '12',
                    delta: '+2')),
            SizedBox(
                width: 300,
                child: StatCard(
                    icon: Icons.person,
                    title: 'Użytkownicy',
                    value: '348',
                    delta: '+6')),
            SizedBox(
                width: 300,
                child: StatCard(
                    icon: Icons.check_circle,
                    title: 'Ukończone',
                    value: '1,210',
                    delta: '-4')),
          ],
        ),

        const SizedBox(height: 20),

        // Placeholder content similar to React dashboard sections
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Tokens.radius2xl)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ostatnie aktywności',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 12),
                Text(
                    'Lista ostatnich zdarzeń i aktywności użytkowników pojawi się tutaj.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
