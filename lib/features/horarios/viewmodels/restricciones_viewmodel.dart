import 'package:flutter/material.dart';
import '../models/restriccion_horario_model.dart';
import '../repositories/restricciones_repository.dart'; // <--- YA DESCOMENTADO

class RestriccionesViewModel extends ChangeNotifier {
  // Instancia real del repositorio
  final RestriccionesRepository _repository = RestriccionesRepository();

  List<RestriccionHorario> _restricciones = [];
  List<RestriccionHorario> get restricciones => _restricciones;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RestriccionesViewModel() {
    cargarRestricciones();
  }

  // --- READ: Carga los datos reales de SQLite ---
  Future<void> cargarRestricciones() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Llamamos al repositorio para traer los datos de la tabla
      _restricciones = await _repository.obtenerTodos();
    } catch (e) {
      debugPrint("Error al cargar restricciones: $e");
    }

    _isLoading = false;
    notifyListeners(); // Esto redibuja la tabla en la UI
  }

  // --- CREATE ---
  Future<void> agregarRestriccion(RestriccionHorario nueva) async {
    await _repository.insertar(nueva);
    await cargarRestricciones(); // Recargamos para ver el nuevo registro
  }

  // --- UPDATE (Unificado con el nombre que usa tu formulario) ---
  Future<void> actualizarRestriccion(RestriccionHorario actualizada) async {
    await _repository.actualizar(actualizada);
    await cargarRestricciones();
  }

  // --- DELETE ---
  Future<void> eliminarRestriccion(RestriccionHorario restriccion) async {
    if (restriccion.idRestriccion != null) {
      await _repository.eliminar(restriccion.idRestriccion!);
      await cargarRestricciones();
    }
  }
}