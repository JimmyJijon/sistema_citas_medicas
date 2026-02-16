import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/citas/widgets/app_header.dart'; 

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  // --- ESTADO ---
  Map<String, bool> diasSeleccionados = {
    "L": false,
    "M": false,
    "X": false, // Miércoles
    "J": false,
    "V": false,
    "S": false,
    "D": false,
  };

  final TextEditingController horaInicioCtrl = TextEditingController(text: "08:00");
  final TextEditingController horaFinCtrl = TextEditingController(text: "17:00");
  final TextEditingController pausaInicioCtrl = TextEditingController(text: "12:00");
  final TextEditingController pausaFinCtrl = TextEditingController(text: "13:00");
  final TextEditingController vigenciaCtrl = TextEditingController(text: "01/03/2026");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. HEADER
          const AppHeader(title: "Inicio / Configuración / Horarios"),

          // 2. BOTÓN VOLVER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.btnGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Volver",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          // 3. TARJETA PRINCIPAL
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      
                      // Título Sección
                      const Text(
                        "Configuración de Horario",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Define tu disponibilidad semanal", 
                        style: TextStyle(color: Colors.grey, fontSize: 12)
                      ),
                      const SizedBox(height: 25),

                      // --- SECCIÓN DÍAS ---
                      _tituloSeccion("Días de Atención"),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: diasSeleccionados.keys.map((dia) {
                          return _buildDayCircle(dia);
                        }).toList(),
                      ),

                      const SizedBox(height: 25),

                      // --- SECCIÓN HORAS ---
                      _tituloSeccion("Horario General"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _campoTime("Inicio", horaInicioCtrl)),
                          const SizedBox(width: 15),
                          Expanded(child: _campoTime("Fin", horaFinCtrl)),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // --- SECCIÓN PAUSA ---
                      _tituloSeccion("Pausa / Almuerzo"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _campoTime("Inicio Pausa", pausaInicioCtrl)),
                          const SizedBox(width: 15),
                          Expanded(child: _campoTime("Fin Pausa", pausaFinCtrl)),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // --- VIGENCIA ---
                      _campoGenerico("Vigencia desde", vigenciaCtrl, Icons.calendar_today),

                      const SizedBox(height: 30),

                      // --- BOTONES DE ACCIÓN ---
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancelar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.btnGreen,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Horario guardado correctamente")),
                                );
                              },
                              child: const Text("Guardar Cambios", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // WIDGETS AUXILIARES

  Widget _buildDayCircle(String dia) {
    bool isSelected = diasSeleccionados[dia]!;
    return GestureDetector(
      onTap: () {
        setState(() {
          diasSeleccionados[dia] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.btnGreen : Colors.grey[200],
          shape: BoxShape.circle,
          border: isSelected 
            ? Border.all(color: Colors.green.shade700, width: 2)
            : Border.all(color: Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          dia,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _tituloSeccion(String texto) {
    return Row(
      children: [
        Container(
          height: 20, 
          width: 4, 
          decoration: BoxDecoration(
            color: AppColors.btnGreen,
            borderRadius: BorderRadius.circular(2)
          ),
        ),
        const SizedBox(width: 8),
        Text(texto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _campoTime(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            prefixIcon: const Icon(Icons.access_time, size: 20, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[50],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blueGrey),
            ),
          ),
          readOnly: true, 
          onTap: () {
            // Aquí iría la lógica del TimePicker
          },
        ),
      ],
    );
  }

  Widget _campoGenerico(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[50],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
      ),
    );
  }
}