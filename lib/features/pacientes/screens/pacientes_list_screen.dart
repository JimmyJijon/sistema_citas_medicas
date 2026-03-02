import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/pacientes/viewmodels/pacientes_viewmodel.dart';
import 'package:sistema_citas_medicas/features/pacientes/models/paciente_model.dart';
import 'package:sistema_citas_medicas/features/pacientes/widgets/campo_formulario_widget.dart';

class PacientesListScreen extends StatelessWidget {
  const PacientesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PacientesViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // --- HEADER ---
          _buildHeader(),

          // --- BOTÓN VOLVER ---
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildBotonVolver(context),
            ),
          ),

          const SizedBox(height: 10),

          // --- CONTENEDOR BLANCO REDONDEADO ---
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildSectionTitle('Gestión de Pacientes'),
                          const SizedBox(height: 15),

                          _buildBotonNuevo(context, vm),
                          const SizedBox(height: 20),

                          _buildSearchBar(vm),
                          const SizedBox(height: 20),

                          // --- LISTADO DE TARJETAS ---
                          vm.pacientes.isEmpty
                              ? const Center(
                                  child: Text('No hay pacientes registrados'),
                                )
                              : Column(
                                  children: vm.pacientes.map((paciente) {
                                    return _buildPacienteCard(
                                      context,
                                      paciente,
                                      vm,
                                    );
                                  }).toList(),
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

  // --- COMPONENTES DE INTERFAZ ---

  Widget _buildHeader() {
    return Container(
      color: AppColors.header,
      padding: const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[400],
            radius: 20,
            child: const Text(
              'logo',
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.fieldBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Inicio / Gestión / Pacientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildBotonNuevo(BuildContext context, PacientesViewModel vm) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _mostrarDialogoFormulario(context, vm),
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          'Nuevo Paciente',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnGreen,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(PacientesViewModel vm) {
    return TextField(
      onChanged: (value) => vm.filtrarPacientes(value),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o cédula...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[100],
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
    // Verificamos si el paciente está inactivo
    final bool esInactivo = paciente.estado == 'Inactivo';

    // Usamos Opacity para dar el efecto de desvanecido
    return Opacity(
      opacity: esInactivo ? 0.5 : 1.0, // 50% de opacidad si es inactivo
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: esInactivo ? Colors.grey.shade100 : Colors.white, // Fondo un poco más gris si es inactivo
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.fieldBlue.withOpacity(0.3),
              child: Text(
                paciente.nombres.isNotEmpty ? paciente.nombres[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${paciente.nombres} ${paciente.apellidos}'.trim(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: esInactivo ? TextDecoration.lineThrough : null, // Opcional: tachar el nombre
                    ),
                  ),
                  Text(
                    '${paciente.cedula} • ${paciente.estado}',
                    style: TextStyle(
                      color: esInactivo ? Colors.redAccent : Colors.grey[600], 
                      fontSize: 12,
                      fontWeight: esInactivo ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueGrey),
              onPressed: () => _mostrarDialogoFormulario(
                context,
                vm,
                paciente: paciente,
              ),
            ),
            // Solo mostramos el botón de eliminar si el paciente ESTÁ ACTIVO
            if (!esInactivo)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  _mostrarDialogoConfirmacion(context, paciente, vm);
                },
              ),
          ],
        ),
      ),
    );
  }

  // --- LÓGICA DE FORMULARIO Y VALIDACIONES ---

  void _mostrarDialogoFormulario(
    BuildContext context,
    PacientesViewModel vm, {
    PacienteModel? paciente,
  }) {
    final bool esEdicion = paciente != null;

    final nombreCtrl = TextEditingController(text: paciente?.nombres);
    final apellidosCtrl = TextEditingController(text: paciente?.apellidos);
    final cedulaCtrl = TextEditingController(text: paciente?.cedula);
    final telefonoCtrl = TextEditingController(text: paciente?.telefono);
    final correoCtrl = TextEditingController(text: paciente?.correo);
    
    // Guardamos el estado actual si es edición, o asignamos 'Activo' por defecto si es nuevo
    final String estadoSeleccionado = paciente?.estado ?? 'Activo';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Text(
            esEdicion ? 'Editar Paciente' : 'Nuevo Paciente',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CampoFormulario(
                  label: 'Nombres',
                  hint: 'Ej: Juan Pablo',
                  controller: nombreCtrl,
                  soloLetras: true,
                ),
                const SizedBox(height: 10),
                CampoFormulario(
                  label: 'Apellidos',
                  hint: 'Ej: Pérez Gómez',
                  controller: apellidosCtrl,
                  soloLetras: true,
                ),
                const SizedBox(height: 10),
                CampoFormulario(
                  label: 'Cédula',
                  hint: 'Ej: 0102030405',
                  controller: cedulaCtrl,
                  soloNumeros: true,
                ),
                const SizedBox(height: 10),
                CampoFormulario(
                  label: 'Teléfono',
                  hint: 'Ej: 0991234567',
                  controller: telefonoCtrl,
                  soloNumeros: true,
                ),
                const SizedBox(height: 10),
                CampoFormulario(
                  label: 'Correo',
                  hint: 'Ej: juan@email.com',
                  controller: correoCtrl,
                ),
                // Eliminamos la fila del DropdownButton de Estado. El usuario ya no lo ve.
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: AppColors.btnRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (nombreCtrl.text.trim().isEmpty ||
                          apellidosCtrl.text.trim().isEmpty ||
                          cedulaCtrl.text.trim().isEmpty ||
                          telefonoCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, llene todos los campos obligatorios.',
                            ),
                          ),
                        );
                        return;
                      }

                      final p = PacienteModel(
                        idPaciente: paciente?.idPaciente,
                        cedula: cedulaCtrl.text,
                        nombres: nombreCtrl.text,
                        apellidos: apellidosCtrl.text,
                        telefono: telefonoCtrl.text,
                        correo: correoCtrl.text,
                        estado: estadoSeleccionado, // Se asigna el estado silenciosamente
                      );
                      
                      if (esEdicion) {
                        vm.editarPaciente(p);
                      } else {
                        vm.agregarPaciente(p);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      esEdicion ? 'Actualizar' : 'Guardar',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- AVISO DE CONFIRMACIÓN PARA ELIMINAR ---
  void _mostrarDialogoConfirmacion(
    BuildContext context,
    PacienteModel paciente,
    PacientesViewModel vm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: const Text(
          'Eliminar Paciente',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${paciente.nombres} ${paciente.apellidos}?\n\nEsta acción no lo borrará por completo, solo lo marcará como inactivo.',
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: AppColors.btnRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    vm.eliminarPaciente(paciente);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Paciente eliminado correctamente'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}