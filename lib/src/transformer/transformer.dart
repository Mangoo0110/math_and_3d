import 'package:flutter/material.dart';
import '../painters/draw_square_dots.dart';
import '../core/vectors/vectors.dart';


class Transformer {
  // Simple camera controls for perspective projection.
  // Larger `cameraDistance` pushes the object "away" (smaller on screen).
  final double cameraDistance = 3.0;
  final double focalLength = 1.0; // Think of this as zoom.
  //double nearPlane = 0.001; // Prevents division blow-ups near z ~= 0.
  bool logProjection = false;

  static List<SquareDotInfo> toSquareDots(List<Vec2> points) {
    return points.map((e) => SquareDotInfo(Vec2(e.x, e.y))).toList();
  }

  static List<Converted2dVector> project3dTo2dAll(List<Vec3> points) {
    return points.map((e) {
      final twoD = project3dTo2d(e);
      return Converted2dVector(point: twoD, z: e.z);
    }).toList();
  }

  static List<Vec3> translateZ(List<Vec3> points, double dz) {
    // Copy the list
    final processPoints = points.map((e) => e.copyWith()).toList();
    for(int i = 0; i < processPoints.length; i++) {
      processPoints[i] = processPoints[i].translateZ(dz);
    }
    return processPoints;
  }

  static List<Vec3> translateX(List<Vec3> points, double dx) {
    // Copy the list
    final processPoints = points.map((e) => e.copyWith()).toList();
    for(int i = 0; i < processPoints.length; i++) {
      processPoints[i] = processPoints[i].translateX(dx);
    }
    return processPoints;
  }

  static List<Vec3> translateY(List<Vec3> points, double dy) {
    // Copy the list
    final processPoints = points.map((e) => e.copyWith()).toList();
    for(int i = 0; i < processPoints.length; i++) {
      processPoints[i] = processPoints[i].translateY(dy);
    }
    return processPoints;
  }

  
  static List<Vec3> rotateXZ(List<Vec3> points, double angle) {
    // Copy the list
    final processPoints = points.map((e) => e.copyWith()).toList();
    for(int i = 0; i < processPoints.length; i++) {
      processPoints[i] = processPoints[i].rotateXZ(angle);
    }
    return processPoints;
  }

  //
  // Formula:
  // x' = x
  // y' = y * cos(theta) - z * sin(theta)
  // z' = y * sin(theta) + z * cos(theta)
  static List<Vec3> rotateYZ(List<Vec3> points, double angle) {
    // Copy the list
    final processPoints = points.map((e) => e.copyWith()).toList();
    for(int i = 0; i < processPoints.length; i++) {
      processPoints[i] = processPoints[i].rotateYZ(angle);
      
    }
    return processPoints;
  }

  // Formula:
  // x' = x * cos(theta) - z * sin(theta)
  // y' = x * sin(theta) + z * cos(theta)
  // z' = z
  static List<Vec3> rotateXY(List<Vec3> points, double angle) {
    // Copy the list
    final processPoints = points.map((e) => e.copyWith()).toList();
    for(int i = 0; i < processPoints.length; i++) {
      processPoints[i] = processPoints[i].rotateXY(angle);
    }
    return processPoints;
  }

  // Simplified formula from: 3d: (x, y, z) => 2d: (x/z, y/z)
  // Which is essentially derived from similar triangle theorem
  //
  /// Below videos sources explains the formula behind 3d coordinates to 2d coordinates much better: 
  /// https://youtu.be/eoXn6nwV694?si=hOaW5FIAczj45jzD
  /// https://youtu.be/qjWkNZ0SXfo?si=gYZLzmht9McmHW7
  ///
  // More detailed formula is: 
  // 3d: (x, y, z) => 2d: (x/(z * tan(theta)), y/(z * tan(theta))) 
  //
  // Here z is the depth or how far behind the object is from the screen.
  // Minimum depth z is 0.1 to avoid division by zero
  static Vec2 project3dTo2d(Vec3 coooridanates) {
    // Keep everything in front of the camera and
    // away from the near plane.
    final z = coooridanates.z;
    //final scale = focalLength / z;
    final vec2 = Vec2(
      coooridanates.x / z,
      coooridanates.y / z,
    );
    return vec2;
  }

  static Vec2 translateToScreenPoint(Vec2 coordinate, Size screenSize) {
    // Assuming that coordinate values are between -1 and 1
    // (0,0) is the middle point of the plane
    if(coordinate.x > 1 || coordinate.x < -1 || coordinate.y > 1 || coordinate.y < -1) {
      //debugPrint(coordinate.toString());
    }
    return Vec2(
      (coordinate.x + 1)/2 * screenSize.width,
      (1 - coordinate.y)/2 * screenSize.height
    );
  }

  /// ### Batch translation
  static List<ScreenVector> translateToScreenPoints(List<Converted2dVector> coordinates, Size screenSize) {
    return coordinates.map((e) => ScreenVector.fromConverted2dVector(e, null, screenSize)).toList();
  }
}
