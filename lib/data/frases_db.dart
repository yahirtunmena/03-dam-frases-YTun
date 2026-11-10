import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/frase.dart';

class FrasesDb {
  FrasesDb._();
  static final FrasesDb instancia = FrasesDb._();
  static const _nombreArchivo = 'misfrases.db';
  static const _tabla = 'frases';
  Database? _db;

  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tabla (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            frase TEXT NOT NULL,
            autor TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(Frase frase) async {
    final db = await _database;
    return db.insert(_tabla, frase.toMap());
  }

  Future<List<Frase>> obtenerTodas() async {
    final db = await _database;
    final filas = await db.query(_tabla, orderBy: 'id DESC');
    return filas.map((e) => Frase.fromMap(e)).toList();
  }

  Future<int> actualizar(Frase frase) async {
    final db = await _database;
    return db.update(
      _tabla,
      frase.toMap(),
      where: 'id = ?',
      whereArgs: [frase.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _database;
    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }
}