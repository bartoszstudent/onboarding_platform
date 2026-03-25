import 'package:flutter/material.dart';

import '../../../core/constants/design_tokens.dart';

///
/// Do wklejenia w dowolnym ekranie; nie jest podpięty pod routing.
class CourseProgressBar extends StatelessWidget {
  /// Ukończenie w procentach, 0–100 (wartości poza zakresem są przycinane).
  final int progress;

  /// Tekst po lewej (np. „Postęp kursu”). Gdy null — tylko pasek i opcjonalnie %.
  final String? label;

  /// Czy pokazać „{progress}%” po prawej stronie nagłówka.
  final bool showPercentLabel;

  /// Wysokość paska (domyślnie jak w karcie kursu).
  final double barHeight;

  const CourseProgressBar({
    super.key,
    required this.progress,
    this.label,
    this.showPercentLabel = true,
    this.barHeight = 10,
  });

  int get _clamped => progress.clamp(0, 100);

  @override
  Widget build(BuildContext context) {
    final value = _clamped / 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Expanded(
                    child: Text(
                      label!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Tokens.textDark,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                if (showPercentLabel)
                  Text(
                    '$_clamped%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Tokens.textMuted2,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Tokens.gray100,
            color: Tokens.blue,
            minHeight: barHeight,
          ),
        ),
      ],
    );
  }
}
