import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('foods.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // إنشاء الجدول
    await db.execute('''
    CREATE TABLE custom_foods ( 
      id TEXT PRIMARY KEY, 
      name TEXT, 
      calories INTEGER, 
      protein REAL, 
      carbs REAL, 
      fat REAL, 
      imageUrl TEXT,
      isCustom INTEGER
    )
    ''');
  }

  // دالة الحفظ (Create)
  Future<void> insertFood(FoodItem food) async {
    final db = await instance.database;
    await db.insert(
      'custom_foods',
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // دالة الاسترجاع (Read)
  Future<List<FoodItem>> getCustomFoods() async {
    final db = await instance.database;
    final result = await db.query('custom_foods');
    return result.map((json) => FoodItem.fromMap(json)).toList();
  }

  // دالة الحذف (Delete)
  Future<void> deleteFood(String id) async {
    final db = await instance.database;
    await db.delete('custom_foods', where: 'id = ?', whereArgs: [id]);
  }
}
