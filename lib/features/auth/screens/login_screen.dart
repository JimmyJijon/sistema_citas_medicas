import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/features/home/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Médico',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de colores aproximados basados en la imagen

    final Color backgroundColor = const Color(
      0xFF95AAB4,
    ); // Gris azulado de fondo
    final Color cardColor = const Color(0xFFD9D9D9); // Gris claro de la tarjeta
    final Color inputColor = const Color(
      0xFF9FBCC8,
    ); // Azul grisáceo de los inputs
    final Color buttonColor = const Color(
      0xFF72AEC6,
    ); // Azul más fuerte del botón
    final Color topBarColor = const Color(0xFF464541); // Barra superior oscura

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 1. Barra superior oscura
          Container(
            height: 40, // Altura aproximada de la barra superior
            color: topBarColor,
          ),

          // Espacio expandible para centrar el contenido verticalmente
          Expanded(
            child: SingleChildScrollView(
              // Permite scroll si el teclado tapa la pantalla
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // 2. Título "Sistema de gestión..."
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: inputColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Sistema de gestión de citas médicas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily:
                              'Courier', // Fuente tipo máquina de escribir
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 3. Tarjeta Central (Card)
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ), // Ancho máximo
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Bordes redondeados
                      ),
                      child: Column(
                        children: [
                          // Icono de Usuario
                          Icon(
                            Icons.account_circle_outlined,
                            size: 120,
                            color: Colors.grey[700],
                          ),

                          const SizedBox(height: 30),

                          // Campo: Ingresar usuario
                          _buildCustomTextField(
                            hintText: "Ingresar usuario",
                            fillColor: inputColor,
                          ),

                          const SizedBox(height: 20),

                          // Campo: Ingresar contraseña
                          _buildCustomTextField(
                            hintText: "Ingresar contraseña",
                            fillColor: inputColor,
                            obscureText: true,
                          ),

                          const SizedBox(height: 30),

                          // Botón Ingresar
                          SizedBox(
                            width: 200, // Ancho del botón
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) =>
                                      false, // Esto borra todo el historial anterior (el Login)
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation:
                                    0, // Sin sombra para que se vea plano como el diseño
                              ),
                              child: const Text(
                                "Ingresar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget personalizado para los campos de texto
  Widget _buildCustomTextField({
    required String hintText,
    required Color fillColor,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: obscureText,
        textAlign: TextAlign.center, // Texto centrado como en la imagen
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          fontFamily: 'Courier',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
          border: InputBorder.none, // Quita la línea inferior por defecto
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
