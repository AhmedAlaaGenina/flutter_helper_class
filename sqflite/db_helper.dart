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

//? More Flexible  way
import 'package:mobile_developer_test/features/auth/data/models/auth_request.dart';
import 'package:mobile_developer_test/features/auth/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseTables {
  DataBaseTables._();
  static const String recipes = 'recipes';
  static const String users = 'users';
  static const String favorites = 'favorites';
}

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DataBaseTables.users} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        fullName TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ${DataBaseTables.favorites} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        recipeId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES ${DataBaseTables.users}(id),
        UNIQUE(userId, recipeId)
      )
    ''');
  }

  // Insert User (Registration)
  Future<UserModel?> insertUser(AuthRequest request) async {
    Database db = await instance.database;
    var id = await db.insert(DataBaseTables.users, request.toJson());
    if (id > 0) {
      return UserModel(
        id: id,
        email: request.email,
        fullName: request.fullName,
      ); // User Add
    } else {
      return null; // User not Add
    }
  }

  // Query User by username and password (Login)
  Future<UserModel?> getUser(AuthRequest request) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      DataBaseTables.users,
      where: 'email = ? AND password = ?',
      whereArgs: [request.email, request.password],
    );
    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first); // User found
    } else {
      return null; // User not found
    }
  }

  // Query User by id (for checking duplicates during registration)
  Future<UserModel?> getUserById(String id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      DataBaseTables.users,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first); // User found
    } else {
      return null; // User not found
    }
  }

  // Query User by email (for checking duplicates during registration)
  Future<UserModel?> getUserByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      DataBaseTables.users,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first); // User found
    } else {
      return null; // User not found
    }
  }

  // Update User (e.g., change password)
  Future<int> updateUser(UserModel user) async {
    Database db = await instance.database;
    return await db.update(
      DataBaseTables.users,
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete User
  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(
      DataBaseTables.users,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Info: favorites
  // Add to favorites
  Future<bool> addToFavorites(int userId, String recipeId) async {
    Database db = await instance.database;
    try {
      await db.insert(
        DataBaseTables.favorites,
        {
          'userId': userId,
          'recipeId': recipeId,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Remove from favorites
  Future<bool> removeFromFavorites(int userId, String recipeId) async {
    Database db = await instance.database;
    int count = await db.delete(
      DataBaseTables.favorites,
      where: 'userId = ? AND recipeId = ?',
      whereArgs: [userId, recipeId],
    );
    return count > 0;
  }

  // Get all favorite recipeIds for a user
  Future<List<String>> getFavoriteRecipeIds(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      DataBaseTables.favorites,
      columns: ['recipeId'],
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return results.map((result) => result['recipeId'] as String).toList();
  }

  // Check if a recipe is favorited by user
  Future<bool> isFavorite(int userId, String recipeId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      DataBaseTables.favorites,
      where: 'userId = ? AND recipeId = ?',
      whereArgs: [userId, recipeId],
    );
    return results.isNotEmpty;
  }
}

// class DatabaseHelper {
//   static const _databaseName = "MyDatabase.db";
//   static const _databaseVersion = 1;

//   // Singleton pattern
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), _databaseName);
//     return await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     // Create tables here
//     await db.execute('''
//       CREATE TABLE ${DataBaseTables.users} (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         value INTEGER NOT NULL
//       )
//     ''');
//   }

//   // INSERT
//   Future<int> insert(String table, Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(table, row);
//   }

//   // QUERY all rows
//   Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
//     Database db = await instance.database;
//     return await db.query(table);
//   }

//   // QUERY specific row
//   Future<List<Map<String, dynamic>>> queryRows(
//     String table,
//     String columnName,
//     dynamic value,
//   ) async {
//     Database db = await instance.database;
//     return await db.query(table, where: '$columnName = ?', whereArgs: [value]);
//   }

//   // UPDATE row(s)
//   Future<int> update(
//     String table,
//     Map<String, dynamic> row,
//     String columnName,
//     dynamic value,
//   ) async {
//     Database db = await instance.database;
//     return await db.update(
//       table,
//       row,
//       where: '$columnName = ?',
//       whereArgs: [value],
//     );
//   }

//   // DELETE row(s)
//   Future<int> delete(String table, String columnName, dynamic value) async {
//     Database db = await instance.database;
//     return await db.delete(
//       table,
//       where: '$columnName = ?',
//       whereArgs: [value],
//     );
//   }

//   // Get row count
//   Future<int?> queryRowCount(String table) async {
//     Database db = await instance.database;
//     return Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM $table'));
//   }
// }
