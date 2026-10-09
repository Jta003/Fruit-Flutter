import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/fruit.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fruit_nutrition_v4.db'); // v4: เพิ่ม Kiwi, Chickoo, Cherry
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, 
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS fruits');
      await db.execute('DROP TABLE IF EXISTS scan_history');
      await _createDB(db, newVersion);
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE fruits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  scientificName TEXT NOT NULL,
  kind TEXT NOT NULL,
  kcal REAL NOT NULL,
  sugar REAL NOT NULL,
  carbs REAL NOT NULL,
  fiber REAL NOT NULL,
  protein REAL NOT NULL,
  fat REAL NOT NULL,
  vitaminC REAL NOT NULL,
  servingSize TEXT NOT NULL,
  healthScore INTEGER NOT NULL,
  isFavorite INTEGER NOT NULL DEFAULT 0
)
''');

    await db.execute('''
CREATE TABLE scan_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fruitId INTEGER NOT NULL,
  scanTime TEXT NOT NULL,
  FOREIGN KEY (fruitId) REFERENCES fruits (id) ON DELETE CASCADE
)
''');

    await _prepopulateData(db);
  }

  Future _prepopulateData(Database db) async {
    final initialFruits = [
      {
        'name': 'แอปเปิล (แดง)',
        'scientificName': 'Malus domestica',
        'kind': 'apple',
        'kcal': 52.0,
        'sugar': 10.3,
        'carbs': 13.8,
        'fiber': 2.4,
        'protein': 0.3,
        'fat': 0.2,
        'vitaminC': 4.6,
        'servingSize': '1 ผลกลาง (ประมาณ 150ก.)',
        'healthScore': 92,
      },
      {
        'name': 'กล้วยหอม',
        'scientificName': 'Musa acuminata',
        'kind': 'banana',
        'kcal': 132.0,
        'sugar': 24.0,
        'carbs': 31.0,
        'fiber': 2.1,
        'protein': 1.2,
        'fat': 0.3,
        'vitaminC': 8.7,
        'servingSize': '1 ผล (ประมาณ 120ก.)',
        'healthScore': 85,
      },
      {
        'name': 'ส้มเขียวหวาน',
        'scientificName': 'Citrus sinensis',
        'kind': 'orange',
        'kcal': 42.0,
        'sugar': 9.0,
        'carbs': 10.0,
        'fiber': 1.4,
        'protein': 0.7,
        'fat': 0.1,
        'vitaminC': 42.0,
        'servingSize': '2 ผลกลาง',
        'healthScore': 88,
      },
      {
        'name': 'มะม่วงน้ำดอกไม้ (สุก)',
        'scientificName': 'Mangifera indica',
        'kind': 'mango',
        'kcal': 84.0,
        'sugar': 18.0,
        'carbs': 21.0,
        'fiber': 1.8,
        'protein': 0.6,
        'fat': 0.3,
        'vitaminC': 36.4,
        'servingSize': '1/2 ผลใหญ่',
        'healthScore': 78,
      },
      {
        'name': 'องุ่นแดง',
        'scientificName': 'Vitis vinifera',
        'kind': 'grapes',
        'kcal': 69.0,
        'sugar': 15.5,
        'carbs': 18.1,
        'fiber': 0.9,
        'protein': 0.7,
        'fat': 0.2,
        'vitaminC': 3.2,
        'servingSize': '1 พวงเล็ก (100ก.)',
        'healthScore': 82,
      },
      {
        'name': 'สตรอว์เบอร์รี',
        'scientificName': 'Fragaria × ananassa',
        'kind': 'strawberry',
        'kcal': 33.0,
        'sugar': 4.9,
        'carbs': 7.7,
        'fiber': 2.0,
        'protein': 0.7,
        'fat': 0.3,
        'vitaminC': 58.8,
        'servingSize': '6-8 ผลกลาง',
        'healthScore': 95,
      },
      {
        'name': 'กีวี',
        'scientificName': 'Actinidia deliciosa',
        'kind': 'kiwi',
        'kcal': 61.0,
        'sugar': 9.0,
        'carbs': 14.7,
        'fiber': 3.0,
        'protein': 1.1,
        'fat': 0.5,
        'vitaminC': 92.7,
        'servingSize': '1 ผลกลาง (ประมาณ 75ก.)',
        'healthScore': 94,
      },
      {
        'name': 'ละมุด (Chickoo)',
        'scientificName': 'Manilkara zapota',
        'kind': 'chickoo',
        'kcal': 83.0,
        'sugar': 14.8,
        'carbs': 20.0,
        'fiber': 5.3,
        'protein': 0.4,
        'fat': 1.1,
        'vitaminC': 14.7,
        'servingSize': '1 ผลกลาง (ประมาณ 100ก.)',
        'healthScore': 86,
      },
      {
        'name': 'เชอร์รี',
        'scientificName': 'Prunus avium',
        'kind': 'cherry',
        'kcal': 63.0,
        'sugar': 12.8,
        'carbs': 16.0,
        'fiber': 2.1,
        'protein': 1.1,
        'fat': 0.2,
        'vitaminC': 7.0,
        'servingSize': '1 ถ้วย (ประมาณ 140ก.)',
        'healthScore': 90,
      },
    ];

    for (var fruit in initialFruits) {
      await db.insert('fruits', fruit);
    }
  }

  Future<List<Fruit>> readAllFruits() async {
    final db = await instance.database;
    final result = await db.query('fruits');
    return result.map((json) => Fruit.fromJson(json)).toList();
  }

  Future<List<Map<String, dynamic>>> readHistory() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT h.id as historyId, f.*, h.scanTime 
      FROM scan_history h 
      JOIN fruits f ON h.fruitId = f.id 
      ORDER BY h.scanTime DESC
    ''');
  }

  Future<int> insertHistory(int fruitId, String scanTime) async {
    final db = await instance.database;
    return await db.insert('scan_history', {
      'fruitId': fruitId,
      'scanTime': scanTime,
    });
  }

  Future<int> deleteHistory(int historyId) async {
    final db = await instance.database;
    return await db.delete(
      'scan_history',
      where: 'id = ?',
      whereArgs: [historyId],
    );
  }

  Future<void> clearHistory() async {
    final db = await instance.database;
    await db.delete('scan_history');
  }

  Future<int> updateFavorite(int id, bool isFavorite) async {
    final db = await instance.database;
    return db.update(
      'fruits',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
