import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_and_3d/src/core/vectors/vectors.dart';
import 'package:math_and_3d/src/transformer/transformer.dart';

class LineInfo {
  const LineInfo({required this.from, required this.to, this.color = Colors.greenAccent});
  final ScreenVector from;
  final ScreenVector to;
  final Color color;

  double get minZ => min(from.z, to.z);
  double get maxZ => min(from.z, to.z);
}

class DrawLines extends CustomPainter {
  const DrawLines({required this.lines});

  final List<LineInfo> lines;

  @override
  void paint(Canvas canvas, Size size) {
    Offset toOffset(Vec2 coordinate) => Offset(coordinate.x, coordinate.y);
    final paint = Paint()
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    // Sort lines by minZ
    // This way we decide which lines to paint first
    lines.sort((a, b) => (-1 * (a.minZ).compareTo((b.minZ))));
    // debugPrint("\n\nPainting Lines------------------------------\n");
    for (final line in lines) {
      // debugPrint("Line >> from: ${line.from.point}, to: ${line.to.point}, minZ: ${line.minZ}, maxZ: ${line.maxZ}");
      paint.color = line.color;
      canvas.drawLine(toOffset(line.from.point), toOffset(line.to.point), paint);
    }
    // debugPrint("\nLines are painted------------------------------\n\n");

  }

  @override
  bool shouldRepaint(covariant DrawLines oldDelegate) {
    return !listEquals(oldDelegate.lines, lines);
  }
}

