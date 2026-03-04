import 'package:flutter/material.dart';
import '../models/cita_model.dart';
import '../models/historial_cita_model.dart';
import '../repositories/CitaRepository.dart';
import '../../pacientes/models/paciente_model.dart';

class CitaViewModel extends ChangeNotifier {
  final CitaRepository _repository = CitaRepository();

  // ─────────────────────────────────────────
  // ESTADO — Registro
  // ─────────────────────────────────────────
  List<PacienteModel> _todosLosPacientes = [];
  List<PacienteModel> _pacientesFiltrados = [];
  List<String> _franjasHorarias = [];
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
      _generarFranjasDe20Minutos("08:00", "17:00");
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

  void setFecha(DateTime fecha) {
    _fechaSeleccionada = fecha;
    _horaSeleccionada = null;
    notifyListeners();
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