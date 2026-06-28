class DashboardStats {
  // Pola Admina
  final int courses;
  final int employees;
  final double avgCompletionHours;

  // Pola Pracownika
  final int completedCourses;
  final int inProgressCourses;
  final String learningTime;
  final int streak;

  DashboardStats({
    this.courses = 0,
    this.employees = 0,
    this.avgCompletionHours = 0.0,
    this.completedCourses = 0,
    this.inProgressCourses = 0,
    this.learningTime = '0h',
    this.streak = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      courses: json['courses'] as int? ?? 0,
      employees: json['employees'] as int? ?? 0,
      avgCompletionHours: (json['avg_completion_hours'] as num?)?.toDouble() ?? 0.0,
      completedCourses: json['completed_courses'] as int? ?? 0,
      inProgressCourses: json['in_progress_courses'] as int? ?? 0,
      learningTime: json['learning_time'] as String? ?? '0h',
      streak: json['streak'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'courses': courses,
        'employees': employees,
        'avg_completion_hours': avgCompletionHours,
      };
}

class ActivityItem {
  final String user;
  final String action;
  final String course;
  final String time;

  ActivityItem({
    required this.user,
    required this.action,
    required this.course,
    required this.time,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      user: json['user'] as String? ?? '',
      action: json['action'] as String? ?? '',
      course: json['course'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'action': action,
        'course': course,
        'time': time,
      };
}
