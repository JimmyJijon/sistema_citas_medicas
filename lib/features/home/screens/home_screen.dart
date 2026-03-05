import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sistema_citas_medicas/features/alertas/screens/alerts_view.dart';
import 'package:sistema_citas_medicas/features/alertas/viewmodels/alert_viewmodel.dart';
import 'package:sistema_citas_medicas/features/auth/screens/login_screen.dart';
import 'package:sistema_citas_medicas/features/citas/screens/agenda_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/registrar_cita_view.dart';
import 'package:sistema_citas_medicas/features/horarios/screens/horario_screen.dart';
import 'package:sistema_citas_medicas/features/usuarios/screens/usuarios_list_screen.dart';
import 'package:sistema_citas_medicas/features/pacientes/viewmodels/pacientes_viewmodel.dart';
import 'package:sistema_citas_medicas/features/pacientes/screens/pacientes_list_screen.dart';
import 'package:sistema_citas_medicas/features/reportes/screens/reportes_screen.dart';
import 'package:sistema_citas_medicas/features/home/viewmodels/home_viewmodel.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/core/widgets/clinic_logo.dart';
import 'package:sistema_citas_medicas/features/horarios/screens/restricciones_screen.dart'; // Verifica la ruta exacta
import 'package:sistema_citas_medicas/features/horarios/viewmodels/restricciones_viewmodel.dart'; // Verifica la ruta exacta

// ==========================================
// 1. PANTALLA PRINCIPAL
// ==========================================

class HomeScreen extends StatefulWidget {
  final int idUsuario;
  const HomeScreen({super.key, required this.idUsuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.cargarUsuario(widget.idUsuario);
    // Carga inicial del conteo de alertas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertViewModel>().cargarConteo();
    });
  }

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
        ).then((_) => context.read<AlertViewModel>().cargarConteo());
        break;
      case "Registrar Cita":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrarCitaView()),
        ).then((_) => context.read<AlertViewModel>().cargarConteo());
        break;
      case "Usuarios":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GestionUsuariosScreen()),
        );
        break;
      case "Configuración de horario":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HorarioScreen()),
        );
        break;
      case "Restricciones de horario":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => RestriccionesViewModel(), // Inyectamos el ViewModel
              child: const RestriccionesScreen(),       // Cargamos la pantalla
            ),
          ),
        );
        break;
      case "Gestión de Pacientes":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => PacientesViewModel(),
              child: const PacientesListScreen(),
            ),
          ),
        );
        break;
      case "Reportes":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportesScreen()),
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
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.altBackground,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        if (_viewModel.usuario == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: const Center(child: Text("Error al cargar los datos del usuario")),
          );
        }

        final userData = {
          "nombre": "${_viewModel.usuario!.nombre} ${_viewModel.usuario!.apellido}",
          "correo": _viewModel.usuario!.correo,
          "rol": _viewModel.usuario!.rol,
          "codigo": _viewModel.usuario!.idUsuario.toString().padLeft(3, '0'),
        };

        return HomeLayout(
          userData: userData,
          searchController: _searchController,
          onMenuTap: _onMenuOptionTap,
        );
      },
    );
  }
}

// ==========================================
// 2. LAYOUT
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
    return Scaffold(
      backgroundColor: AppColors.altBackground,
      body: Column(
        children: [
          const HomeHeaderWidget(),
          const SizedBox(height: 15),
          UserCard(userData: userData),
          const SizedBox(height: 15),
          CustomSearchBar(controller: searchController),
          const SizedBox(height: 10),
          Expanded(
            child: MenuGrid(
              onOptionTap: onMenuTap,
              searchController: searchController,
              rolUsuario: userData['rol'] ?? 'Doctor',
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. HEADER CON CAMPANITA DINÁMICA
// ==========================================

class HomeHeaderWidget extends StatefulWidget {
  const HomeHeaderWidget({super.key});

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _textAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lee el conteo de alertas pendientes del Provider
    final totalPendientes = context.watch<AlertViewModel>().totalPendientes;

    return Container(
      width: double.infinity,
      color: AppColors.darkTopBar,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              // Logo
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    ClinicLogo(size: 22, color: AppColors.accentColor),
                    const SizedBox(width: 8),
                    const Text(
                      "CLÍNICA",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.accentColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Texto animado
              Expanded(
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.center,
                  child: AnimatedBuilder(
                    animation: _textAnimation,
                    builder: (context, child) {
                      return FractionalTranslation(
                        translation: _textAnimation.value,
                        child: const Text(
                          "Sistema de gestión citas medicas",
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // ── Campanita con contador dinámico ──
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AlertsView()),
                  ).then((_) {
                    // Refresca conteo al volver de alertas
                    context.read<AlertViewModel>().cargarConteo();
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications, color: Colors.yellow, size: 30),
                    if (totalPendientes > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            // Muestra "9+" si hay más de 9
                            totalPendientes > 9 ? '9+' : '$totalPendientes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Botón cerrar sesión
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF81C784),
                  child: Icon(Icons.power_settings_new, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// RESTO DE WIDGETS (sin cambios)
// ==========================================

class ClinicLogoCrossHeartPainter extends CustomPainter {
  final Color color;
  ClinicLogoCrossHeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final double mid = size.width / 2;
    const double crossSize = 6.0;
    final Path heartPath = Path()
      ..moveTo(mid, size.height * 0.25)
      ..cubicTo(size.width * 0.9, -size.height * 0.1, size.width * 1.3, size.height * 0.6, mid, size.height)
      ..cubicTo(-size.width * 0.3, size.height * 0.6, size.width * 0.1, -size.height * 0.1, mid, size.height * 0.25)
      ..close();
    canvas.drawPath(heartPath, paint);
    final Paint crossPaint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(mid - (crossSize * 0.8), size.height * 0.45, crossSize * 1.6, crossSize * 0.3), crossPaint);
    canvas.drawRect(Rect.fromLTWH(mid - (crossSize * 0.15), size.height * 0.35, crossSize * 0.3, crossSize), crossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UserCard extends StatelessWidget {
  final Map<String, String> userData;
  const UserCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.homeCard,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Datos del usuario:", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Courier', fontSize: 16)),
            const SizedBox(height: 10),
            Text("Usuario: ${userData['nombre']}", style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
            Text("Correo: ${userData['correo']}", style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
            Text("Rol: ${userData['rol']}", style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
            Text("cod: ${userData['codigo']}", style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const CustomSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.cyan[600], size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 35,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
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

class MenuGrid extends StatelessWidget {
  final Function(String) onOptionTap;
  final TextEditingController searchController;
  final String rolUsuario;

  const MenuGrid({
    super.key,
    required this.onOptionTap,
    required this.searchController,
    required this.rolUsuario,
  });

  @override
  Widget build(BuildContext context) {
    List<String> baseMenuOptions = rolUsuario == 'Recepcionista'
        ? ["Agenda", "Registrar Cita", "Gestión de Pacientes"]
        : [
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
      child: ListenableBuilder(
        listenable: searchController,
        builder: (context, _) {
          final query = searchController.text.toLowerCase().trim();
          final filtered = baseMenuOptions.where((o) => o.replaceAll("\n", " ").toLowerCase().contains(query)).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text("No se encontraron resultados", style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)));
          }

          return GridView.builder(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onOptionTap(filtered[index]),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.homeCard, borderRadius: BorderRadius.circular(15)),
                  alignment: Alignment.center,
                  child: Text(
                    filtered[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}