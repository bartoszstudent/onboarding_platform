import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/input.dart';
import '../../../../data/services/company_service.dart';

class AddCompanyModal extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const AddCompanyModal({
    super.key,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<AddCompanyModal> createState() => _AddCompanyModalState();
}

class _AddCompanyModalState extends State<AddCompanyModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _newCompany = {};
  bool _isLoading = false;

  void _onChange(String key, dynamic value) {
    setState(() {
      _newCompany[key] = value;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await CompanyService.createCompany(
        name: (_newCompany['name'] ?? '').trim(),
        domain: (_newCompany['domain'] ?? '').trim(),
        logoUrl: (_newCompany['logo_url'] ?? '').trim().isEmpty
            ? null
            : (_newCompany['logo_url'] ?? '').trim(),
        primaryColor: (_newCompany['primary_color'] ?? '#2563EB').trim(),
        secondaryColor: (_newCompany['secondary_color'] ?? '#1E40AF').trim(),
        accentColor: (_newCompany['accent_color'] ?? '#3B82F6').trim(),
      );

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sukces! 🎉'),
              content: const Text('Firma została utworzona pomyślnie.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Zamknij dialog
                    Navigator.pop(context); // Zamknij modal AddCompanyModal
                    widget.onSuccess(); // Odśwież listę firm
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Tokens.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> newCompany = _newCompany;
    final Function(String key, dynamic value) onChange = _onChange;
    final VoidCallback onCancel = widget.onCancel;
    final GlobalKey<FormState> formKey = _formKey;

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
                  child: Form(
                    key: formKey,
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
                        "Wypełnij pola wymagane: name, domain, logo_url, primary_color, secondary_color, accent_color.",
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

                      // Nazwa firmy i domena
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
                                  validator: (v) => (v == null || v.trim().isEmpty)
                                      ? 'Podaj nazwę firmy'
                                      : null,
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
                                  "Domena",
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
                                        keyName: "domain",
                                        initialValue: newCompany["domain"] ?? "",
                                        onChange: onChange,
                                        validator: (v) => (v == null || v.trim().isEmpty)
                                            ? 'onboardly.com'
                                            : null,
                                        keyboardType: TextInputType.url,
                                        height: 28,
                                      ),
                                    ),
                                    const SizedBox(width: Tokens.spacingXs),
                                    const Text(
                                      "onboardly.com",
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
                      // Logo URL i kolory
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Logo URL (opcjonalne)",
                                  style: TextStyle(
                                    color: Tokens.textDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "logo_url",
                                  initialValue: newCompany["logo_url"] ?? "",
                                  onChange: onChange,
                                  height: 28,
                                  keyboardType: TextInputType.url,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Tokens.spacingSm),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Primary color (hex)",
                                  style: TextStyle(
                                    color: Tokens.textDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "primary_color",
                                  initialValue: newCompany["primary_color"] ?? "#2563EB",
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
                                  "Secondary color (hex)",
                                  style: TextStyle(
                                    color: Tokens.textDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "secondary_color",
                                  initialValue: newCompany["secondary_color"] ?? "#1E40AF",
                                  onChange: onChange,
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Tokens.spacingSm),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Accent color (hex)",
                                  style: TextStyle(
                                    color: Tokens.textDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _AppInputField(
                                  keyName: "accent_color",
                                  initialValue: newCompany["accent_color"] ?? "#3B82F6",
                                  onChange: onChange,
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                        ],
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
                              onPressed: _isLoading ? null : _handleSubmit,
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
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text('Utwórz firmę'),
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
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _AppInputField({
    super.key,
    required this.keyName,
    required this.initialValue,
    required this.onChange,
    this.height = 30,
    this.validator,
    this.keyboardType,
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
        validator: widget.validator,
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
