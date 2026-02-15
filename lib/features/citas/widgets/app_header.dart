import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Asegura que ocupe todo el ancho
      color: AppColors.header, // El color de fondo cubre la barra de estado 
      child: SafeArea(
        bottom: false, //proteger la parte superior
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), 
          child: Row(
            children: [
              // Placeholder del Logo
              Container(
                width: 45, // tamaño para ajustar altura
                height: 45,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text("logo", style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
              const SizedBox(width: 15),
              
              // Barra de título breadcrumb
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.fieldBlue,
                    borderRadius: BorderRadius.circular(8), // Bordes un poco menos redondeados para verse más técnico
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Ajuste de fuente para que quepa mejor
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis, // Si el texto es muy largo, pone "..."
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}