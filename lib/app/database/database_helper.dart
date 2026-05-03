import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'player_progress.dart';
import 'course.dart';

part 'seed_data.dart';

class DatabaseHelper {
  static const _databaseName = "PlayerProgress.db";
  static const _databaseVersion = 5; // expanded seed_data.dart

  static const tableProgress = 'player_progress';

  static const columnId = 'id';
  static const columnLessonId = 'lesson_id';
  static const columnScore = 'score';
  static const columnIsCompleted = 'is_completed';
  static const columnUpdatedAt = 'updated_at';

  static const tableCourses = 'courses';
  static const tableCourseContents = 'course_contents';

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableProgress (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnLessonId TEXT NOT NULL UNIQUE,
            $columnScore INTEGER DEFAULT 0,
            $columnIsCompleted INTEGER DEFAULT 0,
            $columnUpdatedAt INTEGER
          )
          ''');
    await _createCourseTables(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createCourseTables(db);
    }
    if (oldVersion < 5) {
      // Reseed with expanded content from seed_data.dart
      await db.delete(tableCourseContents);
      await db.delete(tableCourses);
      await _seedCourses(db);
    }
  }

  Future _createCourseTables(Database db) async {
    await db.execute('''
          CREATE TABLE $tableCourses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL,
            short_code TEXT NOT NULL,
            lessons_count INTEGER NOT NULL,
            duration INTEGER NOT NULL,
            author TEXT NOT NULL,
            level TEXT NOT NULL,
            points INTEGER NOT NULL,
            rating REAL NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableCourseContents (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            course_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            FOREIGN KEY (course_id) REFERENCES $tableCourses (id) ON DELETE CASCADE
          )
          ''');

    await _seedCourses(db);
  }

  /// Reads all courses from [_kCourses] (defined in seed_data.dart)
  /// and inserts them along with their content lessons.
  Future _seedCourses(Database db) async {
    for (final courseDef in _kCourses) {
      final contents =
          List<Map<String, dynamic>>.from(courseDef['contents'] as List);
      final courseMap = Map<String, dynamic>.from(courseDef)
        ..remove('contents');

      final courseId = await db.insert(tableCourses, courseMap);

      for (final content in contents) {
        await db.insert(tableCourseContents, {
          'course_id': courseId,
          'title': content['title'],
          'body': content['body'],
        });
      }
    }
  }

  // ── Course query methods ───────────────────────────────────────────────

  Future<List<Course>> getAllCourses() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableCourses);
    return List.generate(maps.length, (i) => Course.fromMap(maps[i]));
  }

  Future<List<CourseContent>> getContentsForCourse(int courseId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableCourseContents,
      where: 'course_id = ?',
      whereArgs: [courseId],
    );
    return List.generate(maps.length, (i) => CourseContent.fromMap(maps[i]));
  }

  // ── Progress methods ───────────────────────────────────────────────────

  Future<int> insertOrUpdateProgress(PlayerProgress progress) async {
    Database db = await instance.database;
    return await db.insert(
      tableProgress,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PlayerProgress?> getProgress(String lessonId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableProgress,
      where: '$columnLessonId = ?',
      whereArgs: [lessonId],
    );
    if (maps.isNotEmpty) return PlayerProgress.fromMap(maps.first);
    return null;
  }

  Future<List<PlayerProgress>> getAllProgress() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableProgress);
    return List.generate(maps.length, (i) => PlayerProgress.fromMap(maps[i]));
  }

  Future<int> deleteProgress(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableProgress,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
