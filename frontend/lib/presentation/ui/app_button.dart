import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final bool primary;

  const AppButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.primary = true});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hover = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.primary ? Tokens.primary : Colors.grey.shade100;
    final fg = widget.primary ? Colors.white : Tokens.textPrimary;
    final hoverBg = widget.primary
        ? HSLColor.fromColor(Tokens.primary).withAlpha(0.92).toColor()
        : Colors.grey.shade200;

    return FocusableActionDetector(
      onShowFocusHighlight: (v) => setState(() => _focus = v),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: _hover ? hoverBg : bg,
            borderRadius: BorderRadius.circular(Tokens.radius),
            boxShadow: _hover
                ? [
                    const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                        blurRadius: 6,
                        offset: Offset(0, 2))
                  ]
                : [
                    const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.04),
                        blurRadius: 2,
                        offset: Offset(0, 1))
                  ],
            border:
                _focus ? Border.all(color: Tokens.primary, width: 1.5) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(Tokens.radius),
              onTap: widget.onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Tokens.spacing, vertical: 12),
                child: DefaultTextStyle(
                  style:
                      GoogleFonts.inter(fontWeight: FontWeight.w600, color: fg),
                  child: Text(widget.label),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
