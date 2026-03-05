import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/database/database_helper.dart';

class ReportesViewModel extends ChangeNotifier {
  DateTime _desdeDateTime = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
  DateTime _hastaDateTime = DateTime.now().copyWith(hour: 23, minute: 59, second: 59);

  // ─────────────────────────────────────────
  // ESTADÍSTICAS
  // ─────────────────────────────────────────
  int totalCitas   = 0;
  int completadas  = 0;
  int canceladas   = 0;
  int reagendadas  = 0;
  int enEspera     = 0;
  int noAtendidas  = 0;

  bool isLoading = false;

  // ─────────────────────────────────────────
  // LISTADO DETALLE
  // ─────────────────────────────────────────
  List<Map<String, dynamic>> _listadoCitasDetalle = [];
  List<Map<String, dynamic>> get listadoCitasDetalle => _listadoCitasDetalle;

  // ─────────────────────────────────────────
  // GETTERS
  // ─────────────────────────────────────────
  DateTime get desdeDateTime => _desdeDateTime;
  DateTime get hastaDateTime => _hastaDateTime;

  // ─────────────────────────────────────────
  // FORMATEO VISUAL
  // ─────────────────────────────────────────
  String formatDateTime(DateTime dt) {
    final day    = dt.day.toString().padLeft(2, '0');
    final month  = dt.month.toString().padLeft(2, '0');
    final year   = dt.year;
    final hour   = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$day/$month/$year $hour:$minute";
  }

  // ─────────────────────────────────────────
  // FORMATEO PARA BD  yyyy-MM-dd HH:mm
  // ─────────────────────────────────────────
  String _formatFecha(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return "${dt.year}-$m-$d";
  }

  String _formatHora(DateTime dt) {
    final h  = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return "$h:$mi";
  }

  void setDesdeDateTime(DateTime v) { _desdeDateTime = v; notifyListeners(); }
  void setHastaDateTime(DateTime v) { _hastaDateTime = v; notifyListeners(); }

  // ─────────────────────────────────────────
  // DETERMINAR ESTADO VISUAL de una fila
  // Considera estados guardados en BD + lógica temporal
  // ─────────────────────────────────────────
  String _estadoVisual(Map<String, dynamic> fila) {
    final estado     = (fila['estado'] ?? '').toString();
    final fechaStr   = fila['fecha']    as String;
    final horaFinStr = fila['hora_fin'] as String;

    // Solo Ingresada tiene lógica temporal — el resto se muestra tal cual
    if (estado != 'Ingresada') return estado;

    final momentoFin = DateTime.tryParse('${fechaStr}T$horaFinStr:00');
    final ahora = DateTime.now();

    if (momentoFin != null && ahora.isAfter(momentoFin)) {
      return 'No atendida'; // Solo visual — no cambia la BD
    }
    return 'En espera';
  }

  // ─────────────────────────────────────────
  // VERIFICAR si la cita está dentro del rango fecha+hora
  // ─────────────────────────────────────────
  bool _dentroDeRango(Map<String, dynamic> fila) {
    final fechaStr      = fila['fecha']      as String; // yyyy-MM-dd
    final horaInicioStr = fila['hora_inicio'] as String; // HH:mm

    final momentoInicio = DateTime.tryParse('${fechaStr}T$horaInicioStr:00');
    if (momentoInicio == null) return false;

    return !momentoInicio.isBefore(_desdeDateTime) &&
           !momentoInicio.isAfter(_hastaDateTime);
  }

  // ─────────────────────────────────────────
  // GENERAR REPORTE
  // ─────────────────────────────────────────
  Future<void> generarReporte() async {
    isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;

      // Traemos todas las citas en el rango de FECHAS (sin filtrar hora aún)
      final resultados = await db.rawQuery('''
        SELECT estado, fecha, hora_inicio, hora_fin
        FROM cita
        WHERE fecha >= ? AND fecha <= ?
      ''', [_formatFecha(_desdeDateTime), _formatFecha(_hastaDateTime)]);

      // Reiniciar contadores
      totalCitas = completadas = canceladas = reagendadas = enEspera = noAtendidas = 0;

      for (final fila in resultados) {
        // Filtrar por hora exacta
        if (!_dentroDeRango(fila)) continue;

        totalCitas++;
        switch (_estadoVisual(fila)) {
          case 'Completada':  completadas++;  break;
          case 'Cancelada':   canceladas++;   break;
          case 'Reagendada':  reagendadas++;  break;
          case 'En espera':   enEspera++;     break;
          case 'No atendida': noAtendidas++;  break;
        }
      }
    } catch (e) {
      debugPrint('Error al generar reporte: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────
  // LISTADO DETALLADO
  // ─────────────────────────────────────────
  Future<void> cargarListadoDetalle() async {
    isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;

      final resultados = await db.rawQuery('''
        SELECT
          c.id_cita,
          c.estado,
          c.fecha,
          c.hora_inicio,
          c.hora_fin,
          (p.nombres || ' ' || p.apellidos) AS nombre_paciente,
          p.cedula,
          u.nombre AS nombre_doctor
        FROM cita c
        LEFT JOIN paciente p ON c.id_paciente = p.id_paciente
        LEFT JOIN usuario u ON c.creada_por = u.id_usuario
        WHERE c.fecha BETWEEN ? AND ?
        ORDER BY c.fecha ASC, c.hora_inicio ASC
      ''', [_formatFecha(_desdeDateTime), _formatFecha(_hastaDateTime)]);

      // Filtrar por hora y enriquecer con estado visual
      _listadoCitasDetalle = resultados
          .where(_dentroDeRango)
          .map((fila) => {
                ...fila,
                'estado_visual': _estadoVisual(fila),
              })
          .toList();

    } catch (e) {
      debugPrint('Error al cargar listado: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}