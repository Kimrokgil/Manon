import 'package:flutter/material.dart';
import 'dart:math';

class PolygonChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final double maxValue;

  PolygonChart({
    required this.values,
    required this.labels,
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200),
      painter: HexagonChartPainter(values: values, labels: labels, maxValue: maxValue),
    );
  }
}

class HexagonChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final double maxValue;

  HexagonChartPainter({
    required this.values,
    required this.labels,
    this.maxValue = 100,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final Paint gridPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    final double angle = (2 * pi) / values.length;
    final double radius = min(size.width / 2, size.height / 2) * 0.8;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Path path = Path();

    for (int i = 0; i < values.length; i++) {
      final double x = center.dx + radius * (values[i] / maxValue) * cos(angle * i - pi / 2);
      final double y = center.dy + radius * (values[i] / maxValue) * sin(angle * i - pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      final double labelX = center.dx + (radius + 10) * cos(angle * i - pi / 2);
      final double labelY = center.dy + (radius + 10) * sin(angle * i - pi / 2);

      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(color: Colors.black, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas, Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2));
    }

    path.close();
    canvas.drawPath(path, paint);

    for (int i = 0; i < values.length; i++) {
      final double x = center.dx + radius * cos(angle * i - pi / 2);
      final double y = center.dy + radius * sin(angle * i - pi / 2);

      canvas.drawLine(center, Offset(x, y), gridPaint);
    }

    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
