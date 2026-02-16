import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import '../widgets/app_header.dart';
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

          // 2. BOTÓN VOLVER
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, bottom: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.btnGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Volver",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Contenido
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                          isLast: true
                        ),
                      ],
                    ),
                  ),

                  // AJUSTE: Reduje este espacio de 30 a 15
                  const SizedBox(height: 15),

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
                        HistoryLogItem(
                          date: "15/09/2026 10:30",
                          user: "Recepcionista",
                          action: "Reagendada",
                          description: "Se ajusta la franja horaria por retraso del paciente.",
                        ),
                        
                        SizedBox(height: 15),
                        
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