import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/citas/viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/auth/viewmodels/auth_viewmodel.dart';
import '../widgets/app_header.dart';
import '../widgets/section_title.dart';
import '../widgets/detail_info_row.dart';
import '../widgets/observation_input.dart';
import '../widgets/marcar_cita_widgets/status_change_row.dart';
import '../widgets/marcar_cita_widgets/form_action_buttons.dart';

class MarcarCitaView extends StatefulWidget {
  const MarcarCitaView({Key? key}) : super(key: key);

  @override
  State<MarcarCitaView> createState() => _MarcarCitaViewState();
}

class _MarcarCitaViewState extends State<MarcarCitaView> {
  final TextEditingController _observacionController = TextEditingController();

  // TODO: Reemplazar con usuario de sesión al integrar auth

  @override
  void dispose() {
    _observacionController.dispose();
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
  // CONFIRMAR MARCAR COMO COMPLETADA
  // ─────────────────────────────────────────

  Future<void> _confirmarMarcar() async {
    final observacion = _observacionController.text.trim();

    if (observacion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa una observación o resultado de la cita'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final vm = context.read<CitaViewModel>();
    final exito = await vm.registrarAccionEnHistorial(
      idUsuario: context.read<AuthViewModel>().usuarioActual?.idUsuario ?? 1,
      nuevoEstado: 'Completada',
      descripcion: observacion,
    );

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Cita marcada como completada'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Error al marcar la cita'),
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
          const AppHeader(title: "Inicio / Agenda / Marcar Cita"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 2. Título
                  const SectionTitle(title: "Marcar Cita"),

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

                  // 4. Nuevo estado (siempre Completada)
                  const StatusChangeRow(
                    label: "Nuevo Estado:",
                    value: "Completada",
                  ),

                  const SizedBox(height: 20),

                  // 5. Observación
                  const SectionTitle(title: "Observación / resultado de la cita"),
                  ObservationInput(
                    hintText: "Describe el resultado o notas de la cita...",
                    controller: _observacionController,
                  ),

                  const SizedBox(height: 30),

                  // 6. Botones
                  vm.isLoading
                      ? const CircularProgressIndicator()
                      : FormActionButtons(
                          onConfirm: _confirmarMarcar,
                          onCancel: () => Navigator.pop(context),
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