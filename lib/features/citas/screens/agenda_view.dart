import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/citas/screens/cancelar_cita_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/detalle_cita_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/marcar_cita_view.dart';
import 'package:sistema_citas_medicas/features/citas/screens/reagendar_cita_view.dart'; 
import '../widgets/app_header.dart';
// Importamos nuestros nuevos widgets modulares
import '../widgets/agenda_widgets/agenda_filters.dart';
import '../widgets/agenda_widgets/agenda_appointment_card.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({Key? key}) : super(key: key);

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  // --- ESTADO ---
  DateTime _fechaDesde = DateTime.now();
  DateTime _fechaHasta = DateTime.now().add(const Duration(days: 1));
  String? _filtroEstado;

  // Datos simulados
  final List<Map<String, dynamic>> _listaCitas = [
    {"fecha": "05/03/2026", "hora": "10:00-10:20", "paciente": "Juan Pérez", "estado": "Ingresada"},
    {"fecha": "05/03/2026", "hora": "10:20-10:40", "paciente": "María López", "estado": "Completada"},
    {"fecha": "06/03/2026", "hora": "10:20-10:40", "paciente": "Jose Castro", "estado": "Reagendada"},
    {"fecha": "06/03/2026", "hora": "14:00-14:20", "paciente": "Ana Villa", "estado": "Cancelada"},
    {"fecha": "07/03/2026", "hora": "09:00-09:30", "paciente": "Carlos Ruiz", "estado": "Ingresada"},
  ];

  Future<void> _seleccionarFecha(bool esDesde) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: esDesde ? _fechaDesde : _fechaHasta,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.fieldBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        esDesde ? _fechaDesde = picked : _fechaHasta = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header
          const AppHeader(title: "Inicio / Agenda"),
          // 2. BOTÓN VOLVER 
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, top: 15, bottom: 5),
            alignment: Alignment.centerLeft, // Alineado a la izquierda
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent, // Fondo blanco para que resalte el celeste
                foregroundColor: Colors.black,  // Color Celeste para el texto/icono
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados consistentes
                ),
                elevation: 3, // Sombra suave
              ),
              onPressed: () {
                // Navigator.pop(context);
                print("Volver presionado");
              },
              // Usamos Row para agregar una flechita junto al texto
              child: const Row(
                mainAxisSize: MainAxisSize.min, // El botón se ajusta al contenido
                children: [
                  Icon(Icons.arrow_back_ios_new, size: 16),
                  SizedBox(width: 8),
                  Text(
                    "Volver",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 3. Contenido Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // Filtros
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: AgendaFilters(
                      fechaDesde: _fechaDesde,
                      fechaHasta: _fechaHasta,
                      estadoSeleccionado: _filtroEstado,
                      onTapDesde: () => _seleccionarFecha(true),
                      onTapHasta: () => _seleccionarFecha(false),
                      onChangedEstado: (v) => setState(() => _filtroEstado = v),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Título Lista
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: AppColors.fieldBlue,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2)
                        )
                      ]
                    ),
                    child: const Text(
                      "Listado de Citas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: Colors.black87
                      ),
                    ),
                  ),

                  // Lista de Tarjetas
                  if (_listaCitas.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No hay citas para este filtro."),
                    )
                  else
                    ..._listaCitas.map((cita) {
                      return AgendaAppointmentCard(
                        data: cita,
                        onAction: (accion) {
                          _manejarNavegacion(context, accion);
                        },
                      );
                    }).toList(),

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

void _manejarNavegacion(BuildContext context, String accion) {
  // Asegúrate que estos textos ("Completar", "Cancelar") sean IDÉNTICOS 
  // a los que pusiste en el onAction("...") dentro de tu Widget.
  
  switch (accion) {
    case "completar": //para el botón verde
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MarcarCitaView()),
      );
      break;

    case "cancelar": // Para el botón de la X roja
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CancelarCitaView()),
      );
      break;

    case "reagendar": // Para el botón del calendario
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReagendarCitaView()),
      );
      break;
      
    case "ver": // Para el botón del ojo marrón
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetalleCitaView()),
      );
      break;
  }
}