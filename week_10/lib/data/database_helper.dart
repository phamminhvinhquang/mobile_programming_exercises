import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart'; // Import model Task

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // --- Hàm khởi tạo Database (Đã cập nhật lệnh in đường dẫn) ---
  Future<Database> _initDatabase() async {
    // 1. Lấy đường dẫn thư mục lưu database trên thiết bị
    String dbPath = await getDatabasesPath();

    // 2. Tạo đường dẫn đầy đủ đến file 'smart_tasks.db'
    String path = join(dbPath, 'smart_tasks.db');

    // ---> DÒNG IN ĐƯỜNG DẪN ĐỂ DEBUG <---
    print("🔥🔥🔥 ĐƯỜNG DẪN DATABASE Ở ĐÂY: $path");

    // 3. Mở database (nếu chưa có thì tạo mới)
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)',
        );
      },
    );
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: "id DESC", // Sắp xếp cái mới nhất lên đầu
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }
}
