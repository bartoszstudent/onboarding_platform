import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/design_tokens.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final String thumbnail;
  final VoidCallback onTap;
  final int progress;
  final String? duration;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.onTap,
    this.progress = 0,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Tokens.surface,
            borderRadius: BorderRadius.circular(Tokens.radius2xl),
            boxShadow: Tokens.shadowSm,
            border: Border.all(color: Tokens.gray200),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail with fixed height and progress overlay
              SizedBox(
                height: 192,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                            child: SizedBox(
                                width: 48,
                                height: 48,
                                child: SvgPicture.asset(
                                    'assets/icons/image-not-supported.svg'))),
                      ),
                    ),
                    if (progress > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Tokens.radius),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              color: const Color.fromRGBO(255, 255, 255, 0.75),
                              child: Text('$progress% ukończono',
                                  style: const TextStyle(
                                      color: Tokens.textDark, fontSize: 12)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Tokens.textMuted2)),
                    const SizedBox(height: 12),
                    if (progress > 0)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress / 100.0,
                          backgroundColor: Tokens.gray100,
                          color: Tokens.blue,
                          minHeight: 10,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(duration ?? '',
                            style: const TextStyle(
                                color: Tokens.textMuted2, fontSize: 13)),
                        TextButton(
                          onPressed: onTap,
                          style: TextButton.styleFrom(
                            backgroundColor: Tokens.gray50,
                            foregroundColor: Tokens.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Tokens.radius)),
                          ),
                          child: Text(progress > 0 && progress < 100
                              ? 'Kontynuuj'
                              : progress == 100
                                  ? 'Przejrzyj'
                                  : 'Rozpocznij'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
