import 'package:flutter/material.dart';

class RescheduleActionButtons extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const RescheduleActionButtons({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón Confirmar (Verde - Texto Largo)
        Expanded(
          flex: 2, // Le damos más espacio al botón de confirmar
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676), // Verde brillante
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
            ),
            child: const Text(
              "Confirmar reagendamiento",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        
        const SizedBox(width: 15),
        
        // Botón Cancelar (Rojo)
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252), // Rojo
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
            ),
            child: const Text(
              "Cancelar", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
        ),
      ],
    );
  }
}