import 'package:flutter/material.dart';
import '../models/paciente_model.dart';
import '../repositories/pacientes_repository.dart'; 

class PacientesViewModel extends ChangeNotifier {
  // 1. Instanciamos el repositorio que habla con SQLite
  final PacientesRepository _repository = PacientesRepository();

  // 2. Nuestra lista maestra ahora empieza VACÍA
  List<PacienteModel> _pacientes = [];
  String _filtroBusqueda = '';
  
  // Opcional pero recomendado: un indicador de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 3. El Constructor: Apenas la pantalla se abra, vamos a la BD a traer los pacientes
  PacientesViewModel() {
    cargarPacientes();
  }

  // --- READ (Leer de la Base de Datos) ---
  Future<void> cargarPacientes() async {
    _isLoading = true;
    notifyListeners();
    // Traemos la lista actualizada de la BD
    _pacientes = await _repository.getPacientes();
    _isLoading = false;
    notifyListeners();
  }

  // --- LÓGICA DE BÚSQUEDA Mejorada ---
  List<PacienteModel> get pacientes {
    // 1. Limpiamos la búsqueda del usuario: quitamos espacios extras
    // Ejemplo: "  Juan    Perez  " -> "juan perez"
    final query = _filtroBusqueda.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    if (query.isEmpty) {
      return _pacientes;
    }

    return _pacientes.where((paciente) {
      // 2. Creamos un String con el nombre completo para comparar
      final nombreCompleto = "${paciente.nombres} ${paciente.apellidos}".toLowerCase();
      final cedula = paciente.cedula.toLowerCase();

      // 3. Verificamos si el query está en el nombre completo o en la cédula
      return nombreCompleto.contains(query) || cedula.contains(query);
    }).toList();
  }

  void filtrarPacientes(String query) {
    _filtroBusqueda = query;
    notifyListeners(); 
  }

  // --- Activar Paciente ---
  Future<void> activarPaciente(PacienteModel paciente) async {
    paciente.estado = 'Activo'; // O 'activo' según lo manejes en tu BD
    await _repository.updatePaciente(paciente);
    await cargarPacientes();
  }

  // --- CREATE (Guardar en Base de Datos) ---
  Future<void> agregarPaciente(PacienteModel nuevo) async {
    // 1. Guardamos en SQLite
    await _repository.insertPaciente(nuevo);
    // 2. Refrescamos la lista completa para ver al nuevo integrante
    await cargarPacientes();
  }

  // --- UPDATE (Editar en Base de Datos) ---
  Future<void> editarPaciente(PacienteModel actualizado) async {
    await _repository.updatePaciente(actualizado);
    await cargarPacientes();
  }

  // --- DELETE LOGICO (Inactivar en Base de Datos) ---
  // CAMBIO CLAVE: Ahora recibimos el PacienteModel completo.
  // Ya no usamos deletePaciente, usamos updatePaciente.
  Future<void> eliminarPaciente(PacienteModel paciente) async {
    // 1. Cambiamos el estado del paciente a 'Inactivo'
    paciente.estado = 'Inactivo';
    
    // 2. Actualizamos el registro en la base de datos
    await _repository.updatePaciente(paciente);
    
    // 3. Recargamos la lista (como cargarPacientes solo trae los 'Activo', este desaparecerá de la vista)
    await cargarPacientes();
  }
}