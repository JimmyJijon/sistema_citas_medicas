// lib/features/citas/models/cita_model.dart

class Cita {
  final int idCita;
  final int idPaciente;
  final DateTime fecha;
  final String horaInicio;
  final String horaFin;
  final String estado;
  final int creadaPor; // FK de usuario
  final DateTime fechaCreacion;

  Cita({
    required this.idCita,
    required this.idPaciente,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.estado,
    required this.creadaPor,
    required this.fechaCreacion,
  });

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
    idCita: json['id_cita'],
    idPaciente: json['id_paciente'],
    fecha: DateTime.parse(json['fecha']),
    horaInicio: json['hora_inicio'],
    horaFin: json['hora_fin'],
    estado: json['estado'],
    creadaPor: json['creada_por'],
    fechaCreacion: DateTime.parse(json['fecha_creacion']),
  );

  Map<String, dynamic> toJson() => {
    'id_cita': idCita,
    'id_paciente': idPaciente,
    'fecha': fecha.toIso8601String().split('T')[0], // Solo fecha
    'hora_inicio': horaInicio,
    'hora_fin': horaFin,
    'estado': estado,
    'creada_por': creadaPor,
    'fecha_creacion': fechaCreacion.toIso8601String(),
  };
}
