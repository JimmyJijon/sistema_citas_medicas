import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart'; // Asegúrate de importar tus colores

class FormLabelField extends StatelessWidget {
  final String label;
  final Widget child; // El input (Dropdown, Texto, Fecha, etc.)
  final double labelWidth;

  const FormLabelField({
    Key? key,
    required this.label,
    required this.child,
    this.labelWidth = 140,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          // La etiqueta azul (Izquierda)
          Container(
            width: labelWidth,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.fieldBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 10),
          // El campo de entrada (Derecha)
          Expanded(child: child),
        ],
      ),
    );
  }
}