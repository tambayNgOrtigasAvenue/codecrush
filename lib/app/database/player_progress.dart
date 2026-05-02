class PlayerProgress {
  final int? id;
  final String lessonId;
  final int score;
  final bool isCompleted;
  final DateTime? updatedAt;

  PlayerProgress({
    this.id,
    required this.lessonId,
    this.score = 0,
    this.isCompleted = false,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'lesson_id': lessonId,
      'score': score,
      'is_completed': isCompleted ? 1 : 0,
      'updated_at': updatedAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory PlayerProgress.fromMap(Map<String, dynamic> map) {
    return PlayerProgress(
      id: map['id'],
      lessonId: map['lesson_id'],
      score: map['score'] ?? 0,
      isCompleted: map['is_completed'] == 1,
      updatedAt: map['updated_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at']) 
          : null,
    );
  }

  PlayerProgress copyWith({
    int? id,
    String? lessonId,
    int? score,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return PlayerProgress(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
