import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_cab/data/models/subscription_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  static const String _dbName = 'app_database.db';
  static const int _dbVersion = 1;

  // Table name for subscription
  static const String tableSubscription = 'subscriptions';

  // Column names (matching SubscriptionModel)
  static const String columnId = 'id';
  static const String columnSubscriptionType = 'subscriptionType';
  static const String columnPrice = 'price';
  static const String columnListingLimit = 'listingLimit';
  static const String columnDiscountPercent = 'discountPercent';
  static const String columnSupportLevel = 'supportLevel';
  static const String columnPremiumListingAccess = 'premiumListingAccess';
  static const String columnDurationInMonths = 'durationInMonths';
  static const String columnActive = 'active';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create subscription table with all fields of SubscriptionModel
    await db.execute('''
      CREATE TABLE $tableSubscription (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnSubscriptionType TEXT,
        $columnPrice REAL,
        $columnListingLimit INTEGER,
        $columnDiscountPercent INTEGER,
        $columnSupportLevel TEXT,
        $columnPremiumListingAccess INTEGER,
        $columnDurationInMonths INTEGER,
        $columnActive INTEGER
      )
    ''');
  }

  // CRUD operations for SubscriptionModel
  Future<void> insertAllSubscriptions(List<SubscriptionModel> list) async {
    final db = await database;
    final batch = db.batch();

    for (var sub in list) {
      batch.insert(
        tableSubscription,
        sub.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<SubscriptionModel>> getAllSubscriptions() async {
    try {
      final db = await database;
      final result = await db.query(tableSubscription);
      debugPrint('result $result');
      return result.map((e) => SubscriptionModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('error $e');
      rethrow;
    }
  }

  Future<void> clearSubscriptions() async {
    final db = await database;
    await db.delete(tableSubscription);
  }

  Future<int> updateSubscription(SubscriptionModel subscription) async {
    final db = await database;
    if (subscription.id == null) {
      throw Exception("SubscriptionModel must have an id to update.");
    }
    final map = subscription.toJson()
      ..[columnPremiumListingAccess] =
          (subscription.premiumListingAccess ?? false) ? 1 : 0
      ..[columnActive] = (subscription.active ?? false) ? 1 : 0;
    return await db.update(
      tableSubscription,
      map,
      where: '$columnId = ?',
      whereArgs: [subscription.id],
    );
  }

  Future<int> deleteSubscription(int id) async {
    final db = await database;
    return await db.delete(
      tableSubscription,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
