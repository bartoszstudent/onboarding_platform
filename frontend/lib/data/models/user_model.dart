class UserModel {
  final int id;
  final String email;
  final String name;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  /// Tworzy model na podstawie JSON-a z backendu.
  /// Oczekiwane pola po stronie Django:
  /// {
  ///   "id": 1,
  ///   "email": "user@example.com",
  ///   "first_name": "Jan",
  ///   "last_name": "Kowalski",
  ///   "username": "jan",
  ///   "role": "admin"
  /// }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName = (json['first_name'] ?? json['firstName'] ?? '').toString();
    final lastName = (json['last_name'] ?? json['lastName'] ?? '').toString();
    String name;

    if (json['name'] != null && json['name'].toString().isNotEmpty) {
      name = json['name'].toString();
    } else {
      final fullName = (firstName + ' ' + lastName).trim();
      if (fullName.isNotEmpty) {
        name = fullName;
      } else if (json['username'] != null &&
          json['username'].toString().isNotEmpty) {
        name = json['username'].toString();
      } else {
        name = json['email']?.toString() ?? '';
      }
    }

    return UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email']?.toString() ?? '',
      name: name,
      role: json['role']?.toString() ?? 'employee',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    };
  }
}
