class DashboardStats {
  final int courses;
  final int employees;
  final double avgCompletionHours;

  DashboardStats({
    required this.courses,
    required this.employees,
    required this.avgCompletionHours,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      courses: json['courses'] as int? ?? 0,
      employees: json['employees'] as int? ?? 0,
      avgCompletionHours:
          (json['avg_completion_hours'] as num?)?.toDouble() ?? 0.0,
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
