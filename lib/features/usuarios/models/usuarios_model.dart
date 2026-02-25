// lib/features/auth/models/usuario_model.dart

class Usuario {
  final int idUsuario;
  final String nombre;
  final String apellido;
  final String correo;
  final String password;
  final String rol; // 'Doctor' o 'Recepcionista'
  final String estado; // 'A' o 'I'
  final DateTime fechaCreacion;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.password,
    required this.rol,
    required this.estado,
    required this.fechaCreacion,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    idUsuario: json['id_usuario'],
    nombre: json['nombre'],
    apellido: json['apellido'],
    correo: json['correo'],
    password: json['password'],
    rol: json['rol'],
    estado: json['estado'],
    fechaCreacion: DateTime.parse(json['fecha_creacion']),
  );

  Map<String, dynamic> toJson() => {
    'id_usuario': idUsuario,
    'nombre': nombre,
    'apellido': apellido,
    'correo': correo,
    'password': password,
    'rol': rol,
    'estado': estado,
    'fecha_creacion': fechaCreacion.toIso8601String(),
  };
}
