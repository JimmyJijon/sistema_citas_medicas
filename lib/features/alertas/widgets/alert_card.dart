import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart'; 

class AlertCard extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color colorIcono;
  final String paciente;
  final String detalleFecha;
  final String estado;
  final VoidCallback onVerCita;
  final VoidCallback onMarcarLeida;

  const AlertCard({
    super.key,
    required this.titulo,
    required this.icono,
    required this.colorIcono,
    required this.paciente,
    required this.detalleFecha,
    required this.estado,
    required this.onVerCita,
    required this.onMarcarLeida,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e Icono
          Row(
            children: [
              Icon(icono, color: colorIcono, size: 20),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Información
          _buildInfoText("Paciente: $paciente"),
          const SizedBox(height: 4),
          Text(
            detalleFecha,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          _buildInfoText("Estado: $estado"),

          const SizedBox(height: 15),

          // Botones
          Row(
            children: [
              // Botón Ver Cita
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: onVerCita,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.fieldBlue,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Ver Cita",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              
              // Botón Marcar Leída
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: onMarcarLeida,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnGreen,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Marcar leída",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.black,
      ),
    );
  }
}