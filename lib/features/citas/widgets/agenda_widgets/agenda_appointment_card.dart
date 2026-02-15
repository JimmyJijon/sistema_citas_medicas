import 'package:flutter/material.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart'; // Asegúrate de importar tus colores

class AgendaAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String action) onAction;

  const AgendaAppointmentCard({
    Key? key,
    required this.data,
    required this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String estado = data['estado'];
    bool esEditable = (estado == "Ingresada" || estado == "Reagendada");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2), // Padding muy reducido
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
        ]
      ),
      child: Row(
        children: [
          // Usamos los MISMOS flex que en el header
          Expanded(flex: 2, child: _CellText(data['fecha'])),
          Expanded(flex: 2, child: _CellText(data['hora'])),
          Expanded(flex: 3, child: _CellText(data['paciente'])),
          Expanded(flex: 2, child: _CellText(data['estado'])),
          
          // Columna de Acciones (Flex 4)
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _IconBtn(Icons.remove_red_eye, Colors.brown, () => onAction("ver")),
                
                if (esEditable) ...[
                  // Espacios reducidos a 2px
                  const SizedBox(width: 2),
                  _IconBtn(Icons.sync, Colors.blueGrey, () => onAction("reagendar")),
                  const SizedBox(width: 2),
                  _IconBtn(Icons.check_box, AppColors.btnGreen, () => onAction("completar")),
                  const SizedBox(width: 2),
                  _IconBtn(Icons.close, AppColors.btnRed, () => onAction("cancelar")),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Texto de Celda Inteligente
class _CellText extends StatelessWidget {
  final String text;
  const _CellText(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: FittedBox( 
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: Colors.black87), // Fuente base 11
        ),
      ),
    );
  }
}

// Botón de Ícono ajustado
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn(this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0), // Aumenta área de toque sin ocupar espacio visual
        child: Icon(icon, size: 18, color: color), // Íconos más pequeños (18px)
      ),
    );
  }
}