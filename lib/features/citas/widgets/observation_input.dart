import 'package:flutter/material.dart';

class ObservationInput extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const ObservationInput({
    Key? key, 
    this.hintText = "[Descripción]", 
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 3, // Altura suficiente para escribir
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.4),
            fontWeight: FontWeight.bold,
            fontSize: 14
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}