import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/core/widgets/clinic_logo.dart';
import 'package:sistema_citas_medicas/features/reportes/viewmodels/reportes_viewmodel.dart';

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

  // --- LÓGICA DE SELECCIÓN DE FECHA ---
  Future<void> _pickDateTime(
    BuildContext context,
    bool isDesde,
    ReportesViewModel viewModel,
  ) async {
    final DateTime initialDate = isDesde
        ? viewModel.desdeDateTime
        : viewModel.hastaDateTime;
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
          // EXPANDED + LAYOUTBUILDER: La clave para la responsividad
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                            // Botón Volver
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

                            // Banner de Título
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

                            // Selectores de Fecha
                            DateSelectorWidget(
                              label: "Desde:",
                              dateValue: viewModel.formatDateTime(
                                viewModel.desdeDateTime,
                              ),
                              onTap: () =>
                                  _pickDateTime(context, true, viewModel),
                            ),
                            const SizedBox(height: 12),
                            DateSelectorWidget(
                              label: "Hasta:",
                              dateValue: viewModel.formatDateTime(
                                viewModel.hastaDateTime,
                              ),
                              onTap: () =>
                                  _pickDateTime(context, false, viewModel),
                            ),
                            const SizedBox(height: 25),

                            // Botón Generar
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.btnGreen,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Cuadro de Resultados
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
                                    value: viewModel.totalCitas
                                        .toString()
                                        .padLeft(2, '0'),
                                    isTotal: true,
                                  ),
                                  const Divider(),
                                  StatRowWidget(
                                    label: "Completadas:",
                                    value: viewModel.completadas
                                        .toString()
                                        .padLeft(2, '0'),
                                  ),
                                  StatRowWidget(
                                    label: "Canceladas:",
                                    value: viewModel.canceladas
                                        .toString()
                                        .padLeft(2, '0'),
                                  ),
                                  StatRowWidget(
                                    label: "Reagendadas:",
                                    value: viewModel.reagendadas
                                        .toString()
                                        .padLeft(2, '0'),
                                  ),
                                  StatRowWidget(
                                    label: "En espera:",
                                    value: viewModel.enEspera
                                        .toString()
                                        .padLeft(2, '0'),
                                  ),
                                  StatRowWidget(
                                    label: "No atendidas:",
                                    value: viewModel.noAtendidas
                                        .toString()
                                        .padLeft(2, '0'),
                                  ),
                                ],
                              ),
                            ),

                            // Espacio flexible que empuja el último botón al fondo si hay espacio
                            const Spacer(),
                            const SizedBox(height: 20),

                            // Botón Ver Listado
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF19C5D0),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
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

  // --- HEADER SE MANTIENE FIJO ---
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

  // --- MODAL DETALLE (CORREGIDO) ---
  void _mostrarModalListado(
    BuildContext context,
    List<Map<String, dynamic>> citas,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                      itemBuilder: (context, index) {
                        final cita = citas[index];

                        // 1. OBTENEMOS DATOS DE LA CITA
                        final String estadoBD = (cita['estado'] ?? '')
                            .toString()
                            .toLowerCase();
                        final String fechaStr = cita['fecha']; // YYYY-MM-DD
                        final String horaFinStr = cita['hora_fin']; // HH:mm

                        // 2. LÓGICA TEMPORAL (Igual a la del ViewModel)
                        final ahora = DateTime.now();
                        final momentoFinCita = DateTime.parse(
                          "$fechaStr $horaFinStr",
                        );

                        // 3. DEFINIMOS COLOR Y TEXTO VISUAL
                        Color colorE = Colors.grey;
                        String labelE = "NO ATENDIDA";

                        if (estadoBD == 'completada') {
                          colorE = Colors.green;
                          labelE = "COMPLETADA";
                        } else if (estadoBD == 'cancelada') {
                          colorE = Colors.red;
                          labelE = "CANCELADA";
                        } else if (estadoBD == 'reagendada') {
                          colorE = Colors.orange;
                          labelE = "REAGENDADA";
                        } else if (estadoBD == 'ingresada' ||
                            estadoBD == 'en espera') {
                          // Si el estado es ingresada, verificamos si ya expiró
                          if (ahora.isAfter(momentoFinCita)) {
                            colorE = Colors
                                .grey; // Color para las que se pasaron de hora
                            labelE = "NO ATENDIDA";
                          } else {
                            colorE = Colors
                                .orange; // Color para las que aún están a tiempo
                            labelE = "EN ESPERA";
                          }
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade100),
                          ),
                          child: ListTile(
                            title: Text(
                              cita['nombre_paciente'] ?? 'Sin Nombre',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Dr: ${cita['nombre_doctor']}\n${cita['fecha']} | ${cita['hora_inicio']} - ${cita['hora_fin']}",
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorE,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                labelE,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

// --- WIDGETS AUXILIARES RESPONSIVOS ---

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
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                      ),
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
