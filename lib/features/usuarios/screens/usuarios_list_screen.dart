import 'package:flutter/material.dart';
// Asumiendo que tienes estos archivos según los pasos anteriores.
// Si no, puedes copiar las clases AppHeader y AppColors al final de este archivo.
import 'package:sistema_citas_medicas/core/theme/app_colors.dart'; 
import 'package:sistema_citas_medicas/features/citas/widgets/app_header.dart'; 

// ==========================================
// 1. MODELO DE DATOS
// ==========================================
class Usuario {
  String nombre;
  String usuario;
  String rol;
  String estado;
  String password;

  Usuario({
    required this.nombre,
    required this.usuario,
    required this.rol,
    required this.estado,
    required this.password,
  });
}

// ==========================================
// 2. PANTALLA LISTA DE USUARIOS
// ==========================================
class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  // Lista simulada
  List<Usuario> usuarios = [
    Usuario(
        nombre: "Jenny Montalvo",
        usuario: "jenny.m",
        rol: "Recepcionista",
        estado: "Activo",
        password: "123456"),
    Usuario(
        nombre: "Ana Perez",
        usuario: "ana.p",
        rol: "Recepcionista",
        estado: "Activo",
        password: "123456"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Color de fondo del tema
      body: Column(
        children: [
          // HEADER DEL TEMA
          const AppHeader(title: "Inicio / Configuración / Usuarios"),

          // BOTÓN VOLVER
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
                      )
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

          // CONTENIDO PRINCIPAL
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
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
                  // Título de sección
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "Gestión de Usuarios",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Botón Nuevo Usuario
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.btnGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        final nuevoUsuario = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FormularioUsuarioScreen(), // Modo crear
                          ),
                        );

                        if (nuevoUsuario != null && nuevoUsuario is Usuario) {
                          setState(() {
                            usuarios.add(nuevoUsuario);
                          });
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text(
                        "Nuevo Usuario",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Lista de Usuarios
                  Expanded(
                    child: ListView.separated(
                      itemCount: usuarios.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final user = usuarios[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueGrey[100],
                              child: Text(
                                user.nombre.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              user.nombre,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("${user.rol} • ${user.estado}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: () async {
                                final actualizado = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FormularioUsuarioScreen(usuarioParaEditar: user),
                                  ),
                                );

                                if (actualizado != null && actualizado is Usuario) {
                                  setState(() {
                                    usuarios[index] = actualizado;
                                  });
                                }
                              },
                            ),
                          ),
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

// ==========================================
// 3. PANTALLA FORMULARIO (CREAR / EDITAR)
// ==========================================
class FormularioUsuarioScreen extends StatefulWidget {
  final Usuario? usuarioParaEditar;

  const FormularioUsuarioScreen({super.key, this.usuarioParaEditar});

  @override
  State<FormularioUsuarioScreen> createState() => _FormularioUsuarioScreenState();
}

class _FormularioUsuarioScreenState extends State<FormularioUsuarioScreen> {
  final nombreController = TextEditingController();
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  String rol = "Recepcionista";
  String estado = "Activo";
  bool esEdicion = false;

  @override
  void initState() {
    super.initState();
    // Lógica para cargar datos si es edición
    if (widget.usuarioParaEditar != null) {
      esEdicion = true;
      nombreController.text = widget.usuarioParaEditar!.nombre;
      usuarioController.text = widget.usuarioParaEditar!.usuario;
      passwordController.text = widget.usuarioParaEditar!.password;
      confirmController.text = widget.usuarioParaEditar!.password;
      rol = widget.usuarioParaEditar!.rol;
      estado = widget.usuarioParaEditar!.estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          const AppHeader(title: "Inicio / Usuarios / Registro"),

           // CONTENIDO CENTRADO Y ESTILIZADO
           Expanded(
             child: Center(
               child: SingleChildScrollView(
                 padding: const EdgeInsets.all(20),
                 child: Container(
                   padding: const EdgeInsets.all(25),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(25),
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
                       Text(
                         esEdicion ? "Editar Usuario" : "Registrar Usuario",
                         style: const TextStyle(
                           fontSize: 20, 
                           fontWeight: FontWeight.bold
                         ),
                       ),
                       const SizedBox(height: 20),
                 
                       _campo("Nombre Completo", nombreController, Icons.person),
                       _campo("Usuario", usuarioController, Icons.account_circle),
                       
                       _dropdown("Rol", ["Recepcionista", "Administrador", "Doctor"], (val) => rol = val),
                       _dropdown("Estado", ["Activo", "Inactivo"], (val) => estado = val),
                       
                       _campo("Contraseña", passwordController, Icons.lock, obscure: true),
                       _campo("Confirmar Contraseña", confirmController, Icons.lock_outline, obscure: true),
                 
                       const SizedBox(height: 25),
                 
                       Row(
                         children: [
                           Expanded(
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.red[400],
                                 padding: const EdgeInsets.symmetric(vertical: 12),
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                               ),
                               onPressed: () => Navigator.pop(context),
                               child: const Text("Cancelar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                             ),
                           ),
                           const SizedBox(width: 15),
                           Expanded(
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppColors.btnGreen,
                                 padding: const EdgeInsets.symmetric(vertical: 12),
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                               ),
                               onPressed: () {
                                 // Retornamos el objeto Usuario modificado o creado
                                 Navigator.pop(
                                   context,
                                   Usuario(
                                     nombre: nombreController.text,
                                     usuario: usuarioController.text,
                                     rol: rol,
                                     estado: estado,
                                     password: passwordController.text,
                                   ),
                                 );
                               },
                               child: Text(
                                 esEdicion ? "Actualizar" : "Guardar", 
                                 style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                               ),
                             ),
                           ),
                         ],
                       )
                     ],
                   ),
                 ),
               ),
             ),
           ),
        ],
      ),
    );
  }

  Widget _campo(String label, TextEditingController controller, IconData icon, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[50], // Fondo muy suave para el input
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, Function(String) onChanged) {
    // Aseguramos que el valor actual esté en la lista, si no, tomamos el primero
    String initialValue = items.contains(esEdicion && label == "Rol" ? rol : (esEdicion && label == "Estado" ? estado : items.first)) 
        ? (label == "Rol" ? rol : estado) 
        : items.first;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[50],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
    );
  }
}