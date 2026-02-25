/*
class PacienteModel {
  final String nombre;
  final String cedula;
  final String telefono;
  final String estado;

  PacienteModel({
    required this.nombre,
    required this.cedula,
    required this.telefono,
    required this.estado,
  });

  // Esto te servirá luego para conectar con una base de datos
  factory PacienteModel.fromMap(Map<String, String> map) {
    return PacienteModel(
      nombre: map['nombre'] ?? '',
      cedula: map['cedula'] ?? '',
      telefono: map['telefono'] ?? '',
      estado: map['estado'] ?? 'Activo',
    );
  }
}*/

// lib/features/pacientes/models/paciente_model.dart

class PacienteModel {
  final int idPaciente;
  final String cedula;
  final String nombres;
  final String apellidos;
  final String telefono;
  final String correo;
  final String estado;

  PacienteModel({
    required this.idPaciente,
    required this.cedula,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.correo,
    required this.estado,
  });

  // Esto te servirá para leer los datos desde tu base de datos o API
  factory PacienteModel.fromMap(Map<String, dynamic> map) {
    return PacienteModel(
      idPaciente: map['id_paciente'] ?? 0,
      cedula: map['cedula'] ?? '',
      nombres:
          map['nombres'] ??
          '', // Cambiado de 'nombre' a 'nombres' para coincidir con tu ER
      apellidos: map['apellidos'] ?? '',
      telefono: map['telefono'] ?? '',
      correo: map['correo'] ?? '',
      estado: map['estado'] ?? 'Activo', // Manteniendo tu valor por defecto
    );
  }

  // Esto te servirá para enviar o guardar los datos
  Map<String, dynamic> toMap() {
    return {
      'id_paciente': idPaciente,
      'cedula': cedula,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'correo': correo,
      'estado': estado,
    };
  }
}
