import 'package:flutter/material.dart';

class Badge extends StatefulWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final Widget? leading;
  final EdgeInsetsGeometry padding;

  const Badge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  State<Badge> createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.color ?? Theme.of(context).colorScheme.primary;
    final txt = widget.textColor ?? Colors.white;
    final hoverBg = Color.alphaBlend(const Color.fromRGBO(0, 0, 0, 0.04), bg);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _hover ? hoverBg : bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.leading != null) ...[
              Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: widget.leading!),
            ],
            Text(widget.text,
                style: TextStyle(
                  color: txt,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
