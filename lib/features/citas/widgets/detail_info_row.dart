import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class DetailInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isLast;

  const DetailInfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono con ancho fijo
              if (icon != null) ...[
                SizedBox(
                  width: 22,
                  child: Icon(icon, color: AppColors.btnGreen, size: 22),
                ),
                const SizedBox(width: 12),
              ],
              
              // ETIQUETA con ancho FIJO - CLAVE para la alineación
              SizedBox(
                width: 120, 
                child: Text(
                  "$label:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              
              const SizedBox(width: 8), // Espacio entre etiqueta y valor
              
              // VALOR que ocupa el espacio restante
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}