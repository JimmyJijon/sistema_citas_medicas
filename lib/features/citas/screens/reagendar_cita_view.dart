import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/citas/viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/auth/viewmodels/auth_viewmodel.dart';
import '../widgets/app_header.dart';
import '../widgets/section_title.dart';
import '../widgets/detail_info_row.dart';
import '../widgets/observation_input.dart';
import '../widgets/reagendar_widgets/reschedule_input_row.dart';
import '../widgets/reagendar_widgets/reschedule_action_buttons.dart';

class ReagendarCitaView extends StatefulWidget {
  const ReagendarCitaView({Key? key}) : super(key: key);

  @override
  State<ReagendarCitaView> createState() => _ReagendarCitaViewState();
}

class _ReagendarCitaViewState extends State<ReagendarCitaView> {
  late DateTime _nuevaFecha;
  String? _nuevaFranja;
  final TextEditingController _motivoController = TextEditingController();

  // TODO: Reemplazar con usuario de sesión al integrar auth

  @override
  void initState() {
    super.initState();
    _nuevaFecha = DateTime.now();
  }

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

  String _formatDate(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";

  // ─────────────────────────────────────────
  // CALENDARIO
  // ─────────────────────────────────────────

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nuevaFecha,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2E7D32),
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null && picked != _nuevaFecha) {
      setState(() {
        _nuevaFecha = picked;
        _nuevaFranja = null; // Reset franja al cambiar fecha
      });
    }
  }

  // ─────────────────────────────────────────
  // CONFIRMAR REAGENDAMIENTO
  // ─────────────────────────────────────────

  Future<void> _confirmarReagendar() async {
    final motivo = _motivoController.text.trim();

    if (_nuevaFranja == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una nueva franja horaria'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (motivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el motivo del reagendamiento'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final vm = context.read<CitaViewModel>();
    final exito = await vm.reagendarCita(
      nuevaFecha: _nuevaFecha,
      nuevaHoraInicio: _nuevaFranja!,
      idUsuario: context.read<AuthViewModel>().usuarioActual?.idUsuario ?? 1,
      motivo: motivo,
    );

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita reagendada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Error al reagendar la cita'),
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
          const AppHeader(title: "Inicio / Agenda / Reagendar Cita"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Título
                  const SectionTitle(title: "Reagendar Cita"),

                  // 2. Info actual de la cita
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
                          label: "Fecha actual",
                          value: _formatearFecha(cita['fecha'] ?? ''),
                        ),
                        DetailInfoRow(
                          label: "Franja actual",
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

                  // 3. Nueva fecha
                  RescheduleInputRow(
                    label: "Nueva Fecha:",
                    value: _formatDate(_nuevaFecha),
                    onTap: _selectDate,
                  ),

                  // 4. Nueva franja — usa las franjas del ViewModel
                  RescheduleInputRow(
                    label: "Nueva Franja:",
                    customChild: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _nuevaFranja,
                        hint: const Text(
                          "Seleccionar...",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        // Franjas vienen del ViewModel (mismas que al registrar)
                        items: vm.franjasHorarias
                            .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                            .toList(),
                        onChanged: (v) => setState(() => _nuevaFranja = v),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 5. Motivo
                  const SectionTitle(title: "Motivo del reagendamiento"),
                  ObservationInput(
                    hintText: "Describe el motivo del reagendamiento...",
                    controller: _motivoController,
                  ),

                  const SizedBox(height: 30),

                  // 6. Botones
                  vm.isLoading
                      ? const CircularProgressIndicator()
                      : RescheduleActionButtons(
                          onConfirm: _confirmarReagendar,
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