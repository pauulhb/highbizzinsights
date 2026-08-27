import 'package:sqflite/sqflite.dart';
import '../models/domain_models.dart';
import '../services/local_database.dart';

class VisitRepository {
  Future<void> save(Visit visit) async {
    final db = await LocalDatabase.instance.database;
    await db.insert(
      'visits',
      visit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> countQualified() async {
    final db = await LocalDatabase.instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM visits WHERE qualified = 1'
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countShort() async {
    final db = await LocalDatabase.instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM visits WHERE qualified = 0'
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
