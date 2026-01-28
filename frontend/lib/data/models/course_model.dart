class Course {
  final int id;
  final String title;
  final String? description;
  final String? thumbnail;
  final String? duration;
  final List<CourseSection> sections;

  Course({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
    this.duration,
    this.sections = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      duration: json['duration'],
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => CourseSection.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CourseSection {
  final String title;
  final List<CourseContentItem> content;

  CourseSection({required this.title, required this.content});

  factory CourseSection.fromJson(Map<String, dynamic> json) {
    return CourseSection(
      title: json['title'],
      content: (json['content'] as List<dynamic>)
          .map((e) => CourseContentItem.fromJson(e))
          .toList(),
    );
  }
}

class CourseContentItem {
  final String type; // "text", "image", "quiz"
  final dynamic data;

  CourseContentItem({required this.type, required this.data});

  factory CourseContentItem.fromJson(Map<String, dynamic> json) {
    return CourseContentItem(
      type: json['type'],
      data: json['data'],
    );
  }
}