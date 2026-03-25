import 'package:flutter/material.dart';
import '../physics/particle_2d.dart';

class DrawParticles2D extends CustomPainter {
  DrawParticles2D({required this.particles, required this.bounds});

  final List<Particle2D> particles;
  final Size bounds;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw an outline boundary to represent the world limits
    final boundsPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, bounds.width, bounds.height), boundsPaint);

    // Draw each particle at its vector position
    for (var p in particles) {
      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(p.position.x, p.position.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
