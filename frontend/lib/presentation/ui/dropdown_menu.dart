import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;

  const AppDropdown(
      {super.key, this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      underline: const SizedBox.shrink(),
      isDense: true,
      style: const TextStyle(color: Colors.black87),
    );
  }
}
