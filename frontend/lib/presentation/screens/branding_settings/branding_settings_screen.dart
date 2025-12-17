import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../core/constants/design_tokens.dart';
import '../../ui/app_card.dart';
import '../../ui/input.dart';
import '../../ui/label.dart';

class BrandingSettingsScreen extends StatefulWidget {
  const BrandingSettingsScreen({super.key});

  @override
  State<BrandingSettingsScreen> createState() => _BrandingSettingsScreenState();
}

class _BrandingSettingsScreenState extends State<BrandingSettingsScreen> {
  String primaryColor = '#2563EB';
  String secondaryColor = '#3B82F6';
  String accentColor = '#60A5FA';
  String companyName = 'TechCorp Sp. z o.o.';
  String? logo;
  bool isSaving = false;
  bool showPreview = true;

  final TextEditingController companyController = TextEditingController(text: 'TechCorp Sp. z o.o.');
  final TextEditingController primaryColorController = TextEditingController(text: '#2563EB');
  final TextEditingController secondaryColorController = TextEditingController(text: '#3B82F6');
  final TextEditingController accentColorController = TextEditingController(text: '#60A5FA');

  final presetColors = [
    '#2563EB',
    '#7C3AED',
    '#059669',
    '#EA580C',
    '#DB2777',
    '#0D9488',
    '#4F46E5',
    '#DC2626',
  ];

  @override
  void initState() {
    super.initState();

    companyController.addListener(() {
      setState(() {
        companyName = companyController.text;
      });
    });

    primaryColorController.addListener(() {
      setState(() {
        primaryColor = primaryColorController.text;
      });
    });

    secondaryColorController.addListener(() {
      setState(() {
        secondaryColor = secondaryColorController.text;
      });
    });

    accentColorController.addListener(() {
      setState(() {
        accentColor = accentColorController.text;
      });
    });
  }

  @override
  void dispose() {
    companyController.dispose();
    primaryColorController.dispose();
    secondaryColorController.dispose();
    accentColorController.dispose();
    super.dispose();
  }

  void handleLogoUpload(String? path) {
    setState(() {
      logo = path;
    });
  }

  void resetToDefaults() {
    setState(() {
      primaryColor = '#2563EB';
      secondaryColor = '#3B82F6';
      accentColor = '#60A5FA';
      logo = null;
      companyName = 'TechCorp Sp. z o.o.';
      companyController.text = companyName;
      primaryColorController.text = primaryColor;
      secondaryColorController.text = secondaryColor;
      accentColorController.text = accentColor;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Przywrócono domyślne ustawienia')),
    );
  }

  void saveSettings() {
    setState(() => isSaving = true);
    companyName = companyController.text;
    primaryColor = primaryColorController.text;
    secondaryColor = secondaryColorController.text;
    accentColor = accentColorController.text;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Ustawienia brandingu zostały zapisane! Zmiany będą widoczne dla wszystkich użytkowników.'),
        ),
      );
    });
  }

  Future<void> pickColor(
      TextEditingController controller, Color currentColor, Function(String) onSelected) async {
    Color pickerColor = currentColor;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wybierz kolor'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.7,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Anuluj')),
            ElevatedButton(
                onPressed: () {
                  final hex =
                      '#${pickerColor.value.toRadixString(16).substring(2).toUpperCase()}';
                  controller.text = hex;
                  onSelected(hex);
                  Navigator.of(context).pop();
                },
                child: const Text('Ustaw')),
          ],
        );
      },
    );
  }

  Color parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Tokens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLabel(
            'Personalizacja firmy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const AppLabel(
            'Dostosuj wygląd platformy dla swojej firmy',
            style: TextStyle(color: Tokens.textMuted2, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Informacje o firmie
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.apartment,
                                  color: Tokens.blue, size: 20),
                              SizedBox(width: 8),
                              AppLabel('Informacje o firmie',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const AppLabel('Nazwa firmy',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          AppInput(
                              labelText: 'Nazwa firmy',
                              controller: companyController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Logo
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.upload,
                                  color: Tokens.blue, size: 20),
                              SizedBox(width: 8),
                              AppLabel(
                                'Logo firmy',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (logo != null)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Tokens.gray50,
                                borderRadius:
                                    BorderRadius.circular(Tokens.radiusLg),
                              ),
                              child: Image.network(
                                logo!,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => handleLogoUpload(null),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Tokens.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Tokens.radiusLg),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                logo != null ? 'Zmień logo' : 'Prześlij logo',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (logo != null)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() => logo = null);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Tokens.destructive,
                                  side: const BorderSide(color: Tokens.destructive),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Usuń',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          const SizedBox(height: 4),
                          const AppLabel(
                            'Zalecany format: PNG lub SVG z przezroczystym tłem. Maksymalny rozmiar: 2MB',
                            style: TextStyle(
                                fontSize: 12, color: Tokens.textMuted2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Kolory
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.palette, color: Tokens.blue, size: 20),
                              SizedBox(width: 8),
                              AppLabel('Kolorystyka',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Kolor główny
                          const AppLabel('Kolor główny', style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => pickColor(primaryColorController,
                                    parseColor(primaryColor), (val) {
                                  setState(() => primaryColor = val);
                                }),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: parseColor(primaryColor),
                                    borderRadius: BorderRadius.circular(Tokens.radiusLg),
                                    border: Border.all(color: Tokens.gray200),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: AppInput(
                                      labelText: primaryColor, controller: primaryColorController)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: presetColors.map((c) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    primaryColor = c;
                                    primaryColorController.text = c;
                                  });
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: parseColor(c),
                                    borderRadius: BorderRadius.circular(Tokens.radiusLg),
                                    border: Border.all(color: Tokens.gray200),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),

                          // Kolor pomocniczy
                          const AppLabel('Kolor pomocniczy',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => pickColor(
                                    secondaryColorController,
                                    parseColor(secondaryColor), (val) {
                                  setState(() => secondaryColor = val);
                                }),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: parseColor(secondaryColor),
                                    borderRadius:
                                        BorderRadius.circular(Tokens.radiusLg),
                                    border: Border.all(color: Tokens.gray200),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: AppInput(
                                      labelText: secondaryColor,
                                      controller: secondaryColorController)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Kolor akcentu
                          const AppLabel('Kolor akcentu',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => pickColor(accentColorController,
                                    parseColor(accentColor), (val) {
                                  setState(() => accentColor = val);
                                }),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: parseColor(accentColor),
                                    borderRadius:
                                        BorderRadius.circular(Tokens.radiusLg),
                                    border: Border.all(color: Tokens.gray200),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: AppInput(
                                      labelText: accentColor,
                                      controller: accentColorController)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Akcje
                    AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isSaving ? null : saveSettings,
                              icon: const Icon(Icons.save),
                              label: Text(
                                  isSaving ? 'Zapisywanie...' : 'Zapisz zmiany'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Tokens.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Tokens.radiusLg)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: resetToDefaults,
                            icon: const Icon(Icons.rotate_left),
                            label: const Text('Przywróć'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Tokens.textMuted2,
                              side: const BorderSide(color: Tokens.gray200),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Tokens.radiusLg),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.remove_red_eye, color: Tokens.blue, size: 20),
                                  SizedBox(width: 8),
                                  AppLabel(
                                    'Podgląd na żywo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => setState(() => showPreview = !showPreview),
                                child: Text(showPreview ? 'Ukryj' : 'Pokaż',
                                    style: const TextStyle(color: Tokens.blue)),
                              ),
                            ],
                          ),
                          if (showPreview)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),

                                // Sidebar
                                const AppLabel('Sidebar', style: TextStyle(fontSize: 14)),
                                const SizedBox(height: 8),
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: parseColor(primaryColor),
                                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Logo
                                      Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(Tokens.radiusLg),
                                        ),
                                        alignment: Alignment.center,
                                        child: logo != null
                                            ? Image.network(logo!)
                                            : AppLabel(
                                                companyName,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Menu items
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(Tokens.radiusLg),
                                              ),
                                            ),
                                            Container(
                                              height: 20,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.3),
                                                borderRadius:
                                                    BorderRadius.circular(Tokens.radiusLg),
                                              ),
                                            ),
                                            Container(
                                              height: 20,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.3),
                                                borderRadius:
                                                    BorderRadius.circular(Tokens.radiusLg),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Przyciski
                                const AppLabel('Przyciski', style: TextStyle(fontSize: 14)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: parseColor(primaryColor)),
                                        child: const Text('Przycisk główny'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: parseColor(secondaryColor)),
                                        child: const Text('Przycisk pomocniczy'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: parseColor(primaryColor),
                                          side: BorderSide(color: parseColor(primaryColor)),
                                        ),
                                        child: const Text('Przycisk obramowany'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Karty kursów
                                const AppLabel('Karty kursów', style: TextStyle(fontSize: 14)),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Tokens.radiusLg),
                                    color: parseColor(accentColor),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Kurs Flutter - Podstawy',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 8,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: parseColor(primaryColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: FractionallySizedBox(
                                          widthFactor: 0.6,
                                          alignment: Alignment.centerLeft,
                                          child: Container(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text('60% ukończone',
                                          style:
                                              TextStyle(color: Colors.white, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Statystyki
                                const AppLabel('Statystyki', style: TextStyle(fontSize: 14)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: parseColor(primaryColor).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(Tokens.radiusLg),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: parseColor(primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(Tokens.radiusLg),
                                              ),
                                              child: const Icon(Icons.bar_chart,
                                                  color: Colors.white, size: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 8,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: parseColor(secondaryColor).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(Tokens.radiusLg),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: parseColor(secondaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(Tokens.radiusLg),
                                              ),
                                              child: const Icon(Icons.pie_chart,
                                                  color: Colors.white, size: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 8,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Tokens.blue100,
                                    borderRadius: BorderRadius.circular(Tokens.radiusLg),
                                  ),
                                  child: const Text(
                                    'Zmiany będą widoczne dla wszystkich użytkowników Twojej firmy po zapisaniu.',
                                    style: TextStyle(color: Tokens.blue),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
