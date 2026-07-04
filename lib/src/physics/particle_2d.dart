import 'package:flutter/material.dart';
import '../core/vectors/vectors.dart';

class Particle2D {
  Particle2D({
    required this.position,
    required this.velocity,
    required this.acceleration,
    this.radius = 10.0,
    this.color = Colors.blue,
  });

  /// Position of the center of the particle in 2D space.
  /// This is a vector with x and y coordinates.
  Vec2 position;
  Vec2 velocity;
  Vec2 acceleration;
  double radius;
  
  Color color;

  double get mass => radius * radius * 3.14; // Assuming mass is proportional to area (πr²) for simplicity.

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Particle2D &&
        other.position == position &&
        other.velocity == velocity &&
        other.acceleration == acceleration &&
        other.radius == radius &&
        other.mass == mass &&
        other.color == color;
  }

  @override
  int get hashCode {
    return position.hashCode ^
        velocity.hashCode ^
        acceleration.hashCode ^
        radius.hashCode ^
        mass.hashCode ^
        color.hashCode;
  }
}
