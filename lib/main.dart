import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_and_3d/core/themes/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math And 3D',
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: ThemeMode.dark,
      home: const TheRealm(
        screenSize: Size(500, 400),
      ),
    );
  }
}


class TheRealm extends StatefulWidget {
  const TheRealm({super.key, required this.screenSize});
  final Size screenSize;

  @override
  State<TheRealm> createState() => _TheRealmState();
}

class _TheRealmState extends State<TheRealm> {
  Timer? timer;
  static const int fps = 60;
  double dz = 1;
  double depth = 0;
  double angle = 0;



  List<Vec3> threeDpoints = [
    Vec3(.25, .25, 0.25),
    Vec3(-.25, .25, 0.25),
    Vec3(.25, -.25, 0.25),
    Vec3(-.25, -.25, 0.25),

    Vec3(.25, .25, -0.25),
    Vec3(-.25, .25, -0.25),
    Vec3(.25, -.25, -0.25),
    Vec3(-.25, -.25, -0.25),
  ];

  List<SquareDotValue> toSquareDots(List<Vec2> points) {
    return points.map((e) => SquareDotValue(Vec2(e.x, e.y))).toList();
  }

  List<Vec2> project3dTo2dAll(List<Vec3> points) {
    return points.map((e) => project3dTo2d(e)).toList();
  }

  List<Vec3> translateZ(List<Vec3> points, double dz) {
    return points.map((e) => Vec3(e.x, e.y, e.z + dz)).toList();
  }

  /// This rotates around the y axis on plane xz
  // Formula:
  // x' = x * cos(theta) - y * sin(theta)
  // y' = y
  // z' = x * sin(theta) + y + cos(theta)
  List<Vec3> rotateXZ(List<Vec3> points, double angle) {
    return points.map((e) {
      final x = e.x;
      final y = e.y;
      final z = e.z;
      return Vec3(
        x * cos(angle) - z * sin(angle),
        y,
        x * sin(angle) + z * cos(angle)
      );
    }).toList();
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
    return Vec2(
      coooridanates.x / coooridanates.z,
      coooridanates.y / coooridanates.z
    );
  }

  Vec2 translateToScreenPoint(Vec2 coordinate) {
    // Assuming that coordinate values are between -1 and 1
    // (0,0) is the middle point of the plane
    if(coordinate.x > 1 || coordinate.x < -1 || coordinate.y > 1 || coordinate.y < -1) {
      debugPrint(coordinate.toString());
    }
    return Vec2(
      (coordinate.x + 1)/2 * widget.screenSize.width,
      (1 - coordinate.y)/2 * widget.screenSize.height
    );
  }

  List<Vec2> translateToScreenPoints(List<Vec2> coordinates) {
    return coordinates.map((e) => translateToScreenPoint(e)).toList();
  }



  @override
  void initState() {
    double frame = 0;
    final dt = 1/fps;
    timer = Timer.periodic(Duration(milliseconds: (1000/fps).floor()), (timer) {
      frame += 1;
      depth += dt;
      //dz += dt;
      angle += pi * dt;
      // if(frame >= fps * 10) {
      //   timer.cancel();
      //   return;
      // }
      setState(() {
        
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Container(
            color: Colors.black,
            height: widget.screenSize.height,
            width: widget.screenSize.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 10,
                  left: 0,
                  child: Text((dz).toString(), style: const TextStyle(color: Colors.white),),
                ),
                  Positioned(
                    left: widget.screenSize.width/2,
                    child: Container(
                      height: widget.screenSize.height,
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                    
                CustomPaint(
                  painter: DrawSquareDots(
                    dots: toSquareDots(
                      translateToScreenPoints(
                        project3dTo2dAll(
                         translateZ(
                            rotateXZ(threeDpoints, angle), 
                         dz),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        );
      },
    );
  }
  
}



/// Draws a rectangle point on screen
Widget drawRectPoint(Vec2 point) {
  return CustomPaint(
    painter: SquareDotPainter(coordinate: point),
  );
}


/// Normalized vector value from -1..1
/// 
/// This is our `point of view`
/// If a point is (0, 0) it is in the middle of the screen.
class Vec2{
  Vec2(this.x, this.y);

  final double x;
  final double y;

  Vec2 operator +(Vec2 other) => Vec2(x + other.x, y + other.y);
  Vec2 operator -(Vec2 other)=> Vec2(x- other.x, y - other.y);

  @override
  bool operator ==(Object other) {
    return identical(this, other) 
      && other is Vec2
      &&  runtimeType ==  other.runtimeType
      && x == other.x
      && y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Vec2(x: $x, y: $y)';
}

/// 3 dimensional vector
class Vec3{
  Vec3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  Vec3 operator +(Vec3 other) => Vec3(x + other.x, y + other.y, z + other.z);
  Vec3 operator -(Vec3 other)=> Vec3(x- other.x, y - other.y, z - other.z);

  @override
  bool operator ==(Object other) {
    return identical(this, other) 
      && other is Vec3
      && runtimeType ==  other.runtimeType
      && x == other.x
      && y == other.y
      && z == other.z;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}



class SquareDotPainter extends CustomPainter {
  const SquareDotPainter({this.color = Colors.greenAccent, required this.coordinate});

  final Color color;
  final Vec2 coordinate;

  @override
  void paint(Canvas canvas, Size size) {
    final double squareLen = 10;
    final rect = Rect.fromLTWH(
      coordinate.x - squareLen / 2,
      coordinate.y - squareLen / 2,
      squareLen,
      squareLen,
    );
    canvas.drawRect(rect, Paint()..color = color);
  }
  
  @override
  bool shouldRepaint(covariant SquareDotPainter oldDelegate) {
    return color != oldDelegate.color || coordinate != oldDelegate.coordinate;
  }
}



class SquareDotValue {
  final Vec2 coordinate;
  final Color color;
  SquareDotValue(this.coordinate, [this.color = Colors.greenAccent]);
}

class DrawSquareDots extends CustomPainter {
  const DrawSquareDots({required this.dots});

  final List<SquareDotValue> dots;

  @override
  void paint(Canvas canvas, Size size) {
    for (var dot in dots) {
      final double squareLen = 10;
      final color = dot.color;
      final coordinate = dot.coordinate;
      final rect = Rect.fromLTWH(coordinate.x - squareLen/2, coordinate.y - squareLen/2, squareLen, squareLen);
      canvas.drawRect(rect, Paint()..color = color);
    }
    
  }
  
  @override
  bool shouldRepaint(covariant DrawSquareDots oldDelegate) {
    return !listEquals(oldDelegate.dots, dots);
  }
}
