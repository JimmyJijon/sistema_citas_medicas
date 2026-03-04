import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/citas/viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/citas/screens/cancelar_cita_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/detalle_cita_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/marcar_cita_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/reagendar_cita_view.dart';
import '../widgets/app_header.dart';
import '../widgets/agenda_widgets/agenda_filters.dart';
import '../widgets/agenda_widgets/agenda_appointment_card.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({Key? key}) : super(key: key);

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CitaViewModel>().cargarCitas();
    });
  }

  Future<void> _seleccionarFecha(bool esDesde) async {
    final vm = context.read<CitaViewModel>();
    final inicial = esDesde ? vm.filtroDesde : vm.filtroHasta;

    final picked = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.fieldBlue),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      esDesde ? vm.setFiltroDesde(picked) : vm.setFiltroHasta(picked);
    }
  }

  void _manejarAccion(String accion, Map<String, dynamic> cita) {
    context.read<CitaViewModel>().setCitaSeleccionada(cita);

    Widget destino;
    switch (accion) {
      case "ver":
        destino = const DetalleCitaView();
        break;
      case "reagendar":
        destino = const ReagendarCitaView();
        break;
      case "completar":
        destino = const MarcarCitaView();
        break;
      case "cancelar":
        destino = const CancelarCitaView();
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => destino)).then((
      _,
    ) {
      context.read<CitaViewModel>().cargarCitas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CitaViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(title: "Inicio / Agenda"),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, bottom: 5),
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
                      ),
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

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: AgendaFilters(
                            fechaDesde: vm.filtroDesde,
                            fechaHasta: vm.filtroHasta,
                            estadoSeleccionado: vm.filtroEstado,
                            onTapDesde: () => _seleccionarFecha(true),
                            onTapHasta: () => _seleccionarFecha(false),
                            onChangedEstado: vm.setFiltroEstado,
                            onChangedPaciente: vm.setFiltroPaciente,
                          ),
                        ),

                        const SizedBox(height: 25),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: AppColors.fieldBlue,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Listado de Citas",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        if (vm.citasFiltradas.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("No hay citas para este filtro."),
                          )
                        else
                          ...vm.citasFiltradas.map((cita) {
                            return AgendaAppointmentCard(
                              data: {
                                'fecha': _formatearFecha(cita['fecha']),
                                'hora':
                                    "${cita['hora_inicio']} - ${cita['hora_fin']}",
                                'paciente': cita['nombre_paciente'] ?? '—',
                                'estado': cita['estado'] ?? '—',
                              },
                              onAction: (accion) =>
                                  _manejarAccion(accion, cita),
                            );
                          }).toList(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

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
}
