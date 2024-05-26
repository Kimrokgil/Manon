import 'package:flutter/material.dart';
import 'dart:math';

class HexagonChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;

  HexagonChartPainter(this.values, this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    Paint polygonPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    Paint linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Paint labelPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = min(centerX, centerY) * 0.8; // 반경 조절
    double angle = (2 * pi) / values.length;

    Path polygonPath = Path();
    for (int i = 0; i < values.length; i++) {
      double x = centerX + radius * values[i] * cos(angle * i);
      double y = centerY + radius * values[i] * sin(angle * i);
      if (i == 0) {
        polygonPath.moveTo(x, y);
      } else {
        polygonPath.lineTo(x, y);
      }
    }
    polygonPath.close();
    canvas.drawPath(polygonPath, polygonPaint);

    for (int i = 0; i < values.length; i++) {
      double x = centerX + radius * cos(angle * i);
      double y = centerY + radius * sin(angle * i);
      canvas.drawLine(Offset(centerX, centerY), Offset(x, y), linePaint);

      double labelX = centerX + (radius + 20) * cos(angle * i);
      double labelY = centerY + (radius + 20) * sin(angle * i);
      TextSpan span = TextSpan(style: TextStyle(color: Colors.black, fontSize: 12), text: labels[i]);
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(labelX - tp.width / 2, labelY - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
