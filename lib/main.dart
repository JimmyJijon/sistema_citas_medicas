import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/features/alertas/screens/alerts_view.dart';
import 'package:sistema_citas_medicas/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:sistema_citas_medicas/features/auth/screens/login_screen.dart';
import 'package:sistema_citas_medicas/features/citas/screens/agenda_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/registrar_cita_view.dart';
import 'package:sistema_citas_medicas/features/home/screens/home_screen.dart';
import 'package:sistema_citas_medicas/features/horarios/screens/horario_screen.dart';
import 'package:sistema_citas_medicas/features/pacientes/screens/pacientes_list_screen.dart';
import 'package:sistema_citas_medicas/features/pacientes/viewmodels/pacientes_viewmodel.dart';
import 'package:sistema_citas_medicas/features/usuarios/screens/usuarios_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());

            case '/home':
              final int idUsuario = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => HomeScreen(idUsuario: idUsuario),
              );

            case '/agenda':
              return MaterialPageRoute(builder: (_) => const AgendaView());

            case '/registrar-cita':
              return MaterialPageRoute(
                builder: (_) => const RegistrarCitaView(),
              );

            case '/usuarios':
              return MaterialPageRoute(
                builder: (_) => const GestionUsuariosScreen(),
              );

            case '/horario':
              return MaterialPageRoute(builder: (_) => const HorarioScreen());

            case '/pacientes':
              return MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => PacientesViewModel(),
                  child: const PacientesListScreen(),
                ),
              );

            case '/alertas':
              return MaterialPageRoute(builder: (_) => const AlertsView());

            default:
              return null;
          }
        },
      ),
    );
  }
}
