import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import '../widgets/app_header.dart';
// Widgets Reutilizados
import '../widgets/section_title.dart';
import '../widgets/detail_info_row.dart';
import '../widgets/observation_input.dart';
// Widgets propios de esta pantalla
import '../widgets/reagendar_widgets/reschedule_input_row.dart';
import '../widgets/reagendar_widgets/reschedule_action_buttons.dart';


class ReagendarCitaView extends StatefulWidget {
  const ReagendarCitaView({Key? key}) : super(key: key);

  @override
  State<ReagendarCitaView> createState() => _ReagendarCitaViewState();
}

class _ReagendarCitaViewState extends State<ReagendarCitaView> {
  // 1. Inicializamos con la FECHA DE HOY
  late DateTime _selectedDate;
  
  // 2. Variable para el Dropdown (null al principio o un valor por defecto)
  String? _selectedTimeSlot;

  // Lista de horarios disponibles (simulados por ahora)
  final List<String> _timeSlots = [
    "09:00 - 09:20",
    "09:20 - 09:40",
    "10:00 - 10:20",
    "11:00 - 11:20",
    "11:20 - 11:40",
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Seteamos la fecha actual al inicio
  }

  // Lógica del Calendario
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32), // Verde oscuro
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Helper simple para formatear fecha (dd/MM/yyyy) 
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(title: "Inicio / Agenda / Reagendar Cita"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SectionTitle(title: "Reagendar Cita"),
                  
                  // Panel de info 
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: const [
                        DetailInfoRow(label: "Paciente", value: "Juan Perez"),
                        DetailInfoRow(label: "Fecha actual", value: "[05/03/2026]"),
                        DetailInfoRow(label: "Franja actual", value: "[10:00 - 10:20]"),
                        DetailInfoRow(label: "Estado Actual", value: "[Ingresada]", isLast: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  // 1. INPUT FECHA (Parece un input real, muestra fecha actual)
                  RescheduleInputRow(
                    label: "Nueva Fecha:", 
                    value: _formatDate(_selectedDate), // Muestra 15/05/2026
                    onTap: () => _selectDate(context),
                  ),
                  
                  // 2. INPUT FRANJA (Es un Dropdown real)
                  RescheduleInputRow(
                    label: "Nueva Franja:",
                    // customChild para incrustar el DropdownButton
                    customChild: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedTimeSlot,
                        hint: const Text(
                          "Seleccionar...", 
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)
                        ),
                        isExpanded: true, // Ocupa todo el ancho del contenedor gris
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        items: _timeSlots.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTimeSlot = newValue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const SectionTitle(title: "Motivo del reagendamiento"),
                  const ObservationInput(hintText: "[Descripción]"),
                  const SizedBox(height: 30),

                  RescheduleActionButtons(
                    onConfirm: () {
                       // Validación básica
                       if (_selectedTimeSlot == null) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(
                             content: Text("Por favor selecciona una nueva franja horaria"),
                             backgroundColor: Colors.red,
                           )
                         );
                         return;
                       }
                       // Guardar
                      Navigator.pop(context);
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}