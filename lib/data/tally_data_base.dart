import 'package:counter/model/tally_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Adjust this based on your project structure

class TallyDatabase {
  static final TallyDatabase instance = TallyDatabase._init();
  static Database? _database;

  TallyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tallyItems.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE tallyItems (
        id $idType,
        name $textType,
        count $intType
      )
    ''');
  }

  Future<void> create(TallyItem item) async {
    final db = await instance.database;
    await db.insert(
      'tallyItems',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TallyItem>> readAllItems() async {
    final db = await instance.database;

    const orderBy = 'id ASC';
    final result = await db.query('tallyItems', orderBy: orderBy);

    return result.map((json) => TallyItem.fromMap(json)).toList();
  }

  Future<int> update(TallyItem item) async {
    final db = await instance.database;

    return db.update(
      'tallyItems',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'tallyItems',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<TallyItem?> getItem(int id) async {
    final db = await TallyDatabase.instance.database;

    // Query the database for the item with the matching id
    final maps = await db.query(
      'tallyItems',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TallyItem.fromMap(maps.first); // Return the first matching item
    } else {
      return null; // Return null if no matching item is found
    }
  }
}
