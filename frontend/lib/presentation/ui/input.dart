import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final String? Function(String?)? validator;

  const AppInput(
      {super.key,
      this.controller,
      this.hintText,
      this.labelText,
      this.obscureText = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        // Prefer showing a stationary placeholder. If a labelText was
        // provided, we keep it as hintText and disable the floating label
        // behaviour so the placeholder does not animate upwards on focus.
        // We prefer labels displayed above the field; keep labelText optional.
        // Always show hintText with a stable color so it doesn't change on focus.
        labelText: null,
        hintText: hintText ?? labelText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
      ),
    );
  }
}
