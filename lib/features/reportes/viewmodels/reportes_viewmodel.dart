import 'package:flutter/material.dart';
// import 'package:sistema_citas_medicas/core/database/database_helper.dart'; // Comentado temporalmente si te da error de que no existe aún

class ReportesViewModel extends ChangeNotifier {
  DateTime _desdeDateTime = DateTime.now();
  DateTime _hastaDateTime = DateTime.now();

  // Estadísticas del reporte
  int totalCitas = 0;
  int completadas = 0;
  int canceladas = 0;
  int reagendadas = 0;
  int enEspera = 0;
  int noAtendidas = 0;

  bool isLoading = false; // Para mostrar un indicador de carga si es necesario

  DateTime get desdeDateTime => _desdeDateTime;
  DateTime get hastaDateTime => _hastaDateTime;

  // --- FORMATEO VISUAL (Para los botones) ---
  String formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$day/$month/$year $hour:$minute";
  }

  // --- FORMATEO PARA BASE DE DATOS (YYYY-MM-DD) ---
  String _formatForDB(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    return "$year-$month-$day";
  }

  void setDesdeDateTime(DateTime newDate) {
    _desdeDateTime = newDate;
    notifyListeners();
  }

  void setHastaDateTime(DateTime newDate) {
    _hastaDateTime = newDate;
    notifyListeners();
  }

  // --- LÓGICA DE BASE DE DATOS ---
  Future<void> generarReporte() async {
    isLoading = true;
    notifyListeners();

    // Simulamos un pequeño retraso para que veas el indicador de carga (opcional)
    await Future.delayed(const Duration(seconds: 1));

    try {
      // =========================================================
      // TODO: DESCOMENTAR ESTO CUANDO LA BD FUNCIONE Y BORRAR EL MOCK
      /*
      final db = await DatabaseHelper.instance.database;
      
      String fechaDesdeStr = _formatForDB(_desdeDateTime);
      String fechaHastaStr = _formatForDB(_hastaDateTime);

      final List<Map<String, dynamic>> resultados = await db.rawQuery('''
        SELECT estado, COUNT(*) as cantidad
        FROM cita
        WHERE fecha >= ? AND fecha <= ?
        GROUP BY estado
      ''', [fechaDesdeStr, fechaHastaStr]);
      */
      // =========================================================

      // =========================================================
      // DATOS MOCK: Simulamos lo que respondería SQLite
      // =========================================================
      final List<Map<String, dynamic>> resultados = [
        {'estado': 'completada', 'cantidad': 15},
        {'estado': 'cancelada', 'cantidad': 3},
        {'estado': 'reagendada', 'cantidad': 2},
        {'estado': 'en espera', 'cantidad': 8},
        {'estado': 'no atendida', 'cantidad': 1},
      ];

      // Reiniciamos contadores
      totalCitas = 0;
      completadas = 0;
      canceladas = 0;
      reagendadas = 0;
      enEspera = 0;
      noAtendidas = 0;

      // Procesamos los resultados de la BD (¡Tu lógica intacta!)
      for (var fila in resultados) {
        String estado = fila['estado'].toString().toLowerCase();
        int cantidad = fila['cantidad'] as int;

        totalCitas += cantidad;

        switch (estado) {
          case 'completada':
            completadas = cantidad;
            break;
          case 'cancelada':
            canceladas = cantidad;
            break;
          case 'reagendada':
            reagendadas = cantidad;
            break;
          case 'en espera':
            enEspera = cantidad;
            break;
          case 'no atendida':
            noAtendidas = cantidad;
            break;
        }
      }
    } catch (e) {
      debugPrint("Error al generar reporte: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // Avisamos a la pantalla que ya tenemos los datos
    }
  }

  // --- NUEVAS VARIABLES PARA EL LISTADO ---
  List<Map<String, dynamic>> _listadoCitasDetalle = [];
  List<Map<String, dynamic>> get listadoCitasDetalle => _listadoCitasDetalle;

  

  // --- NUEVA FUNCIÓN PARA EL BOTÓN "VER LISTADO" ---
  Future<void> cargarListadoDetalle() async {
    isLoading = true;
    notifyListeners();

    // Simulamos que la base de datos está buscando
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // =========================================================
      // TODO: DESCOMENTAR CUANDO LA BD FUNCIONE Y BORRAR EL MOCK
      /*
      final db = await DatabaseHelper.instance.database;
      String fechaDesdeStr = _formatForDB(_desdeDateTime);
      String fechaHastaStr = _formatForDB(_hastaDateTime);

      // Aquí pedimos TODOS los datos (SELECT *), no solo el COUNT
      _listadoCitasDetalle = await db.rawQuery('''
        SELECT *
        FROM cita
        WHERE fecha >= ? AND fecha <= ?
        ORDER BY fecha DESC, hora DESC
      ''', [fechaDesdeStr, fechaHastaStr]);
      */
      // =========================================================

      // =========================================================
      // DATOS MOCK: Simulamos el detalle de las citas
      // =========================================================
      _listadoCitasDetalle = [
        {'id': 101, 'paciente': 'Juan Pérez', 'fecha': '2026-03-02', 'hora': '09:00', 'estado': 'Completada', 'doctor': 'Dra. García'},
        {'id': 102, 'paciente': 'María López', 'fecha': '2026-03-02', 'hora': '10:30', 'estado': 'Cancelada', 'doctor': 'Dr. Rodríguez'},
        {'id': 103, 'paciente': 'Carlos Ruiz', 'fecha': '2026-03-03', 'hora': '14:00', 'estado': 'En espera', 'doctor': 'Dra. García'},
        {'id': 104, 'paciente': 'Ana Martínez', 'fecha': '2026-03-03', 'hora': '16:15', 'estado': 'Completada', 'doctor': 'Dra. Gómez'},
      ];

    } catch (e) {
      debugPrint("Error al cargar listado: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}