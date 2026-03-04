import '../../../core/database/database_helper.dart';
import '../models/alerta_model.dart';

class AlertRepository {
  final _dbHelper = DatabaseHelper.instance;

  // ─────────────────────────────────────────
  // READ — Todas las alertas con JOIN cita + paciente
  // ─────────────────────────────────────────

  Future<List<Map<String, dynamic>>> obtenerTodasLasAlertas() async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT
        a.id_alerta,
        a.id_cita,
        a.tipo_alerta,
        a.descripcion,
        a.estado AS estado,
        a.fecha_generacion,
        c.fecha,
        c.hora_inicio,
        c.hora_fin,
        c.estado AS estado_cita,
        p.nombres || ' ' || p.apellidos AS nombre_paciente,
        p.cedula
      FROM alerta a
      INNER JOIN cita c ON a.id_cita = c.id_cita
      INNER JOIN paciente p ON c.id_paciente = p.id_paciente
      ORDER BY a.fecha_generacion DESC
    ''');
  }

  // ─────────────────────────────────────────
  // CREATE — Insertar alerta
  // ─────────────────────────────────────────

  Future<int> insertarAlerta(Alerta alerta) async {
    final db = await _dbHelper.database;
    final map = alerta.toJson()..remove('id_alerta');
    return await db.insert('alerta', map);
  }

  // ─────────────────────────────────────────
  // UPDATE — Marcar como leída
  // ─────────────────────────────────────────

  Future<int> marcarLeida(int idAlerta) async {
    final db = await _dbHelper.database;
    return await db.update(
      'alerta',
      {'estado': 'Leída'},
      where: 'id_alerta = ?',
      whereArgs: [idAlerta],
    );
  }

  // ─────────────────────────────────────────
  // GENERACIÓN AUTOMÁTICA — No atendidas
  // Busca citas Ingresadas cuya franja ya pasó
  // y genera alerta si no existe una previa
  // ─────────────────────────────────────────

  Future<void> generarAlertasNoAtendidas() async {
    final db = await _dbHelper.database;
    final ahora = DateTime.now();
    final fechaHoy = "${ahora.year}-${ahora.month.toString().padLeft(2, '0')}-${ahora.day.toString().padLeft(2, '0')}";

    // Citas Ingresadas de hoy o anteriores
    final citas = await db.rawQuery('''
      SELECT id_cita, fecha, hora_fin
      FROM cita
      WHERE estado = 'Ingresada'
        AND fecha <= ?
    ''', [fechaHoy]);

    for (final cita in citas) {
      final idCita = cita['id_cita'] as int;
      final fechaCita = cita['fecha'] as String;
      final horaFin = cita['hora_fin'] as String;

      // Construir datetime completo de fin de franja
      final partes = horaFin.split(':');
      final fechaFinFranja = DateTime(
        int.parse(fechaCita.substring(0, 4)),
        int.parse(fechaCita.substring(5, 7)),
        int.parse(fechaCita.substring(8, 10)),
        int.parse(partes[0]),
        int.parse(partes[1]),
      );

      // Solo si la franja ya terminó
      if (ahora.isAfter(fechaFinFranja)) {
        // Verificar si ya existe alerta de este tipo para esta cita
        final existente = await db.query(
          'alerta',
          where: 'id_cita = ? AND tipo_alerta = ?',
          whereArgs: [idCita, 'No atendida'],
        );

        if (existente.isEmpty) {
          await insertarAlerta(Alerta(
            idAlerta: 0,
            idCita: idCita,
            tipoAlerta: 'No atendida',
            descripcion: 'La cita no fue atendida en la franja asignada.',
            estado: 'Pendiente',
            fechaGeneracion: DateTime.now(),
          ));
        }
      }
    }
  }
}