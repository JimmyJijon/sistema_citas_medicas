import 'package:flutter/material.dart';

class HistoryLogItem extends StatelessWidget {
  final String date;
  final String user;
  final String action;
  final String description;

  const HistoryLogItem({
    Key? key,
    required this.date,
    required this.user,
    required this.action,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50, // fondo muy sutil para diferenciar del blanco
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha pequeña arriba
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 12, 
                  color: Colors.grey
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Usuario y Acción
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
              children: [
                const TextSpan(text: "Usuario: ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "$user\n"),
                const TextSpan(text: "Acción: ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: action), 
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 5),
          
          // Descripción
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}