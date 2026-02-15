import 'package:flutter/material.dart';
import '../registrar_cita_widgets/form_label_field.dart';
import '../registrar_cita_widgets/custom_input_container.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class AgendaFilters extends StatelessWidget {
  final DateTime fechaDesde;
  final DateTime fechaHasta;
  final String? estadoSeleccionado;
  final VoidCallback onTapDesde;
  final VoidCallback onTapHasta;
  final Function(String?) onChangedEstado;

  const AgendaFilters({
    Key? key,
    required this.fechaDesde,
    required this.fechaHasta,
    required this.estadoSeleccionado,
    required this.onTapDesde,
    required this.onTapHasta,
    required this.onChangedEstado,
  }) : super(key: key);

  String _formatearFecha(DateTime fecha) => "${fecha.day}/${fecha.month}/${fecha.year}";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título de Sección
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
                  hintText: "[Buscar por cédula]",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 5),
                  hintStyle: TextStyle(fontSize: 14, color: Colors.black54)),
              onChanged: (val) {},
            ),
          ),
        ),

        // Filtro Desde
        FormLabelField(
          label: "Desde:",
          child: CustomInputContainer(
            onTap: onTapDesde,
            child: Text(_formatearFecha(fechaDesde)),
          ),
        ),

        // Filtro Hasta
        FormLabelField(
          label: "Hasta:",
          child: CustomInputContainer(
            onTap: onTapHasta,
            child: Text(_formatearFecha(fechaHasta)),
          ),
        ),

        // Filtro Estado
        FormLabelField(
          label: "Estado:",
          child: CustomInputContainer(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: estadoSeleccionado,
                hint: const Text("[Todas]"),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                items: const [
                  DropdownMenuItem(value: null, child: Text("Todas")),
                  DropdownMenuItem(value: "ING", child: Text("Ingresadas")),
                  DropdownMenuItem(value: "COM", child: Text("Completadas")),
                ],
                onChanged: onChangedEstado,
              ),
            ),
          ),
        ),
      ],
    );
  }
}