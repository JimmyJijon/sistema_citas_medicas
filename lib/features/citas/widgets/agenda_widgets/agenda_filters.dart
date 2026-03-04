import 'package:flutter/material.dart';
import '../registrar_cita_widgets/form_label_field.dart';
import '../registrar_cita_widgets/custom_input_container.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class AgendaFilters extends StatelessWidget {
  final DateTime fechaDesde;
  final DateTime fechaHasta;
  final Set<String> estadosSeleccionados;
  final VoidCallback onTapDesde;
  final VoidCallback onTapHasta;
  final Function(String) onToggleEstado;
  final Function(String) onChangedPaciente;

  const AgendaFilters({
    Key? key,
    required this.fechaDesde,
    required this.fechaHasta,
    required this.estadosSeleccionados,
    required this.onTapDesde,
    required this.onTapHasta,
    required this.onToggleEstado,
    required this.onChangedPaciente,
  }) : super(key: key);

  String _formatearFecha(DateTime fecha) =>
      "${fecha.day.toString().padLeft(2, '0')}/"
      "${fecha.month.toString().padLeft(2, '0')}/"
      "${fecha.year}";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.fieldBlue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            "Agenda de citas",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 15),

        // Filtro Paciente
        FormLabelField(
          label: "Paciente",
          child: CustomInputContainer(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Buscar por nombre o cédula",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 5),
                hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              onChanged: onChangedPaciente,
            ),
          ),
        ),

        // Filtro Desde
        FormLabelField(
          label: "Desde:",
          child: CustomInputContainer(
            onTap: onTapDesde,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatearFecha(fechaDesde)),
                const Icon(Icons.calendar_today, size: 16),
              ],
            ),
          ),
        ),

        // Filtro Hasta
        FormLabelField(
          label: "Hasta:",
          child: CustomInputContainer(
            onTap: onTapHasta,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatearFecha(fechaHasta)),
                const Icon(Icons.calendar_today, size: 16),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Filtro Estado — checkboxes
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.fieldBlue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            "Filtrar por estado",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 6),

        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _EstadoChip(
              label: "Ingresada",
              color: const Color(0xFFFFA726),
              seleccionado: estadosSeleccionados.contains("Ingresada"),
              onTap: () => onToggleEstado("Ingresada"),
            ),

            _EstadoChip(
              label: "Reagendada",
              color: const Color(0xFFAB47BC),
              seleccionado: estadosSeleccionados.contains("Reagendada"),
              onTap: () => onToggleEstado("Reagendada"),
            ),
            _EstadoChip(
              label: "Completada",
              color: const Color(0xFF66BB6A),
              seleccionado: estadosSeleccionados.contains("Completada"),
              onTap: () => onToggleEstado("Completada"),
            ),
            _EstadoChip(
              label: "Cancelada",
              color: const Color(0xFFEF5350),
              seleccionado: estadosSeleccionados.contains("Cancelada"),
              onTap: () => onToggleEstado("Cancelada"),
            ),
          ],
        ),

        // Indicador de sin filtro activo
        if (estadosSeleccionados.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text(
              "Mostrando todos los estados",
              style: TextStyle(fontSize: 11, color: Colors.black45, fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// CHIP DE ESTADO CON CHECKBOX VISUAL
// ─────────────────────────────────────────

class _EstadoChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool seleccionado;
  final VoidCallback onTap;

  const _EstadoChip({
    required this.label,
    required this.color,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: seleccionado ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: seleccionado ? color : Colors.grey.shade300,
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: seleccionado ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: seleccionado ? color : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: seleccionado
                  ? const Icon(Icons.check, size: 11, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
                color: seleccionado ? color : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}