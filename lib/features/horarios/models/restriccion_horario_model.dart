class RestriccionHorario {
  final int idRestriccion;
  final String tipo; // feriado, reunion, otro
  final DateTime fecha;
  final String horaInicio;
  final String horaFin;
  final String estado;

  RestriccionHorario({
    required this.idRestriccion,
    required this.tipo,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.estado,
  });

  factory RestriccionHorario.fromJson(Map<String, dynamic> json) =>
      RestriccionHorario(
        idRestriccion: json['id_restriccion'],
        tipo: json['tipo'],
        fecha: DateTime.parse(json['fecha']),
        horaInicio: json['hora_inicio'],
        horaFin: json['hora_fin'],
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
    'id_restriccion': idRestriccion,
    'tipo': tipo,
    'fecha': fecha.toIso8601String().split('T')[0],
    'hora_inicio': horaInicio,
    'hora_fin': horaFin,
    'estado': estado,
  };
}