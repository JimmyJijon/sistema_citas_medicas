import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- NOTA: Asegúrate de que estas rutas coincidan con tu proyecto ---
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/reportes/viewmodels/reportes_viewmodel.dart';

// 1. EL ENVOLTORIO (Stateless)
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

// 2. LA VISTA REAL
class _ReportesView extends StatelessWidget {
  const _ReportesView();

  // Función para seleccionar Fecha y Hora
  Future<void> _pickDateTime(BuildContext context, bool isDesde, ReportesViewModel viewModel) async {
    final DateTime initialDate = isDesde ? viewModel.desdeDateTime : viewModel.hastaDateTime;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.fieldBlue),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.fieldBlue),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final newDateTime = DateTime(
      pickedDate.year, pickedDate.month, pickedDate.day,
      pickedTime.hour, pickedTime.minute,
    );

    if (isDesde) {
      viewModel.setDesdeDateTime(newDateTime);
    } else {
      viewModel.setHastaDateTime(newDateTime);
    }
  }

  // --- FUNCIÓN PARA MOSTRAR EL LISTADO (MODAL) ---
  void _mostrarModalListado(BuildContext context, List<Map<String, dynamic>> citas) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Detalle de Citas Encontradas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: citas.isEmpty
                    ? const Center(child: Text("No hay registros para este rango."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: citas.length,
                        itemBuilder: (context, index) {
                          final cita = citas[index];
                          
                          // Lógica de color visual rápida
                          Color colorEstado = Colors.blueGrey;
                          if(cita['estado'].toString().toLowerCase() == 'completada') colorEstado = Colors.green;
                          if(cita['estado'].toString().toLowerCase() == 'cancelada') colorEstado = Colors.red;

                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: colorEstado.withOpacity(0.1),
                                child: Icon(Icons.person, color: colorEstado),
                              ),
                              title: Text("${cita['paciente']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("Dr: ${cita['doctor']}\n${cita['fecha']} | ${cita['hora']}"),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorEstado,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${cita['estado']}",
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReportesViewModel>();
    const Color btnCyanLocal = Color(0xFF19C5D0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.btnGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Volver", style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Reportes Estadísticos", style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),

                    DateSelectorWidget(
                      label: "Desde:",
                      dateValue: viewModel.formatDateTime(viewModel.desdeDateTime),
                      onTap: () => _pickDateTime(context, true, viewModel),
                    ),
                    const SizedBox(height: 10),
                    DateSelectorWidget(
                      label: "Hasta:",
                      dateValue: viewModel.formatDateTime(viewModel.hastaDateTime),
                      onTap: () => _pickDateTime(context, false, viewModel),
                    ),
                    const SizedBox(height: 20),

                    // BOTÓN GENERAR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnGreen,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          viewModel.generarReporte();
                        },
                        child: viewModel.isLoading 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                            : const Text("Generar Reporte", style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TABLA DE RESULTADOS
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                      ),
                      child: Column(
                        children: [
                          StatRowWidget(label: "Total de Citas:", value: viewModel.totalCitas.toString().padLeft(2, '0')),
                          const Divider(),
                          StatRowWidget(label: "Completadas:", value: viewModel.completadas.toString().padLeft(2, '0')),
                          StatRowWidget(label: "Canceladas:", value: viewModel.canceladas.toString().padLeft(2, '0')),
                          StatRowWidget(label: "Reagendadas:", value: viewModel.reagendadas.toString().padLeft(2, '0')),
                          StatRowWidget(label: "En espera:", value: viewModel.enEspera.toString().padLeft(2, '0')),
                          StatRowWidget(label: "No atendidas:", value: viewModel.noAtendidas.toString().padLeft(2, '0')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // BOTÓN VER LISTADO
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnCyanLocal,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () async {
                          // Llamamos a la carga de datos mock del viewmodel
                          await viewModel.cargarListadoDetalle();
                          if (context.mounted) {
                            _mostrarModalListado(context, viewModel.listadoCitasDetalle);
                          }
                        },
                        child: const Text("Ver Listado Detallado", style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[600],
                radius: 22,
                child: const Text("logo", style: TextStyle(fontSize: 10, color: Colors.black)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.fieldBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Inicio / Reporte",
                    style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS AUXILIARES ---

class DateSelectorWidget extends StatelessWidget {
  final String label;
  final String dateValue;
  final VoidCallback onTap;
  const DateSelectorWidget({super.key, required this.label, required this.dateValue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold))),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: AppColors.fieldBlue, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("[$dateValue]", style: const TextStyle(fontFamily: 'Courier', fontSize: 13)),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}

class StatRowWidget extends StatelessWidget {
  final String label;
  final String value;
  const StatRowWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
          Text(value, style: const TextStyle(fontFamily: 'Courier', fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}