import '../../../core/database/database_helper.dart';
import '../../../core/models/usuario_model.dart';

class UsuarioRepository {
  final _dbHelper = DatabaseHelper.instance;

  // ─────────────────────────────────────────
  // READ — Todos los usuarios
  // ─────────────────────────────────────────

  Future<List<Usuario>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'usuario',
      orderBy: 'nombre ASC',
    );
    return maps.map((m) => Usuario.fromJson(m)).toList();
  }

  // ─────────────────────────────────────────
  // READ — Por ID
  // ─────────────────────────────────────────

  Future<Usuario?> obtenerPorId(int idUsuario) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'usuario',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );
    if (maps.isEmpty) return null;
    return Usuario.fromJson(maps.first);
  }

  // ─────────────────────────────────────────
  // READ — Verificar correo duplicado
  // ─────────────────────────────────────────

  Future<bool> correoExiste(String correo, {int? excluirId}) async {
    final db = await _dbHelper.database;
    final maps = excluirId != null
        ? await db.query(
            'usuario',
            where: 'correo = ? AND id_usuario != ?',
            whereArgs: [correo, excluirId],
          )
        : await db.query(
            'usuario',
            where: 'correo = ?',
            whereArgs: [correo],
          );
    return maps.isNotEmpty;
  }

  // ─────────────────────────────────────────
  // CREATE
  // ─────────────────────────────────────────

  Future<int> insertar(Usuario usuario) async {
    final db = await _dbHelper.database;
    final map = usuario.toJson()..remove('id_usuario');
    return await db.insert('usuario', map);
  }

  // ─────────────────────────────────────────
  // UPDATE
  // ─────────────────────────────────────────

  Future<int> actualizar(Usuario usuario) async {
    final db = await _dbHelper.database;
    return await db.update(
      'usuario',
      usuario.toJson(),
      where: 'id_usuario = ?',
      whereArgs: [usuario.idUsuario],
    );
  }

  // ─────────────────────────────────────────
  // DELETE — Inactivar (no borrado físico)
  // ─────────────────────────────────────────

  Future<int> cambiarEstado(int idUsuario, String nuevoEstado) async {
    final db = await _dbHelper.database;
    return await db.update(
      'usuario',
      {'estado': nuevoEstado},
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );
  }
}