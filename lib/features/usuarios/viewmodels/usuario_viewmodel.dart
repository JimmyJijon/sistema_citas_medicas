import 'package:flutter/material.dart';
import '../../../core/models/usuario_model.dart';
import '../repositories/usuario_repository.dart';

class UsuarioViewModel extends ChangeNotifier {
  final UsuarioRepository _repository = UsuarioRepository();

  // ─────────────────────────────────────────
  // ESTADO — Lista
  // ─────────────────────────────────────────

  List<Usuario> _usuarios = [];
  List<Usuario> _usuariosFiltrados = [];
  String _filtroQuery = '';

  // ─────────────────────────────────────────
  // ESTADO — Formulario
  // ─────────────────────────────────────────

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // ─────────────────────────────────────────
  // GETTERS
  // ─────────────────────────────────────────

  List<Usuario> get usuariosFiltrados => _usuariosFiltrados;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // ─────────────────────────────────────────
  // CARGAR
  // ─────────────────────────────────────────

  Future<void> cargarUsuarios() async {
    _setLoading(true);
    try {
      _usuarios = await _repository.obtenerTodos();
      _aplicarFiltro();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar usuarios: $e';
    }
    _setLoading(false);
  }

  // ─────────────────────────────────────────
  // FILTRO
  // ─────────────────────────────────────────

  void setFiltro(String query) {
    _filtroQuery = query.toLowerCase();
    _aplicarFiltro();
  }

  void _aplicarFiltro() {
    if (_filtroQuery.isEmpty) {
      _usuariosFiltrados = List.from(_usuarios);
    } else {
      _usuariosFiltrados = _usuarios.where((u) {
        final nombre = '${u.nombre} ${u.apellido}'.toLowerCase();
        return nombre.contains(_filtroQuery) ||
            u.correo.toLowerCase().contains(_filtroQuery) ||
            u.rol.toLowerCase().contains(_filtroQuery);
      }).toList();
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────
  // CREATE
  // ─────────────────────────────────────────

  Future<bool> crearUsuario({
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
    required String rol,
  }) async {
    _clearMessages();
    _setLoading(true);

    try {
      // Validar correo duplicado
      if (await _repository.correoExiste(correo)) {
        _errorMessage = 'Ya existe un usuario con ese correo/usuario.';
        _setLoading(false);
        return false;
      }

      final nuevoUsuario = Usuario(
        idUsuario: 0,
        nombre: nombre.trim(),
        apellido: apellido.trim(),
        correo: correo.trim(),
        password: password,
        rol: rol,
        estado: 'A',
        fechaCreacion: DateTime.now(),
      );

      final resultado = await _repository.insertar(nuevoUsuario);
      if (resultado > 0) {
        _successMessage = 'Usuario creado correctamente.';
        await cargarUsuarios();
        return true;
      }
      _errorMessage = 'No se pudo crear el usuario.';
    } catch (e) {
      _errorMessage = 'Error al crear usuario: $e';
    }
    _setLoading(false);
    return false;
  }

  // ─────────────────────────────────────────
  // UPDATE
  // ─────────────────────────────────────────

  Future<bool> actualizarUsuario({
    required Usuario usuarioOriginal,
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
    required String rol,
    required String estado,
  }) async {
    _clearMessages();
    _setLoading(true);

    try {
      // Validar correo duplicado excluyendo el usuario actual
      if (await _repository.correoExiste(correo, excluirId: usuarioOriginal.idUsuario)) {
        _errorMessage = 'Ya existe otro usuario con ese correo/usuario.';
        _setLoading(false);
        return false;
      }

      final usuarioActualizado = Usuario(
        idUsuario: usuarioOriginal.idUsuario,
        nombre: nombre.trim(),
        apellido: apellido.trim(),
        correo: correo.trim(),
        password: password.isNotEmpty ? password : usuarioOriginal.password,
        rol: rol,
        estado: estado,
        fechaCreacion: usuarioOriginal.fechaCreacion,
      );

      final resultado = await _repository.actualizar(usuarioActualizado);
      if (resultado > 0) {
        _successMessage = 'Usuario actualizado correctamente.';
        await cargarUsuarios();
        return true;
      }
      _errorMessage = 'No se pudo actualizar el usuario.';
    } catch (e) {
      _errorMessage = 'Error al actualizar usuario: $e';
    }
    _setLoading(false);
    return false;
  }

  // ─────────────────────────────────────────
  // CAMBIAR ESTADO (Activar / Inactivar)
  // ─────────────────────────────────────────

  Future<void> cambiarEstado(int idUsuario, String estadoActual) async {
    final nuevoEstado = estadoActual == 'A' ? 'I' : 'A';
    try {
      await _repository.cambiarEstado(idUsuario, nuevoEstado);
      await cargarUsuarios();
    } catch (e) {
      _errorMessage = 'Error al cambiar estado: $e';
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}