import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/core/widgets/clinic_logo.dart';
import 'package:sistema_citas_medicas/features/reportes/viewmodels/reportes_viewmodel.dart';
import 'package:sistema_citas_medicas/features/citas/viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/citas/screens/detalle_cita_view.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportesViewModel(),
      child: const _ReportesView(),
    );
  }
}

class _ReportesView extends StatelessWidget {
  const _ReportesView();

  Future<void> _pickDateTime(
    BuildContext context,
    bool isDesde,
    ReportesViewModel viewModel,
  ) async {
    final DateTime initialDate =
        isDesde ? viewModel.desdeDateTime : viewModel.hastaDateTime;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (isDesde) {
      viewModel.setDesdeDateTime(newDateTime);
    } else {
      viewModel.setHastaDateTime(newDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReportesViewModel>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: 15,
                        ),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.btnGreen,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, size: 18),
                              label: const Text(
                                "Volver",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.fieldBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "REPORTES ESTADÍSTICOS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            DateSelectorWidget(
                              label: "Desde:",
                              dateValue: viewModel.formatDateTime(viewModel.desdeDateTime),
                              onTap: () => _pickDateTime(context, true, viewModel),
                            ),
                            const SizedBox(height: 12),
                            DateSelectorWidget(
                              label: "Hasta:",
                              dateValue: viewModel.formatDateTime(viewModel.hastaDateTime),
                              onTap: () => _pickDateTime(context, false, viewModel),
                            ),
                            const SizedBox(height: 25),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.btnGreen,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () => viewModel.generarReporte(),
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Text(
                                        "GENERAR REPORTE",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  StatRowWidget(
                                    label: "Total de Citas:",
                                    value: viewModel.totalCitas.toString().padLeft(2, '0'),
                                    isTotal: true,
                                  ),
                                  const Divider(),
                                  StatRowWidget(
                                    label: "Completadas:",
                                    value: viewModel.completadas.toString().padLeft(2, '0'),
                                  ),
                                  StatRowWidget(
                                    label: "Canceladas:",
                                    value: viewModel.canceladas.toString().padLeft(2, '0'),
                                  ),
                                  StatRowWidget(
                                    label: "Reagendadas:",
                                    value: viewModel.reagendadas.toString().padLeft(2, '0'),
                                  ),
                                  StatRowWidget(
                                    label: "En espera:",
                                    value: viewModel.enEspera.toString().padLeft(2, '0'),
                                  ),
                                  StatRowWidget(
                                    label: "No atendidas:",
                                    value: viewModel.noAtendidas.toString().padLeft(2, '0'),
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),
                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF19C5D0),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () async {
                                  await viewModel.cargarListadoDetalle();
                                  if (context.mounted) {
                                    _mostrarModalListado(
                                      context,
                                      viewModel.listadoCitasDetalle,
                                    );
                                  }
                                },
                                child: const Text(
                                  "VER LISTADO DETALLADO",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.header,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ClinicLogo(size: 22, color: AppColors.accentColor),
              const SizedBox(width: 8),
              const Text(
                "CLÍNICA",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.accentColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.fieldBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Inicio / Reporte",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarModalListado(
    BuildContext context,
    List<Map<String, dynamic>> citas,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        height: MediaQuery.of(modalContext).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Detalle de Citas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: citas.isEmpty
                  ? const Center(child: Text("Sin registros."))
                  : ListView.builder(
                      itemCount: citas.length,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (ctx, index) {
                        final cita = citas[index];
                        final String estadoVisual =
                            cita['estado_visual'] as String? ?? 'No atendida';

                        Color colorE;
                        switch (estadoVisual) {
                          case 'Completada':
                            colorE = const Color(0xFF66BB6A);
                            break;
                          case 'Cancelada':
                            colorE = const Color(0xFFEF5350);
                            break;
                          case 'Reagendada':
                            colorE = const Color(0xFFAB47BC);
                            break;
                          case 'En espera':
                            colorE = const Color(0xFF42A5F5);
                            break;
                          default: // No atendida
                            colorE = Colors.grey;
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: colorE.withOpacity(0.3)),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              // Cerrar el modal primero
                              Navigator.pop(modalContext);
                              // Cargar la cita seleccionada y navegar al detalle
                              final citaVm = context.read<CitaViewModel>();
                              await citaVm.setCitaSeleccionada({
                                'id_cita':         cita['id_cita'],
                                'nombre_paciente': cita['nombre_paciente'] ?? '—',
                                'cedula':          cita['cedula'] ?? '—',
                                'fecha':           cita['fecha'],
                                'hora_inicio':     cita['hora_inicio'],
                                'hora_fin':        cita['hora_fin'],
                                'estado':          cita['estado'],
                              });
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DetalleCitaView(),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  // Borde color izquierdo
                                  Container(
                                    width: 4,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: colorE,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cita['nombre_paciente'] ?? 'Sin Nombre',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${cita['fecha']}  ${cita['hora_inicio']} - ${cita['hora_fin']}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Badge estado
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colorE,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      estadoVisual.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.chevron_right,
                                      color: Colors.black38, size: 18),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// WIDGETS AUXILIARES
// ─────────────────────────────────────────

class DateSelectorWidget extends StatelessWidget {
  final String label;
  final String dateValue;
  final VoidCallback onTap;
  const DateSelectorWidget({
    super.key,
    required this.label,
    required this.dateValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 65,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.fieldBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "[$dateValue]",
                      style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.calendar_today, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StatRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const StatRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}