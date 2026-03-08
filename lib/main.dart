import 'dart:async';
import 'dart:math';

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
  double depth = 1;

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: (1000/60).floor()), (timer) {
      depth += 1/60;
      if(depth >= 10) {
        timer.cancel();
        return;
      }
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
                  child: Text(depth.toString(), style: const TextStyle(color: Colors.white),),
                ),
                  Positioned(
                    left: widget.screenSize.width/2,
                    child: Container(
                      height: widget.screenSize.height,
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                    
                drawRectPoint(
                  translateToScreenPoint(project3dTo2d(Vec3(.5, .5, depth)))
                ),

                drawRectPoint(
                  translateToScreenPoint(project3dTo2d(Vec3(.5, -.5, depth)))
                ),

                drawRectPoint(
                  translateToScreenPoint(project3dTo2d(Vec3(-.5, .5, depth)))
                ),

                drawRectPoint(
                  translateToScreenPoint(project3dTo2d(Vec3(-.5, -.5, depth)))
                ),
              ],
            ),
          )
        );
      },
    );
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
      coooridanates.x / (max(0.1, coooridanates.z)),
      coooridanates.y / (max(0.1, coooridanates.z))
    );
  }

  Vec2 translateToScreenPoint(Vec2 coordinate) {
    // Assuming that coordinate values are between -1 and 1
    // (0,0) is the middle point of the plane
    return Vec2(
      (1 - coordinate.x)/2 * widget.screenSize.width,
      (1 - coordinate.y)/2 * widget.screenSize.height
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
      &&  runtimeType ==  other.runtimeType
      && x == other.x
      && y == other.y
      && z == other.z;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}



class SquareDotPainter extends CustomPainter {
  const SquareDotPainter({this.color = Colors.green, required this.coordinate});

  final Color color;
  final Vec2 coordinate;

  @override
  void paint(Canvas canvas, Size size) {
    final double squareLen = 10;
    final rect = Rect.fromLTWH(coordinate.x - squareLen/2, coordinate.y - squareLen/2, squareLen, squareLen);
    canvas.drawRect(rect, Paint()..color = color);
  }
  
  @override
  bool shouldRepaint(covariant SquareDotPainter oldDelegate) {
    return color != oldDelegate.color || coordinate != oldDelegate.coordinate;
  }
}
