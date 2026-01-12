import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('galeria_examen.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        autor TEXT NOT NULL
      )
    ''');

    // CARGA DE 15 REGISTROS
    for (int i = 1; i <= 15; i++) {
      // Para demostrar el filtro: 
      // Los múltiplos de 3 tendrán un autor diferente, los demás serán "AI-4"
      String valorAutor = (i % 3 == 0) ? "OTRO-99" : "AI-4";
      
      await db.insert('items', {
        'titulo': 'Elemento #$i',
        'imageUrl': 'https://picsum.photos/400/400?random=$i',
        'autor': valorAutor, // <--- REQUERIMIENTO: Guardar el autor
      });
    }
  }

  // MÉTODO DE FILTRADO OBLIGATORIO
  Future<List<Map<String, dynamic>>> getMisRegistros(String miAutor) async {
    final db = await instance.database;
    // Retorna solo los que coinciden con "AI-4"
    return await db.query('items', where: 'autor = ?', whereArgs: [miAutor]);
  }
}