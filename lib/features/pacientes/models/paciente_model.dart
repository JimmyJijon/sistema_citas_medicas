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
}