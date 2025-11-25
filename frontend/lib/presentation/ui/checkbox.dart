import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;

  const AppCheckbox(
      {super.key, required this.value, required this.onChanged, this.label});

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(label!),
        controlAffinity: ListTileControlAffinity.leading,
      );
    }
    return Checkbox(value: value, onChanged: onChanged);
  }
}
