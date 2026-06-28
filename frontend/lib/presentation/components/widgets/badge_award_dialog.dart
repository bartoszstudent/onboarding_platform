import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../data/models/badge_model.dart';

class BadgeAwardDialog extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onClaim;

  const BadgeAwardDialog({
    super.key,
    required this.badge,
    required this.onClaim,
  });

  static void show(BuildContext context, BadgeModel badge, VoidCallback onClaim) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Badge Dialog',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            content: BadgeAwardDialog(badge: badge, onClaim: onClaim),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Tokens.radius2xl),
        boxShadow: Tokens.shadowMd,
        border: Border.all(color: Tokens.gray200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Tokens.radius2xl),
        child: Stack(
          children: [
            // Gold decoration glow background
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Tokens.blue.withOpacity(0.06),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge icon floating box
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.12),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badge.emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Congratulations title
                  const Text(
                    'Gratulacje! 🎉',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Tokens.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Zdobyłeś nową odznakę:',
                    style: TextStyle(
                      fontSize: 13,
                      color: Tokens.textMuted2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Badge details box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Tokens.gray50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Tokens.gray200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          badge.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Tokens.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          badge.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Tokens.textMuted2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // XP points indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7), // bg-amber-50
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '+${badge.xpReward} XP',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Claim button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onClaim();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Tokens.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Odbierz',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
