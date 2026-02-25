// lib/features/horarios/models/horario_atencion_model.dart

class HorarioAtencion {
  final int idHorario;
  final String diasAtencion;
  final String horaInicio;
  final String horaFin;
  final int duracionCita; // En minutos
  final String? pausaInicio; // Nullable
  final String? pausaFin; // Nullable
  final DateTime vigenciaDesde;
  final String estado;

  HorarioAtencion({
    required this.idHorario,
    required this.diasAtencion,
    required this.horaInicio,
    required this.horaFin,
    required this.duracionCita,
    this.pausaInicio,
    this.pausaFin,
    required this.vigenciaDesde,
    required this.estado,
  });

  factory HorarioAtencion.fromJson(Map<String, dynamic> json) =>
      HorarioAtencion(
        idHorario: json['id_horario'],
        diasAtencion: json['dias_atencion'],
        horaInicio: json['hora_inicio'],
        horaFin: json['hora_fin'],
        duracionCita: json['duracion_cita'],
        pausaInicio: json['pausa_inicio'],
        pausaFin: json['pausa_fin'],
        vigenciaDesde: DateTime.parse(json['vigencia_desde']),
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
    'id_horario': idHorario,
    'dias_atencion': diasAtencion,
    'hora_inicio': horaInicio,
    'hora_fin': horaFin,
    'duracion_cita': duracionCita,
    'pausa_inicio': pausaInicio,
    'pausa_fin': pausaFin,
    'vigencia_desde': vigenciaDesde.toIso8601String().split('T')[0],
    'estado': estado,
  };
}
