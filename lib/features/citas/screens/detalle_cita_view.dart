import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/citas/viewmodels/citas_viewmodel.dart';
import '../widgets/app_header.dart';
import '../widgets/section_title.dart';
import '../widgets/detail_info_row.dart';
import '../widgets/detalle_cita_widgets/history_log_item.dart';

class DetalleCitaView extends StatelessWidget {
  const DetalleCitaView({Key? key}) : super(key: key);

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────

  String _formatearFecha(String fechaIso) {
    try {
      final f = DateTime.parse(fechaIso);
      return "${f.day.toString().padLeft(2, '0')}/"
          "${f.month.toString().padLeft(2, '0')}/"
          "${f.year}";
    } catch (_) {
      return fechaIso;
    }
  }

  String _formatearFechaHora(String fechaIso) {
    try {
      final f = DateTime.parse(fechaIso);
      return "${f.day.toString().padLeft(2, '0')}/"
          "${f.month.toString().padLeft(2, '0')}/"
          "${f.year} "
          "${f.hour.toString().padLeft(2, '0')}:"
          "${f.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return fechaIso;
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CitaViewModel>();
    final cita = vm.citaSeleccionada;

    // Protección: si no hay cita seleccionada, volvemos atrás
    if (cita == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header
          const AppHeader(title: "Inicio / Agenda / Detalle"),

          // 2. Botón Volver
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
                  // ── Bloque 1: Info de la cita ──
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
                      children: [
                        DetailInfoRow(
                          icon: Icons.person,
                          label: "Paciente",
                          value: cita['nombre_paciente'] ?? '—',
                        ),
                        DetailInfoRow(
                          icon: Icons.badge_outlined,
                          label: "Cédula",
                          value: cita['cedula'] ?? '—',
                        ),
                        DetailInfoRow(
                          icon: Icons.calendar_today,
                          label: "Fecha",
                          value: _formatearFecha(cita['fecha'] ?? ''),
                        ),
                        DetailInfoRow(
                          icon: Icons.access_time,
                          label: "Franja Horaria",
                          value: "${cita['hora_inicio']} - ${cita['hora_fin']}",
                        ),
                        DetailInfoRow(
                          icon: Icons.info_outline,
                          label: "Estado",
                          value: cita['estado'] ?? '—',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ── Bloque 2: Historial ──
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
                    child: vm.isLoadingHistorial
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : vm.historialCita.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Sin acciones registradas.",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              )
                            : Column(
                                children: vm.historialCita
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final i = entry.key;
                                  final h = entry.value;
                                  return Column(
                                    children: [
                                      HistoryLogItem(
                                        date: _formatearFechaHora(
                                            h['fecha_evento'] ?? ''),
                                        user: h['nombre_usuario'] ?? '—',
                                        action: h['estado'] ?? '—',
                                        description: h['descripcion'] ?? '',
                                      ),
                                      if (i < vm.historialCita.length - 1)
                                        const SizedBox(height: 15),
                                    ],
                                  );
                                }).toList(),
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