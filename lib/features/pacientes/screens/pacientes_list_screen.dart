import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/pacientes/viewmodels/pacientes_viewmodel.dart';
import 'package:sistema_citas_medicas/features/pacientes/models/paciente_model.dart';

class PacientesListScreen extends StatelessWidget {
  const PacientesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PacientesViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildBotonVolver(context),
            ),
          ),
          const SizedBox(height: 10),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSectionTitle('Gestión de Pacientes'),
                    const SizedBox(height: 15),
                    _buildBotonNuevo(context),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    vm.pacientes.isEmpty
                        ? const Text('No hay pacientes registrados')
                        : Column(
                            children: vm.pacientes.asMap().entries.map((entry) {
                              return _buildPacienteCard(context, entry.value, entry.key, vm);
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

  // --- COMPONENTES DE DISEÑO ---

  Widget _buildHeader() {
    return Container(
      color: AppColors.header,
      padding: const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[400],
            radius: 20,
            child: const Text('logo', style: TextStyle(fontSize: 10, color: Colors.black)),
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
      child: const Text('Volver', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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

  Widget _buildBotonNuevo(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _dialogoFormulario(context),
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Nuevo Paciente', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnGreen,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar paciente...',
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

  Widget _buildPacienteCard(BuildContext context, PacienteModel paciente, int index, PacientesViewModel vm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.fieldBlue.withOpacity(0.3),
            child: Text(paciente.nombre[0], style: const TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(paciente.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${paciente.cedula} • ${paciente.estado}', 
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueGrey),
            onPressed: () => _dialogoFormulario(context, paciente: paciente, index: index),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => vm.eliminarPaciente(index),
          ),
        ],
      ),
    );
  }

  // --- DIÁLOGO PARA CREAR Y EDITAR ---

  void _dialogoFormulario(BuildContext context, {PacienteModel? paciente, int? index}) {
    final bool esEdicion = paciente != null;
    final TextEditingController nombreCtrl = TextEditingController(text: paciente?.nombre);
    final TextEditingController cedulaCtrl = TextEditingController(text: paciente?.cedula);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          esEdicion ? 'Editar Paciente' : 'Nuevo Paciente',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _campoTexto('Nombres', 'Ej: Juan Perez', nombreCtrl),
            const SizedBox(height: 15),
            _campoTexto('Cédula', 'Ej: 09XXXXXXXX', cedulaCtrl),
          ],
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: TextStyle(color: AppColors.btnRed, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    if (nombreCtrl.text.isNotEmpty && cedulaCtrl.text.isNotEmpty) {
                      final p = PacienteModel(
                        nombre: nombreCtrl.text,
                        cedula: cedulaCtrl.text,
                        telefono: paciente?.telefono ?? 'S/N',
                        estado: paciente?.estado ?? 'Activo',
                      );
                      
                      if (esEdicion) {
                        Provider.of<PacientesViewModel>(context, listen: false).editarPaciente(index!, p);
                      } else {
                        Provider.of<PacientesViewModel>(context, listen: false).agregarPaciente(p);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(esEdicion ? 'Actualizar' : 'Guardar', 
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _campoTexto(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}