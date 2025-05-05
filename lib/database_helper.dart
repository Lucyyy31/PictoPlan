import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class DatabaseHelper {
  static const String _databaseName = "picto_plan.db";
  static const int _databaseVersion = 2;

  static const String tableEvento = 'evento';
  static const String tablePictograma = 'pictograma';
  static const String tableRutina = 'rutina';
  static const String tableUsar = 'usar';
  static const String tableUsuario = 'usuario';

  static const String createTablePictograma = '''
    CREATE TABLE $tablePictograma (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      categoria TEXT NOT NULL,
      imagen BLOB NOT NULL
    );
  ''';

  static const String createTableEvento = '''
    CREATE TABLE $tableEvento (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      fecha TEXT NOT NULL,
      descripcion TEXT,
      id_pictograma INTEGER,
      id_usuario INTEGER,
      FOREIGN KEY (id_pictograma) REFERENCES $tablePictograma(id),
      FOREIGN KEY (id_usuario) REFERENCES $tableUsuario(id)
    );
  ''';

  static const String createTableRutina = '''
    CREATE TABLE $tableRutina (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      hora TEXT NOT NULL,
      fecha TEXT NOT NULL,
      completado BOOLEAN NOT NULL,
      id_pictograma INTEGER,
      id_usuario INTEGER,
      FOREIGN KEY (id_pictograma) REFERENCES $tablePictograma(id),
      FOREIGN KEY (id_usuario) REFERENCES $tableUsuario(id)
    );
  ''';

  static const String createTableUsar = '''
    CREATE TABLE $tableUsar (
      id_usuario INTEGER NOT NULL,
      id_pictograma INTEGER NOT NULL,
      PRIMARY KEY (id_usuario, id_pictograma),
      FOREIGN KEY (id_usuario) REFERENCES $tableUsuario(id),
      FOREIGN KEY (id_pictograma) REFERENCES $tablePictograma(id)
    );
  ''';

  static const String createTableUsuario = '''
    CREATE TABLE $tableUsuario (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombreUsuario TEXT NOT NULL,
      correoElectronico TEXT NOT NULL UNIQUE,
      contrasena TEXT NOT NULL
    );
  ''';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(createTablePictograma);
    await db.execute(createTableEvento);
    await db.execute(createTableRutina);
    await db.execute(createTableUsar);
    await db.execute(createTableUsuario);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tableRutina ADD COLUMN nombre TEXT NOT NULL');
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
  }

  Future<void> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    await db.insert(tableUsuario, usuario, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int?> getUsuarioIdByEmail(String correoElectronico) async {
    final db = await database;
    final result = await db.query(
      tableUsuario,
      where: 'correoElectronico = ?',
      whereArgs: [correoElectronico],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int?;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await database;
    return await db.query(tableUsuario);
  }

  Future<void> insertRutina(Map<String, dynamic> rutina) async {
    final db = await database;
    rutina['fecha'] = _getFormattedDate();
    await db.insert(tableRutina, rutina, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getRutinasPorUsuario(int usuarioId) async {
    final db = await database;
    return await db.query(
      tableRutina,
      where: 'id_usuario = ?',
      whereArgs: [usuarioId],
    );
  }

  Future<List<Map<String, dynamic>>> getPictogramasPorUsuario(int usuarioId) async {
    final db = await database;
    return await db.query(
      tablePictograma,
      where: 'id IN (SELECT id_pictograma FROM $tableUsar WHERE id_usuario = ?)',
      whereArgs: [usuarioId],
    );
  }

  Future<void> asociarPictogramaAUsuario(int usuarioId, int pictogramaId) async {
    final db = await database;
    await db.insert(
      tableUsar,
      {'id_usuario': usuarioId, 'id_pictograma': pictogramaId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPictogramas() async {
    final db = await database;
    return List<Map<String, dynamic>>.from(await db.query(tablePictograma));
  }

  Future<List<int>> imageToBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<void> insertPictograma(Map<String, String> pictograma, List<int> imagenBytes) async {
    final db = await database;
    await db.insert(
      tablePictograma,
      {
        'nombre': pictograma['nombre'],
        'categoria': pictograma['categoria'],
        'imagen': imagenBytes,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAllPictogramas(List<Map<String, String>> pictogramas) async {
    final db = await database;
    for (var pictograma in pictogramas) {
      final imagenBytes = await imageToBytes('assets/pictogramas/${pictograma['categoria']}/${pictograma['nombre']}.png');
      await insertPictograma(pictograma, imagenBytes);
    }
  }

  Future<List<Map<String, dynamic>>> getPictogramasPorCarpeta(String carpeta) async {
    final db = await database;
    return List<Map<String, dynamic>>.from(await db.query(
      tablePictograma,
      where: 'categoria = ?',
      whereArgs: [carpeta],
    ));
  }

  Future<List<Map<String, dynamic>>> getEventos() async {
    final db = await database;
    return await db.query(tableEvento);
  }

  Future<void> insertarEventoConPictogramas({
    required String nombre,
    required String fecha,
    required String descripcion,
    required List<int> pictogramaIds,
    required int idUsuario,
  }) async {
    final db = await database;
    for (int idPicto in pictogramaIds) {
      await db.insert(tableEvento, {
        'nombre': nombre,
        'fecha': fecha,
        'descripcion': descripcion,
        'id_pictograma': idPicto,
        'id_usuario': idUsuario,
      });
    }
  }

  Future<void> insertEvento(Map<String, dynamic> evento) async {
    final db = await database;
    await db.insert(tableEvento, evento, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getEventosByEmail(String email) async {
    final db = await database;

    return await db.rawQuery('''
    SELECT 
      e.id, e.nombre, e.fecha, e.descripcion, e.id_usuario,
      p.id AS pictograma_id, p.nombre AS pictograma_nombre, p.imagen AS pictograma_imagen
    FROM evento e
    JOIN usuario u ON e.id_usuario = u.id
    LEFT JOIN pictograma p ON e.id_pictograma = p.id
    WHERE u.correoElectronico = ?
    GROUP BY e.nombre, e.fecha, e.descripcion, e.id_usuario
    ORDER BY e.fecha DESC
  ''', [email]);
  }


  Future<List<Map<String, dynamic>>> getPictogramaById(int id) async {
    final db = await database;
    return await db.query(
      tablePictograma,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Uint8List?> getPictogramaImageById(int idPictograma) async {
    final db = await database;
    final result = await db.query(
      'pictograma',
      columns: ['imagen'],
      where: 'id = ?',
      whereArgs: [idPictograma],
    );

    if (result.isNotEmpty) {
      return result.first['imagen'] as Uint8List?;
    }

    return null;
  }
  Future<Map<String, dynamic>?> getEventoCompletoPorId(int eventId) async {
    final db = await database;

    // Obtiene los datos base del evento
    final evento = await getEventById(eventId);
    if (evento == null) return null;

    // Obtiene los pictogramas asociados a ese evento
    final pictogramas = await db.rawQuery('''
    SELECT p.*
    FROM $tableEvento e
    JOIN $tablePictograma p ON e.id_pictograma = p.id
    WHERE e.nombre = ? AND e.fecha = ? AND e.descripcion = ? AND e.id_usuario = ?
  ''', [
      evento['nombre'],
      evento['fecha'],
      evento['descripcion'],
      evento['id_usuario'],
    ]);

    // Devuelve un mapa combinando evento base y pictogramas asociados
    return {
      'evento': evento,
      'pictogramas': pictogramas,
    };
  }

  Future<void> deleteEvent(int id) async {
    final db = await database;
    final event = await getEventById(id);
    if (event == null) return;
    await db.delete(
      'evento',
      where: 'nombre = ? AND fecha = ? AND descripcion = ? AND id_usuario = ?',
      whereArgs: [
        event['nombre'],
        event['fecha'],
        event['descripcion'],
        event['id_usuario']
      ],
    );
  }

  Future<void> actualizarEvento({
    required int eventId,
    required String nombre,
    required String fecha,
    required String descripcion,
    required List<int> pictogramaIds,
    required int idUsuario,
  }) async {
    final db = await database;
    final originalEvent = await getEventById(eventId);
    if (originalEvent == null) return;

    await db.delete(
      'evento',
      where: 'nombre = ? AND fecha = ? AND descripcion = ? AND id_usuario = ?',
      whereArgs: [
        originalEvent['nombre'],
        originalEvent['fecha'],
        originalEvent['descripcion'],
        originalEvent['id_usuario']
      ],
    );

    for (int pictogramaId in pictogramaIds) {
      await db.insert('evento', {
        'nombre': nombre,
        'fecha': fecha,
        'descripcion': descripcion,
        'id_pictograma': pictogramaId,
        'id_usuario': idUsuario,
      });
    }
  }

  Future<Map<String, dynamic>?> getEventById(int eventId) async {
    final db = await database;
    final result = await db.query(
      'evento',
      where: 'id = ?',
      whereArgs: [eventId],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }
}
