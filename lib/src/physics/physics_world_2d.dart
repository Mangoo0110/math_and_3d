import 'package:flutter/material.dart';
import '../core/vectors/vectors.dart';
import 'particle_2d.dart';

class PhysicsWorld2D {
  PhysicsWorld2D(this.bounds);

  Size bounds;
  List<Particle2D> particles = [];
  
  // Gravity pulls down (positive Y in Flutter). 
  // Scaled up to 980 for 2D screen pixels instead of 9.8 m/s^2.
  Vec2 gravity = Vec2(0, 980); 

  void addParticle(Particle2D particle) {
    particles.add(particle);
  }

  void update(double dt) {
    for (var p in particles) {
      // 1. Apply Forces
      // Assuming gravity is the only force for now
      p.acceleration = gravity;

      // 2. Integration (Euler)
      // Velocity = Velocity + (Acceleration * TimeDelta)
      p.velocity = p.velocity + (p.acceleration * dt);
      
      // Position = Position + (Velocity * TimeDelta)
      p.position = p.position + (p.velocity * dt);

      // 3. Handle boundary collisions
      _checkBoundaries(p);
    }
  }

  void _checkBoundaries(Particle2D p) {
    double restitution = 0.8; // Bounciness (0.0 to 1.0)

    // Floor
    if (p.position.y + p.radius > bounds.height) {
      p.position = Vec2(p.position.x, bounds.height - p.radius);
      p.velocity = Vec2(p.velocity.x, p.velocity.y * -restitution);
    }
    
    // Ceiling
    if (p.position.y - p.radius < 0) {
      p.position = Vec2(p.position.x, p.radius);
      p.velocity = Vec2(p.velocity.x, p.velocity.y * -restitution);
    }

    // Right wall
    if (p.position.x + p.radius > bounds.width) {
      p.position = Vec2(bounds.width - p.radius, p.position.y);
      p.velocity = Vec2(p.velocity.x * -restitution, p.velocity.y);
    }

    // Left wall
    if (p.position.x - p.radius < 0) {
      p.position = Vec2(p.radius, p.position.y);
      p.velocity = Vec2(p.velocity.x * -restitution, p.velocity.y);
    }
  }
}
