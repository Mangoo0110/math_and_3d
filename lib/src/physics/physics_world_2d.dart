import 'dart:math';

import 'package:math_and_3d/src/physics/fluid_realm.dart';
import '../core/vectors/vectors.dart';
import 'particle_2d.dart';

class PhysicsWorld2D {
  PhysicsWorld2D(this.box);

  Box2D box;
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

      // 4. Handle particle-particle collisions
      _checkParticleCollisions(p);
    }
  }

  void _checkParticleCollisions(Particle2D p) {
    for (var other in particles) {
      if(p == other) continue; // Skip self

      double dx = other.position.x - p.position.x;
      double dy = other.position.y - p.position.y;
      double distance = sqrt(dx * dx + dy * dy);
      double minDistance = p.radius + other.radius;

      if(distance < minDistance) {
        // Particles are colliding. Let's resolve the collision by adjusting their velocities.
        // Calculate the normal vector

        final deltaVelocity = p.velocity - other.velocity;
        final squaredDistance = distance * distance;
        final totalMass = p.mass + other.mass;

        final impulseScaler =
            (2 * other.mass / totalMass) *
            ((deltaVelocity.dot(Vec2(dx, dy)) / squaredDistance));

        p.velocity = p.velocity - Vec2(dx, dy) * impulseScaler;
        other.velocity = other.velocity + Vec2(dx, dy) * impulseScaler;
      }
    }
  }

  void _checkBoundaries(Particle2D p) {
    double restitution = 0.8; // Bounciness (0.0 to 1.0)

    // Floor
    if (p.position.y > box.height - p.radius) {
      p.position = Vec2(p.position.x, box.height - p.radius);
      p.velocity = Vec2(p.velocity.x, p.velocity.y * -restitution);
    }
    
    // Ceiling
    if (p.position.y - p.radius < 0) {
      p.position = Vec2(p.position.x, p.radius);
      p.velocity = Vec2(p.velocity.x, p.velocity.y * -restitution);
    }

    // Right wall
    if (p.position.x + p.radius > box.width) {
      p.position = Vec2(box.width - p.radius, p.position.y);
      p.velocity = Vec2(p.velocity.x * -restitution, p.velocity.y);
    }

    // Left wall
    if (p.position.x - p.radius < 0) {
      p.position = Vec2(p.radius, p.position.y);
      p.velocity = Vec2(p.velocity.x * -restitution, p.velocity.y);
    }
  }
}
