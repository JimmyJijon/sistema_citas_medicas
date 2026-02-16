import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestionUsuariosScreen(),
    );
  }
}

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

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() =>
      _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {

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
      backgroundColor: const Color(0xFFB8D3E0),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {},
                  child: const Text("Volver"),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Gestión de Usuarios",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  final nuevoUsuario = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegistrarUsuarioScreen(),
                    ),
                  );

                  if (nuevoUsuario != null) {
                    setState(() {
                      usuarios.add(nuevoUsuario);
                    });
                  }
                },
                child: const Text("+ Nuevo Usuario"),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final user = usuarios[index];

                    return Card(
                      child: ListTile(
                        title: Text(user.nombre),
                        subtitle:
                            Text("${user.rol} - ${user.estado}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final actualizado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditarUsuarioScreen(
                                  usuario: user,
                                ),
                              ),
                            );

                            if (actualizado != null) {
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
    );
  }
}

class RegistrarUsuarioScreen extends StatefulWidget {
  const RegistrarUsuarioScreen({super.key});

  @override
  State<RegistrarUsuarioScreen> createState() =>
      _RegistrarUsuarioScreenState();
}

class _RegistrarUsuarioScreenState
    extends State<RegistrarUsuarioScreen> {

  final nombreController = TextEditingController();
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  String rol = "Recepcionista";
  String estado = "Activo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8D3E0),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(25),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                const Text(
                  "Editar Usuario",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                _campo("Nombre", nombreController),
                _campo("Usuario", usuarioController),
                _dropdown("Rol", ["Recepcionista", "Administrador"],
                    (value) => rol = value),
                _dropdown("Estado", ["Activo", "Inactivo"],
                    (value) => estado = value),
                _campo("Contraseña", passwordController,
                    obscure: true),
                _campo("Confirmar", confirmController,
                    obscure: true),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
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
                      child: const Text("Guardar"),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController controller,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.lightBlue.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdown(
      String label, List<String> items, Function(String) onChanged) {
    String value = items.first;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map((e) =>
                DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) {
          onChanged(val!);
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.lightBlue.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class EditarUsuarioScreen extends StatelessWidget {
  final Usuario usuario;

  const EditarUsuarioScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return RegistrarUsuarioScreen();
  }
}
