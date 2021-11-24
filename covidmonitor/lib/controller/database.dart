import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:covidmonitor/model/userData.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "MainDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE UserData ("
          " id INTEGER PRIMARY KEY,"
          " profileImagePath TEXT,"
          " vacPassImagePath TEXT,"
          " vacDate TEXT,"
          " isVaccinated INTEGER,"
          " name TEXT,"
          " age INTEGER"
          " )");
    });
  }

  newUserData() async {
    final userData = new UserData();
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into UserData (id,profileImagePath,vacPassImagePath,vacDate,isVaccinated,name,age)"
        " VALUES (?,?,?,?,?,?,?)",
        [
          UserData.id,
          userData.profileImagePath ?? "",
          userData.vacPassImagePath ?? "",
          userData.vacDate ?? "",
          userData.isVaccinated ?? 0,
          userData.name ?? "",
          userData.age ?? 0
        ]);
    return raw;
  }

  updateUserData(UserData userData) async {
    final db = await database;
    var res = await db.update("UserData", userData.toMap(),
        where: "id = ?", whereArgs: [UserData.id]);
    return res;
  }

  getUserData() async {
    final db = await database;
    var res =
        await db.query("UserData", where: "id = ?", whereArgs: [UserData.id]);
    return res.isNotEmpty ? UserData.fromMap(res.first) : null;
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from UserData");
  }

  getSingleUserData() async {
    final UserData? userData = await getUserData();
    if (userData == null) {
      await newUserData();
      return await getUserData();
    } else {
      return userData;
    }
  }
}
