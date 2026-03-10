import 'package:flutter/material.dart';
import 'package:math_and_3d/components/draw_lines.dart';
import 'package:math_and_3d/components/draw_triangles.dart';
import 'package:math_and_3d/core/math/vectors.dart';
import 'package:math_and_3d/transformer.dart';

class Cube extends Vec3Transformer {
  Vec3 _a;
  Vec3 _b;
  Vec3 _c;
  Vec3 _d;
  Vec3 _e;
  Vec3 _f;
  Vec3 _g;
  Vec3 _h;

  Cube(Vec3 a, Vec3 b, Vec3 c, Vec3 d, Vec3 e, Vec3 f, Vec3 g, Vec3 h):
    _a = a,
    _b = b,
    _c = c,
    _d = d,
    _e = e,
    _f = f,
    _g = g,
    _h = h,
    super(vertices: [a, b, c, d, e, f, g, h]);

  
  List<TriangleInfo> cubeTriangles(Size screenSize) {
    final cube2d = translateToScreenPoints(to2d(), screenSize);

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
                a: cube2d[t.a],
                b: cube2d[t.b],
                c: cube2d[t.c],
                color: t.color,
              ),
            )
            .toList();

    return triangles;
  }

  List<LineInfo> cubeLines(Size screenSize) {
    List<LineInfo> lines = [];
    final points = projectScreen(screenSize);
    List<Color> colors = [
      Colors.greenAccent,
      Colors.greenAccent,
      Colors.greenAccent,
    ];
    for(int i = 0; i < points.length; i++) {
      // join
      if((i + 1) % 4 != 0) lines.add(LineInfo(from: points[i], to: points[(i + 1) % points.length], color: colors[i % colors.length]));
      if((i + 1) % 4 == 0) lines.add(LineInfo(from: points[i], to: points[(i + 1) - 4], color: colors[i % colors.length]));
      if(i + 4 < 8) lines.add(LineInfo(from: points[i], to: points[(i + 4)], color: colors[i % colors.length]));
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