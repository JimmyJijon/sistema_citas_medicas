import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/features/auth/screens/login_screen.dart';
import 'package:sistema_citas_medicas/features/citas/viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/citas/repositories/citaRepository.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repo = CitaRepository();
  await repo.actualizarEstadosAntiguos(); // ← SE EJECUTA AQUÍ

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CitaViewModel()),
        // agrega aquí los demás viewmodels cuando los necesites
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestor de Citas',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
