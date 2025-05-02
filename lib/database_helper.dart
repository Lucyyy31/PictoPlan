import 'package:flutter/services.dart';  // Para cargar los assets (imágenes) desde la carpeta assets
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'dart:io';

class DatabaseHelper {
  // El nombre de la base de datos
  static const String _databaseName = "picto_plan.db";
  static const int _databaseVersion = 2;  // Incrementamos la versión para agregar el campo 'nombre'

  // Nombre de las tablas
  static const String tableEvento = 'evento';
  static const String tablePictograma = 'pictograma';
  static const String tableRutina = 'rutina';
  static const String tableUsar = 'usar';
  static const String tableUsuario = 'usuario';

  // Crear las tablas
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
    nombre TEXT NOT NULL,  -- Campo agregado para almacenar el nombre
    hora TEXT NOT NULL,
    fecha TEXT NOT NULL,  -- Campo para almacenar la fecha en formato 'DD-MM-YYYY'
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

  // Crear la base de datos
  static Database? _database;

  // Inicializar la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si no está creado, lo creamos
    _database = await _initDatabase();
    return _database!;
  }

  // Crear y abrir la base de datos
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // Crear las tablas en la base de datos
  Future _onCreate(Database db, int version) async {
    await db.execute(createTablePictograma);
    await db.execute(createTableEvento);
    await db.execute(createTableRutina);
    await db.execute(createTableUsar);
    await db.execute(createTableUsuario);
  }

  // Actualizar la base de datos cuando se cambia la versión
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Añadimos el nuevo campo 'nombre' en la tabla rutina
      await db.execute('ALTER TABLE $tableRutina ADD COLUMN nombre TEXT NOT NULL');
    }
  }

  // Método para obtener la fecha actual en formato 'DD-MM-YYYY'
  String _getFormattedDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();

    return '$day-$month-$year'; // Formato 'DD-MM-YYYY'
  }

  // Método para insertar un usuario
  Future<void> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    await db.insert(
      tableUsuario,
      usuario,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para obtener el id del usuario por correo electrónico
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

  // Método para obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await database;
    return await db.query(tableUsuario);
  }

  // Método para insertar una rutina
  Future<void> insertRutina(Map<String, dynamic> rutina) async {
    final db = await database;
    rutina['fecha'] = _getFormattedDate();

    await db.insert(
      tableRutina,
      rutina,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para obtener rutinas por usuario
  Future<List<Map<String, dynamic>>> getRutinasPorUsuario(int usuarioId) async {
    final db = await database;
    return await db.query(
      tableRutina,
      where: 'id_usuario = ?',
      whereArgs: [usuarioId],
    );
  }

  // Método para obtener pictogramas por usuario
  Future<List<Map<String, dynamic>>> getPictogramasPorUsuario(int usuarioId) async {
    final db = await database;
    return await db.query(
      tablePictograma,
      where: 'id IN (SELECT id_pictograma FROM $tableUsar WHERE id_usuario = ?)',
      whereArgs: [usuarioId],
    );
  }

  // Método para asociar un pictograma con un usuario
  Future<void> asociarPictogramaAUsuario(int usuarioId, int pictogramaId) async {
    final db = await database;
    await db.insert(
      tableUsar,
      {
        'id_usuario': usuarioId,
        'id_pictograma': pictogramaId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para obtener todos los pictogramas
  Future<List<Map<String, dynamic>>> getPictogramas() async {
    final db = await database;
    final result = await db.query(tablePictograma);
    return List<Map<String, dynamic>>.from(result);
  }

  // Método para convertir imagen de assets a bytes
  Future<List<int>> imageToBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath); // Cargar archivo de imagen desde assets
    return data.buffer.asUint8List();
  }

  // Método para insertar pictogramas
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

  // Método para insertar pictogramas en lotes
  Future<void> insertAllPictogramas(List<Map<String, String>> pictogramas) async {
    final db = await database;
    for (var pictograma in pictogramas) {
      final imagenBytes = await imageToBytes('assets/pictogramas/${pictograma['categoria']}/${pictograma['nombre']}.png');
      await insertPictograma(pictograma, imagenBytes);
    }
  }

  // Método para obtener pictogramas por carpeta
  Future<List<Map<String, dynamic>>> getPictogramasPorCarpeta(String carpeta) async {
    final db = await database;
    final result = await db.query(
      tablePictograma,
      where: 'categoria = ?',
      whereArgs: [carpeta],
    );
    return List<Map<String, dynamic>>.from(result);
  }

  // Método para obtener todos los eventos
  Future<List<Map<String, dynamic>>> getEventos() async {
    final db = await database;
    return await db.query(tableEvento);
  }

  // Método para insertar un evento
  Future<void> insertEvento(Map<String, dynamic> evento) async {
    final db = await database;
    await db.insert(tableEvento, evento, conflictAlgorithm: ConflictAlgorithm.replace);
  }

}
