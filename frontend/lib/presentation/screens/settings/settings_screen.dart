import 'package:flutter/material.dart';
import '../../ui/app_card.dart';
import '../../ui/input.dart';
import '../../ui/label.dart';
import '../../ui/avatar.dart';
import '../../../core/constants/design_tokens.dart';

class OnboardingSettingsScreen extends StatefulWidget {
  const OnboardingSettingsScreen({super.key});

  @override
  State<OnboardingSettingsScreen> createState() =>
      _OnboardingSettingsScreenState();
}

class _OnboardingSettingsScreenState extends State<OnboardingSettingsScreen> {
  bool darkMode = false;
  bool emailNotifications = true;
  bool pushNotifications = false;
  bool twoFactorEnabled = false;
  bool showBackupCodes = false;
  bool securityQuestionsExpanded = false;

  final nameCtrl = TextEditingController(text: 'admin');
  final emailCtrl = TextEditingController(text: 'admin@test.com');

  final currentPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  final activeSessions = [
    {
      'id': '1',
      'device': 'Chrome na Windows',
      'location': 'Warszawa, Polska',
      'lastActive': 'Aktywna teraz',
      'current': true,
    },
    {
      'id': '2',
      'device': 'Safari na iPhone',
      'location': 'Warszawa, Polska',
      'lastActive': '2 godz. temu',
      'current': false,
    },
    {
      'id': '3',
      'device': 'Firefox na MacOS',
      'location': 'Kraków, Polska',
      'lastActive': '1 dzień temu',
      'current': false,
    },
  ];

  final securityLogs = [
    {
      'action': 'Logowanie',
      'device': 'Chrome na Windows',
      'time': '2024-12-14 09:30',
      'status': 'success',
    },
    {
      'action': 'Zmiana hasła',
      'device': 'Chrome na Windows',
      'time': '2024-12-10 15:45',
      'status': 'success',
    },
    {
      'action': 'Nieudane logowanie',
      'device': 'Nieznane',
      'time': '2024-12-09 22:15',
      'status': 'failed',
    },
  ];

  final backupCodes = const [
    'A1B2-C3D4',
    'E5F6-G7H8',
    'I9J0-K1L2',
    'M3N4-O5P6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLabel(
              'Ustawienia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            AppLabel(
              'Zarządzaj swoim profilem i preferencjami',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Tokens.gray700,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLabel(
                    'Profil użytkownika',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const AppAvatar(name: 'admin', radius: 40), const SizedBox(width: 16), const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Upload po backendzie'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Tokens.gray100,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Zmień zdjęcie',
                          style: TextStyle(
                            color: Tokens.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const AppLabel(
                    'Imię i nazwisko',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppInput(
                    controller: nameCtrl,
                    hintText: 'Wpisz imię i nazwisko',
                  ),

                  const SizedBox(height: 16),

                  const AppLabel(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppInput(
                    controller: emailCtrl,
                    hintText: 'Wpisz adres email',
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Tokens.blue,
                      foregroundColor: Tokens.background,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Zapisz zmiany',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // haslo
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLabel(
                    'Zmień hasło',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const AppLabel(
                    'Aktualne hasło',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInput(
                    controller: currentPassCtrl..text = '••••••••',
                  ),

                  const SizedBox(height: 16),

                  const AppLabel(
                    'Nowe hasło',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInput(
                    controller: newPassCtrl..text = '••••••••',
                  ),

                  const SizedBox(height: 16),

                  const AppLabel(
                    'Potwierdź nowe hasło',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInput(
                    controller: confirmPassCtrl..text = '••••••••',
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Tokens.blue,
                      foregroundColor: Tokens.background,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Zmień hasło',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // bezpieczenstwo
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLabel(
                    'Bezpieczeństwo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Tokens.gray50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLabel(
                                'Uwierzytelnianie dwuskładnikowe (2FA)',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              AppLabel(
                                'Dodatkowa warstwa bezpieczeństwa dla Twojego konta',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Tokens.gray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: twoFactorEnabled,
                          onChanged: (v) {
                            setState(() {
                              twoFactorEnabled = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  if (twoFactorEnabled) ...[
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Tokens.background,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Generuj kody zapasowe',
                          style: TextStyle(
                            color: Tokens.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],

                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Tokens.gray50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          securityQuestionsExpanded = !securityQuestionsExpanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppLabel(
                                  'Pytania zabezpieczające',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 4),
                                AppLabel(
                                  'Pomogą w odzyskaniu dostępu do konta',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Tokens.gray700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            securityQuestionsExpanded ? Icons.remove : Icons.add,
                            color: Tokens.gray700,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (securityQuestionsExpanded) ...[
                    const SizedBox(height: 16),

                    const AppLabel(
                      'Pytanie 1: Nazwisko panieńskie matki?',
                      style: TextStyle(fontSize: 14, color: Tokens.gray700),
                    ),
                    const SizedBox(height: 8),
                    const AppInput(
                      hintText: 'Twoja odpowiedź',
                    ),

                    const SizedBox(height: 16),

                    const AppLabel(
                      'Pytanie 2: Imię pierwszego zwierzaka?',
                      style: TextStyle(fontSize: 14, color: Tokens.gray700),
                    ),
                    const SizedBox(height: 8),
                    const AppInput(
                      hintText: 'Twoja odpowiedź',
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Tokens.blue,
                          foregroundColor: Tokens.background,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Zapisz odpowiedzi',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Tokens.blue100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const AppLabel(
                      '''Polityka haseł
• Minimalna długość: 8 znaków
• Musi zawierać wielkie i małe litery
• Musi zawierać cyfrę
• Zmiana hasła zalecana co 90 dni''',
                      style: TextStyle(
                        color: Tokens.blue,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // aktywne sesje
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLabel(
                    'Aktywne sesje',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ...activeSessions.map((s) {
                    final isCurrent = s['current'] as bool;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Tokens.gray50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppLabel(
                                      s['device'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    if (isCurrent) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Tokens.green100,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Aktualna sesja',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Tokens.green700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                AppLabel(
                                  '${s['location']} • ${s['lastActive']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (!isCurrent)
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(
                                  Tokens.destructive,
                                ),
                                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                  (states) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Tokens.destructive.withValues(alpha: 0.1);
                                    }
                                    return null;
                                  },
                                ),
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Zamknij',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // historia aktywnosci
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLabel(
                    'Historia aktywności',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ...securityLogs.map((log) {
                    final success = log['status'] == 'success';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.basic,
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Tokens.background, 
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: success ? Tokens.green700 : Tokens.destructive,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppLabel(log['action'] as String),
                                        AppLabel(
                                          log['device'] as String,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Tokens.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppLabel(
                                    log['time'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Tokens.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(WidgetState.hovered)) {
                              return Tokens.gray50;
                            }
                            return Colors.white;
                          },
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 14),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Zobacz pełną historię',
                        style: TextStyle(
                          color: Tokens.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // powiadomienia
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLabel(
                    'Powiadomienia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Tokens.gray50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLabel(
                                'Powiadomienia email',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              AppLabel(
                                'Otrzymuj informacje o aktywności na adres email',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Tokens.gray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: emailNotifications,
                          onChanged: (v) {
                            setState(() {
                              emailNotifications = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Tokens.gray50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLabel(
                                'Powiadomienia push',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              AppLabel(
                                'Szybkie alerty bezpośrednio na Twoje urządzenie',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Tokens.gray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: pushNotifications,
                          onChanged: (v) {
                            setState(() {
                              pushNotifications = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // wyglad
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLabel(
                    'Wygląd',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Tokens.gray50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLabel(
                                'Tryb ciemny',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              AppLabel(
                                'Zmniejsza jasność interfejsu i poprawia komfort nocą',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Tokens.gray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: darkMode,
                          onChanged: (v) {
                            setState(() {
                              darkMode = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
