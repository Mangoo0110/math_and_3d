import 'package:flutter/material.dart';
import 'package:math_and_3d/core/themes/themes.dart';

void main() {
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


class TheRealm extends StatelessWidget {
  const TheRealm({super.key, required this.screenSize});
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Container(
            color: Colors.black,
            height: screenSize.height,
            width: screenSize.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                  Positioned(
                    left: screenSize.width/2,
                    child: Container(
                      height: screenSize.height,
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                    
                drawRectPoint(
                  translateToScreenPoint(Vec2(.5, .5))
                ),

                drawRectPoint(
                  translateToScreenPoint(Vec2(.5, -.5))
                ),

                drawRectPoint(
                  translateToScreenPoint(Vec2(-.5, .5))
                ),

                drawRectPoint(
                  translateToScreenPoint(Vec2(-.5, -.5))
                ),
              ],
            ),
          )
        );
      },
    );
  }

  Vec2 translateToScreenPoint(Vec2 coordinate) {
    // Assuming that coordinate values are between -1 and 1
    // (0,0) is the middle point of the plane
    return Vec2(
      (1 - coordinate.x)/2 * screenSize.width,
      (1 -(coordinate.y))/2 * screenSize.height
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
