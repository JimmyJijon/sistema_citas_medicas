// lib/features/citas/widgets/hora_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/citas_viewmodel.dart';

class HoraSelector extends StatelessWidget {
  const HoraSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CitaViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: vm.horaSeleccionada,
              hint: const Text("Seleccione una hora"),
              items: vm.franjasHorarias.map((String hora) {
                return DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                );
              }).toList(),
              onChanged: (String? nuevaHora) {
                if (nuevaHora != null) vm.setHora(nuevaHora);
              },
            ),
          ),
        ),
      ],
    );
  }
}