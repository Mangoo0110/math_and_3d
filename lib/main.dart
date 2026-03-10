import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_and_3d/components/draw_lines.dart';
import 'package:math_and_3d/components/draw_square_dots.dart';
import 'package:math_and_3d/core/math/vectors.dart';
import 'package:math_and_3d/core/themes/themes.dart';
import 'package:math_and_3d/cube.dart';

import 'components/draw_triangles.dart';

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
  double angle = 0;



  List<Cube> cubeArmies = [
    // Back face coordinates/points
    // Cube(
    //   Vec3(.5, .5, 15),  // bottom-right // a
    //   Vec3(-.5, .5, 15), // bottom-left  // b
    //   Vec3(-.5, -.5, 15),// top-left     // c
    //   Vec3(.5, -.5, 15), // top-right    // d

    //   // Front face coordinates/points
    //   Vec3(.5, .5, 5), // bottom-right // e
    //   Vec3(-.5, .5, 5),// bottom-left  // f
    //   Vec3(-.5, -.5, 5),// top-left     // g
    //   Vec3(.5, -.5, 5), // top-right    // h
    // ),

    Cube(
      Vec3(.5, .5, 0.5),  // bottom-right // a
      Vec3(-.5, .5, 0.5), // bottom-left  // b
      Vec3(-.5, -.5, 0.5),// top-left     // c
      Vec3(.5, -.5, 0.5), // top-right    // d

      // Front face coordinates/points
      Vec3(.5, .5, -0.5), // bottom-right // e
      Vec3(-.5, .5, -0.5),// bottom-left  // f
      Vec3(-.5, -.5, -0.5),// top-left     // g
      Vec3(.5, -.5, -0.5), // top-right    // h
    ),
  ];

  buildCubeArmies() {
    // cubeArmies = [];
    // // 10 columns and 10 rows; total 100 cubes; cube arms are size of 10
    // for(int i = 0; i < 10; i++) {
    //   for(int j = 0; j < 10; j++) {
    //     cubeArmies.add(Cube(
    //       Vec3(i * 10, j * 10, 0),  // bottom-right // a
    //       Vec3((i + 1) * 10, j * 10, 0), // bottom-left  // b
    //       Vec3((i + 1) * 10, (j + 1) * 10, 0),// top-left     // c
    //       Vec3(i * 10, (j + 1) * 10, 0), // top-right    // d

    //       // Front face coordinates/points
    //       Vec3(i * 10, j * 10, -10), // bottom-right // e
    //       Vec3((i + 1) * 10, j * 10, -10),// bottom-left  // f
    //       Vec3((i + 1) * 10, (j + 1) * 10, -10),// top-left     // g
    //       Vec3(i * 10, (j + 1) * 10, -10), // top-right    // h
    //     ));
    //   }
    // }
  }

  // List<LineInfo> toDrawCubeLineValues(List<Vec2> points) {
  //   List<LineInfo> lines = [];
  //   List<Color> colors = [
  //     Colors.greenAccent,
  //     Colors.greenAccent,
  //     Colors.greenAccent,
  //   ];
  //   for(int i = 0; i < points.length; i++) {
  //     // join
  //     if((i + 1) % 4 != 0) lines.add(LineInfo(from: points[i], to: points[(i + 1) % points.length], color: colors[i % colors.length]));
  //     if((i + 1) % 4 == 0) lines.add(LineInfo(from: points[i], to: points[(i + 1) - 4], color: colors[i % colors.length]));
  //     if(i + 4 < 8) lines.add(LineInfo(from: points[i], to: points[(i + 4)], color: colors[i % colors.length]));
  //   }
  //   return lines;
  // }

  

  @override
  void initState() {
    buildCubeArmies();
    double frame = 0;
    final dt = 1/fps;
    timer = Timer.periodic(Duration(milliseconds: (1000/fps).floor()), (timer) {
      frame += 1;
      if(frame < fps * 5) dz += dt;
      angle = pi * dt;
      for(Cube cube in cubeArmies) {
        cube.rotateXZ(angle);
        cube.translateZ(dz);
      }
      // if(frame >= fps * 5) {
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
                    
                // CustomPaint(
                //   painter: DrawSquareDots(
                //     dots: cubeArmies.map((cube) => cube.squareDots(widget.screenSize)).toList().expand((element) => element).toList(),
                //   ),
                // ),

                // CustomPaint(
                //   painter: DrawTriangles(
                //     triangles: cubeArmies.map((cube) => cube.cubeTriangles(widget.screenSize)).toList().expand((element) => element).toList(),
                //   ),
                // )

                CustomPaint(
                  painter: DrawLines(
                    lines: cubeArmies.map((cube) => cube.cubeLines(widget.screenSize)).toList().expand((element) => element).toList(),
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

