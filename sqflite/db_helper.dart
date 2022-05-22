import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static late Database db;

  static Future<Database> openDatabase() async {
    final dbPath = await sql.getDatabasesPath();

    /// change name of database to specify the app
    return db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, version) {
        /// change arguments of database
        return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)',
        );
      },
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    // final db = await DBHelper.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    //  final db = await DBHelper.database();
    return db.query(table);
  }
}
