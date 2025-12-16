import 'package:flutter/material.dart';
import '../components/sidebar.dart';
import '../components/topbar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Topbar(),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: const Color(0xFFF8FAFC),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
