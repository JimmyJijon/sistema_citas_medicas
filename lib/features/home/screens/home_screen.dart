/*
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores del diseño
    final Color backgroundColor = const Color(0xFF95AAB4); // Fondo general
    final Color darkColor = const Color(0xFF464541); // Header y Footer
    final Color cardColor = const Color(0xFFE6E6E1);
    final Color accentColor = const Color(0xFF88C3C7);
    final Color searchBarColor = const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // ---------------------------------------------
          // 1. HEADER (Barra Superior Oscura)
          // ---------------------------------------------
          Container(
            color: darkColor,
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 10,
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                // Logo Circular
                CircleAvatar(
                  backgroundColor: Colors.grey[600],
                  radius: 22,
                  child: const Text(
                    "logo",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),

                // Barra
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
                      "Nombre u otra cosa",
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Icono Notificación
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

                // Botón Cerrar Sesión
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blueGrey,
                  child: const Icon(
                    Icons.power_settings_new,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ---------------------------------------------
          // 2. SUB-HEADER ("Version movil")
          // ---------------------------------------------
          Container(
            width: double.infinity,
            color: cardColor, // Color crema
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

          // ---------------------------------------------
          // 3. TARJETA DE USUARIO
          // ---------------------------------------------
          Padding(
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
                  // Cuadro de imagen
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
                  // Datos de texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Datos del usuario:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courier',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Usuario: Juan Vera",
                          style: TextStyle(fontFamily: 'Courier'),
                        ),
                        Text(
                          "Cedula: 0900000000",
                          style: TextStyle(fontFamily: 'Courier'),
                        ),
                        Text(
                          "Rol: Doctor",
                          style: TextStyle(fontFamily: 'Courier'),
                        ),
                        Text(
                          "cod: 001",
                          style: TextStyle(fontFamily: 'Courier'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ---------------------------------------------
          // 4. BARRA DE BÚSQUEDA (Lupa)
          // ---------------------------------------------
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300], // Fondo gris del contenedor de la lupa
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.cyan[600], size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: searchBarColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------
          // 5. GRID DE BOTONES (Agenda, Cita, etc.)
          // ---------------------------------------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GridView.count(
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: 20, // Espacio horizontal entre botones
                mainAxisSpacing: 15, // Espacio vertical entre botones
                childAspectRatio:
                    1.5, // Proporción ancho/alto para que sean rectangulares
                children: [
                  _buildMenuButton("Agenda", cardColor),
                  _buildMenuButton("Registrar Cita", cardColor),
                  _buildMenuButton("Usuarios", cardColor),
                  _buildMenuButton("Configuración de\nhorario", cardColor),
                  _buildMenuButton("Restricciones de\nhorario", cardColor),
                  _buildMenuButton("Gestión de Pacientes", cardColor),
                  _buildMenuButton("Reportes", cardColor),
                ],
              ),
            ),
          ),

          // ---------------------------------------------
          // 6. FOOTER
          // ---------------------------------------------
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

  // Widget auxiliar para crear los botones del menú
  Widget _buildMenuButton(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Courier',
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';

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
    // Limpiamos el controlador cuando se cierra la pantalla para liberar memoria
    _searchController.dispose();
    super.dispose();
  }

  void _onMenuOptionTap(String option) {
    // LÓGICA: Se manejaria qué pasa al tocar un botón
    print("Navegar a: $option");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Seleccionaste: $option'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pasamos la lógica y los datos a la vista (Diseño)
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
    // Definición de colores centralizada
    final Color backgroundColor = const Color(0xFF95AAB4);
    final Color darkColor = const Color(0xFF464541);
    final Color cardColor = const Color(0xFFE6E6E1);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Header extraído
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

          const SizedBox(height: 20),

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

// --- HEADER ---
class HomeHeader extends StatelessWidget {
  final Color darkColor;

  const HomeHeader({super.key, required this.darkColor});

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFF88C3C7);

    return Container(
      color: darkColor,
      padding: const EdgeInsets.only(top: 40, bottom: 10, left: 15, right: 15),
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            children: [
              const Icon(Icons.notifications, color: Colors.yellow, size: 30),
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
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pop(), // Lógica simple de volver atrás
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
                    style: TextStyle(fontFamily: 'Courier'),
                  ),
                  Text(
                    "Cedula: ${userData['cedula']}",
                    style: TextStyle(fontFamily: 'Courier'),
                  ),
                  Text(
                    "Rol: ${userData['rol']}",
                    style: TextStyle(fontFamily: 'Courier'),
                  ),
                  Text(
                    "cod: ${userData['codigo']}",
                    style: TextStyle(fontFamily: 'Courier'),
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

// --- BARRA DE BÚSQUEDA (AHORA FUNCIONAL) ---
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
          // Aquí está el cambio: Usamos Expanded + TextField
          Expanded(
            child: Container(
              height: 35, // Altura un poco mayor para que quepa el texto
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
                  ), // Ajuste fino para centrar texto
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
        itemCount: menuOptions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 15,
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
