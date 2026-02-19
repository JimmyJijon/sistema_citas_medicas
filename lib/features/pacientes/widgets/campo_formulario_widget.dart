import 'package:flutter/material.dart';

class CampoFormulario extends StatelessWidget {
  final String label;
  final String hint;
  final String? valorInicial;

  const CampoFormulario({
    super.key, 
    required this.label, 
    required this.hint, 
    this.valorInicial
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF8AB4C4),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(label),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: TextEditingController(text: valorInicial),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}