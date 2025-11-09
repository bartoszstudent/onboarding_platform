class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Podaj email';
    if (!value.contains('@')) return 'Nieprawidłowy email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) return 'Hasło za krótkie';
    return null;
  }
}
