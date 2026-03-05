import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/core/widgets/clinic_logo.dart';
import 'package:sistema_citas_medicas/features/pacientes/viewmodels/pacientes_viewmodel.dart';
import 'package:sistema_citas_medicas/features/pacientes/models/paciente_model.dart';
import 'package:sistema_citas_medicas/features/pacientes/screens/formulario_pacientes_screen.dart';

class PacientesListScreen extends StatelessWidget {
  const PacientesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PacientesViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // --- HEADER (FIJO) ---
          _buildHeader(),

          // --- BOTÓN VOLVER (FIJO) ---
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildBotonVolver(context),
            ),
          ),

          // --- CONTENEDOR PRINCIPAL ---
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // --- SECCIÓN ESTÁTICA (Título, Botón Nuevo y Buscador) ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      children: [
                        _buildSectionTitle('Gestión de Pacientes'),
                        const SizedBox(height: 15),
                        _buildBotonNuevo(context),
                        const SizedBox(height: 15),
                        _buildSearchBar(vm),
                      ],
                    ),
                  ),

                  // --- LISTADO (SCROLL INDEPENDIENTE) ---
                  Expanded(
                    child: vm.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.btnGreen),
                          )
                        : vm.pacientes.isEmpty
                            ? const Center(
                                child: Text(
                                  'No hay pacientes registrados',
                                  style: TextStyle(color: AppColors.textLight),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                itemCount: vm.pacientes.length,
                                itemBuilder: (context, index) {
                                  final paciente = vm.pacientes[index];
                                  return _buildPacienteCard(context, paciente, vm);
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES DE INTERFAZ ---

  Widget _buildHeader() {
    return Container(
      color: AppColors.header,
      padding: const EdgeInsets.only(top: 45, bottom: 15, left: 15, right: 15),
      child: Row(
        children: [
          ClinicLogo(size: 22, color: AppColors.accentColor),
          const SizedBox(width: 8),
          const Text(
            "CLÍNICA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.accentColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.fieldBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Inicio / Gestión / Pacientes',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 13, 
                  color: AppColors.textDark
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonVolver(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.btnGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: const Text(
        'Volver',
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.altBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 16, 
          color: AppColors.textDark
        ),
      ),
    );
  }

  Widget _buildBotonNuevo(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: context.read<PacientesViewModel>(),
                child: const FormularioPacienteScreen(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Paciente',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnGreen,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildSearchBar(PacientesViewModel vm) {
    return TextField(
      onChanged: (value) => vm.filtrarPacientes(value),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o cédula...',
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: AppColors.accentColor),
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPacienteCard(
    BuildContext context,
    PacienteModel paciente,
    PacientesViewModel vm,
  ) {
    final bool esInactivo = paciente.estado.toLowerCase() == 'inactivo';

    return Opacity(
      opacity: esInactivo ? 0.7 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: esInactivo ? Colors.grey.shade50 : AppColors.cardBg,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: esInactivo ? Colors.grey.shade300 : AppColors.accentColor.withOpacity(0.3),
          ),
          boxShadow: [
            if (!esInactivo)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: esInactivo 
                  ? Colors.grey.shade200 
                  : AppColors.accentColor.withOpacity(0.2),
              child: Text(
                paciente.nombres.isNotEmpty ? paciente.nombres[0].toUpperCase() : '?',
                style: TextStyle(
                  color: esInactivo ? Colors.grey : AppColors.textDark, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${paciente.nombres} ${paciente.apellidos}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: esInactivo ? Colors.grey : AppColors.textDark,
                      decoration: esInactivo ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    'C.I: ${paciente.cedula} • ${paciente.estado.toUpperCase()}',
                    style: TextStyle(
                      color: esInactivo ? Colors.grey : AppColors.textLight, 
                      fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit_outlined, 
                color: esInactivo ? Colors.grey : AppColors.buttonPrimary, 
                size: 22
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: context.read<PacientesViewModel>(),
                      child: FormularioPacienteScreen(paciente: paciente),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                esInactivo ? Icons.settings_backup_restore : Icons.delete_outline,
                color: esInactivo ? AppColors.btnGreen : AppColors.btnRed,
                size: 22,
              ),
              onPressed: () {
                if (esInactivo) {
                  _mostrarDialogoReactivacion(context, paciente, vm);
                } else {
                  _mostrarDialogoConfirmacion(context, paciente, vm);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- DIÁLOGOS ---

  void _mostrarDialogoConfirmacion(BuildContext context, PacienteModel paciente, PacientesViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: AppColors.cardBg,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Eliminar Paciente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
            const SizedBox(height: 15),
            Text(
              '¿Estás seguro de que deseas eliminar a ${paciente.nombres}?\n\nSolo se marcará como inactivo.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar', style: TextStyle(color: AppColors.btnRed)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      vm.eliminarPaciente(paciente);
                      Navigator.pop(context);
                    },
                    child: const Text('Eliminar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoReactivacion(BuildContext context, PacienteModel paciente, PacientesViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: AppColors.cardBg,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.settings_backup_restore, color: AppColors.btnGreen, size: 40),
            const SizedBox(height: 15),
            const Text('Reactivar Paciente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
            const SizedBox(height: 10),
            Text('¿Deseas activar nuevamente a ${paciente.nombres}?', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textLight)),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No, cancelar', style: TextStyle(color: AppColors.textLight)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      vm.activarPaciente(paciente);
                      Navigator.pop(context);
                    },
                    child: const Text('Activar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}