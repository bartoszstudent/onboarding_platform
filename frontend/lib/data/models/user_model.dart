class UserModel {
  final int id;
  final String email;
  final String name;
  final String role;
<<<<<<<<< Temporary merge branch 1
  final int? companyId;
=========
  final int? companyId; 
>>>>>>>>> Temporary merge branch 2

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
<<<<<<<<< Temporary merge branch 1
    this.companyId,
=========
    this.companyId, 
>>>>>>>>> Temporary merge branch 2
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName =
        (json['first_name'] ?? json['firstName'] ?? '').toString();
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

    int? extractedCompanyId;
    if (json['company_id'] != null) {
      extractedCompanyId = (json['company_id'] as num).toInt();
    } else if (json['company'] != null && json['company']['id'] != null) {
      extractedCompanyId = (json['company']['id'] as num).toInt();
    }

    return UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email']?.toString() ?? '',
      name: name,
      role: json['role']?.toString() ?? 'employee',
<<<<<<<<< Temporary merge branch 1
      companyId: json['company_id'] != null
          ? (json['company_id'] as num).toInt()
          : null,
=========
      companyId: extractedCompanyId, 
>>>>>>>>> Temporary merge branch 2
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
<<<<<<<<< Temporary merge branch 1
      'company_id': companyId,
=========
      'company_id': companyId, 
>>>>>>>>> Temporary merge branch 2
    };
  }
}