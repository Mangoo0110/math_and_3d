import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_and_3d/core/math/vectors.dart';

class LineInfo {
  const LineInfo({required this.from, required this.to, this.color = Colors.greenAccent});
  final Vec2 from;
  final Vec2 to;
  final Color color;
}

class DrawLines extends CustomPainter {
  const DrawLines({required this.lines});

  final List<LineInfo> lines;

  @override
  void paint(Canvas canvas, Size size) {
    Offset toOffset(Vec2 coordinate) => Offset(coordinate.x, coordinate.y);
    final paint = Paint()
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    for (final line in lines) {
      paint.color = line.color;
      canvas.drawLine(toOffset(line.from), toOffset(line.to), paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawLines oldDelegate) {
    return !listEquals(oldDelegate.lines, lines);
  }
}

