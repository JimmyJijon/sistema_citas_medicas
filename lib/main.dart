import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/features/auth/screens/login_screen.dart';
import 'package:sistema_citas_medicas/features/citas/screens/agenda_view.dart';
import 'package:sistema_citas_medicas/features/home/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Quita la etiqueta "DEBUG" de la esquina
      title: 'Gestor de Citas',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue, // O el color base que prefieras
      ),
      // AQUÍ es donde defines que pantalla arranca primero
      home: const LoginScreen(),
    );
  }
}
