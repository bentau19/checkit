import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/datesClass.dart';

class EventsDatabase {
  static final EventsDatabase instance = EventsDatabase._init();

  static Database? _database;

  EventsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // if (Platform.isAndroid) {
    //   final dbPath = await Loader().androidAccess();
    //   final path = join(dbPath, filePath);
    //   return await openDatabase(path, version: 1, onCreate: _createDB);
    // } else {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
    // }
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    // final boolType = 'BOOLEAN NOT NULL';
    // final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableDates ( 
  ${DatesFields.id} $idType, 
  ${DatesFields.date} $textType,
  ${DatesFields.events} $textType
  )
''');
  }

  Future<Date> create(Date note) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableDates, note.toJson());
    return note.copy(id: id);
  }

  Future<Date> readDate(String date) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDates,
      columns: DatesFields.values,
      where: '${DatesFields.date} = ?',
      whereArgs: [date],
    );

    if (maps.isNotEmpty) {
      return Date.fromJson(maps.first);
    } else {
      throw Exception('ID $date not found');
    }
  }

  Future<bool> isDateExist(String date) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDates,
      columns: DatesFields.values,
      where: '${DatesFields.date} = ?',
      whereArgs: [date],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Date>> readAllNotes() async {
    final db = await instance.database;

    final result = await db.query(tableDates);

    return result.map((json) => Date.fromJson(json)).toList();
  }

  Future<int> update(Date task) async {
    final db = await instance.database;

    return db.update(
      tableDates,
      task.toJson(),
      where: '${DatesFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableDates,
      where: '${DatesFields.id} = ?',
      whereArgs: [id],
    );
  }

  // Future close() async {
  //   final db = await instance.database;

  //   db.close();
  // }
}
