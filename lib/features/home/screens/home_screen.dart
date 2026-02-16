import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/features/auth/screens/login_screen.dart';
// Pantallas de agenda y registrar cita
import 'package:sistema_citas_medicas/features/citas/screens/agenda_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/registrar_cita_view.dart';

// ==========================================
// 1. PANTALLA PRINCIPAL (LÓGICA Y ESTADO)
// ==========================================
void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // CONTROLADOR: lógica del buscador
  final TextEditingController _searchController = TextEditingController();

  // DATOS: Simulamos datos que podrían venir de una base de datos
  final Map<String, String> userData = {
    "nombre": "Juan Vera",
    "cedula": "0900000000",
    "rol": "Doctor",
    "codigo": "001",
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMenuOptionTap(String option) {
    final String menuOption = option.replaceAll("\n", " ");

    switch (menuOption) {
      case "Agenda":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AgendaView()),
        );
        break;

      case "Registrar Cita":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrarCitaView()),
        );
        break;

      case "Gestión de Pacientes":
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Módulo de Pacientes en construcción')),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seleccionaste: $menuOption (En construcción)'),
            duration: const Duration(milliseconds: 500),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      userData: userData,
      searchController: _searchController,
      onMenuTap: _onMenuOptionTap,
    );
  }
}

// ==========================================
// 2. LAYOUT PRINCIPAL (DISEÑO ESTRUCTURAL)
// ==========================================
class HomeLayout extends StatelessWidget {
  final Map<String, String> userData;
  final TextEditingController searchController;
  final Function(String) onMenuTap;

  const HomeLayout({
    super.key,
    required this.userData,
    required this.searchController,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF95AAB4);
    final Color darkColor = const Color(0xFF464541);
    final Color cardColor = const Color(0xFFE6E6E1);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Header extraído (Ahora Responsive)
          HomeHeader(darkColor: darkColor),

          // Sub-header
          Container(
            width: double.infinity,
            color: cardColor,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: const Text(
              "Version movil",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Tarjeta de Usuario extraída
          UserCard(userData: userData, cardColor: cardColor),

          const SizedBox(height: 15),

          // Barra de Búsqueda Funcional extraída
          CustomSearchBar(controller: searchController),

          const SizedBox(height: 10),

          // Grid de Menú extraído
          Expanded(
            child: MenuGrid(cardColor: cardColor, onOptionTap: onMenuTap),
          ),

          // Footer
          Container(
            width: double.infinity,
            color: darkColor,
            padding: const EdgeInsets.all(15),
            child: const Text(
              "Footer",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Courier',
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. WIDGETS INDEPENDIENTES (COMPONENTES)
// ==========================================

// --- HEADER CORREGIDO (RESPONSIVE) ---
class HomeHeader extends StatelessWidget {
  final Color darkColor;

  const HomeHeader({super.key, required this.darkColor});

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFF88C3C7);

    return Container(
      width: double.infinity,
      color: darkColor, // El color cubre toda la parte superior
      child: SafeArea(
        // SafeArea evita que el contenido toque la barra de estado/notch
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[600],
                radius: 22,
                child: const Text(
                  "logo",
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Sistema de gestión citas medicas",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // Ajustado para evitar overflow
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Notificaciones
              Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),

              // Botón Logout (Con lógica de salida)
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false, // Borra el historial para no volver atrás
                  );
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blueGrey,
                  child: const Icon(
                    Icons.power_settings_new,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- TARJETA DE USUARIO ---
class UserCard extends StatelessWidget {
  final Map<String, String> userData;
  final Color cardColor;

  const UserCard({super.key, required this.userData, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFF88C3C7);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: accentColor, width: 4),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Imagen",
                style: TextStyle(fontFamily: 'Courier'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Datos del usuario:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Usuario: ${userData['nombre']}",
                    style: const TextStyle(fontFamily: 'Courier'),
                  ),
                  Text(
                    "Cedula: ${userData['cedula']}",
                    style: const TextStyle(fontFamily: 'Courier'),
                  ),
                  Text(
                    "Rol: ${userData['rol']}",
                    style: const TextStyle(fontFamily: 'Courier'),
                  ),
                  Text(
                    "cod: ${userData['codigo']}",
                    style: const TextStyle(fontFamily: 'Courier'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- BARRA DE BÚSQUEDA ---
class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const CustomSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.cyan[600], size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  hintText: "Buscar...",
                  hintStyle: TextStyle(fontSize: 13, fontFamily: 'Courier'),
                  isDense: true,
                ),
                style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- GRID DE MENÚ ---
class MenuGrid extends StatelessWidget {
  final Color cardColor;
  final Function(String) onOptionTap;

  const MenuGrid({
    super.key,
    required this.cardColor,
    required this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> menuOptions = [
      "Agenda",
      "Registrar Cita",
      "Usuarios",
      "Configuración de\nhorario",
      "Restricciones de\nhorario",
      "Gestión de Pacientes",
      "Reportes",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 0, bottom: 20),
        itemCount: menuOptions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onOptionTap(menuOptions[index]),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                menuOptions[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
