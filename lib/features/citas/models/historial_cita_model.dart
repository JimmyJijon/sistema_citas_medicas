// lib/features/citas/models/historial_cita_model.dart

class HistorialCita {
  final int idHistorial;
  final int idCita;
  final String estado;
  final String descripcion;
  final DateTime fechaEvento;
  final int idUsuario; // FK de usuario

  HistorialCita({
    required this.idHistorial,
    required this.idCita,
    required this.estado,
    required this.descripcion,
    required this.fechaEvento,
    required this.idUsuario,
  });

  factory HistorialCita.fromJson(Map<String, dynamic> json) => HistorialCita(
    idHistorial: json['id_historial'],
    idCita: json['id_cita'],
    estado: json['estado'],
    descripcion: json['descripcion'],
    fechaEvento: DateTime.parse(json['fecha_evento']),
    idUsuario: json['id_usuario'],
  );

  Map<String, dynamic> toJson() => {
    'id_historial': idHistorial,
    'id_cita': idCita,
    'estado': estado,
    'descripcion': descripcion,
    'fecha_evento': fechaEvento.toIso8601String(),
    'id_usuario': idUsuario,
  };
}
