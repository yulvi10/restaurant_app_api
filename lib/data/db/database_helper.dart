import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableFavorite = 'favorite';

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = await openDatabase(
      join(path, 'restaurant.db'),
      onCreate: (db, version) async {
        try {
          await db.execute('''CREATE TABLE $_tableFavorite(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating TEXT
          )
          ''');
          print('Table $_tableFavorite created successfully'); // Tampilkan pesan keberhasilan pembuatan tabel di konsol
        } catch (e) {
          print('Error creating table: $e');
        }
      },
      version: 1,
    );

    return db;
  }

  // Future<void> insertBookmark(Restaurant restaurant) async {
  //   final db = await database;
  //   await db!.insert(_tableFavorite, restaurant.toJson());
  // }

  Future<void> insertBookmark(Restaurant restaurantId) async {
    final db = await database;
    print(
        'Inserting restaurant with ID: ${restaurantId.id} into bookmarks...'); // Menampilkan ID restoran yang akan disimpan ke bookmark di console
    await db!.insert(_tableFavorite, restaurantId.toJson());
  }

  Future<List<Restaurant>> getBookmarks() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tableFavorite);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map> getBookmarkById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeBookmark(String id) async {
    final db = await database;

    await db!.delete(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> viewBookmarks() async {
    final db = await database;
    List<Map<String, dynamic>> bookmarks = await db!.query(_tableFavorite);

    bookmarks.forEach((bookmark) {
      print(bookmark); // Menampilkan data bookmark ke konsol
    });
  }
}
