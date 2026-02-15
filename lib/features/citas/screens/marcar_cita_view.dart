import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import '../widgets/app_header.dart';
// Widgets Modulares
import '../widgets/section_title.dart';
import '../widgets/detail_info_row.dart';
import '../widgets/marcar_cita_widgets/status_change_row.dart';
import '../widgets/observation_input.dart';
import '../widgets/marcar_cita_widgets/form_action_buttons.dart';

class MarcarCitaView extends StatelessWidget {
  const MarcarCitaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header Global
          const AppHeader(title: "Inicio / Agenda / Marcar Cita"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  
                  // 2. Título de Sección
                  const SectionTitle(title: "Marcar Cita"),
                  
                  // 3. Contenedor de Información Principal
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: const [
                        // Usamos tu widget DetailInfoRow existente
                        DetailInfoRow(
                          label: "Paciente", 
                          value: "Juan Perez" // Sin icono en esta vista según diseño
                        ),
                        DetailInfoRow(
                          label: "Fecha", 
                          value: "[05/03/2026]"
                        ),
                        DetailInfoRow(
                          label: "Franja horaria", 
                          value: "[10:00 - 10:20]"
                        ),
                        DetailInfoRow(
                          label: "Estado Actual", 
                          value: "[Ingresada]",
                          isLast: true // Para que no ponga la línea divisoria
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Fila de Nuevo Estado (Widget Modular Nuevo)
                  const StatusChangeRow(
                    label: "Nuevo Estado:", 
                    value: "[Completada]"
                  ),

                  const SizedBox(height: 20),

                  // 5. Título de Observación (Reutilizamos SectionTitle)
                  const SectionTitle(title: "Observación / resultado de la cita"),
                  
                  // 6. Input de Observación (Widget Modular Nuevo)
                  const ObservationInput(),

                  const SizedBox(height: 30),

                  // 7. Botones de Acción (Widget Modular Nuevo)
                  FormActionButtons(
                    onConfirm: () {
                      // Lógica de confirmar
                      print("Cita marcada como completada");
                      Navigator.pop(context);
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}