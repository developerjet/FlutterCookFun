import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';

class DBManager {
  static const String _tableName = "CookConfig";

  /// 数据库名
  final String _dbName = "CookFun";

  /// 数据库版本
  final int _version = 1;

  static final DBManager _instance = DBManager._();

  factory DBManager() {
    return _instance;
  }

  DBManager._();

  static Database? _db;

  Future<Database> get db async {
    // if (_db != null) {
    //   return _db;
    // }
    // _db = await _initDB();
    // return _db;
    return _db ??= await _initDB();
  }

  /// 初始化数据库
  Future<Database> _initDB() async {
    final databaseDirectory = await getDatabasesPath();
    final path = join(databaseDirectory, _dbName);
    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 创建表
  Future _onCreate(Database db, int version) async {
    const String sql = """
    CREATE TABLE CookConfig (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      dishes_id TEXT,
      image TEXT,
      title TEXT,
      hard_level TEXT,
      taste TEXT,
      cooking_time TEXT,
      description TEXT);
    """;
    return await db.execute(sql);
  }

  /// 更新表
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  /// 保存数据
  Future saveData(CookConfigListModel cook) async {
    Database database = await db;

    Map<String, Object?> values = {
      'dishes_id': cook.dishesId ?? "",
      'image': cook.image ?? "",
      'title': cook.title ?? "",
      'hard_level': cook.hardLevel ?? "",
      'taste': cook.taste ?? "",
      'cooking_time': cook.cookingTime ?? "",
      'description': cook.description ?? "",
    };

    return await database.insert(_tableName, values);
  }

  /// 使用SQL保存数据
  Future saveDataBySQL(CookConfigListModel cook) async {
    const String sql = """
    INSERT INTO CookConfig(dishes_id,image,title,hard_level,taste,cooking_time,description) values(?,?,?,?,?,?,?)
    """;
    Database database = await db;
    return await database.rawInsert(sql, [
      cook.dishesId,
      cook.image,
      cook.title,
      cook.hardLevel,
      cook.taste,
      cook.cookingTime,
      cook.description
    ]);
  }

  /// 查询全部数据
  Future<List<CookConfigListModel>?> findAll() async {
    Database? database = await db;
    List<Map<String, Object?>> result = await database.query(_tableName);
    if (result.isNotEmpty) {
      return result.map((e) => CookConfigListModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  ///条件查询
  Future<List<CookConfigListModel>?> find(String dishesId) async {
    Database database = await db;
    List<Map<String, Object?>> result = await database
        .query(_tableName, where: "dishes_id=?", whereArgs: [dishesId]);
    if (result.isNotEmpty) {
      return result.map((e) => CookConfigListModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  /// 修改
  Future<int> update(CookConfigListModel cook, String dishesId) async {
    Database database = await db;
    final updatedCook = CookConfigListModel(
      dishesId: dishesId,
      image: cook.image,
      title: cook.title,
      hardLevel: cook.hardLevel,
      taste: cook.taste,
      cookingTime: cook.cookingTime,
      description: cook.description,
      video: cook.video,
      video1: cook.video1,
      play: cook.play,
      collectCount: cook.collectCount,
      createDate: cook.createDate,
      content: cook.content,
      tagsInfo: cook.tagsInfo,
    );
    int count = await database.update(_tableName, updatedCook.toJson(),
        where: "dishes_id=?", whereArgs: [dishesId]);
    return count;
  }

  /// 删除
  Future<int> delete(String dishesId) async {
    Database database = await db;
    int count = await database
        .delete(_tableName, where: "dishes_id=?", whereArgs: [dishesId]);
    return count;
  }

  /// 删除全部
  Future<int> deleteAll() async {
    Database database = await db;
    int count = await database.delete(_tableName);
    return count;
  }
}
