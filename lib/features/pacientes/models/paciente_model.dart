class PacienteModel {
  final int? idPaciente; // Es opcional (?) porque SQLite lo autogenera
  final String cedula;
  final String nombres;
  final String apellidos;
  final String? telefono; // Es opcional (?) porque en la BD no tiene "NOT NULL"
  final String? correo;   // Es opcional (?) porque en la BD no tiene "NOT NULL"
  String estado;    // Obligatorio, sí tiene "NOT NULL"

  PacienteModel({
    this.idPaciente,
    required this.cedula,
    required this.nombres,
    required this.apellidos,
    this.telefono,
    this.correo,
    this.estado = 'Activo'
  });

  // Convierte lo que escupe SQLite a un objeto en Flutter
  factory PacienteModel.fromMap(Map<String, dynamic> map) {
    return PacienteModel(
      idPaciente: map['id_paciente'], 
      cedula: map['cedula'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      telefono: map['telefono'],
      correo: map['correo'],
      estado: map['estado'],
    );
  }

  // Convierte tu objeto en Flutter a un formato que SQLite entiende para guardar
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'cedula': cedula,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'correo': correo,
      'estado': estado,
    };
    
    // Solo mandamos el ID si ya existe (para actualizar). Si es nuevo, SQLite lo pone.
    if (idPaciente != null) {
      map['id_paciente'] = idPaciente;
    }
    return map;
  }
}