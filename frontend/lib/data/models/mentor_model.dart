class MentorModel {
  final String id;
  final String name;
  final String role;
  final String department;
  final double rating;
  final int reviewCount;
  final int activeTasksCount;
  final List<String> expertise;
  final String? avatar;

  const MentorModel({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.rating,
    required this.reviewCount,
    required this.activeTasksCount,
    required this.expertise,
    this.avatar,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      department: json['department'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      activeTasksCount: (json['activeTasksCount'] as num).toInt(),
      expertise: List<String>.from(json['expertise'] as List),
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'department': department,
      'rating': rating,
      'reviewCount': reviewCount,
      'activeTasksCount': activeTasksCount,
      'expertise': expertise,
      'avatar': avatar,
    };
  }
}
