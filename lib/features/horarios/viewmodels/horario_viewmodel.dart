import 'package:flutter/material.dart';
import '../models/horario_model.dart';
import '../repositories/horario_repository.dart';

class HorarioViewModel extends ChangeNotifier {
  final HorarioRepository _repository = HorarioRepository();

  // ─────────────────────────────────────────
  // ESTADO
  // ─────────────────────────────────────────

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // ─────────────────────────────────────────
  // CARGAR horario activo
  // Devuelve null si no hay ninguno guardado aún
  // ─────────────────────────────────────────

  Future<HorarioAtencion?> cargarHorario() async {
    _setLoading(true);
    try {
      final horario = await _repository.obtenerHorarioActivo();
      _errorMessage = null;
      _setLoading(false);
      return horario;
    } catch (e) {
      _errorMessage = 'Error al cargar horario: $e';
      _setLoading(false);
      return null;
    }
  }

  // ─────────────────────────────────────────
  // GUARDAR — valida y hace upsert
  // ─────────────────────────────────────────

  Future<bool> guardarHorario({
    required List<String> diasSeleccionados,
    required String horaInicio,
    required String horaFin,
    required int duracionCita,
    String? pausaInicio,
    String? pausaFin,
    required DateTime vigenciaDesde,
  }) async {
    _clearMessages();

    // ── Validaciones ──
    final error = _validar(
      dias: diasSeleccionados,
      horaInicio: horaInicio,
      horaFin: horaFin,
      duracionCita: duracionCita,
      pausaInicio: pausaInicio,
      pausaFin: pausaFin,
    );
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      final horario = HorarioAtencion(
        idHorario: 0,
        diasAtencion: diasSeleccionados.join(','),
        horaInicio: horaInicio,
        horaFin: horaFin,
        duracionCita: duracionCita,
        pausaInicio: pausaInicio,
        pausaFin: pausaFin,
        vigenciaDesde: vigenciaDesde,
        estado: 'A',
      );

      await _repository.guardarHorario(horario);
      _successMessage = 'Horario guardado correctamente.';
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Error al guardar horario: $e';
      _setLoading(false);
      return false;
    }
  }

  // ─────────────────────────────────────────
  // VALIDACIONES
  // ─────────────────────────────────────────

  String? _validar({
    required List<String> dias,
    required String horaInicio,
    required String horaFin,
    required int duracionCita,
    String? pausaInicio,
    String? pausaFin,
  }) {
    if (dias.isEmpty) return 'Selecciona al menos un día de atención.';

    final inicio = _horaAMinutos(horaInicio);
    final fin = _horaAMinutos(horaFin);

    if (inicio >= fin) return 'La hora de fin debe ser mayor a la hora de inicio.';
    if (duracionCita <= 0) return 'La duración de la cita debe ser mayor a 0.';

    final minutosDisponibles = fin - inicio;
    if (duracionCita > minutosDisponibles) {
      return 'La duración de la cita excede la jornada laboral.';
    }

    // Validar pausa solo si alguno está definido
    final tienePausa = pausaInicio != null && pausaInicio.isNotEmpty &&
                       pausaFin != null && pausaFin.isNotEmpty;
    if (tienePausa) {
      final pInicio = _horaAMinutos(pausaInicio!);
      final pFin = _horaAMinutos(pausaFin!);
      if (pInicio >= pFin) return 'La hora de fin de pausa debe ser mayor al inicio.';
      if (pInicio < inicio || pFin > fin) {
        return 'La pausa debe estar dentro de la jornada laboral.';
      }
    }

    return null;
  }

  int _horaAMinutos(String hora) {
    final p = hora.split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}