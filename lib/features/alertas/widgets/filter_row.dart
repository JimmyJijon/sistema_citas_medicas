import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart'; 

class FilterRow extends StatelessWidget {
  final String label;
  final List<String> items;
  final String currentValue;
  final ValueChanged<String?> onChanged;

  const FilterRow({
    super.key,
    required this.label,
    required this.items,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Etiqueta (Label)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.fieldBlue, 
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // negrita
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 10),
        
        // Dropdown
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.fieldBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                dropdownColor: AppColors.fieldBlue,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}