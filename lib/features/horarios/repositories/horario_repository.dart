import '../../../core/database/database_helper.dart';
import '../models/horario_model.dart';

class HorarioRepository {
  final _dbHelper = DatabaseHelper.instance;

  // ─────────────────────────────────────────
  // READ — Obtener horario activo
  // ─────────────────────────────────────────

  Future<HorarioAtencion?> obtenerHorarioActivo() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'horario_atencion',
      where: 'estado = ?',
      whereArgs: ['A'],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return HorarioAtencion.fromJson(maps.first);
  }

  // ─────────────────────────────────────────
  // SAVE — Upsert: actualiza si existe, inserta si no
  // ─────────────────────────────────────────

  Future<void> guardarHorario(HorarioAtencion horario) async {
    final db = await _dbHelper.database;

    final existente = await db.query(
      'horario_atencion',
      where: 'estado = ?',
      whereArgs: ['A'],
      limit: 1,
    );

    final map = horario.toJson()..remove('id_horario');

    if (existente.isEmpty) {
      // Primer uso: insertar
      await db.insert('horario_atencion', {...map, 'estado': 'A'});
    } else {
      // Ya existe: actualizar
      final idExistente = existente.first['id_horario'] as int;
      await db.update(
        'horario_atencion',
        map,
        where: 'id_horario = ?',
        whereArgs: [idExistente],
      );
    }
  }
}