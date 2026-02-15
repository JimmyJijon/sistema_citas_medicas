import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CustomInputContainer extends StatelessWidget {
  final Widget child;
  final bool isReadOnly;
  final VoidCallback? onTap; // Nuevo: Para detectar el click

  const CustomInputContainer({
    Key? key,
    required this.child,
    this.isReadOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos Material para que el efecto "Ink" (tinta/ola) se vea
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isReadOnly ? null : onTap, // Si es solo lectura, no hace click
        borderRadius: BorderRadius.circular(20), // El efecto respeta los bordes redondeados
        splashColor: Colors.white.withOpacity(0.3), // Color del efecto al tocar
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            // Movemos el color aquí, pero con opacidad si es Ink
            color: AppColors.fieldBlue.withOpacity(isReadOnly ? 0.7 : 1.0),
            borderRadius: BorderRadius.circular(20),
          ),
          height: 45,
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}