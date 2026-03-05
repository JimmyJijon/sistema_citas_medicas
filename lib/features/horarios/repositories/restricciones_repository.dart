import '../models/restriccion_horario_model.dart';
import '../../../core/database/database_helper.dart'; 

class RestriccionesRepository {
  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'restriccion_horario';

  Future<int> insertar(RestriccionHorario r) async {
    final db = await _dbHelper.database;
    // Usamos toJson() que ya configuraste con los nombres id_restriccion, etc.
    return await db.insert(_tableName, r.toJson());
  }

  Future<List<RestriccionHorario>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    // Usamos fromJson() para reconstruir el objeto
    return maps.map((e) => RestriccionHorario.fromJson(e)).toList();
  }

  Future<int> actualizar(RestriccionHorario r) async {
    final db = await _dbHelper.database;
    return await db.update(
      _tableName,
      r.toJson(),
      where: 'id_restriccion = ?',
      whereArgs: [r.idRestriccion],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(_tableName, where: 'id_restriccion = ?', whereArgs: [id]);
  }
}