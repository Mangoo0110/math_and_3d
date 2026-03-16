import 'package:flutter/material.dart';
import 'package:math_and_3d/src/painters/draw_lines.dart';
import 'package:math_and_3d/src/painters/draw_triangles.dart';
import 'package:math_and_3d/src/core/vectors/vectors.dart';
import 'package:math_and_3d/src/transformer/transformer.dart';

class Cube {


  Cube(this.vertices);

  final List<Vec3> vertices;
  
  List<TriangleInfo> cubeTriangles(Size screenSize) {
    final cube2d = Transformer.project3dTo2dAll(vertices);

    // Painter's algorithm: 
    // draw far triangles first, near triangles last.
    final tris3d = _cubeTriangleIndices
            .map(
              (t) => _Triangle3D(
                a: t.a,
                b: t.b,
                c: t.c,
                color: t.color,
                avgZ: (vertices[t.a].z + vertices[t.b].z + vertices[t.c].z) / 3.0,
              ),
            )
            .toList();
        tris3d.sort((l, r) => r.avgZ.compareTo(l.avgZ));
        final triangles = tris3d
            .map(
              (t) => TriangleInfo(
                a: cube2d[t.a].point,
                b: cube2d[t.b].point,
                c: cube2d[t.c].point,
                color: t.color,
              ),
            )
            .toList();

    return triangles;
  }

  List<LineInfo> cubeLines(Size screenSize) {
    List<LineInfo> lines = [];
    final screenepoints = Transformer.translateToScreenPoints(
      Transformer.project3dTo2dAll(vertices,), screenSize
    );
    List<Color> colors = [
      Colors.greenAccent,
      Colors.greenAccent,
      Colors.greenAccent,
    ];
    for(int i = 0; i < screenepoints.length; i++) {
      // join
      if((i + 1) % 4 != 0) lines.add(LineInfo(from: screenepoints[i], to: screenepoints[(i + 1) % screenepoints.length], color: colors[i % colors.length]));
      if((i + 1) % 4 == 0) lines.add(LineInfo(from: screenepoints[i], to: screenepoints[(i + 1) - 4], color: colors[i % colors.length]));
      if(i + 4 < 8) lines.add(LineInfo(from: screenepoints[i], to: screenepoints[(i + 4)], color: colors[i % colors.length]));
    }
    return lines;
  }
}


class _Triangle3D {
  const _Triangle3D({
    required this.a,
    required this.b,
    required this.c,
    required this.color,
    required this.avgZ,
  });
  final int a;
  final int b;
  final int c;
  final Color color;
  final double avgZ;
}


class _TriangleIndex {
  const _TriangleIndex(this.a, this.b, this.c, this.color);
  final int a;
  final int b;
  final int c;
  final Color color;
}


// Indices into `threeDpoints`:
// a=0 b=1 c=2 d=3 e=4 f=5 g=6 h=7
const List<_TriangleIndex> _cubeTriangleIndices = [
  // abcd (back)
  _TriangleIndex(0, 1, 2, Colors.greenAccent),
  _TriangleIndex(0, 3, 2, Colors.greenAccent),
  // bcgf (left)
  _TriangleIndex(1, 2, 6, Colors.greenAccent),
  _TriangleIndex(1, 5, 6, Colors.greenAccent),
  // cdhg (top)
  _TriangleIndex(2, 6, 7, Colors.greenAccent),
  _TriangleIndex(2, 3, 7, Colors.greenAccent),
  // efgh (front)
  _TriangleIndex(4, 5, 6, Colors.greenAccent),
  _TriangleIndex(4, 7, 6, Colors.greenAccent),
  // adeh (right)
  _TriangleIndex(0, 4, 7, Colors.greenAccent),
  _TriangleIndex(0, 3, 7, Colors.greenAccent),
];