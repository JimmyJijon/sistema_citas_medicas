import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/core/models/usuario_model.dart';
import 'package:sistema_citas_medicas/features/usuarios/viewmodels/usuario_viewmodel.dart';
import 'package:sistema_citas_medicas/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:sistema_citas_medicas/features/citas/widgets/app_header.dart';

class UsuarioFormScreen extends StatefulWidget {
  final Usuario? usuarioParaEditar;

  const UsuarioFormScreen({super.key, this.usuarioParaEditar});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _nombreController    = TextEditingController();
  final _apellidoController  = TextEditingController();
  final _correoController    = TextEditingController();
  final _passwordController  = TextEditingController();
  final _confirmController   = TextEditingController();

  String _rol    = 'Recepcionista';
  String _estado = 'A';
  bool _obscurePass    = true;
  bool _obscureConfirm = true;
  bool get _esEdicion => widget.usuarioParaEditar != null;

  @override
  void initState() {
    super.initState();
    if (_esEdicion) {
      final u = widget.usuarioParaEditar!;
      _nombreController.text   = u.nombre;
      _apellidoController.text = u.apellido;
      _correoController.text   = u.correo;
      _rol    = u.rol;
      _estado = u.estado;
      // No precargamos contraseña por seguridad
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // VALIDACIONES
  // ─────────────────────────────────────────

  String? _validar() {
    if (_nombreController.text.trim().isEmpty)   return 'El nombre es requerido.';
    if (_apellidoController.text.trim().isEmpty) return 'El apellido es requerido.';
    if (_correoController.text.trim().isEmpty)   return 'El usuario/correo es requerido.';
    if (!_esEdicion && _passwordController.text.isEmpty) {
      return 'La contraseña es requerida.';
    }
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmController.text) {
      return 'Las contraseñas no coinciden.';
    }
    return null;
  }

  // ─────────────────────────────────────────
  // GUARDAR
  // ─────────────────────────────────────────

  Future<void> _guardar() async {
    final error = _validar();
    if (error != null) {
      _mostrarSnack(error, Colors.orange);
      return;
    }

    final vm = context.read<UsuarioViewModel>();
    bool exito;

    if (_esEdicion) {
      exito = await vm.actualizarUsuario(
        usuarioOriginal: widget.usuarioParaEditar!,
        nombre:   _nombreController.text,
        apellido: _apellidoController.text,
        correo:   _correoController.text,
        password: _passwordController.text,
        rol:      _rol,
        estado:   _estado,
      );
    } else {
      exito = await vm.crearUsuario(
        nombre:   _nombreController.text,
        apellido: _apellidoController.text,
        correo:   _correoController.text,
        password: _passwordController.text,
        rol:      _rol,
      );
    }

    if (!mounted) return;

    if (exito) {
      _mostrarSnack(
        _esEdicion ? 'Usuario actualizado' : 'Usuario creado',
        Colors.green,
      );
      Navigator.pop(context);
    } else {
      _mostrarSnack(vm.errorMessage ?? 'Error al guardar', Colors.red);
    }
  }

  void _mostrarSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsuarioViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppHeader(
            title: _esEdicion
                ? "Inicio / Usuarios / Editar"
                : "Inicio / Usuarios / Nuevo",
          ),

          // Botón Volver
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
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
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Volver",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          _esEdicion ? "Editar Usuario" : "Nuevo Usuario",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Campos
                    _buildLabel("Nombre"),
                    _buildCampo("Ej: Juan", _nombreController, Icons.person_outline),
                    _buildLabel("Apellido"),
                    _buildCampo("Ej: Pérez", _apellidoController, Icons.person_outline),
                    _buildLabel("Usuario / Correo"),
                    _buildCampo("Ej: juan.perez", _correoController, Icons.account_circle_outlined),

                    const SizedBox(height: 4),

                    // Rol — solo Recepcionista en creación
                    _buildLabel("Rol"),
                    _buildDropdown(
                      valor: _rol,
                      items: _esEdicion
                          ? const ['Doctor', 'Recepcionista']
                          : const ['Recepcionista'],
                      itemLabels: _esEdicion
                          ? const ['Doctor', 'Recepcionista']
                          : const ['Recepcionista'],
                      icono: Icons.badge_outlined,
                      hint: "Seleccionar rol",
                      onChanged: (v) => setState(() => _rol = v!),
                    ),

                    // Estado (solo en edición)
                    if (_esEdicion) ...[
                      const SizedBox(height: 4),
                      _buildLabel("Estado"),
                      Builder(builder: (ctx) {
                        final idActual = ctx.read<AuthViewModel>().usuarioActual?.idUsuario;
                        final esSesionActual = widget.usuarioParaEditar?.idUsuario == idActual;
                        if (esSesionActual) {
                          // Mostrar campo bloqueado — no puede inactivarse a sí mismo
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.fieldBlue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lock_outline, size: 18, color: Colors.black38),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    "No puedes cambiar el estado de tu propia cuenta",
                                    style: TextStyle(fontSize: 12, color: Colors.black45),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildDropdown(
                          valor: _estado,
                          items: const ['A', 'I'],
                          itemLabels: const ['Activo', 'Inactivo'],
                          icono: Icons.toggle_on_outlined,
                          hint: "Seleccionar estado",
                          onChanged: (v) => setState(() => _estado = v!),
                        );
                      }),
                    ],

                    const SizedBox(height: 4),

                    // Contraseña
                    _buildLabel(_esEdicion
                        ? "Nueva contraseña (vacío = sin cambios)"
                        : "Contraseña"),
                    _buildCampoPassword(
                      hint: "••••••••",
                      controller: _passwordController,
                      obscure: _obscurePass,
                      onToggle: () => setState(() => _obscurePass = !_obscurePass),
                    ),

                    const SizedBox(height: 4),

                    _buildLabel("Confirmar contraseña"),
                    _buildCampoPassword(
                      hint: "••••••••",
                      controller: _confirmController,
                      obscure: _obscureConfirm,
                      onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),

                    const SizedBox(height: 25),

                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.btnRed,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.btnGreen,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: vm.isLoading ? null : _guardar,
                            child: vm.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    _esEdicion ? "Actualizar" : "Guardar",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                          ),
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
  // WIDGETS HELPERS
  // ─────────────────────────────────────────

  Widget _buildLabel(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCampo(String hint, TextEditingController controller, IconData icono) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: _inputDecoration(hint, icono),
      ),
    );
  }

  Widget _buildCampoPassword({
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textAlignVertical: TextAlignVertical.center,
        decoration: _inputDecoration(hint, Icons.lock_outline).copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.black45,
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String valor,
    required List<String> items,
    List<String>? itemLabels,
    required IconData icono,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: valor,
        decoration: _inputDecoration(hint, icono),
        borderRadius: BorderRadius.circular(15),
        isExpanded: true,
        items: items.asMap().entries.map((e) {
          final display = itemLabels != null ? itemLabels[e.key] : e.value;
          return DropdownMenuItem(
            value: e.value,
            child: Text(display, style: const TextStyle(fontSize: 13)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icono) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Colors.black45),
      prefixIcon: Icon(icono, color: Colors.black45, size: 20),
      filled: true,
      fillColor: AppColors.fieldBlue,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    );
  }
}