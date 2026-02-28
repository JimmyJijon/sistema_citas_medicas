// lib/features/alertas/models/alerta_model.dart

class Alerta {
  final int idAlerta;
  final int idCita; // FK
  final String tipoAlerta;
  final String descripcion;
  final String estado;
  final DateTime fechaGeneracion;

  Alerta({
    required this.idAlerta,
    required this.idCita,
    required this.tipoAlerta,
    required this.descripcion,
    required this.estado,
    required this.fechaGeneracion,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) => Alerta(
    idAlerta: json['id_alerta'],
    idCita: json['id_cita'],
    tipoAlerta: json['tipo_alerta'],
    descripcion: json['descripcion'],
    estado: json['estado'],
    fechaGeneracion: DateTime.parse(json['fecha_generacion']),
  );

  Map<String, dynamic> toJson() => {
    'id_alerta': idAlerta,
    'id_cita': idCita,
    'tipo_alerta': tipoAlerta,
    'descripcion': descripcion,
    'estado': estado,
    'fecha_generacion': fechaGeneracion.toIso8601String(),
  };
}
