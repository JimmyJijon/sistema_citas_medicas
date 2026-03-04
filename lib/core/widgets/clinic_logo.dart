// Archivo: lib/core/widgets/clinic_logo.dart
import 'package:flutter/material.dart';

class ClinicLogo extends StatelessWidget {
  final double size;
  final Color color;

  const ClinicLogo({
    super.key,
    this.size = 22.0, // Tamaño por defecto
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ClinicLogoCrossHeartPainter(color: color),
    );
  }
}

class _ClinicLogoCrossHeartPainter extends CustomPainter {
  final Color color;
  _ClinicLogoCrossHeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double mid = size.width / 2;
    const double crossSize = 6.0;

    final Path heartPath = Path()
      ..moveTo(mid, size.height * 0.25)
      ..cubicTo(
        size.width * 0.9,
        -size.height * 0.1,
        size.width * 1.3,
        size.height * 0.6,
        mid,
        size.height,
      )
      ..cubicTo(
        -size.width * 0.3,
        size.height * 0.6,
        size.width * 0.1,
        -size.height * 0.1,
        mid,
        size.height * 0.25,
      )
      ..close();
    canvas.drawPath(heartPath, paint);

    final Paint crossPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        mid - (crossSize * 0.8),
        size.height * 0.45,
        crossSize * 1.6,
        crossSize * 0.3,
      ),
      crossPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        mid - (crossSize * 0.15),
        size.height * 0.35,
        crossSize * 0.3,
        crossSize,
      ),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
