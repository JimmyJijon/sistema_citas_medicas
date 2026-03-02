import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart'; 
import '../models/paciente_model.dart';

class PacientesRepository {
  // Instanciamos la conexión a tu base de datos SQLite
  final dbHelper = DatabaseHelper.instance;

  // --- CREATE ---
  Future<int> insertPaciente(PacienteModel paciente) async {
    final db = await dbHelper.database;
    return await db.insert('paciente', paciente.toMap());
  }

  // --- READ ---
  Future<List<PacienteModel>> getPacientes() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('paciente');
    
    return List.generate(maps.length, (i) => PacienteModel.fromMap(maps[i]));
  }

  // --- UPDATE ---
  Future<int> updatePaciente(PacienteModel paciente) async {
    final db = await dbHelper.database;
    return await db.update(
      'paciente',
      paciente.toMap(),
      where: 'id_paciente = ?',
      whereArgs: [paciente.idPaciente],
    );
  }

  // --- DELETE ---
  Future<int> deletePaciente(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'paciente',
      where: 'id_paciente = ?',
      whereArgs: [id],
    );
  }
}