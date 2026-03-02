import 'package:flutter/material.dart';
// Asegúrate de que estas rutas coincidan exactamente con tu estructura de carpetas
import 'package:sistema_citas_medicas/features/home/screens/home_screen.dart';
import 'package:sistema_citas_medicas/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final AuthViewModel _viewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.inicializarApp();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor rellene todos los campos")),
      );
      return;
    }

    final usuarioValido = await _viewModel.autenticar(user, pass);

    if (usuarioValido != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(idUsuario: usuarioValido.idUsuario),
        ),
        (route) => false,
      );
    } else if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_viewModel.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.altBackground,
      body: Column(
        children: [
          // 1. Barra superior oscura
          Container(height: 40, color: AppColors.darkTopBar),

          Expanded(
            child: SingleChildScrollView(
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
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Sistema de gestión de citas médicas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 3. Tarjeta Central (Card)
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.loginCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 120,
                            color: Colors.grey[700],
                          ),

                          const SizedBox(height: 30),

                          // Campo: Ingresar usuario
                          _buildCustomTextField(
                            controller: _userController,
                            hintText: "Ingresar usuario",
                            fillColor: AppColors.inputFill,
                          ),

                          const SizedBox(height: 20),

                          // Campo: Ingresar contraseña
                          _buildCustomTextField(
                            controller: _passController,
                            hintText: "Ingresar contraseña",
                            fillColor: AppColors.inputFill,
                            obscureText: true,
                          ),

                          const SizedBox(height: 30),

                          // Botón Ingresar
                          SizedBox(
                            width: 200,
                            height: 45,
                            child: ListenableBuilder(
                              listenable: _viewModel,
                              builder: (context, _) {
                                return ElevatedButton(
                                  onPressed: _viewModel.isLoading
                                      ? null
                                      : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _viewModel.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Ingresar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                );
                              },
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

  Widget _buildCustomTextField({
    required TextEditingController controller,
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
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.center,
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
