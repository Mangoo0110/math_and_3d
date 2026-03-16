part of '../vectors.dart';

class ScreenVector{
  final Vec2 point;
  final Color? color;
  final double z;

  ScreenVector({required this.point, required this.color, required this.z});

  factory ScreenVector.fromConverted2dVector(Converted2dVector point, Color? color, Size screenSize) {
    final Vec2 screen2d = Transformer.translateToScreenPoint(point.point, screenSize);
    return ScreenVector(point: screen2d, color: color, z: point.z);
  }

  ScreenVector copyWith({Vec2? point, Color? color, double? z}) => ScreenVector(point: point ?? this.point, color: color ?? this.color, z: z ?? this.z);
}

class Converted2dVector{
  final Vec2 point;
  final double z;

  Converted2dVector({required this.point, required this.z});

  Converted2dVector copyWith({Vec2? point, double? z}) => Converted2dVector(point: point ?? this.point, z: z ?? this.z);
}
