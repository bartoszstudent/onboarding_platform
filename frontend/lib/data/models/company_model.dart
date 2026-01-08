class Company {
  final int id;
  final String name;
  final String domain;
  final DateTime createdAt;

  Company({
    required this.id,
    required this.name,
    required this.domain,
    required this.createdAt,
  });

  // This is a factory constructor that creates a Company from a JSON object.
  // It's essential for parsing the API response.
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      domain: json['domain'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // This method converts a Company object back into a JSON object.
  // It's useful for sending data to the API (e.g., when creating or updating).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domain': domain,
      'created_at': createdAt.toIso8601String(),
    };
  }
}