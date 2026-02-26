// lib/core/database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('clinica.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      // Esto es VITAL: Le dice a SQLite que respete las relaciones (Llaves Foráneas)
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  // AQUÍ CONSTRUIMOS TODAS LAS TABLAS DEL DIAGRAMA
  Future _createDB(Database db, int version) async {
    // 1. Tabla Usuario
    await db.execute('''
      CREATE TABLE usuario (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        apellido TEXT NOT NULL,
        correo TEXT NOT NULL,
        password TEXT NOT NULL,
        rol TEXT NOT NULL,
        estado TEXT NOT NULL,
        fecha_creacion TEXT NOT NULL
      )
    ''');

    // 2. Tabla Paciente
    await db.execute('''
      CREATE TABLE paciente (
        id_paciente INTEGER PRIMARY KEY AUTOINCREMENT,
        cedula TEXT NOT NULL,
        nombres TEXT NOT NULL,
        apellidos TEXT NOT NULL,
        telefono TEXT,
        correo TEXT,
        estado TEXT NOT NULL
      )
    ''');

    // 3. Tabla Cita (Tiene llaves foráneas conectando a Paciente y Usuario)
    await db.execute('''
      CREATE TABLE cita (
        id_cita INTEGER PRIMARY KEY AUTOINCREMENT,
        id_paciente INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        hora_inicio TEXT NOT NULL,
        hora_fin TEXT NOT NULL,
        estado TEXT NOT NULL,
        creada_por INTEGER NOT NULL,
        fecha_creacion TEXT NOT NULL,
        FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente),
        FOREIGN KEY (creada_por) REFERENCES usuario (id_usuario)
      )
    ''');

    // 4. Tabla Historial Cita
    await db.execute('''
      CREATE TABLE historial_cita (
        id_historial INTEGER PRIMARY KEY AUTOINCREMENT,
        id_cita INTEGER NOT NULL,
        estado TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        fecha_evento TEXT NOT NULL,
        id_usuario INTEGER NOT NULL,
        FOREIGN KEY (id_cita) REFERENCES cita (id_cita),
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      )
    ''');

    // 5. Tabla Horario Atencion (Con las pausas que pueden ser nulas)
    await db.execute('''
      CREATE TABLE horario_atencion (
        id_horario INTEGER PRIMARY KEY AUTOINCREMENT,
        dias_atencion TEXT NOT NULL,
        hora_inicio TEXT NOT NULL,
        hora_fin TEXT NOT NULL,
        duracion_cita INTEGER NOT NULL,
        pausa_inicio TEXT,
        pausa_fin TEXT,
        vigencia_desde TEXT NOT NULL,
        estado TEXT NOT NULL
      )
    ''');

    // 6. Tabla Restriccion Horario
    await db.execute('''
      CREATE TABLE restriccion_horario (
        id_restriccion INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        fecha TEXT NOT NULL,
        hora_inicio TEXT NOT NULL,
        hora_fin TEXT NOT NULL,
        estado TEXT NOT NULL
      )
    ''');

    // 7. Tabla Alerta
    await db.execute('''
      CREATE TABLE alerta (
        id_alerta INTEGER PRIMARY KEY AUTOINCREMENT,
        id_cita INTEGER NOT NULL,
        tipo_alerta TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        estado TEXT NOT NULL,
        fecha_generacion TEXT NOT NULL,
        FOREIGN KEY (id_cita) REFERENCES cita (id_cita)
      )
    ''');
  }
}
