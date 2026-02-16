import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/registrar_cita_widgets/form_label_field.dart';
import '../widgets/registrar_cita_widgets/custom_input_container.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class RegistrarCitaView extends StatefulWidget {
  const RegistrarCitaView({Key? key}) : super(key: key);

  @override
  State<RegistrarCitaView> createState() => _RegistrarCitaViewState();
}

class _RegistrarCitaViewState extends State<RegistrarCitaView> {
  //VARIABLES DE ESTADO
  String? _selectedPaciente;
  String? _selectedFranja;
  String? _selectedEstado;
  
  // Iniciamos la fecha con el día de hoy
  DateTime _fechaSeleccionada = DateTime.now();

  // --- LÓGICA DEL CALENDARIO ---
  Future<void> _abrirCalendario() async {
    final DateTime? fechaEscogida = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada, // Fecha que aparece marcada al abrir
      firstDate: DateTime(2020),       // Fecha mínima permitida
      lastDate: DateTime(2030),        // Fecha máxima permitida
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.fieldBlue, // Color de la cabecera del calendario
              onPrimary: Colors.white,      // Color del texto de la cabecera
              onSurface: Colors.black,      // Color de los números
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.btnGreen, // Color de botones "Aceptar/Cancelar"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (fechaEscogida != null && fechaEscogida != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = fechaEscogida;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formateo simple de la fecha para mostrarla (dd/mm/aaaa)
    String textoFecha = "${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(title: "Inicio / Registrar Cita"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Registrar Cita",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),

                    // 1. PACIENTE
                    FormLabelField(
                      label: "Paciente",
                      child: CustomInputContainer(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPaciente,
                            hint: const Text("Buscar Paciente"),
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: "1", child: Text("Juan Perez")),
                              DropdownMenuItem(value: "2", child: Text("Maria Lopez")),
                              DropdownMenuItem(value: "3", child: Text("Carlos Ruiz")),
                            ],
                            onChanged: (v) => setState(() => _selectedPaciente = v),
                          ),
                        ),
                      ),
                    ),

                    // 2. CÉDULA
                    const FormLabelField(
                      label: "Cédula",
                      child: CustomInputContainer(
                        isReadOnly: true,
                        child: Text("[Auto: 0912345678]"),
                      ),
                    ),

                    // 3. TELÉFONO
                    const FormLabelField(
                      label: "Teléfono:",
                      child: CustomInputContainer(
                        isReadOnly: true,
                        child: Text("[Auto: 0998765432]"),
                      ),
                    ),

                    // 4. FECHA 
                    FormLabelField(
                      label: "Fecha:",
                      child: CustomInputContainer(
                        onTap: _abrirCalendario, // Abre el calendario al tocar el campo
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(textoFecha), // Muestra la variable actualizada
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),

                    // 5. FRANJA HORARIA
                    FormLabelField(
                      label: "Franja Horaria",
                      child: CustomInputContainer(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFranja,
                            hint: const Text("[Seleccionar]"),
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: "AM", child: Text("10:00 - 10:20")),
                              DropdownMenuItem(value: "PM", child: Text("14:00 - 14:20")),
                            ],
                            onChanged: (v) => setState(() => _selectedFranja = v),
                          ),
                        ),
                      ),
                    ),

                    // 6. ESTADO
                    FormLabelField(
                      label: "Estado:",
                      child: CustomInputContainer(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedEstado,
                            hint: const Text("[Ingresada]"),
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: "ING", child: Text("Ingresada")),
                              DropdownMenuItem(value: "CNF", child: Text("Confirmada")),
                              DropdownMenuItem(value: "CAN", child: Text("Cancelada")),
                            ],
                            onChanged: (v) => setState(() => _selectedEstado = v),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 7. OBSERVACIÓN
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Observación", style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height: 10),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Escriba una descripción...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- BOTONES ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.btnGreen,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          onPressed: () {},
                          child: const Text("Guardar"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.btnRed,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}