import 'dart:math';
import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  final int percentage;
  final Color foregroundColor;
  final double strokeWidth;

  ArcPainter({
    required this.percentage,
    required this.foregroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Configuración común de la pintura para ambos arcos
    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke // Queremos solo el borde del arco
      ..strokeCap = StrokeCap.round; // Extremos redondeados

    // Centro y radio del círculo que contendrá los arcos
    final center = Offset(size.width / 2, size.height / 2);
    // Usamos el menor entre ancho y alto para asegurar que sea un círculo
    // y restamos la mitad del grosor para que quepa completo
    final radius = min(size.width / 2, size.height / 2) - strokeWidth / 2;

    // Rectángulo delimitador para los arcos
    final rect = Rect.fromCircle(center: center, radius: radius);

    // --- 2. Dibuja el arco de progreso ---
    paint.color = foregroundColor;
    final double sweepAngle = 2 * pi * (percentage/100); // Ángulo basado en el porcentaje
    canvas.drawArc(
      rect,
      -pi / 2, // Mismo ángulo inicial
      sweepAngle,
      false,
      paint,
    );
  }

  // Repintar solo si cambian los valores que afectan el dibujo
  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
            oldDelegate.foregroundColor != foregroundColor ||
            oldDelegate.strokeWidth != strokeWidth;
  }
}