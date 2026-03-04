import 'package:flutter/material.dart';
import '../repositories/alert_repository.dart';

class AlertViewModel extends ChangeNotifier {
  final AlertRepository _repository = AlertRepository();

  List<Map<String, dynamic>> _todasLasAlertas = [];
  List<Map<String, dynamic>> _alertasFiltradas = [];

  Set<String> _filtroTipos = {};
  String _filtroEstadoAlerta = 'Pendientes';
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get alertasFiltradas => _alertasFiltradas;
  Set<String> get filtroTipos => _filtroTipos;
  String get filtroEstadoAlerta => _filtroEstadoAlerta;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalPendientes =>
      _todasLasAlertas.where((a) => a['estado'] == 'Pendiente').length;

  Future<void> cargarConteo() async {
    try {
      await _repository.generarAlertasNoAtendidas();
      _todasLasAlertas = await _repository.obtenerTodasLasAlertas();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> inicializar() async {
    _setLoading(true);
    try {
      await _repository.generarAlertasNoAtendidas();
      _todasLasAlertas = await _repository.obtenerTodasLasAlertas();
      _aplicarFiltros();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar alertas: $e';
    }
    _setLoading(false);
  }

  void toggleFiltroTipo(String tipo) {
    if (_filtroTipos.contains(tipo)) {
      _filtroTipos.remove(tipo);
    } else {
      _filtroTipos.add(tipo);
    }
    _aplicarFiltros();
  }

  void setFiltroEstadoAlerta(String? valor) {
    _filtroEstadoAlerta = valor ?? 'Todas';
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    _alertasFiltradas = _todasLasAlertas.where((alerta) {
      if (_filtroEstadoAlerta == 'Pendientes' && alerta['estado'] != 'Pendiente') return false;
      if (_filtroEstadoAlerta == 'Leídas' && alerta['estado'] != 'Leída') return false;
      if (_filtroTipos.isNotEmpty && !_filtroTipos.contains(alerta['tipo_alerta'])) return false;
      return true;
    }).toList();
    notifyListeners();
  }

  Future<void> marcarLeida(int idAlerta) async {
    try {
      await _repository.marcarLeida(idAlerta);
      // Recargar desde BD para garantizar que el estado refleja lo persistido
      _todasLasAlertas = await _repository.obtenerTodasLasAlertas();
      _aplicarFiltros();
    } catch (e) {
      _errorMessage = 'Error al marcar alerta: $e';
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}