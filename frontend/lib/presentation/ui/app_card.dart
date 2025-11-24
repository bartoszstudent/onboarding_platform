import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16)});

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final hoverElevation = _hover ? 8.0 : 2.0;
    final offset = _hover ? -4.0 : 0.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, offset, 0),
        decoration: BoxDecoration(
          color: Tokens.surface,
          borderRadius: BorderRadius.circular(Tokens.radius2xl),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: hoverElevation,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );
  }
}
