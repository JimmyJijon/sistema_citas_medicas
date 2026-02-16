import 'package:flutter/material.dart';

class RescheduleInputRow extends StatelessWidget {
  final String label;
  final String? value;      // Ahora es opcional si usas customChild
  final VoidCallback? onTap;
  final Widget? customChild; // Nuevo: Para meter el Dropdown real aquí

  const RescheduleInputRow({
    Key? key,
    required this.label,
    this.value,
    this.onTap,
    this.customChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Etiqueta Verde Oscuro
          Container(
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32), 
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          
          const SizedBox(width: 15),
          
          // Valor (Gris Azulado)
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 45, // Altura fija para uniformidad
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.centerLeft, // Alineación a la izquierda
                child: customChild ?? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    // Icono de calendario siempre visible para fechas
                    const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
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