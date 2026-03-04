import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class AlertCard extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color colorIcono;
  final String paciente;
  final String detalleFecha;
  final String estado;
  final bool leida;
  final VoidCallback onVerCita;
  final VoidCallback? onMarcarLeida; // null cuando ya está leída

  const AlertCard({
    super.key,
    required this.titulo,
    required this.icono,
    required this.colorIcono,
    required this.paciente,
    required this.detalleFecha,
    required this.estado,
    required this.leida,
    required this.onVerCita,
    required this.onMarcarLeida,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: leida ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          left: BorderSide(
            color: leida ? Colors.grey.shade300 : colorIcono,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(leida ? 0.03 : 0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Título + badge leída ──
          Row(
            children: [
              Icon(icono, color: leida ? Colors.grey : colorIcono, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: leida ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              if (leida)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Leída",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Info ──
          _infoText("Paciente: $paciente", leida),
          const SizedBox(height: 4),
          Text(
            detalleFecha,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: leida ? Colors.grey : Colors.black,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          _infoText("Estado cita: $estado", leida),

          const SizedBox(height: 15),

          // ── Botones ──
          Row(
            children: [
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    // null deshabilita el botón automáticamente
                    onPressed: onMarcarLeida,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: leida ? Colors.grey.shade300 : AppColors.btnGreen,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      leida ? "Ya leída" : "Marcar leída",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: leida ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoText(String text, bool leida) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: leida ? Colors.grey : Colors.black,
      ),
    );
  }
}