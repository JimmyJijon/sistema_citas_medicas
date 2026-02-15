import 'package:flutter/material.dart';

class CancelActionButtons extends StatelessWidget {
  final VoidCallback onConfirmCancel; // La acción destructiva
  final VoidCallback onAbort;         // La acción de volver atrás

  const CancelActionButtons({
    Key? key,
    required this.onConfirmCancel,
    required this.onAbort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón Confirmar Cancelación (ROJO - Acción Principal)
        Expanded(
          child: ElevatedButton(
            onPressed: onConfirmCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252), // Rojo Alerta
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
            ),
            child: const Text(
              "Confirmar Cancelación",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        
        const SizedBox(width: 15),
        
        // Botón Cancelar/Volver (VERDE - Acción Segura)
        ElevatedButton(
          onPressed: onAbort,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E676), // Verde
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