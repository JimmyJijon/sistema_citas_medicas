import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/auth/viewmodels/auth_viewmodel.dart';
import '../widgets/app_header.dart';
import '../widgets/registrar_cita_widgets/form_label_field.dart';
import '../widgets/registrar_cita_widgets/custom_input_container.dart';
import '../widgets/registrar_cita_widgets/paciente_selector.dart';
import '../widgets/registrar_cita_widgets/hora_selector.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class RegistrarCitaView extends StatefulWidget {
  const RegistrarCitaView({Key? key}) : super(key: key);

  @override
  State<RegistrarCitaView> createState() => _RegistrarCitaViewState();
}

class _RegistrarCitaViewState extends State<RegistrarCitaView> {
  final TextEditingController _observacionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargamos pacientes y franjas al abrir la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CitaViewModel>().inicializarRegistro();
    });
  }

  @override
  void dispose() {
    _observacionController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // CALENDARIO
  // ─────────────────────────────────────────

  Future<void> _abrirCalendario(CitaViewModel vm) async {
    final fechaEscogida = await showDatePicker(
      context: context,
      initialDate: vm.fechaSeleccionada,
      firstDate: DateTime.now(), // No permite fechas pasadas
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.fieldBlue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.btnGreen,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

      if (fechaEscogida != null) {
        await vm.setFecha(fechaEscogida);
      }
  }

  // ─────────────────────────────────────────
  // GUARDAR
  // ─────────────────────────────────────────

  Future<void> _guardar(CitaViewModel vm) async {
    final authVm = context.read<AuthViewModel>();
    final idUsuario = authVm.usuarioActual?.idUsuario ?? 1;

    vm.setObservacion(_observacionController.text.trim());
    final exito = await vm.guardarCita(idUsuario);

    if (!mounted) return;

    if (exito) {
      _observacionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita registrada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Error al guardar la cita'),
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

    final textoFecha =
        "${vm.fechaSeleccionada.day.toString().padLeft(2, '0')}/"
        "${vm.fechaSeleccionada.month.toString().padLeft(2, '0')}/"
        "${vm.fechaSeleccionada.year}";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(title: "Inicio / Registrar Cita"),

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // ── Título ──
                          _buildTitulo("Registrar Cita"),

                          // ── 1. Paciente (con buscador) ──
                          const PacienteSelector(),

                          const SizedBox(height: 10),

                          // ── 2. Cédula (auto) ──
                          FormLabelField(
                            label: "Cédula",
                            child: CustomInputContainer(
                              isReadOnly: true,
                              child: Text(
                                vm.pacienteSeleccionado?.cedula ?? '—',
                              ),
                            ),
                          ),

                          // ── 3. Teléfono (auto) ──
                          FormLabelField(
                            label: "Teléfono",
                            child: CustomInputContainer(
                              isReadOnly: true,
                              child: Text(
                                vm.pacienteSeleccionado?.telefono ?? '—',
                              ),
                            ),
                          ),

                          // ── 4. Fecha ──
                          FormLabelField(
                            label: "Fecha",
                            child: CustomInputContainer(
                              onTap: () => _abrirCalendario(vm),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(textoFecha),
                                  const Icon(Icons.calendar_today, size: 18),
                                ],
                              ),
                            ),
                          ),

                          // ── 5. Franja Horaria ──
                          FormLabelField(
                            label: "Franja Horaria",
                            child: HoraSelector(),
                          ),

                          // Mensaje cuando no hay franjas disponibles
                          if (vm.mensajeFranjas != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline,
                                      size: 14, color: Colors.orange),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      vm.mensajeFranjas!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 10),

                          // ── 7. Observación ──
                          _buildTitulo("Observación"),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _observacionController,
                              maxLines: 3,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: "Escriba una descripción...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ── Botones ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: vm.formularioValido
                                      ? AppColors.btnGreen
                                      : Colors.grey,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                ),
                                onPressed: vm.isLoading || !vm.formularioValido
                                    ? null
                                    : () => _guardar(vm),
                                child: vm.isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white),
                                      )
                                    : const Text("Guardar"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.btnRed,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancelar"),
                              ),
                            ],
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

  // ─────────────────────────────────────────
  // HELPER WIDGET
  // ─────────────────────────────────────────

  Widget _buildTitulo(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}