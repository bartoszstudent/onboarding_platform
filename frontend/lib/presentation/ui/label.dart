import 'package:flutter/material.dart';

class AppLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AppLabel(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: style ?? const TextStyle(fontSize: 14, color: Colors.black87));
  }
}
