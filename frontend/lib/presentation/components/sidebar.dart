import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.blue.shade800,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Onboardly",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            title: const Text(
              "Dashboard",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => context.go('/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.school, color: Colors.white),
            title: const Text("Kursy", style: TextStyle(color: Colors.white)),
            onTap: () => context.go('/courses'),
          ),
        ],
      ),
    );
  }
}
