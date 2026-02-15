import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import '../widgets/app_header.dart';
// Importamos tus nuevos widgets modulares
import '../widgets/section_title.dart';
import '../widgets/detail_info_row.dart';
import '../widgets/detalle_cita_widgets/history_log_item.dart';

class DetalleCitaView extends StatelessWidget {
  const DetalleCitaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header
          const AppHeader(title: "Inicio / Agenda / Detalle"),

          // 2. Botón Volver (Mismo diseño que Agenda)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, top: 15, bottom: 5),
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 3,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios_new, size: 16),
                  SizedBox(width: 8),
                  Text("Volver", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),

          // 3. Contenido
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  
                  // --- BLOQUE 1: INFO DE LA CITA ---
                  const SectionTitle(title: "Detalle de Cita"),
                  
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
                        // Usamos el widget modular DetailInfoRow
                        DetailInfoRow(
                          icon: Icons.person, 
                          label: "Paciente", 
                          value: "Jorge Castro"
                        ),
                        DetailInfoRow(
                          icon: Icons.calendar_today, 
                          label: "Fecha", 
                          value: "05/03/2026"
                        ),
                        DetailInfoRow(
                          icon: Icons.access_time, 
                          label: "Franja Horaria", 
                          value: "10:00 - 10:20"
                        ),
                        DetailInfoRow(
                          icon: Icons.info_outline, 
                          label: "Estado", 
                          value: "Reagendada", 
                          isLast: true // Para quitar la línea divisoria final
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- BLOQUE 2: HISTORIAL ---
                  const SectionTitle(title: "Historial de acciones"),

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
                        // Usamos el widget modular HistoryLogItem
                        HistoryLogItem(
                          date: "15/09/2026 10:30",
                          user: "Recepcionista",
                          action: "Reagendada",
                          description: "Se ajusta la franja horaria por retraso del paciente.",
                        ),
                        
                        SizedBox(height: 15), // Separación entre items
                        
                        HistoryLogItem(
                          date: "10/09/2026 09:00",
                          user: "Sistema",
                          action: "Creación",
                          description: "Cita creada exitosamente desde el módulo web.",
                        ),
                      ],
                    ),
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