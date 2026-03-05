import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/core/models/usuario_model.dart';
import 'package:sistema_citas_medicas/features/usuarios/viewmodels/usuario_viewmodel.dart';
import 'package:sistema_citas_medicas/features/citas/widgets/app_header.dart';
import 'usuario_form_screen.dart';

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuarioViewModel>().cargarUsuarios();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _irAFormulario({Usuario? usuario}) async {
    final vm = context.read<UsuarioViewModel>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: vm,
          child: UsuarioFormScreen(usuarioParaEditar: usuario),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsuarioViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(title: "Inicio / Configuración / Usuarios"),

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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 5, 20, 20),
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
                children: [
                  // Título
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.fieldBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "Gestión de Usuarios",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Buscador + Botón Nuevo
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.fieldBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: vm.setFiltro,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              hintText: "Buscar por nombre, correo o rol...",
                              hintStyle: TextStyle(fontSize: 13, color: Colors.black45),
                              prefixIcon: Icon(Icons.search, size: 20, color: Colors.black45),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () => _irAFormulario(),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Nuevo", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Lista
                  Expanded(
                    child: vm.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : vm.usuariosFiltrados.isEmpty
                            ? const Center(
                                child: Text(
                                  "No se encontraron usuarios.",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              )
                            : ListView.separated(
                                itemCount: vm.usuariosFiltrados.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final u = vm.usuariosFiltrados[index];
                                  final activo = u.estado == 'A';
                                  return _UsuarioCard(
                                    usuario: u,
                                    onEditar: () => _irAFormulario(usuario: u),
                                    onToggleEstado: () => vm.cambiarEstado(u.idUsuario, u.estado),
                                  );
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
}

// ─────────────────────────────────────────
// CARD DE USUARIO
// ─────────────────────────────────────────

class _UsuarioCard extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback onEditar;
  final VoidCallback onToggleEstado;

  const _UsuarioCard({
    required this.usuario,
    required this.onEditar,
    required this.onToggleEstado,
  });

  Color get _colorRol {
    switch (usuario.rol) {
      case 'Doctor':        return const Color(0xFF42A5F5);
      case 'Recepcionista': return const Color(0xFF66BB6A);
      default:              return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activo = usuario.estado == 'A';

    return Container(
      decoration: BoxDecoration(
        color: activo ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          left: BorderSide(color: activo ? _colorRol : Colors.grey.shade300, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Avatar inicial
            CircleAvatar(
              backgroundColor: activo ? _colorRol.withOpacity(0.15) : Colors.grey.shade200,
              radius: 22,
              child: Text(
                usuario.nombre.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: activo ? _colorRol : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${usuario.nombre} ${usuario.apellido}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: activo ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    usuario.correo,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Badge rol
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _colorRol.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _colorRol.withOpacity(0.4)),
                        ),
                        child: Text(
                          usuario.rol,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _colorRol,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Badge estado
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: activo
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: activo
                                ? Colors.green.withOpacity(0.4)
                                : Colors.red.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          activo ? 'Activo' : 'Inactivo',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: activo ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Acciones
            Column(
              children: [
                // Editar
                Tooltip(
                  message: "Editar",
                  child: InkWell(
                    onTap: onEditar,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.edit_outlined, size: 18, color: Colors.blueGrey),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Activar / Inactivar
                Tooltip(
                  message: activo ? "Inactivar" : "Activar",
                  child: InkWell(
                    onTap: onToggleEstado,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: activo
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        activo ? Icons.person_off_outlined : Icons.person_outlined,
                        size: 18,
                        color: activo ? Colors.red : Colors.green,
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
}