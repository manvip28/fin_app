// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart' as sqlite; // Use a prefix for sqflite
import 'package:path/path.dart';
import '../models/transaction.dart'; // Keep your model import as is
import '../models/category.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static sqlite.Database? _database;

  Future<sqlite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<sqlite.Database> _initDatabase() async {
    String path = join(await sqlite.getDatabasesPath(), 'myfinance.db');
    return await sqlite.openDatabase(
      path,
      version: 3, // Increment version number
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(sqlite.Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Add the new columns for notifications
      await db.execute('''
      ALTER TABLE transactions ADD COLUMN enableNotification INTEGER NOT NULL DEFAULT 0
    ''');

      // The notification time seems to be stored as hour and minute in separate fields
      await db.execute('''
      ALTER TABLE transactions ADD COLUMN notificationHour INTEGER
    ''');

      await db.execute('''
      ALTER TABLE transactions ADD COLUMN notificationMinute INTEGER
    ''');
    }
  }

  Future<void> _createDB(sqlite.Database db, int version) async {
    await db.execute('''
    CREATE TABLE categories(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      icon TEXT NOT NULL,
      color TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE transactions(
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      date INTEGER NOT NULL,
      isExpense INTEGER NOT NULL,
      categoryId TEXT NOT NULL,
      isRecurring INTEGER NOT NULL DEFAULT 0,
      recurrencePattern TEXT,
      nextDueDate INTEGER,
      enableNotification INTEGER NOT NULL DEFAULT 0,
      notificationHour INTEGER,
      notificationMinute INTEGER,
      FOREIGN KEY (categoryId) REFERENCES categories (id)
    )
  ''');

    // Insert default categories
    await db.insert('categories', {
      'id': '1',
      'name': 'Groceries',
      'icon': 'shopping_cart',
      'color': '#4CAF50',
    });

    await db.insert('categories', {
      'id': '2',
      'name': 'Rent',
      'icon': 'home',
      'color': '#2196F3',
    });

    await db.insert('categories', {
      'id': '3',
      'name': 'Salary',
      'icon': 'work',
      'color': '#9C27B0',
    });

    await db.insert('categories', {
      'id': '4',
      'name': 'Entertainment',
      'icon': 'movie',
      'color': '#FF9800',
    });
  }

  // Transaction methods
  Future<String> insertTransaction(Transaction transaction) async {
    final db = await database;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final transactionMap = transaction.copyWith(id: id).toMap();
    await db.insert('transactions', transactionMap);
    return id;
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  Future<List<Transaction>> getTransactionsByDateRange(
      DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    );
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  // Category methods
  Future<String> insertCategory(Category category) async {
    final db = await database;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final categoryMap = category.copyWith(id: id).toMap();
    await db.insert('categories', categoryMap);
    return id;
  }

  Future<void> updateCategory(Category category) async {
    final db = await database;
    await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(String id) async {
    final db = await database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }
}
