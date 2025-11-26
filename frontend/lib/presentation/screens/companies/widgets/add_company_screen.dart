import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/input.dart';

class AddCompanyModal extends StatelessWidget {
  final Map<String, dynamic> newCompany;
  final Function(String key, dynamic value) onChange;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final GlobalKey<FormState> formKey;

  const AddCompanyModal({
    super.key,
    required this.newCompany,
    required this.onChange,
    required this.onCancel,
    required this.onSubmit,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tło półprzezroczyste
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              color: Tokens.surface,
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nagłówek
                      Text(
                        "Dodaj nową firmę",
                        style: TextStyle(
                          color: Tokens.textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Każda firma otrzyma własną subdomenę i administratora",
                        style: TextStyle(
                          fontSize: 12,
                          color: Tokens.textMuted2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Informacje o firmie",
                        style: TextStyle(
                          fontSize: 14,
                          color: Tokens.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Tokens.spacingSm),

                      // Nazwa firmy i Subdomena
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nazwa firmy",
                                  style: TextStyle(
                                    color: Tokens.textDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "name",
                                  initialValue: newCompany["name"] ?? "",
                                  onChange: onChange,
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: Tokens.spacingSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Subdomena",
                                  style: TextStyle(
                                    color: Tokens.textDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _AppInputField(
                                        keyName: "subdomain",
                                        initialValue:
                                            newCompany["subdomain"] ?? "",
                                        onChange: onChange,
                                        height: 28,
                                      ),
                                    ),
                                    const SizedBox(width: Tokens.spacingXs),
                                    Text(
                                      ".onboardly.app",
                                      style: TextStyle(
                                        color: Tokens.textMuted2,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Tokens.spacingSm),

                      // Maksymalna liczba użytkowników i kursów
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Maksymalna liczba użytkowników",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Tokens.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "maxUsers",
                                  initialValue: newCompany["maxUsers"]?.toString() ?? "",
                                  onChange: onChange,
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: Tokens.spacingSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Maksymalna liczba kursów",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Tokens.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "maxCourses",
                                  initialValue:
                                      newCompany["maxCourses"]?.toString() ?? "",
                                  onChange: onChange,
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Tokens.spacingSm),

                      // Tutaj używamy companyLogo
                      Row( 
                        children: [ 
                          Container( 
                            width: 70, 
                            height: 70, 
                            decoration: 
                            BoxDecoration( 
                              color: Tokens.gray100, 
                              borderRadius: BorderRadius.circular(Tokens.radius2xl), 
                              border: Border.all(color: Tokens.gray200), 
                              ), 
                              child: 
                              Icon( 
                                Icons.apartment_rounded, 
                                size: 32, 
                                color: Tokens.textMuted2, 
                                ), 
                          ), 
                          const SizedBox(width: Tokens.spacing), 
                          OutlinedButton( 
                            style: OutlinedButton.styleFrom( 
                              side: BorderSide(
                                color: Tokens.gray100), 
                                backgroundColor: Tokens.gray50, 
                                ), 
                                onPressed: () {}, 
                                child: 
                                Text( "Prześlij logo", 
                                style: 
                                TextStyle(color: Tokens.textMuted2), 
                                ), 
                          ), 
                        ], 
                      ),
                      // Administrator
                      Text( "Główny administrator",
                            style: TextStyle(
                              color: Tokens.textDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      Row(
                        children: [
                          const SizedBox(width: Tokens.spacing), 
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Imię i nazwisko administratora",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Tokens.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "adminName",
                                  initialValue: newCompany["adminName"] ?? "",
                                  onChange: onChange,
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: Tokens.spacingSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email administratora",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Tokens.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "adminEmail",
                                  initialValue: newCompany["adminEmail"] ?? "",
                                  onChange: onChange,
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Tokens.spacingSm),

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Tokens.blue100,
                          borderRadius: BorderRadius.circular(Tokens.radius),
                        ),
                        child: Text(
                          "💡 Administrator otrzyma email z linkiem aktywacyjnym i danymi dostępowymi",
                          style: TextStyle(
                            fontSize: 11,
                            color: Tokens.blue700,
                          ),
                        ),
                      ),
                      const SizedBox(height: Tokens.spacingSm),

                      // Przyciski
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onCancel,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                backgroundColor: Tokens.gray50,
                                side: BorderSide(color: Tokens.gray200),
                              ),
                              child: Text(
                                "Anuluj",
                                style: TextStyle(
                                    color: Tokens.textMuted2, fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: Tokens.spacingXs),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  onSubmit();
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Tokens.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Tokens.radius),
                                ),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              child: const Text('Utwórz firmę'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Wrapper dla AppInput z możliwością ustawienia wysokości pola
class _AppInputField extends StatefulWidget {
  final String keyName;
  final String initialValue;
  final Function(String key, String value) onChange;
  final double height;

  const _AppInputField({
    super.key,
    required this.keyName,
    required this.initialValue,
    required this.onChange,
    this.height = 30,
  });

  @override
  State<_AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<_AppInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onChange(widget.keyName, _controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AppInput(
        controller: _controller,
        labelText: "",
        hintText: "",
      ),
    );
  }
}
