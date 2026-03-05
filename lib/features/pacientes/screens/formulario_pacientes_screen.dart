import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/core/widgets/clinic_logo.dart'; // Asegúrate de tener este widget
import 'package:sistema_citas_medicas/features/pacientes/models/paciente_model.dart';
import 'package:sistema_citas_medicas/features/pacientes/viewmodels/pacientes_viewmodel.dart';

class FormularioPacienteScreen extends StatefulWidget {
  final PacienteModel? paciente;
  const FormularioPacienteScreen({super.key, this.paciente});

  @override
  State<FormularioPacienteScreen> createState() => _FormularioPacienteScreenState();
}

class _FormularioPacienteScreenState extends State<FormularioPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreCtrl;
  late TextEditingController apellidosCtrl;
  late TextEditingController cedulaCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController correoCtrl;
  String _estadoSeleccionado = 'Activo';

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.paciente?.nombres);
    apellidosCtrl = TextEditingController(text: widget.paciente?.apellidos);
    cedulaCtrl = TextEditingController(text: widget.paciente?.cedula);
    telefonoCtrl = TextEditingController(text: widget.paciente?.telefono);
    correoCtrl = TextEditingController(text: widget.paciente?.correo);
    if (widget.paciente != null) {
      _estadoSeleccionado = widget.paciente!.estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool esEdicion = widget.paciente != null;
    final vm = context.read<PacientesViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(esEdicion),

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: AppColors.loginCard,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          esEdicion ? 'Editar Paciente' : 'Registrar Paciente',
                          style: const TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: AppColors.textDark
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        _buildInputField('Nombre Completo', Icons.person_outline, nombreCtrl),
                        const SizedBox(height: 15),
                        _buildInputField('Apellidos', Icons.people_outline, apellidosCtrl),
                        const SizedBox(height: 15),
                        _buildInputField('Cédula', Icons.badge_outlined, cedulaCtrl, isNumeric: true),
                        const SizedBox(height: 15),
                        _buildInputField('Teléfono', Icons.phone_android_outlined, telefonoCtrl, isNumeric: true),
                        const SizedBox(height: 15),
                        _buildInputField('Correo', Icons.email_outlined, correoCtrl),
                        
                        const SizedBox(height: 35),

                        // --- BOTONES ---
                        Row(
                          children: [
                            Expanded(
                              child: _buildButton('Cancelar', AppColors.btnRed, () => Navigator.pop(context)),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildButton('Guardar', AppColors.btnGreen, () => _procesarGuardado(vm)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER CON EL DISEÑO DE TUS CAPTURAS
  Widget _buildHeader(bool esEdicion) {
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
              child: Text(
                esEdicion ? 'Inicio / Gestión / Editar' : 'Inicio / Gestión / Registro',
                style: const TextStyle(
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

  Widget _buildInputField(String hint, IconData icon, TextEditingController controller, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.accentColor),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.fieldBlue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  void _procesarGuardado(PacientesViewModel vm) {
    if (nombreCtrl.text.isEmpty || cedulaCtrl.text.isEmpty) return;

    final nuevoPaciente = PacienteModel(
      idPaciente: widget.paciente?.idPaciente,
      cedula: cedulaCtrl.text,
      nombres: nombreCtrl.text,
      apellidos: apellidosCtrl.text,
      telefono: telefonoCtrl.text,
      correo: correoCtrl.text,
      estado: _estadoSeleccionado,
    );

    if (widget.paciente != null) {
      vm.editarPaciente(nuevoPaciente);
    } else {
      vm.agregarPaciente(nuevoPaciente);
    }
    Navigator.pop(context);
  }
}