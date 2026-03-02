import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/models/usuario_model.dart';
import 'package:sistema_citas_medicas/features/home/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> cargarUsuario(int idUsuario) async {
    _isLoading = true;
    notifyListeners();

    // Traemos los datos desde el repositorio
    _usuario = await _repository.obtenerUsuarioPorId(idUsuario);

    _isLoading = false;
    notifyListeners();
  }
}
