class CourseSummary {
  const CourseSummary({
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

  final String title;
  final String subtitle;
  final String shortCode;
  final int lessons;
  final int duration;
  final String author;
  final String level;
  final int points;
  final double rating;
}

const sampleCourses = [
  CourseSummary(
    title: 'Figma Master Class',
    subtitle: 'Design systems and production UI',
    shortCode: 'FIG',
    lessons: 8,
    duration: 7,
    author: 'Robertson Connie',
    level: 'Advance',
    points: 2000,
    rating: 4.8,
  ),
  CourseSummary(
    title: 'React',
    subtitle: 'Build interactive UIs with hooks',
    shortCode: 'RE',
    lessons: 9,
    duration: 7,
    author: 'Robertson Connie',
    level: 'Beginner',
    points: 2000,
    rating: 4.8,
  ),
  CourseSummary(
    title: 'JavaScript',
    subtitle: 'Modern JS foundations',
    shortCode: 'JS',
    lessons: 9,
    duration: 7,
    author: 'Robertson Connie',
    level: 'Beginner',
    points: 1000,
    rating: 4.6,
  ),
  CourseSummary(
    title: 'TypeScript',
    subtitle: 'Typed JavaScript for large apps',
    shortCode: 'TS',
    lessons: 9,
    duration: 7,
    author: 'Robertson Connie',
    level: 'Beginner',
    points: 1000,
    rating: 4.6,
  ),
];
