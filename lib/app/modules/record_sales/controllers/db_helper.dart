import 'package:florist/app/modules/record_sales/models/sale.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db == null) {
      await initDB();
    }
    return _db!;
  }

  static Future<void> initDB() async {
    if (_db != null) return;
    String path = join(await getDatabasesPath(), 'sales.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productName TEXT,
            quantity INTEGER,
            price REAL,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  // Fungsi untuk menyimpan penjualan ke SQLite
  static Future<void> insertSale(Sale sale) async {
    final dbClient = await db;
    await dbClient.insert(
      'sales',
      sale.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fungsi untuk mengambil semua data penjualan dari SQLite
  static Future<List<Sale>> getSales() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('sales');

    return List.generate(maps.length, (i) {
      return Sale(
        productName: maps[i]['productName'],
        quantity: maps[i]['quantity'],
        price: maps[i]['price'],
        // timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }

  static Future<void> updateStock(String productName, int newStock) async {
  final dbClient = await db;
  await dbClient.update(
    'flowers',
    {'stock': newStock},
    where: 'productName = ?',
    whereArgs: [productName],
  );
}

}
