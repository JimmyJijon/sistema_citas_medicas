import '../../../core/database/database_helper.dart';
import '../models/cita_model.dart';
import '../models/historial_cita_model.dart';
import '../../pacientes/models/paciente_model.dart';
import '../../alertas/models/alerta_model.dart';

class CitaRepository {
  final _dbHelper = DatabaseHelper.instance;

  Future<List<PacienteModel>> obtenerPacientesActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('paciente', where: 'estado = ?', whereArgs: ['Activo']);
    return maps.map((m) => PacienteModel.fromMap(m)).toList();
  }

  Future<int> insertarCita(Cita cita) async {
    final db = await _dbHelper.database;
    final map = cita.toJson()..remove('id_cita');
    return await db.insert('cita', map);
  }

  // Verifica si el paciente ya tiene una cita en estado activo
  Future<bool> tieneCitaActiva(int idPaciente) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'cita',
      where: 'id_paciente = ? AND estado IN (?, ?, ?)',
      whereArgs: [idPaciente, 'Ingresada', 'Confirmada', 'Reagendada'],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> obtenerTodasLasCitas() async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT c.id_cita, c.id_paciente,
        p.nombres || ' ' || p.apellidos AS nombre_paciente,
        p.cedula, c.fecha, c.hora_inicio, c.hora_fin,
        c.estado, c.creada_por, c.fecha_creacion
      FROM cita c
      INNER JOIN paciente p ON c.id_paciente = p.id_paciente
      ORDER BY c.fecha DESC, c.hora_inicio ASC
    ''');
  }

  Future<Cita?> obtenerCitaPorId(int idCita) async {
    final db = await _dbHelper.database;
    final maps = await db.query('cita', where: 'id_cita = ?', whereArgs: [idCita]);
    if (maps.isEmpty) return null;
    return Cita.fromJson(maps.first);
  }

  Future<List<Map<String, dynamic>>> obtenerCitasPorFecha(DateTime fecha) async {
    final db = await _dbHelper.database;
    final fechaStr = fecha.toIso8601String().split('T')[0];
    return await db.rawQuery('''
      SELECT c.id_cita, c.id_paciente,
        p.nombres || ' ' || p.apellidos AS nombre_paciente,
        p.cedula, c.fecha, c.hora_inicio, c.hora_fin,
        c.estado, c.creada_por, c.fecha_creacion
      FROM cita c
      INNER JOIN paciente p ON c.id_paciente = p.id_paciente
      WHERE c.fecha = ?
      ORDER BY c.hora_inicio ASC
    ''', [fechaStr]);
  }

  // Horas ocupadas de un día — para excluir franjas al registrar
  Future<List<String>> obtenerHorasOcupadasPorFecha(String fechaStr) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'cita',
      columns: ['hora_inicio'],
      where: "fecha = ? AND estado NOT IN ('Cancelada', 'Completada')",
      whereArgs: [fechaStr],
    );
    return maps.map((m) => m['hora_inicio'] as String).toList();
  }

  Future<int> actualizarCita(Cita cita) async {
    final db = await _dbHelper.database;
    return await db.update('cita', cita.toJson(), where: 'id_cita = ?', whereArgs: [cita.idCita]);
  }

  Future<int> actualizarEstadoCita(int idCita, String nuevoEstado) async {
    final db = await _dbHelper.database;
    return await db.update('cita', {'estado': nuevoEstado}, where: 'id_cita = ?', whereArgs: [idCita]);
  }

  Future<int> eliminarCita(int idCita) async {
    final db = await _dbHelper.database;
    return await db.delete('cita', where: 'id_cita = ?', whereArgs: [idCita]);
  }

  Future<List<Map<String, dynamic>>> obtenerHistorialPorCita(int idCita) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT h.id_historial, h.id_cita, h.estado, h.descripcion,
        h.fecha_evento, h.id_usuario,
        u.nombre || ' ' || u.apellido AS nombre_usuario, u.rol
      FROM historial_cita h
      INNER JOIN usuario u ON h.id_usuario = u.id_usuario
      WHERE h.id_cita = ?
      ORDER BY h.fecha_evento DESC
    ''', [idCita]);
  }

  Future<int> insertarHistorial(HistorialCita historial) async {
    final db = await _dbHelper.database;
    final map = historial.toJson()..remove('id_historial');
    return await db.insert('historial_cita', map);
  }

  // ─────────────────────────────────────────
  // ALERTA — Insertar alerta asociada a una cita
  // ─────────────────────────────────────────

  Future<void> insertarAlertaDeCita({
    required int idCita,
    required String tipoAlerta,
    required String descripcion,
  }) async {
    final db = await _dbHelper.database;
    await db.insert('alerta', {
      'id_cita': idCita,
      'tipo_alerta': tipoAlerta,
      'descripcion': descripcion,
      'estado': 'Pendiente',
      'fecha_generacion': DateTime.now().toIso8601String(),
    });
  }

}