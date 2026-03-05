import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import '../models/restriccion_horario_model.dart';
import 'package:provider/provider.dart'; // Lo usaremos para guardar luego
import '../viewmodels/restricciones_viewmodel.dart';

class FormularioRestriccionScreen extends StatefulWidget {
  final RestriccionHorario? restriccion;

  const FormularioRestriccionScreen({super.key, this.restriccion});

  @override
  State<FormularioRestriccionScreen> createState() => _FormularioRestriccionScreenState();
}

class _FormularioRestriccionScreenState extends State<FormularioRestriccionScreen> {
  late String tipoSeleccionado;
  late String estadoSeleccionado;
  DateTime? fechaSeleccionada;
  TimeOfDay? horaInicio;
  TimeOfDay? horaFin;

  bool get esEdicion => widget.restriccion != null;

  @override
  void initState() {
    super.initState();
    // Inicializamos las variables al cargar la pantalla
    tipoSeleccionado = widget.restriccion?.tipo ?? 'Feriado';
    estadoSeleccionado = widget.restriccion?.estado ?? 'Activa';
    fechaSeleccionada = widget.restriccion?.fecha;
    horaInicio = widget.restriccion != null ? _parseTimeOfDay(widget.restriccion!.horaInicio) : null;
    horaFin = widget.restriccion != null ? _parseTimeOfDay(widget.restriccion!.horaFin) : null;
  }

  // --- LÓGICA DE FECHAS Y HORAS ---
  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    if (parts.length == 2) {
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '--:--';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'DD/MM/AAAA';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _guardarRestriccion() async {
    // 1. Validar que los campos obligatorios no estén vacíos
    if (fechaSeleccionada == null || horaInicio == null || horaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona la fecha y las horas de inicio y fin.', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFFF4511E), // Rojo para error
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 2. Obtener acceso al ViewModel para guardar
    final vm = context.read<RestriccionesViewModel>();

    // 3. Construir el objeto con los datos del formulario
    final restriccionAGuardar = RestriccionHorario(
      idRestriccion: widget.restriccion?.idRestriccion, // Si es edición, mantenemos su ID. Si es nuevo, será null/0 dependiendo de tu modelo.
      tipo: tipoSeleccionado,
      fecha: fechaSeleccionada!,
      horaInicio: _formatTimeOfDay(horaInicio),
      horaFin: _formatTimeOfDay(horaFin),
      estado: estadoSeleccionado,
    );

    // 4. Ejecutar el guardado
    try {
      if (esEdicion) {
        // NOTA: Asegúrate de que tu ViewModel tenga este método
        await vm.actualizarRestriccion(restriccionAGuardar); 
      } else {
        await vm.agregarRestriccion(restriccionAGuardar);
      }

      // 5. Mostrar éxito y salir de la pantalla
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(esEdicion ? 'Restricción actualizada con éxito' : 'Restricción registrada con éxito'),
            backgroundColor: const Color(0xFF388E3C), // Verde éxito
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context); // Volvemos a la lista
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ocurrió un error al guardar: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: Column(
        children: [
          _buildHeader(size),

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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width > 600 ? 40 : 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      esEdicion ? 'Editar Restricción' : 'Registrar Restricción',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Configura los detalles del evento',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 35),

                    _buildCustomDropdown(
                      label: 'Tipo de restricción',
                      icon: Icons.event_note_outlined,
                      items: ['Feriado', 'Reunión', 'Emergencia', 'Ausencia'],
                      selectedValue: tipoSeleccionado,
                      onChanged: (val) {
                        if (val != null) setState(() => tipoSeleccionado = val);
                      },
                    ),
                    const SizedBox(height: 20),

                    _buildSafePickerField(
                      label: 'Fecha',
                      icon: Icons.calendar_today_outlined,
                      value: _formatDate(fechaSeleccionada),
                      onTap: () async {
                        final DateTime? seleccion = await showDatePicker(
                          context: context,
                          initialDate: fechaSeleccionada ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) => _buildTemaPicker(context, child),
                        );
                        if (seleccion != null) setState(() => fechaSeleccionada = seleccion);
                      },
                    ),
                    const SizedBox(height: 20),

                    _buildCustomDropdown(
                      label: 'Estado',
                      icon: Icons.check_circle_outline,
                      items: ['Activa', 'Inactiva'],
                      selectedValue: estadoSeleccionado,
                      onChanged: (val) {
                        if (val != null) setState(() => estadoSeleccionado = val);
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _buildSafePickerField(
                            label: 'Inicio',
                            icon: Icons.access_time,
                            value: _formatTimeOfDay(horaInicio),
                            onTap: () async {
                              final TimeOfDay? seleccion = await showTimePicker(
                                context: context,
                                initialTime: horaInicio ?? TimeOfDay.now(),
                                builder: (context, child) => _buildTemaPicker(context, child),
                              );
                              if (seleccion != null) setState(() => horaInicio = seleccion);
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildSafePickerField(
                            label: 'Fin',
                            icon: Icons.access_time,
                            value: _formatTimeOfDay(horaFin),
                            onTap: () async {
                              final TimeOfDay? seleccion = await showTimePicker(
                                context: context,
                                initialTime: horaFin ?? TimeOfDay.now(),
                                builder: (context, child) => _buildTemaPicker(context, child),
                              );
                              if (seleccion != null) setState(() => horaFin = seleccion);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // BOTONES DE ACCIÓN
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.btnGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: _guardarRestriccion,
                            child: const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
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
                    esEdicion ? 'Inicio / Restricciones / Editar' : 'Inicio / Restricciones / Nueva',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width > 400 ? 14 : 12, color: Colors.black87),
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

  Widget _buildTemaPicker(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF388E3C), 
        ),
      ),
      child: child!,
    );
  }

  Widget _buildSafePickerField({required String label, required IconData icon, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown({required String label, required IconData icon, required List<String> items, required String selectedValue, required ValueChanged<String?> onChanged}) {
    if (!items.contains(selectedValue)) {
      selectedValue = items.first;
    }

    return DropdownButtonFormField<String>(
      value: selectedValue,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF388E3C), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}