import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import '../models/restriccion_horario_model.dart';
import '../viewmodels/restricciones_viewmodel.dart';
import 'formulario_restriccion_screen.dart';

class RestriccionesScreen extends StatelessWidget {
  const RestriccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos watch para que la pantalla se redibuje cuando cambien los datos
    final vm = context.watch<RestriccionesViewModel>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: Column(
        children: [
          _buildHeader(size),

          // Botón Volver
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnGreen,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  'Volver',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: size.width > 600 ? 40 : 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(size.width > 600 ? 30 : 20),
                      child: Column(
                        children: [
                          const Text(
                            'Gestión de Restricciones',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Administra feriados, reuniones y ausencias',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 25),

                          // Botón Nueva Restricción
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider.value(
                                      value: context.read<RestriccionesViewModel>(),
                                      child: const FormularioRestriccionScreen(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add, color: Colors.white, size: 20),
                              label: const Text(
                                'Nueva restricción',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.btnGreen,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildTablaRestricciones(context, vm, size),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      width: double.infinity,
      color: AppColors.header,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: size.width > 600 ? 20 : 15, bottom: 15, left: 15, right: 15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.5),
                radius: 20,
                child: const Text('logo', style: TextStyle(fontSize: 10, color: Colors.black)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.fieldBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Inicio / Restricciones de horario',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width > 400 ? 14 : 12,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTablaRestricciones(BuildContext context, RestriccionesViewModel vm, Size size) {
    if (vm.restricciones.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200)),
        child: const Text('No hay restricciones registradas.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          dataRowMaxHeight: 55,
          columnSpacing: size.width > 600 ? 40 : 20,
          columns: const [
            DataColumn(label: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Desde', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Hasta', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: vm.restricciones.map((restriccion) {
            final fechaStr = restriccion.fecha.toIso8601String().split('T')[0];

            return DataRow(cells: [
              DataCell(Text(restriccion.tipo)),
              DataCell(Text(fechaStr)),
              DataCell(Text(restriccion.horaInicio)),
              DataCell(Text(restriccion.horaFin)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: restriccion.estado.toLowerCase() == 'activa'
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    restriccion.estado,
                    style: TextStyle(
                        color: restriccion.estado.toLowerCase() == 'activa'
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey, size: 22),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: context.read<RestriccionesViewModel>(),
                            child: FormularioRestriccionScreen(restriccion: restriccion),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                    onPressed: () => _confirmarEliminacion(context, vm, restriccion),
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // DIÁLOGO DE CONFIRMACIÓN
  void _confirmarEliminacion(BuildContext context, RestriccionesViewModel vm, RestriccionHorario restriccion) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // Bordes muy redondeados como en la imagen
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título centrado y en negrita
              const Text(
                'Eliminar Restricción',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Texto descriptivo dinámico
              Text(
                '¿Estás seguro de que deseas eliminar la restricción de tipo "${restriccion.tipo}"?',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              
              // Texto de advertencia de borrado
              const Text(
                'Esta acción borrará por completo esta restricción.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // Fila de botones personalizados
              Row(
                children: [
                  // Botón Cancelar (Texto plano)
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xFFE57373), // Rojo suave/rosado
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  // Botón Eliminar (Fondo sólido rojo/coral)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await vm.eliminarRestriccion(restriccion);
                        if (context.mounted) {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Restricción Eliminada'),
                              backgroundColor: Colors.black87,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5252), // Rojo vibrante de la imagen
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Eliminar',
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
            ],
          ),
        );
      },
    );
  }
}