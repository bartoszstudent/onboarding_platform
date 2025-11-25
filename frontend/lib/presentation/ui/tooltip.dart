import 'package:flutter/material.dart';

class AppTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  const AppTooltip({super.key, required this.child, required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      textStyle: const TextStyle(color: Colors.white),
      decoration: BoxDecoration(
          color: Colors.black87, borderRadius: BorderRadius.circular(6)),
      child: child,
    );
  }
}
