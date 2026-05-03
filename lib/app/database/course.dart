class Course {
  const Course({
    this.id,
    required this.title,
    required this.subtitle,
    required this.shortCode,
    required this.lessons,
    required this.duration,
    required this.author,
    required this.level,
    required this.points,
    required this.rating,
  });

  final int? id;
  final String title;
  final String subtitle;
  final String shortCode;
  final int lessons;
  final int duration;
  final String author;
  final String level;
  final int points;
  final double rating;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'short_code': shortCode,
      'lessons_count': lessons,
      'duration': duration,
      'author': author,
      'level': level,
      'points': points,
      'rating': rating,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      shortCode: map['short_code'],
      lessons: map['lessons_count'],
      duration: map['duration'],
      author: map['author'],
      level: map['level'],
      points: map['points'],
      rating: map['rating'],
    );
  }
}

class CourseContent {
  const CourseContent({
    this.id,
    required this.courseId,
    required this.title,
    required this.body,
  });

  final int? id;
  final int courseId;
  final String title;
  final String body;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'body': body,
    };
  }

  factory CourseContent.fromMap(Map<String, dynamic> map) {
    return CourseContent(
      id: map['id'],
      courseId: map['course_id'],
      title: map['title'],
      body: map['body'],
    );
  }
}
