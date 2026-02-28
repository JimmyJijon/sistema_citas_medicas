import 'package:flutter/material.dart';
import '../models/paciente_model.dart';

class PacientesViewModel extends ChangeNotifier {
  // Lista maestra de datos
  final List<PacienteModel> _pacientes = [
    PacienteModel(
      idPaciente: 1, // Le asignamos un ID de prueba
      nombres: 'Jimmy', // Separamos el nombre
      apellidos: 'Jijon', // Separamos el apellido
      cedula: '0959734154',
      telefono: '0999999999',
      correo: 'jimmy@correo.com', // Correo de prueba
      estado: 'Activo',
    ),
    PacienteModel(
      idPaciente: 2, // Le asignamos otro ID
      nombres: 'Sofia', // Separamos el nombre
      apellidos: 'Garcia', // Separamos el apellido
      cedula: '0959118154',
      telefono: '0999999999',
      correo: 'sofia@correo.com', // Correo de prueba
      estado: 'Activo',
    ),
  ];

  // Variable para almacenar lo que el usuario escribe
  String _filtroBusqueda = '';

  // Getter que devuelve la lista filtrada según el nombre o la cédula
  List<PacienteModel> get pacientes {
    if (_filtroBusqueda.isEmpty) {
      return _pacientes;
    }

    return _pacientes.where((paciente) {
      final nombre = paciente.nombres.toLowerCase();
      final cedula = paciente.cedula.toLowerCase();
      final query = _filtroBusqueda.toLowerCase();

      return nombre.contains(query) || cedula.contains(query);
    }).toList();
  }

  // Método para actualizar el filtro desde el TextField
  void filtrarPacientes(String query) {
    _filtroBusqueda = query;
    notifyListeners(); // Esto redibuja la lista mientras escribes
  }

  void agregarPaciente(PacienteModel nuevo) {
    _pacientes.add(nuevo);
    notifyListeners();
  }

  void editarPaciente(int index, PacienteModel actualizado) {
    // IMPORTANTE: Al editar, debemos buscar el índice real en la lista maestra
    // por si la lista está filtrada actualmente.
    final pacienteAEditar = pacientes[index];
    final indiceReal = _pacientes.indexOf(pacienteAEditar);

    if (indiceReal != -1) {
      _pacientes[indiceReal] = actualizado;
      notifyListeners();
    }
  }

  void eliminarPaciente(int index) {
    // Al igual que al editar, eliminamos basándonos en la lista actual visible
    final pacienteAEliminar = pacientes[index];
    _pacientes.remove(pacienteAEliminar);
    notifyListeners();
  }
}