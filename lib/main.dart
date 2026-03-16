import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_and_3d/src/painters/draw_lines.dart';
import 'package:math_and_3d/src/core/vectors/vectors.dart';
import 'package:math_and_3d/src/core/themes/themes.dart';
import 'package:math_and_3d/cube.dart';
import 'package:math_and_3d/src/transformer/transformer.dart';

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
      debugShowCheckedModeBanner: false,
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final realmWidth = 400.0;
            final realmHeight = 350.0;
            return TheRealm(
              screenSize: Size(realmWidth, realmHeight),
            );
            // return SizedBox(
            //   width: constraints.maxWidth,
            //   child: Column(
            //     children: List.generate((1).floor(), (index)=> Row(
            //         children: List.generate((1).floor(), (index)=> TheRealm(
            //           screenSize: Size(realmWidth, realmHeight),
            //         ),),
            //       ),)
            //   ),
            // );
          }
        ),
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
  bool _paused = false;
  bool _reversed = false;


  List<Vec3> theLine = [
    Vec3(0, -1, 0),
    Vec3(0, 1, 0),
  ];

  List<Cube> cubeArmies = [
    Cube([
      Vec3(.5, .5, .5),  // bottom-right // a
      Vec3(-.5, .5, .5), // bottom-left  // b
      Vec3(-.5, -.5, .5),// top-left     // c
      Vec3(.5, -.5, .5), // top-right    // d

      // Front face coordinates/points
      Vec3(.5, .5, -.5), // bottom-right // e
      Vec3(-.5, .5, -.5),// bottom-left  // f
      Vec3(-.5, -.5, -.5),// top-left     // g
      Vec3(.5, -.5, -.5), // top-right    // h
    ]),
  ];

  buildCubeArmies() {
    //cubeArmies = [];
    // // 10 columns and 10 rows; total 100 cubes; cube arms are size of 10
    // for(int i = 0; i < 10; i++) {
    //   for(int j = 0; j < 10; j++) {
    //     cubeArmies.add(Cube([
    //       Vec3(i * 10, j * 10, 0),  // bottom-right // a
    //       Vec3((i + 1) * 10, j * 10, 0), // bottom-left  // b
    //       Vec3((i + 1) * 10, (j + 1) * 10, 0),// top-left     // c
    //       Vec3(i * 10, (j + 1) * 10, 0), // top-right    // d

    //       // Front face coordinates/points
    //       Vec3(i * 10, j * 10, -10), // bottom-right // e
    //       Vec3((i + 1) * 10, j * 10, -10),// bottom-left  // f
    //       Vec3((i + 1) * 10, (j + 1) * 10, -10),// top-left     // g
    //       Vec3(i * 10, (j + 1) * 10, -10), // top-right    // h
    //     ]));
    //   }
    //}
  }

  List<LineInfo> linesToDraw = [];
  
  final dt = 1/fps;
  @override
  void initState() {
    buildCubeArmies();
    
    double frame = 0;
    timer = Timer.periodic(Duration(milliseconds: (1000/fps).floor()), (timer) {
      // Guard pause case;
      if(_paused) return;

      linesToDraw.clear();
      //if(frame > 500) return;
      if(!_reversed && frame < fps * 2) {
        dz += dt;
        frame++;
      }

      if(_reversed && frame != 0) {
        dz -= dt;
        frame--;
      }
      
      // Next Angle
      if(_reversed) {
        angle -=  pi * dt;
      } else {
        angle +=  pi * dt;
      }
      // Normalizes angle
      angle = angle % (2 * pi);

      List<Vec3> translated = [];
      for(Cube cube in cubeArmies) {
        translated = Transformer.rotateXZ(cube.vertices, angle);
        translated = Transformer.translateZ(translated, dz);
      }
      
      linesToDraw += Cube(translated).cubeLines(widget.screenSize);
      
      final translatedLine = Transformer.translateZ(theLine, dz);
      final linePointsOnScreen = Transformer.translateToScreenPoints(
        // This trick makes the line take the given height and width of the environment
        // (*not the screen size)
        [
          Transformer.project3dTo2dAll(translatedLine)[0].copyWith(point: Vec2(0, -1)),
          Transformer.project3dTo2dAll(translatedLine)[1].copyWith(point: Vec2(0, 1)),
        ], widget.screenSize);
      linesToDraw.add(LineInfo(from: linePointsOnScreen[0], to: linePointsOnScreen[1], color: Colors.white));

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
        return Container(
          color: Colors.black,
          height: widget.screenSize.height,
          width: widget.screenSize.width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              
              // Positioned(
              //   top: 10,
              //   left: 0,
              //   child: Text((dz).toString(), style: const TextStyle(color: Colors.white),),
              // ),
        
              // Positioned(
              //   top: 30,
              //   left: 4,
              //   child: SizedBox(
                  
              //     child: FilledButton(
              //       onPressed: ()=> _reversed = !_reversed,
              //       style: FilledButton.styleFrom(
              //         backgroundColor: _reversed ? Colors.orange : Colors.blue,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(6),
              //         ),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: const Text('Reverse', style: TextStyle(color: Colors.white),),
              //       ),),
              //   ),
              // ),
              
        
              // CustomPaint(
              //   painter: DrawTriangles(
              //     triangles: cubeArmies.map((cube) => cube.cubeTriangles(widget.screenSize)).toList().expand((element) => element).toList(),
              //   ),
              // )
              GestureDetector(
                onTap: () => _paused = !_paused,
                child: CustomPaint(
                  painter: DrawLines(
                    lines: linesToDraw,
                  ),
                ),
              ),
        
              
            ],
          ),
        );
      },
    );
  }
  
}
