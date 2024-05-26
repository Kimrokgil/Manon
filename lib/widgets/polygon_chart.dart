import 'dart:math';

import 'package:flutter/material.dart';
import 'package:man_on/widgets/hexagon_chart_painter.dart';

class PolygonChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const PolygonChart({
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight) * 0.5; // 크기 조절
        return CustomPaint(
          size: Size(size, size),
          painter: HexagonChartPainter(values, labels),
        );
      },
    );
  }
}
