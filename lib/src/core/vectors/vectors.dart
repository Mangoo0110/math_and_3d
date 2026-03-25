import 'dart:math';

import 'package:flutter/material.dart';

import '../../transformer/transformer.dart';
part 'parts/screen_vectors.dart';

class Vec2 {
  Vec2(this.x, this.y);

  final double x;
  final double y;

  Vec2 operator +(Vec2 other) => Vec2(x + other.x, y + other.y);
  Vec2 operator -(Vec2 other) => Vec2(x - other.x, y - other.y);
  Vec2 operator *(double scalar) => Vec2(x * scalar, y * scalar);
  Vec2 operator /(double scalar) => Vec2(x / scalar, y / scalar);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Vec2 && runtimeType == other.runtimeType && x == other.x && y == other.y);
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Vec2(x: $x, y: $y)';
}

class Vec3 {
  Vec3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  Vec3 operator +(Vec3 other) => Vec3(x + other.x, y + other.y, z + other.z);
  Vec3 operator -(Vec3 other) => Vec3(x - other.x, y - other.y, z - other.z);
  Vec3 operator *(double scalar) => Vec3(x * scalar, y * scalar, z * scalar);
  Vec3 operator /(double scalar) => Vec3(x / scalar, y / scalar, z / scalar);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Vec3 &&
            runtimeType == other.runtimeType &&
            x == other.x &&
            y == other.y &&
            z == other.z);
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;

  @override
  String toString() => 'Vec3(x: $x, y: $y, z: $z)';

  Vec3 translateX(double dx) {
    return Vec3(x + dx, y, z);
  }

  Vec3 translateY(double dy) {
    return Vec3(x, y + dy, z);
  }

  Vec3  translateZ(double dz) {
    return Vec3(x, y, z + dz);
  }

  /// This rotates around the y axis on plane xz
  // Formula:
  // x' = x * cos(theta) - y * sin(theta)
  // y' = y
  // z' = x * sin(theta) + y + cos(theta)
  Vec3 rotateXZ(double angle) {
    return Vec3(
      x * cos(angle) - z * sin(angle),
      y,
      x * sin(angle) + z * cos(angle),
    );
  }

  Vec3 rotateYZ(double angle) {
    return Vec3(
      x,
      y * cos(angle) - z * sin(angle),
      y * sin(angle) + z * cos(angle)
    );
  }

  Vec3 rotateXY(double angle) {
    return Vec3(
      x * cos(angle) - y * sin(angle),
      x * sin(angle) + y * cos(angle),
      z,
    );
  }

  Vec3 copyWith({double? x, double? y, double? z}) {
    return Vec3(x ?? this.x, y ?? this.y, z ?? this.z);
  }
}

