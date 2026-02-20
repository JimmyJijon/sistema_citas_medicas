import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoFormulario extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool soloNumeros;
  final bool soloLetras;

  const CampoFormulario({
    super.key, 
    required this.label, 
    required this.hint, 
    required this.controller,
    this.soloNumeros = false,
    this.soloLetras = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF8AB4C4),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller,
              keyboardType: soloNumeros ? TextInputType.number : TextInputType.text,
              inputFormatters: [
                if (soloNumeros) FilteringTextInputFormatter.digitsOnly,
                if (soloLetras) FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
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