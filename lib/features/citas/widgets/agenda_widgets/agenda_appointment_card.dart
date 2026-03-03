import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class AgendaAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String action) onAction;

  const AgendaAppointmentCard({
    Key? key,
    required this.data,
    required this.onAction,
  }) : super(key: key);

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'Ingresada':   return const Color(0xFFFFA726); // Naranja
      case 'Completada':  return const Color(0xFF66BB6A); // Verde
      case 'Cancelada':   return const Color(0xFFEF5350); // Rojo
      case 'Reagendada':  return const Color(0xFFAB47BC); // Morado
      default:            return Colors.grey;
    }
  }

  IconData _iconoEstado(String estado) {
    switch (estado) {
      case 'Pendiente':   return Icons.schedule;
      case 'Confirmada':  return Icons.check_circle_outline;
      case 'Completada':  return Icons.task_alt;
      case 'Cancelada':   return Icons.cancel_outlined;
      case 'Reagendada':  return Icons.update;
      default:            return Icons.help_outline;
    }
  }

  // Estados que permiten acciones de gestión
// Estados que permiten acciones de gestión
    bool _esGestionable(String estado) =>
        estado == 'Ingresada' || 
        estado == 'Reagendada';

  @override
  Widget build(BuildContext context) {
    final String estado = data['estado'] ?? '—';
    final bool gestionable = _esGestionable(estado);
    final Color colorEstado = _colorEstado(estado);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
        border: Border(
          left: BorderSide(color: colorEstado, width: 5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fila superior: Paciente + Badge estado ──
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    data['paciente'] ?? '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Badge de estado
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorEstado.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorEstado.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_iconoEstado(estado), size: 12, color: colorEstado),
                      const SizedBox(width: 4),
                      Text(
                        estado,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorEstado,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 8),

            // ── Fila inferior: Fecha + Hora + Botones ──
            Row(
              children: [
                // Fecha
                const Icon(Icons.calendar_today, size: 13, color: Colors.black45),
                const SizedBox(width: 4),
                Text(
                  data['fecha'] ?? '—',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(width: 12),
                // Hora
                const Icon(Icons.access_time, size: 13, color: Colors.black45),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    data['hora'] ?? '—',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                // Botones de acción
                _buildAcciones(gestionable),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // BOTONES DE ACCIÓN
  // ─────────────────────────────────────────

  Widget _buildAcciones(bool gestionable) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ver detalle — siempre visible
        _ActionBtn(
          icon: Icons.remove_red_eye_outlined,
          color: Colors.brown.shade400,
          tooltip: "Ver detalle",
          onTap: () => onAction("ver"),
        ),

        if (gestionable) ...[
          const SizedBox(width: 4),
          _ActionBtn(
            icon: Icons.update,
            color: Colors.blueGrey.shade500,
            tooltip: "Reagendar",
            onTap: () => onAction("reagendar"),
          ),
          const SizedBox(width: 4),
          _ActionBtn(
            icon: Icons.task_alt,
            color: AppColors.btnGreen,
            tooltip: "Marcar completada",
            onTap: () => onAction("completar"),
          ),
          const SizedBox(width: 4),
          _ActionBtn(
            icon: Icons.cancel_outlined,
            color: AppColors.btnRed,
            tooltip: "Cancelar",
            onTap: () => onAction("cancelar"),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────
// WIDGET INTERNO: Botón con Tooltip
// ─────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}