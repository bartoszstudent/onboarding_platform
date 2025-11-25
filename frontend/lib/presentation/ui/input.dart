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
        labelText: labelText,
        hintText: hintText ?? labelText,
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
