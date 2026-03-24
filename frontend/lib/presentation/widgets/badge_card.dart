import 'package:flutter/material.dart';

import '../../core/constants/design_tokens.dart';
import '../../data/models/badge_list_item.dart';

class _Palette {
  final Color bg;
  final Color accent;
  final Color border;
  final Color iconBg;

  const _Palette({
    required this.bg,
    required this.accent,
    required this.border,
    required this.iconBg,
  });
}

_Palette _paletteFor(String color) {
  switch (color) {
    case 'purple':
      return const _Palette(
        bg: Color(0xFFF3E8FF),
        accent: Color(0xFF7C3AED),
        border: Color(0xFFE9D5FF),
        iconBg: Color(0xFFEDE9FE),
      );
    case 'green':
      return const _Palette(
        bg: Color(0xFFF0FDF4),
        accent: Color(0xFF15803D),
        border: Color(0xFFBBF7D0),
        iconBg: Color(0xFFD1FAE5),
      );
    case 'amber':
      return const _Palette(
        bg: Color(0xFFFFFBEB),
        accent: Color(0xFFB45309),
        border: Color(0xFFFDE68A),
        iconBg: Color(0xFFFEF3C7),
      );
    case 'red':
      return const _Palette(
        bg: Color(0xFFFEF2F2),
        accent: Color(0xFFB91C1C),
        border: Color(0xFFFECACA),
        iconBg: Color(0xFFFEE2E2),
      );
    case 'emerald':
      return const _Palette(
        bg: Color(0xFFECFDF5),
        accent: Color(0xFF047857),
        border: Color(0xFFA7F3D0),
        iconBg: Color(0xFFD1FAE5),
      );
    case 'blue':
    default:
      return const _Palette(
        bg: Color(0xFFEFF6FF),
        accent: Color(0xFF2563EB),
        border: Color(0xFFBFDBFE),
        iconBg: Color(0xFFDBEAFE),
      );
  }
}

IconData _iconData(String key) {
  switch (key) {
    case 'star':
      return Icons.star_outline;
    case 'trophy':
      return Icons.emoji_events_outlined;
    case 'target':
      return Icons.gps_fixed;
    case 'zap':
      return Icons.bolt;
    case 'crown':
      return Icons.military_tech_outlined;
    case 'medal':
      return Icons.workspace_premium_outlined;
    case 'flame':
      return Icons.local_fire_department_outlined;
    case 'award':
    default:
      return Icons.emoji_events_outlined;
  }
}

String _formatDate(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day.$month.${d.year}';
}

/// Pojedyncza karta odznaki (ikona, tytuł, opis, opcjonalnie data zdobycia, kłódka gdy niezdobyta).
class BadgeCard extends StatelessWidget {
  final BadgeListItem badge;
  final VoidCallback? onTap;

  const BadgeCard({
    super.key,
    required this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final earned = badge.earned;
    final p = earned ? _paletteFor(badge.color) : null;
    final borderColor = earned ? p!.border : Tokens.gray200;
    final bgColor = earned ? p!.bg : Tokens.gray50;
    final iconBg = earned ? p!.iconBg : Tokens.gray200;
    final iconColor = earned ? p!.accent : Colors.grey.shade400;
    final titleColor = earned ? Tokens.textDark : const Color(0xFF94A3B8);
    final descColor = earned ? Tokens.textMuted2 : const Color(0xFF94A3B8);

    final body = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: earned ? Tokens.shadowSm : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _iconData(badge.icon),
              size: 24,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badge.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: descColor,
                    height: 1.35,
                  ),
                ),
                if (earned && badge.earnedDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Zdobyto: ${_formatDate(badge.earnedDate!)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    Widget content = MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: body,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: content,
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        content,
        if (!earned)
          Positioned(
            top: 8,
            right: 8,
            child: IgnorePointer(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Tokens.gray200,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text('🔒', style: TextStyle(fontSize: 10)),
              ),
            ),
          ),
      ],
    );
  }
}
