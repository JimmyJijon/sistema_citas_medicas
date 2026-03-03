import 'package:sistema_citas_medicas/core/database/database_helper.dart';
import 'package:sistema_citas_medicas/core/models/usuario_model.dart';

class HomeRepository {
  final dbHelper = DatabaseHelper.instance;

  // Consulta el usuario en base a su ID
  Future<Usuario?> obtenerUsuarioPorId(int idUsuario) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'usuario',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    }
    return null;
  }
}
