import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/citas/viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/auth/viewmodels/auth_viewmodel.dart';
import '../widgets/app_header.dart';
import '../widgets/section_title.dart';
import '../widgets/detail_info_row.dart';
import '../widgets/observation_input.dart';
import '../widgets/cancelar_cita_widgets/cancel_action_buttons.dart';

class CancelarCitaView extends StatefulWidget {
  const CancelarCitaView({Key? key}) : super(key: key);

  @override
  State<CancelarCitaView> createState() => _CancelarCitaViewState();
}

class _CancelarCitaViewState extends State<CancelarCitaView> {
  final TextEditingController _motivoController = TextEditingController();

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
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

  // ─────────────────────────────────────────
  // CONFIRMAR CANCELACIÓN
  // ─────────────────────────────────────────

  Future<void> _confirmarCancelacion() async {
    final motivo = _motivoController.text.trim();

    if (motivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el motivo de la cancelación'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final vm = context.read<CitaViewModel>();
    final exito = await vm.registrarAccionEnHistorial(
      idUsuario: context.read<AuthViewModel>().usuarioActual?.idUsuario ?? 1,
      nuevoEstado: 'Cancelada',
      descripcion: motivo,
    );

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita cancelada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Error al cancelar la cita'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CitaViewModel>();
    final cita = vm.citaSeleccionada;

    if (cita == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header
          const AppHeader(title: "Inicio / Agenda / Cancelar cita"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 2. Título
                  const SectionTitle(title: "Cancelar Cita"),

                  // 3. Info de la cita
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
                          label: "Paciente",
                          value: cita['nombre_paciente'] ?? '—',
                        ),
                        DetailInfoRow(
                          label: "Fecha",
                          value: _formatearFecha(cita['fecha'] ?? ''),
                        ),
                        DetailInfoRow(
                          label: "Franja horaria",
                          value: "${cita['hora_inicio']} - ${cita['hora_fin']}",
                        ),
                        DetailInfoRow(
                          label: "Estado Actual",
                          value: cita['estado'] ?? '—',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Motivo
                  const SectionTitle(title: "Motivo de la cancelación"),

                  // 5. Input con controller
                  ObservationInput(
                    hintText: "Describe el motivo de la cancelación...",
                    controller: _motivoController,
                  ),

                  const SizedBox(height: 30),

                  // 6. Botones
                  vm.isLoading
                      ? const CircularProgressIndicator()
                      : CancelActionButtons(
                          onConfirmCancel: _confirmarCancelacion,
                          onAbort: () => Navigator.pop(context),
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