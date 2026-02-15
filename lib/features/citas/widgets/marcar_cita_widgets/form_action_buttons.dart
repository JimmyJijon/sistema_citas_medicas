import 'package:flutter/material.dart';

class FormActionButtons extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const FormActionButtons({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón Confirmar (Verde)
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E676), // Verde
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
          ),
          child: const Text("Confirmar", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 20),
        // Botón Cancelar (Rojo)
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5252), // Rojo
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
          ),
          child: const Text("Cancelar", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}