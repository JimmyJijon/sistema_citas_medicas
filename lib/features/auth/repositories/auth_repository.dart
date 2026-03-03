import 'package:sistema_citas_medicas/core/database/database_helper.dart';
import 'package:sistema_citas_medicas/core/models/usuario_model.dart';
//import 'package:sistema_citas_medicas/features/auth/models/usuario_model.dart';

class AuthRepository {
  final dbHelper = DatabaseHelper.instance;

  // Método para crear usuarios de prueba si no existen
  Future<void> crearUsuariosPrueba() async {
    final db = await dbHelper.database;
    final usuarios = await db.query('usuario');

    if (usuarios.isEmpty) {
      final ahora = DateTime.now().toIso8601String();

      // Usuario Doctor
      await db.insert('usuario', {
        'nombre': 'Dr. House',
        'apellido': 'Gregory',
        'correo': 'doctor',
        'password': '123',
        'rol': 'Doctor',
        'estado': 'A',
        'fecha_creacion': ahora,
      });

      // Usuario Recepcionista
      await db.insert('usuario', {
        'nombre': 'Clara',
        'apellido': 'Oswald',
        'correo': 'recep',
        'password': '123',
        'rol': 'Recepcionista',
        'estado': 'A',
        'fecha_creacion': ahora,
      });
    }
  }

  // Verificar credenciales
  Future<Usuario?> login(String correo, String password) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'usuario',
      where: 'correo = ? AND password = ? AND estado = ?',
      whereArgs: [correo, password, 'A'],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    }
    return null;
  }
}
