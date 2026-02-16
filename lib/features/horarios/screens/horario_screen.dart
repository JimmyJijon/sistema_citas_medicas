import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HorarioScreen(),
    );
  }
}

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {

  // Variables
  bool lunes = false;
  bool martes = false;
  bool miercoles = false;
  bool jueves = false;
  bool viernes = false;
  bool sabado = false;
  bool domingo = false;

  String horaInicio = "08:00";
  String horaFin = "17:00";
  String duracion = "30 minutos";
  String pausaInicio = "12:00";
  String pausaFin = "13:00";
  String vigencia = "01/03/2026 10:00";

  final List<String> duraciones = [
    "15 minutos",
    "30 minutos",
    "45 minutos",
    "60 minutos"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8D3E0),
      body: Column(
        children: [

          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            color: const Color(0xFF3F3F37),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text("logo"),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Inicio / Gestión de Horario"),
                )
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Título
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Configuración de Horario de Atención",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text("Días de atención"),

                      Wrap(
                        spacing: 5,
                        children: [
                          _buildCheck("L", lunes, (v)=>setState(()=>lunes=v!)),
                          _buildCheck("M", martes, (v)=>setState(()=>martes=v!)),
                          _buildCheck("M", miercoles, (v)=>setState(()=>miercoles=v!)),
                          _buildCheck("J", jueves, (v)=>setState(()=>jueves=v!)),
                          _buildCheck("V", viernes, (v)=>setState(()=>viernes=v!)),
                          _buildCheck("S", sabado, (v)=>setState(()=>sabado=v!)),
                          _buildCheck("D", domingo, (v)=>setState(()=>domingo=v!)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildTextField("Hora inicio:", horaInicio),
                      _buildTextField("Hora fin:", horaFin),

                      const SizedBox(height: 10),

                      // Dropdown duración
                      Row(
                        children: [
                          const Text("Duración cita: "),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: duracion,
                            items: duraciones.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                duracion = value!;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      const Text("Pausa:", style: TextStyle(fontWeight: FontWeight.bold)),

                      Row(
                        children: [
                          Expanded(child: _buildTextField("Inicio:", pausaInicio)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildTextField("Fin:", pausaFin)),
                        ],
                      ),

                      const SizedBox(height: 15),

                      _buildTextField("Vigencia desde:", vigencia),

                      const SizedBox(height: 20),

                      // Botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Horario guardado")),
                              );
                            },
                            child: const Text("Guardar"),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {});
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
          )
        ],
      ),
    );
  }

  Widget _buildCheck(String texto, bool valor, Function(bool?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: valor, onChanged: onChanged),
        Text(texto),
      ],
    );
  }

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: value,
                filled: true,
                fillColor: Colors.lightBlue.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}  