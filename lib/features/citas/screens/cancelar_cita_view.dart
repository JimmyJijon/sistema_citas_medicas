import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import '../widgets/app_header.dart';
// Widgets Modulares Reutilizados
import '../widgets/section_title.dart';
import '../widgets/detail_info_row.dart';
import '../widgets/observation_input.dart';
// Widget Nuevo
import '../widgets/cancelar_cita_widgets/cancel_action_buttons.dart';

class CancelarCitaView extends StatelessWidget {
  const CancelarCitaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header Global
          const AppHeader(title: "Inicio / Agenda / Cancelar cita"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  
                  // 2. Título de Sección
                  const SectionTitle(title: "Cancelar Cita"),
                  
                  // 3. Contenedor de Información (Reutilizando diseño)
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
                        DetailInfoRow(
                          label: "Paciente", 
                          value: "Juan Perez"
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
                          isLast: true
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Sección Motivo
                  const SectionTitle(title: "Motivo de la cancelación"),
                  
                  // 5. Input (Reutilizado de la pantalla anterior)
                  const ObservationInput(
                    hintText: "[Descripción]",
                  ),

                  const SizedBox(height: 30),

                  // 6. Botones de Acción (Invertidos para esta vista)
                  CancelActionButtons(
                    onConfirmCancel: () {
                      // Lógica para procesar la cancelación
                      print("Cita cancelada definitivamente");
                      Navigator.pop(context);
                    },
                    onAbort: () {
                      // Lógica para no hacer nada y volver
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