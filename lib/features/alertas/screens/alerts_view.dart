import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/alertas/viewmodels/alert_viewmodel.dart';
import 'package:sistema_citas_medicas/features/citas/viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/citas/screens/detalle_cita_view.dart';
import '../widgets/alert_card.dart';
import '../widgets/filter_row.dart';

class AlertsView extends StatefulWidget {
  const AlertsView({super.key});

  @override
  State<AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<AlertsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertViewModel>().inicializar();
    });
  }

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

  ({IconData icono, Color color}) _iconoParaTipo(String tipo) {
    switch (tipo) {
      case 'Creada':
        return (icono: Icons.add_circle_outline, color: const Color(0xFF42A5F5));
      case 'No atendida':
        return (icono: Icons.warning_amber_rounded, color: Colors.amber[800]!);
      case 'Reagendada':
        return (icono: Icons.update, color: const Color(0xFFAB47BC));
      case 'Cancelada':
        return (icono: Icons.cancel_outlined, color: const Color(0xFFEF5350));
      case 'Completada':
        return (icono: Icons.task_alt, color: const Color(0xFF66BB6A));
      default:
        return (icono: Icons.notifications_outlined, color: AppColors.fieldBlue);
    }
  }

  Future<void> _verCita(Map<String, dynamic> alerta) async {
    final citaVm = context.read<CitaViewModel>();
    await citaVm.setCitaSeleccionada({
      'id_cita': alerta['id_cita'],
      'nombre_paciente': alerta['nombre_paciente'],
      'fecha': alerta['fecha'],
      'hora_inicio': alerta['hora_inicio'],
      'hora_fin': alerta['hora_fin'],
      'estado': alerta['estado_cita'],
      'cedula': alerta['cedula'] ?? '',
    });
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const DetalleCitaView()));
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AlertViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: AppColors.header,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[600],
                    radius: 22,
                    child: const Text("logo",
                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("Inicio / Alertas",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            // Botón Volver
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
                                  child: const Text("Volver",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Título
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.fieldBlue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                vm.alertasFiltradas.isEmpty
                                    ? "Alertas del Sistema"
                                    : "Alertas del Sistema (${vm.alertasFiltradas.length})",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // ── Filtro por tipo (checkboxes) ──
                            _buildSeccionFiltro("Tipo de alerta"),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _TipoChip(
                                  label: "Creada",
                                  color: const Color(0xFF42A5F5),
                                  icono: Icons.add_circle_outline,
                                  seleccionado: vm.filtroTipos.contains("Creada"),
                                  onTap: () => vm.toggleFiltroTipo("Creada"),
                                ),
                                _TipoChip(
                                  label: "No atendida",
                                  color: Colors.amber[800]!,
                                  icono: Icons.warning_amber_rounded,
                                  seleccionado: vm.filtroTipos.contains("No atendida"),
                                  onTap: () => vm.toggleFiltroTipo("No atendida"),
                                ),
                                _TipoChip(
                                  label: "Reagendada",
                                  color: const Color(0xFFAB47BC),
                                  icono: Icons.update,
                                  seleccionado: vm.filtroTipos.contains("Reagendada"),
                                  onTap: () => vm.toggleFiltroTipo("Reagendada"),
                                ),
                                _TipoChip(
                                  label: "Completada",
                                  color: const Color(0xFF66BB6A),
                                  icono: Icons.task_alt,
                                  seleccionado: vm.filtroTipos.contains("Completada"),
                                  onTap: () => vm.toggleFiltroTipo("Completada"),
                                ),
                                _TipoChip(
                                  label: "Cancelada",
                                  color: const Color(0xFFEF5350),
                                  icono: Icons.cancel_outlined,
                                  seleccionado: vm.filtroTipos.contains("Cancelada"),
                                  onTap: () => vm.toggleFiltroTipo("Cancelada"),
                                ),
                              ],
                            ),
                            if (vm.filtroTipos.isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(top: 6, left: 4),
                                child: Text(
                                  "Mostrando todos los tipos",
                                  style: TextStyle(fontSize: 11, color: Colors.black45, fontStyle: FontStyle.italic),
                                ),
                              ),

                            const SizedBox(height: 15),

                            // ── Filtro estado de alerta (dropdown existente) ──
                            FilterRow(
                              label: "Estado:",
                              items: const ["Todas", "Pendientes", "Leídas"],
                              currentValue: vm.filtroEstadoAlerta,
                              onChanged: vm.setFiltroEstadoAlerta,
                            ),

                            const SizedBox(height: 20),

                            // ── Lista ──
                            if (vm.alertasFiltradas.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Center(
                                  child: Text(
                                    "No hay alertas para este filtro.",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              )
                            else
                              ...vm.alertasFiltradas.map((alerta) {
                                final tipo = alerta['tipo_alerta'] as String? ?? '—';
                                final icono = _iconoParaTipo(tipo);
                                final leida = alerta['estado'] == 'Leída';
                                final fechaStr = _formatearFecha(alerta['fecha'] ?? '');

                                return AlertCard(
                                  titulo: tipo,
                                  icono: icono.icono,
                                  colorIcono: icono.color,
                                  paciente: alerta['nombre_paciente'] ?? '—',
                                  detalleFecha:
                                      "Fecha: $fechaStr   Hora: ${alerta['hora_inicio']} - ${alerta['hora_fin']}",
                                  estado: alerta['estado_cita'] ?? '—',
                                  leida: leida,
                                  onVerCita: () => _verCita(alerta),
                                  onMarcarLeida: leida
                                      ? null
                                      : () => vm.marcarLeida(alerta['id_alerta'] as int),
                                );
                              }).toList(),

                            const SizedBox(height: 20),
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

  Widget _buildSeccionFiltro(String titulo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.fieldBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }
}

// ─────────────────────────────────────────
// CHIP DE TIPO CON CHECKBOX VISUAL
// ─────────────────────────────────────────

class _TipoChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icono;
  final bool seleccionado;
  final VoidCallback onTap;

  const _TipoChip({
    required this.label,
    required this.color,
    required this.icono,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
            // Checkbox visual
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
            Icon(icono, size: 14, color: seleccionado ? color : Colors.black45),
            const SizedBox(width: 4),
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