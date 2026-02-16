import 'package:flutter/material.dart';
import '../widgets/alert_card.dart';
import '../widgets/filter_row.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart'; 

class AlertsView extends StatefulWidget {
  const AlertsView({super.key});

  @override
  State<AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<AlertsView> {
  String filtroEstadoCita = "Todas";
  String filtroEstadoAlerta = "Pendientes";

  @override
  Widget build(BuildContext context) {
    // Estilo de texto base
    const TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ============================================
            // HEADER (Logo + Ruta)
            // ============================================
            Container(
              width: double.infinity,
              color: AppColors.header,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: [
                  // Logo
                  CircleAvatar(
                    backgroundColor: Colors.grey[600],
                    radius: 22,
                    child: const Text(
                      "logo", 
                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Barra de Ruta
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Inicio / Alertas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ============================================
            // CONTENEDOR CENTRAL GRIS
            // ============================================
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg, // Capa Gris
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      
                      // 1. BOTÓN VOLVER (Verde, encima del título)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.btnGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Volver",
                              style: textStyle,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // 2. TÍTULO "Alertas del Sistema"
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.fieldBlue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "Alertas del Sistema",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // 3. FILTROS
                      FilterRow(
                        label: "Estado de cita:",
                        items: const ["Todas", "Ingresada", "Cancelada", "Reagendada"],
                        currentValue: filtroEstadoCita,
                        onChanged: (val) => setState(() => filtroEstadoCita = val!),
                      ),
                      const SizedBox(height: 10),
                      FilterRow(
                        label: "Estado de alerta:",
                        items: const ["Pendientes", "Leídas"],
                        currentValue: filtroEstadoAlerta,
                        onChanged: (val) => setState(() => filtroEstadoAlerta = val!),
                      ),

                      const SizedBox(height: 20),

                      // 4. LISTA DE ALERTAS
                      AlertCard(
                        titulo: "Cita no atendida",
                        icono: Icons.warning_amber_rounded,
                        colorIcono: Colors.amber[800]!,
                        paciente: "Juan Pérez",
                        detalleFecha: "Fecha: 20/03/2026  Hora: 10:00 - 10:20",
                        estado: "No atendida",
                        onVerCita: () {},
                        onMarcarLeida: () {},
                      ),

                      AlertCard(
                        titulo: "Cita reagendada",
                        icono: Icons.refresh,
                        colorIcono: Colors.blueGrey,
                        paciente: "María Gómez",
                        detalleFecha: "Fecha original: 19/03/2026\nNueva fecha:    21/03/2026",
                        estado: "Reagendada",
                        onVerCita: () {},
                        onMarcarLeida: () {},
                      ),

                      AlertCard(
                        titulo: "Cita cancelada",
                        icono: Icons.close,
                        colorIcono: AppColors.btnRed,
                        paciente: "Carlos Ruiz",
                        detalleFecha: "Fecha: 18/03/2026",
                        estado: "Cancelada",
                        onVerCita: () {},
                        onMarcarLeida: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}