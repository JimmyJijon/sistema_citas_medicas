import 'package:flutter/material.dart';
import '../models/paciente_model.dart';

class PacientesViewModel extends ChangeNotifier {
  List<PacienteModel> _pacientes = [
    PacienteModel(nombre: 'Jimmy Jijon', cedula: '0959734154', telefono: '0999999999', estado: 'Activo'),
    PacienteModel(nombre: 'Sofia Garcia', cedula: '0959118154', telefono: '0999999999', estado: 'Activo'),
  ];

  List<PacienteModel> get pacientes => _pacientes;

  void agregarPaciente(PacienteModel nuevo) {
    _pacientes.add(nuevo);
    notifyListeners();
  }

  void editarPaciente(int index, PacienteModel actualizado) {
    _pacientes[index] = actualizado;
    notifyListeners();
  }

  void eliminarPaciente(int index) {
    _pacientes.removeAt(index);
    notifyListeners();
  }
}