import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/design_tokens.dart';

class StatCard extends StatelessWidget {
  final IconData? icon;
  final String? iconAsset;
  final String title;
  final String value;
  final String? delta;

  const StatCard({
    super.key,
    this.icon,
    this.iconAsset,
    required this.title,
    required this.value,
    this.delta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Tokens.surface,
        borderRadius: BorderRadius.circular(Tokens.radius2xl),
        boxShadow: Tokens.shadowSm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(31),
                borderRadius: BorderRadius.circular(Tokens.radius),
              ),
              child: iconAsset != null
                  ? SizedBox(
                      width: 28,
                      height: 28,
                      child: SvgPicture.asset(iconAsset!,
                          color: Theme.of(context).colorScheme.primary))
                  : Icon(icon,
                      size: 28, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 6),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            if (delta != null)
              Text(delta!,
                  style: TextStyle(
                      color:
                          delta!.startsWith('-') ? Colors.red : Colors.green)),
          ],
        ),
      ),
    );
  }
}
