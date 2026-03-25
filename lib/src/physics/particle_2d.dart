import 'package:flutter/material.dart';
import '../core/vectors/vectors.dart';

class Particle2D {
  Particle2D({
    required this.position,
    required this.velocity,
    required this.acceleration,
    this.radius = 10.0,
    this.mass = 1.0,
    this.color = Colors.blue,
  });

  Vec2 position;
  Vec2 velocity;
  Vec2 acceleration;
  double radius;
  double mass;
  Color color;
}
