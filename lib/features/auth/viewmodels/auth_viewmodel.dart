import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/models/usuario_model.dart';
//import 'package:sistema_citas_medicas/features/auth/models/usuario_model.dart';
import 'package:sistema_citas_medicas/features/auth/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Al iniciar, nos aseguramos de que existan los usuarios
  Future<void> inicializarApp() async {
    await _repository.crearUsuariosPrueba();
  }

  Future<Usuario?> autenticar(String correo, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuario = await _repository.login(correo, password);
      if (usuario == null) {
        _errorMessage = "Usuario o contraseña incorrectos";
      }
      _isLoading = false;
      notifyListeners();
      return usuario;
    } catch (e) {
      _errorMessage = "Error de conexión con la base de datos";
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
