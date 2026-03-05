import '../models/restriccion_horario_model.dart';
import '../../../core/database/database_helper.dart';

class RestriccionesRepository {
  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'restriccion_horario';

  Future<int> insertar(RestriccionHorario r) async {
    final db = await _dbHelper.database;
    return await db.insert(_tableName, r.toJson());
  }

  Future<List<RestriccionHorario>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(_tableName, orderBy: 'fecha ASC');
    return maps.map((e) => RestriccionHorario.fromJson(e)).toList();
  }

  // Restricciones activas para una fecha específica (formato 'yyyy-MM-dd')
  Future<List<RestriccionHorario>> obtenerPorFecha(String fecha) async {
    final db = await _dbHelper.database;
    // Estado guardado como 'Activa' desde el formulario
    // Fecha comparada con LIKE para cubrir variaciones de formato
    final maps = await db.query(
      _tableName,
      where: "fecha LIKE ? AND estado = ?",
      whereArgs: ['$fecha%', 'Activa'],
    );
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
    return await db.delete(
      _tableName,
      where: 'id_restriccion = ?',
      whereArgs: [id],
    );
  }
}