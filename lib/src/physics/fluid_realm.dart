import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../core/vectors/vectors.dart';
import 'particle_2d.dart';
import 'physics_world_2d.dart';
import '../painters/draw_particles_2d.dart';

class FluidRealm extends StatefulWidget {
  const FluidRealm({super.key, required this.screenSize});
  final Size screenSize;

  @override
  State<FluidRealm> createState() => _FluidRealmState();
}

class _FluidRealmState extends State<FluidRealm> with SingleTickerProviderStateMixin {
  late final PhysicsWorld2D physicsWorld;
  late final Ticker _ticker;
  double _lastTime = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Initialize the physics world with boundaries
    physicsWorld = PhysicsWorld2D(widget.screenSize);

    // Add some random particles to start
    final random = Random();
    for (int i = 0; i < 2; i++) {
        physicsWorld.addParticle(
          Particle2D(
            position: Vec2(random.nextDouble() * widget.screenSize.width, random.nextDouble() * widget.screenSize.height / 2),
            // Give them a random starting velocity so they scatter beautifully
            velocity: Vec2(random.nextDouble() * 400 - 200, random.nextDouble() * 400 - 200),
            acceleration: Vec2(0, 0),
            radius: 8.0,
            mass: 1.0,
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
      physicsWorld.update(dt);
      
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
    return Container(
      color: Colors.black,
      width: widget.screenSize.width,
      height: widget.screenSize.height,
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
            bounds: physicsWorld.bounds,
          ),
        ),
      ),
    );
  }
}
