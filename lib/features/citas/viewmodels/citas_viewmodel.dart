import 'package:flutter/material.dart';
import '../models/cita_model.dart';
import '../models/historial_cita_model.dart';
import '../repositories/CitaRepository.dart';
import '../../pacientes/models/paciente_model.dart';
import '../../horarios/repositories/horario_repository.dart';
import '../../horarios/models/horario_model.dart';
import '../../horarios/repositories/restricciones_repository.dart';

class CitaViewModel extends ChangeNotifier {
  final CitaRepository _repository = CitaRepository();
  final HorarioRepository _horarioRepository = HorarioRepository();
  final RestriccionesRepository _restriccionesRepository = RestriccionesRepository();

  // ─────────────────────────────────────────
  // ESTADO — Registro
  // ─────────────────────────────────────────
  List<PacienteModel> _todosLosPacientes = [];
  List<PacienteModel> _pacientesFiltrados = [];
  List<String> _franjasHorarias = [];
  HorarioAtencion? _horarioActivo;
  String? _mensajeFranjas; // mensaje cuando no hay horario o día no laborable

  String? get mensajeFranjas => _mensajeFranjas;
  PacienteModel? _pacienteSeleccionado;
  DateTime _fechaSeleccionada = DateTime.now();
  String? _horaSeleccionada;
  String _observacion = '';
  String _estadoCita = 'Ingresada';

  // ─────────────────────────────────────────
  // ESTADO — Agenda
  // ─────────────────────────────────────────
  List<Map<String, dynamic>> _todasLasCitas = [];
  List<Map<String, dynamic>> _citasFiltradas = [];
  DateTime _filtroDesde = DateTime.now();
  DateTime _filtroHasta = DateTime.now().add(const Duration(days: 7));
  // Set vacío = mostrar todos; con valores = mostrar solo los marcados
  Set<String> _filtroEstados = {};
  String _filtroPaciente = '';

  // ─────────────────────────────────────────
  // ESTADO — Detalle / Historial
  // ─────────────────────────────────────────
  Map<String, dynamic>? _citaSeleccionada;
  List<Map<String, dynamic>> _historialCita = [];
  bool _isLoadingHistorial = false;

  // ─────────────────────────────────────────
  // ESTADO — General
  // ─────────────────────────────────────────
  bool _isLoading = false;
  String? _errorMessage;

  // ─────────────────────────────────────────
  // GETTERS — Registro
  // ─────────────────────────────────────────
  List<PacienteModel> get pacientesFiltrados => _pacientesFiltrados;
  List<String> get franjasHorarias => _franjasHorarias;
  PacienteModel? get pacienteSeleccionado => _pacienteSeleccionado;
  DateTime get fechaSeleccionada => _fechaSeleccionada;
  String? get horaSeleccionada => _horaSeleccionada;
  String get observacion => _observacion;
  String get estadoCita => _estadoCita;
  bool get formularioValido =>
      _pacienteSeleccionado != null && _horaSeleccionada != null;

  // ─────────────────────────────────────────
  // GETTERS — Agenda
  // ─────────────────────────────────────────
  List<Map<String, dynamic>> get citasFiltradas => _citasFiltradas;
  DateTime get filtroDesde => _filtroDesde;
  DateTime get filtroHasta => _filtroHasta;
  Set<String> get filtroEstados => _filtroEstados;

  // ─────────────────────────────────────────
  // GETTERS — Detalle / Historial
  // ─────────────────────────────────────────
  Map<String, dynamic>? get citaSeleccionada => _citaSeleccionada;
  List<Map<String, dynamic>> get historialCita => _historialCita;
  bool get isLoadingHistorial => _isLoadingHistorial;

  // ─────────────────────────────────────────
  // GETTERS — General
  // ─────────────────────────────────────────
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ─────────────────────────────────────────
  // REGISTRO
  // ─────────────────────────────────────────

  Future<void> inicializarRegistro() async {
    _setLoading(true);
    try {
      _todosLosPacientes = await _repository.obtenerPacientesActivos();
      _pacientesFiltrados = _todosLosPacientes;
      // Cargar horario activo una sola vez
      _horarioActivo = await _horarioRepository.obtenerHorarioActivo();
      // Generar franjas para la fecha inicial
      await _generarFranjasParaFecha(_fechaSeleccionada);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar datos: $e';
    }
    _setLoading(false);
  }

  void filtrarPacientes(String query) {
    _pacientesFiltrados = query.isEmpty
        ? _todosLosPacientes
        : _todosLosPacientes.where((p) {
            final nombre = "${p.nombres} ${p.apellidos}".toLowerCase();
            return nombre.contains(query.toLowerCase()) ||
                p.cedula.contains(query);
          }).toList();
    notifyListeners();
  }

  void setPaciente(PacienteModel? p) {
    _pacienteSeleccionado = p;
    notifyListeners();
  }

  Future<void> setFecha(DateTime fecha) async {
    _fechaSeleccionada = fecha;
    _horaSeleccionada = null;
    await _generarFranjasParaFecha(fecha);
  }

  void setHora(String hora) {
    _horaSeleccionada = hora;
    notifyListeners();
  }

  void setObservacion(String texto) {
    _observacion = texto;
  }

  void setEstado(String estado) {
    _estadoCita = estado;
    notifyListeners();
  }

  Future<bool> guardarCita(int idUsuarioActual) async {
    if (!formularioValido) return false;
    _setLoading(true);
    try {
      // Validar que el paciente no tenga ya una cita activa
      final tieneCitaActiva = await _repository.tieneCitaActiva(
        _pacienteSeleccionado!.idPaciente!,
      );
      if (tieneCitaActiva) {
        _errorMessage =
            'El paciente ya tiene una cita activa (Ingresada, Confirmada o Reagendada). '
            'Debe completar, cancelar o reagendar la cita existente antes de crear una nueva.';
        _setLoading(false);
        return false;
      }
      final nuevaCita = Cita(
        idCita: 0,
        idPaciente: _pacienteSeleccionado!.idPaciente!,
        fecha: _fechaSeleccionada,
        horaInicio: _horaSeleccionada!,
        horaFin: _calcularHoraFin(_horaSeleccionada!),
        estado: _estadoCita,
        creadaPor: idUsuarioActual,
        fechaCreacion: DateTime.now(),
      );

      // 1. Insertar la cita y obtener el ID generado
      final idCitaNueva = await _repository.insertarCita(nuevaCita);

      if (idCitaNueva > 0) {
        // 2. Insertar en historial con la observación del usuario
        final descripcion = _observacion.isNotEmpty
            ? _observacion
            : 'Cita creada en estado: $_estadoCita';

        await _repository.insertarHistorial(HistorialCita(
          idHistorial: 0,
          idCita: idCitaNueva,
          estado: _estadoCita,
          descripcion: descripcion,
          fechaEvento: DateTime.now(),
          idUsuario: idUsuarioActual,
        ));

        // 3. Insertar alerta de cita creada
        await _repository.insertarAlertaDeCita(
          idCita: idCitaNueva,
          tipoAlerta: 'Creada',
          descripcion: 'Nueva cita registrada en estado: $_estadoCita.',
        );

        _limpiarFormulario();
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _errorMessage = 'Error al guardar la cita: $e';
    }
    _setLoading(false);
    return false;
  }

  // ─────────────────────────────────────────
  // AGENDA
  // ─────────────────────────────────────────

  Future<void> cargarCitas() async {
    _setLoading(true);
    try {
      _todasLasCitas = await _repository.obtenerTodasLasCitas();
      _aplicarFiltros();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar citas: $e';
    }
    _setLoading(false);
  }

  void setFiltroDesde(DateTime fecha) {
    _filtroDesde = fecha;
    _aplicarFiltros();
  }

  void setFiltroHasta(DateTime fecha) {
    _filtroHasta = fecha;
    _aplicarFiltros();
  }

  void toggleFiltroEstado(String estado) {
    if (_filtroEstados.contains(estado)) {
      _filtroEstados.remove(estado);
    } else {
      _filtroEstados.add(estado);
    }
    _aplicarFiltros();
  }

  void setFiltroPaciente(String query) {
    _filtroPaciente = query.toLowerCase();
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    _citasFiltradas = _todasLasCitas.where((cita) {
      final fechaCita = DateTime.parse(cita['fecha']);
      final desde = DateTime(_filtroDesde.year, _filtroDesde.month, _filtroDesde.day);
      final hasta = DateTime(_filtroHasta.year, _filtroHasta.month, _filtroHasta.day);
      final fecha = DateTime(fechaCita.year, fechaCita.month, fechaCita.day);

      if (fecha.isBefore(desde) || fecha.isAfter(hasta)) return false;
      // Filtro estados — si el set está vacío muestra todos
      if (_filtroEstados.isNotEmpty && !_filtroEstados.contains(cita['estado'])) return false;
      if (_filtroPaciente.isNotEmpty) {
        final nombre = (cita['nombre_paciente'] ?? '').toLowerCase();
        final cedula = (cita['cedula'] ?? '').toLowerCase();
        if (!nombre.contains(_filtroPaciente) && !cedula.contains(_filtroPaciente)) {
          return false;
        }
      }
      return true;
    }).toList();
    notifyListeners();
  }

  // ─────────────────────────────────────────
  // DETALLE / HISTORIAL
  // ─────────────────────────────────────────

  Future<void> setCitaSeleccionada(Map<String, dynamic> cita) async {
    _citaSeleccionada = cita;
    notifyListeners();
    await _cargarHistorial(cita['id_cita'] as int);
  }

  Future<void> _cargarHistorial(int idCita) async {
    _isLoadingHistorial = true;
    notifyListeners();
    try {
      _historialCita = await _repository.obtenerHistorialPorCita(idCita);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar historial: $e';
    }
    _isLoadingHistorial = false;
    notifyListeners();
  }

  // Reagenda: actualiza fecha + hora + estado + inserta en historial
  Future<bool> reagendarCita({
    required DateTime nuevaFecha,
    required String nuevaHoraInicio,
    required int idUsuario,
    required String motivo,
  }) async {
    if (_citaSeleccionada == null) return false;
    final idCita = _citaSeleccionada!['id_cita'] as int;

    try {
      // ── Validar día laborable ──
      if (_horarioActivo != null) {
        final diasMap = {'1': 'L', '2': 'M', '3': 'X', '4': 'J', '5': 'V', '6': 'S', '7': 'D'};
        final diaSemana = diasMap[nuevaFecha.weekday.toString()]!;
        final diasLaborables = _horarioActivo!.diasAtencion.split(',');

        if (!diasLaborables.contains(diaSemana)) {
          _errorMessage = 'El día seleccionado no es laborable según la configuración de horario.';
          notifyListeners();
          return false;
        }

        // ── Validar que la hora esté dentro de la jornada ──
        final horaMin   = _horaAMinutos(nuevaHoraInicio);
        final inicioMin = _horaAMinutos(_horarioActivo!.horaInicio);
        final finMin    = _horaAMinutos(_horarioActivo!.horaFin);

        if (horaMin < inicioMin || horaMin + 20 > finMin) {
          _errorMessage = 'La franja seleccionada está fuera del horario laboral.';
          notifyListeners();
          return false;
        }

        // ── Validar pausa ──
        final pausaI = _horarioActivo!.pausaInicio != null && _horarioActivo!.pausaInicio!.isNotEmpty
            ? _horaAMinutos(_horarioActivo!.pausaInicio!)
            : null;
        final pausaF = _horarioActivo!.pausaFin != null && _horarioActivo!.pausaFin!.isNotEmpty
            ? _horaAMinutos(_horarioActivo!.pausaFin!)
            : null;

        if (pausaI != null && pausaF != null) {
          if (horaMin >= pausaI && horaMin < pausaF) {
            _errorMessage = 'La franja seleccionada cae dentro del horario de pausa.';
            notifyListeners();
            return false;
          }
        }

        // ── Validar restricciones del día ──
        final fechaStr = '${nuevaFecha.year}-'
            '${nuevaFecha.month.toString().padLeft(2, '0')}-'
            '${nuevaFecha.day.toString().padLeft(2, '0')}';
        final restricciones = await _restriccionesRepository.obtenerPorFecha(fechaStr);

        for (final r in restricciones) {
          final rI = _horaAMinutos(r.horaInicio);
          final rF = _horaAMinutos(r.horaFin);
          if (horaMin < rF && horaMin + 20 > rI) {
            _errorMessage = 'La franja seleccionada está bloqueada por una restriccion: ${r.tipo}.';
            notifyListeners();
            return false;
          }
        }
      }
      // Calcular nueva hora fin
      final horaFin = _calcularHoraFin(nuevaHoraInicio);

      // Obtener la cita original para reconstruir el objeto completo
      final citaOriginal = await _repository.obtenerCitaPorId(idCita);
      if (citaOriginal == null) return false;

      // Actualizar cita con nueva fecha y franja
      final citaActualizada = Cita(
        idCita: citaOriginal.idCita,
        idPaciente: citaOriginal.idPaciente,
        fecha: nuevaFecha,
        horaInicio: nuevaHoraInicio,
        horaFin: horaFin,
        estado: 'Reagendada',
        creadaPor: citaOriginal.creadaPor,
        fechaCreacion: citaOriginal.fechaCreacion,
      );
      await _repository.actualizarCita(citaActualizada);

      // Insertar en historial
      await _repository.insertarHistorial(HistorialCita(
        idHistorial: 0,
        idCita: idCita,
        estado: 'Reagendada',
        descripcion: motivo,
        fechaEvento: DateTime.now(),
        idUsuario: idUsuario,
      ));

      // Alerta de reagendamiento
      await _repository.insertarAlertaDeCita(
        idCita: idCita,
        tipoAlerta: 'Reagendada',
        descripcion: motivo,
      );

      // Refrescar estado local
      _citaSeleccionada = {
        ..._citaSeleccionada!,
        'fecha': nuevaFecha.toIso8601String().split('T')[0],
        'hora_inicio': nuevaHoraInicio,
        'hora_fin': horaFin,
        'estado': 'Reagendada',
      };
      await _cargarHistorial(idCita);
      return true;
    } catch (e) {
      _errorMessage = 'Error al reagendar la cita: $e';
      return false;
    }
  }

  // Actualiza estado + inserta en historial en una sola operación
  Future<bool> registrarAccionEnHistorial({
    required int idUsuario,
    required String nuevoEstado,
    required String descripcion,
  }) async {
    if (_citaSeleccionada == null) return false;
    final idCita = _citaSeleccionada!['id_cita'] as int;
    try {
      await _repository.actualizarEstadoCita(idCita, nuevoEstado);
      await _repository.insertarHistorial(HistorialCita(
        idHistorial: 0,
        idCita: idCita,
        estado: nuevoEstado,
        descripcion: descripcion,
        fechaEvento: DateTime.now(),
        idUsuario: idUsuario,
      ));

      // Alerta de la acción
      await _repository.insertarAlertaDeCita(
        idCita: idCita,
        tipoAlerta: nuevoEstado, // 'Cancelada' o 'Completada'
        descripcion: descripcion,
      );
      // Refrescar estado local sin ir de nuevo a BD
      _citaSeleccionada = {..._citaSeleccionada!, 'estado': nuevoEstado};
      await _cargarHistorial(idCita);
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrar acción: $e';
      return false;
    }
  }

  // ─────────────────────────────────────────
  // HELPERS PRIVADOS
  // ─────────────────────────────────────────

  // Genera franjas válidas para una fecha considerando:
  // 1. Horario laboral configurado
  // 2. Día de la semana permitido
  // 3. Restricciones activas del día (feriados, reuniones, etc.)
  // 4. Franjas ya ocupadas por citas existentes
  Future<void> _generarFranjasParaFecha(DateTime fecha) async {
    _franjasHorarias.clear();
    _mensajeFranjas = null;

    // Sin horario configurado — fallback al horario por defecto
    if (_horarioActivo == null) {
      _generarFranjasDe20Minutos('08:00', '17:00');
      notifyListeners();
      return;
    }

    final horario = _horarioActivo!;

    // Verificar que el día de la semana esté en los días laborables
    final diasMap = {'1': 'L', '2': 'M', '3': 'X', '4': 'J', '5': 'V', '6': 'S', '7': 'D'};
    final diaSemana = diasMap[fecha.weekday.toString()]!;
    final diasLaborables = horario.diasAtencion.split(',');

    if (!diasLaborables.contains(diaSemana)) {
      _mensajeFranjas = 'Este día no es laborable según la configuración de horario.';
      notifyListeners();
      return;
    }

    // Generar todas las franjas base de la jornada
    final franjasCandidatas = <String>[];
    final inicio = _horaAMinutos(horario.horaInicio);
    final fin    = _horaAMinutos(horario.horaFin);
    final pausaI = horario.pausaInicio != null && horario.pausaInicio!.isNotEmpty
        ? _horaAMinutos(horario.pausaInicio!)
        : null;
    final pausaF = horario.pausaFin != null && horario.pausaFin!.isNotEmpty
        ? _horaAMinutos(horario.pausaFin!)
        : null;

    for (int t = inicio; t + 20 <= fin; t += 20) {
      // Excluir franja si cae dentro de la pausa
      if (pausaI != null && pausaF != null) {
        if (t >= pausaI && t < pausaF) continue;
      }
      franjasCandidatas.add(_minutosAHora(t));
    }

    // Obtener restricciones activas para esta fecha
    final fechaStr = '${fecha.year}-'
        '${fecha.month.toString().padLeft(2, '0')}-'
        '${fecha.day.toString().padLeft(2, '0')}';

    final restricciones = await _restriccionesRepository.obtenerPorFecha(fechaStr);

    // Verificar si hay una restricción que bloquea TODO el día
    final diaCompleto = restricciones.where((r) =>
        r.horaInicio == horario.horaInicio && r.horaFin == horario.horaFin).toList();

    if (diaCompleto.isNotEmpty) {
      _mensajeFranjas = 'No hay disponibilidad este día: ${diaCompleto.first.tipo}.';
      notifyListeners();
      return;
    }

    // Filtrar franjas bloqueadas por restricciones parciales
    final franjasLibres = franjasCandidatas.where((franja) {
      final franjaMin = _horaAMinutos(franja);
      final franjaFinMin = franjaMin + 20;
      for (final r in restricciones) {
        final rI = _horaAMinutos(r.horaInicio);
        final rF = _horaAMinutos(r.horaFin);
        // Bloquear si la franja se superpone con la restricción
        if (franjaMin < rF && franjaFinMin > rI) return false;
      }
      return true;
    }).toList();

    // Filtrar franjas ya ocupadas por citas del mismo día
    final horasOcupadas = (await _repository.obtenerHorasOcupadasPorFecha(fechaStr)).toSet();

    _franjasHorarias = franjasLibres
        .where((f) => !horasOcupadas.contains(f))
        .toList();

    if (_franjasHorarias.isEmpty) {
      _mensajeFranjas = 'No hay franjas disponibles para este día.';
    }

    notifyListeners();
  }

  void _generarFranjasDe20Minutos(String inicioStr, String finStr) {
    _franjasHorarias.clear();
    final inicio = _horaAMinutos(inicioStr);
    final fin = _horaAMinutos(finStr);
    for (int t = inicio; t < fin; t += 20) {
      _franjasHorarias.add(_minutosAHora(t));
    }
  }

  String _calcularHoraFin(String horaInicio) =>
      _minutosAHora(_horaAMinutos(horaInicio) + 20);

  int _horaAMinutos(String hora) {
    final p = hora.split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  String _minutosAHora(int minutos) =>
      "${(minutos ~/ 60).toString().padLeft(2, '0')}:${(minutos % 60).toString().padLeft(2, '0')}";

  void _limpiarFormulario() {
    _pacienteSeleccionado = null;
    _fechaSeleccionada = DateTime.now();
    _horaSeleccionada = null;
    _observacion = '';
    _estadoCita = 'Ingresada';
    _pacientesFiltrados = _todosLosPacientes;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}