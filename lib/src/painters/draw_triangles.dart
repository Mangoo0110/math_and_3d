import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_and_3d/src/core/vectors/vectors.dart';

class TriangleInfo {
  const TriangleInfo({required this.a, required this.b, required this.c, this.color = Colors.greenAccent});
  final Vec2 a;
  final Vec2 b;
  final Vec2 c;
  final Color color;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TriangleInfo &&
            a == other.a &&
            b == other.b &&
            c == other.c &&
            color == other.color);
  }

  @override
  int get hashCode => a.hashCode ^ b.hashCode ^ c.hashCode ^ color.hashCode;
}

class DrawTriangles extends CustomPainter {
  const DrawTriangles({required this.triangles});

  final List<TriangleInfo> triangles;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // A thin stroke outline hides most aliasing artifacts on edges.
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = Colors.greenAccent
      ..isAntiAlias = true;

    for (final triangle in triangles) {
      final path = Path()
        ..moveTo(triangle.a.x, triangle.a.y)
        ..lineTo(triangle.b.x, triangle.b.y)
        ..lineTo(triangle.c.x, triangle.c.y)
        ..close();

      fillPaint.color = triangle.color;
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawTriangles oldDelegate) {
    return !listEquals(oldDelegate.triangles, triangles);
  }
}

