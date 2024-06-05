import 'dart:math' as math;
import 'package:flutter/material.dart';

class HexagonChartPainter extends CustomPainter {
  final List<double> values;
  final double maxValue;
  final List<String> labels;

  HexagonChartPainter({
    required this.values,
    required this.maxValue,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw Hexagon
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, borderPaint);

    // Draw connecting lines
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), borderPaint);
    }

    // Draw Values
    final valuePath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final valueRadius = radius * (values[i] / maxValue);
      final x = center.dx + valueRadius * math.cos(angle);
      final y = center.dy + valueRadius * math.sin(angle);
      if (i == 0) {
        valuePath.moveTo(x, y);
      } else {
        valuePath.lineTo(x, y);
      }
    }
    valuePath.close();
    canvas.drawPath(valuePath, paint);

    // Draw Labels
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final x = center.dx + (radius + 10) * math.cos(angle);
      final y = center.dy + (radius + 10) * math.sin(angle);
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
