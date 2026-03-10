import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_and_3d/core/math/vectors.dart';

/// Draws a rectangle point on screen.
Widget drawRectPoint(Vec2 point) {
  return CustomPaint(
    painter: SquareDotPainter(coordinate: point),
  );
}

class SquareDotPainter extends CustomPainter {
  const SquareDotPainter({this.color = Colors.greenAccent, required this.coordinate});

  final Color color;
  final Vec2 coordinate;

  @override
  void paint(Canvas canvas, Size size) {
    const squareLen = 10.0;
    final rect = Rect.fromLTWH(
      coordinate.x - squareLen / 2,
      coordinate.y - squareLen / 2,
      squareLen,
      squareLen,
    );
    canvas.drawRect(
      rect,
      Paint()
        ..color = color
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant SquareDotPainter oldDelegate) {
    return color != oldDelegate.color || coordinate != oldDelegate.coordinate;
  }
}

class SquareDotInfo {
  const SquareDotInfo(this.coordinate, [this.color = Colors.greenAccent]);
  final Vec2 coordinate;
  final Color color;
}

class DrawSquareDots extends CustomPainter {
  const DrawSquareDots({required this.dots});

  final List<SquareDotInfo> dots;

  @override
  void paint(Canvas canvas, Size size) {
    for (final dot in dots) {
      const squareLen = 10.0;
      final rect = Rect.fromLTWH(
        dot.coordinate.x - squareLen / 2,
        dot.coordinate.y - squareLen / 2,
        squareLen,
        squareLen,
      );
      canvas.drawRect(
        rect,
        Paint()
          ..color = dot.color
          ..isAntiAlias = true,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DrawSquareDots oldDelegate) {
    return !listEquals(oldDelegate.dots, dots);
  }
}

