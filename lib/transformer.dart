import 'dart:math';
import 'package:flutter/material.dart';
import 'components/draw_square_dots.dart';
import 'core/math/vectors.dart';

class Vec3Transformer extends Transformer {
  final List<Vec3> vertices;

  Vec3Transformer({required this.vertices});

  List<SquareDotInfo> squareDots(Size screenSize) => _toSquareDots(translateToScreenPoints(_project3dTo2dAll(vertices), screenSize));

  List<Vec2> to2d() => _project3dTo2dAll(vertices);

  List<Vec2> projectScreen(Size screenSize) => translateToScreenPoints(to2d(), screenSize);

  List<Vec3> rotateXZ(double angle) => _rotateXZ(vertices, angle);
  List<Vec3> rotateXY(double angle) => _rotateXY(vertices, angle);
  List<Vec3> rotateYZ(double angle) => _rotateYZ(vertices, angle);

  List<Vec3> translateZ(double dz) => _translateZ(vertices, dz);
  List<Vec3> translateX(double dz) => _translateX(vertices, dz);
  List<Vec3> translateY(double dz) => _translateY(vertices, dz);
}

mixin class Transformer {
  List<SquareDotInfo> _toSquareDots(List<Vec2> points) {
    return points.map((e) => SquareDotInfo(Vec2(e.x, e.y))).toList();
  }

  List<Vec2> _project3dTo2dAll(List<Vec3> points) {
    return points.map((e) {
      final twoD = project3dTo2d(e);
      debugPrint("3d: $e, 2d: $twoD");
      return twoD;
    }).toList();
  }

  List<Vec3> _translateZ(List<Vec3> points, double dz) {
    for(int i = 0; i < points.length; i++) {
      points[i] = points[i].translateZ(dz);
    }
    return points;
  }

  List<Vec3> _translateX(List<Vec3> points, double dx) {
    for(int i = 0; i < points.length; i++) {
      points[i] = points[i].translateX(dx);
    }
    return points;
  }

  List<Vec3> _translateY(List<Vec3> points, double dy) {
    for(int i = 0; i < points.length; i++) {
      points[i] = points[i].translateY(dy);
    }
    return points;
  }

  
  List<Vec3> _rotateXZ(List<Vec3> points, double angle) {
    for(int i = 0; i < points.length; i++) {
      points[i] = points[i].rotateXZ(angle);
    }
    return points;
  }

  //
  // Formula:
  // x' = x
  // y' = y * cos(theta) - z * sin(theta)
  // z' = y * sin(theta) + z * cos(theta)
  List<Vec3> _rotateYZ(List<Vec3> points, double angle) {
    for(int i = 0; i < points.length; i++) {
      points[i] = points[i].rotateYZ(angle);
    }
    return points;
  }

  // Formula:
  // x' = x * cos(theta) - z * sin(theta)
  // y' = x * sin(theta) + z * cos(theta)
  // z' = z
  List<Vec3> _rotateXY(List<Vec3> points, double angle) {
    for(int i = 0; i < points.length; i++) {
      points[i] = points[i].rotateXY(angle);
    }
    return points;
  }

  // Simplified formula from: 3d: (x, y, z) => 2d: (x/z, y/z)
  // Which is essentially derived from similar triangle theorem
  //
  /// Below videos sources explains the formula behind 3d coordinates to 2d coordinates much better: 
  /// https://youtu.be/eoXn6nwV694?si=hOaW5FIAczj45jzD
  /// https://youtu.be/qjWkNZ0SXfo?si=gYZLzm_ht9McmHW7
  ///
  // More detailed formula is: 
  // 3d: (x, y, z) => 2d: (x/(z * tan(theta)), y/(z * tan(theta))) 
  //
  // Here z is the depth or how far behind the object is from the screen.
  // Minimum depth z is 0.1 to avoid division by zero
  Vec2 project3dTo2d(Vec3 coooridanates) {
    final z = coooridanates.z;
    return Vec2(
      coooridanates.x / z,
      coooridanates.y / z,
    );
  }

  Vec2 translateToScreenPoint(Vec2 coordinate, Size screenSize) {
    // Assuming that coordinate values are between -1 and 1
    // (0,0) is the middle point of the plane
    if(coordinate.x > 1 || coordinate.x < -1 || coordinate.y > 1 || coordinate.y < -1) {
      debugPrint(coordinate.toString());
    }
    return Vec2(
      (coordinate.x + 1)/2 * screenSize.width,
      (1 - coordinate.y)/2 * screenSize.height
    );
  }

  List<Vec2> translateToScreenPoints(List<Vec2> coordinates, Size screenSize) {
    return coordinates.map((e) => translateToScreenPoint(e, screenSize)).toList();
  }
}