import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../core/vectors/vectors.dart';
import 'particle_2d.dart';
import 'physics_world_2d.dart';
import '../painters/draw_particles_2d.dart';

/// Rectangle box in 2D space, defined by its top-left corner and size.
class Box2D {
  Box2D({required this.position, required this.size});
  /// Top-left corner of the box
  Vec2 position; 
  Size size; // Width and height of the box

  double get width => size.width;
  double get height => size.height;

  Vec2 upRightCorner() => Vec2(position.x + size.width, position.y);
  Vec2 upLeftCorner() => Vec2(position.x, position.y);
  Vec2 downLeftCorner() => Vec2(position.x, position.y + size.height);
  Vec2 downRightCorner() => Vec2(position.x + size.width, position.y + size.height);
}

class FluidRealm extends StatefulWidget {
  const FluidRealm({super.key, required this.box});
  final Box2D box;

  @override
  State<FluidRealm> createState() => _FluidRealmState();
}

class _FluidRealmState extends State<FluidRealm> with SingleTickerProviderStateMixin {
  late final PhysicsWorld2D physicsWorld;
  late final Ticker _ticker;
  double _lastTime = 0.0;

  late final Box2D box;


  @override
  void initState() {
    super.initState();
    box = widget.box;
    // Initialize the physics world with boundaries
    physicsWorld = PhysicsWorld2D(widget.box);

    // Add some random particles to start
    final random = Random();
    for (int i = 0; i < 500; i++) {
        physicsWorld.addParticle(
          Particle2D(
            position: Vec2(random.nextDouble() * widget.box.width, random.nextDouble() * widget.box.height),
            // Give them a random starting velocity so they scatter beautifully
            velocity: Vec2(random.nextDouble() * 100 - 50, random.nextDouble() * 100 - 50),
            acceleration: Vec2(0, 0),
            radius: random.nextDouble() * 2 + 5, // Random radius between 5 and 15
            color: Colors.blue.withAlpha(200),
          ),
        );
    }

    // Start the high-performance Game Loop using Ticker
    _ticker = createTicker((elapsed) {
      final currentTime = elapsed.inMilliseconds / 1000.0; // convert to seconds
      double dt = currentTime - _lastTime;
      _lastTime = currentTime;

      // Cap delta time to prevent physics explosions if the app stutters or is paused
      if (dt > 0.05) dt = 0.05;

      // Update the physics engine
      // Improve collision detection by substepping
      int subStep = 2;
      final subDt = dt / subStep;
      while(subStep > 0) {
        physicsWorld.update(subDt);
        subStep--;
      }
      
      // Trigger a repaint
      setState(() {});
    });
    
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('Building FluidRealm with ${physicsWorld.particles.length} particles');
    return Container(
      color: Colors.black,
      width: widget.box.width,
      height: widget.box.height,
      child: GestureDetector(
        onTapDown: (details) {
          // Interactive: Spawn a new particle wherever you click!
          physicsWorld.addParticle(
            Particle2D(
              position: Vec2(details.localPosition.dx, details.localPosition.dy),
              velocity: Vec2(0, 0),
              acceleration: Vec2(0, 0),
              radius: 12.0,
              color: Colors.redAccent,
            )
          );
        },
        child: CustomPaint(
          painter: DrawParticles2D(
            particles: physicsWorld.particles,
            bounds: physicsWorld.box.size,
          ),
        ),
      ),
    );
  }
}
