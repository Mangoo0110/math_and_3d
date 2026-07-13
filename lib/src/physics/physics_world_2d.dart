import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_and_3d/src/physics/fluid_realm.dart';
import '../core/vectors/vectors.dart';
import 'particle_2d.dart';







class PhysicsWorld2D {
  PhysicsWorld2D(this.box);

  Box2D box;
  List<Particle2D> particles = [];
  
  // Gravity pulls down (positive Y in Flutter). 
  // Scaled up to 980 for 2D screen pixels instead of 9.8 m/s^2.
  Vec2 gravity = Vec2(0, 0); 

  void addParticle(Particle2D particle) {
    particles.add(particle);
  }

  void update(double dt) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
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
      for(int j = i + 1; j < particles.length; j++) {
        _checkParticleCollisions(p, particles[j], dt);
      }
      
    }
  }



  bool _isOverlapping(Particle2D p, Particle2D other, double threshold,) {
    double minDistance = p.radius + other.radius;
    return minDistance - _deltaDistance(p, other) > threshold;
  }

  bool _isNotInContact(Particle2D p, Particle2D other) {
    double minDistance = p.radius + other.radius;
    return _deltaDistance(p, other) > minDistance;
  }

  double _deltaDistance(Particle2D p, Particle2D other) {
    Vec2 delta = other.position - p.position;
    double distance = sqrt(delta.x * delta.x + delta.y * delta.y);
    return distance;
  }

  /// Returns position as Vec2
  Vec2 _resonateOverlapping(Particle2D p, Particle2D other, double threshold, double dt) {
    debugPrint("Resonating overlaps");

    double left = 0, right = dt;
    Particle2D p1 = p.copyWith();

    // move particle `p` back to the position before dt
    p1.position= p1.position - p1.velocity *dt;

    int loopThreshold = 10;
    
    // Finding the right time interval
    while((_isOverlapping(p, other, threshold) || _isNotInContact(p, other)) && loopThreshold > 0) {
      final mid = (left + right) / 2;

      final p2 = p1.copyWith();
      // New position
      Vec2 position1 =  p2.position + p1.velocity * mid;
      if(_isOverlapping(p, other, threshold)) {
        right = mid;
      } else if(_isNotInContact(p, other)) {
        left = mid;
      } else {
        return position1;
      }
      loopThreshold--;
    }

    return p.position;
  }


  void _checkParticleCollisions(Particle2D p, Particle2D other, double dt) {
    Vec2 delta = other.position - p.position;
    double distance = sqrt(delta.x * delta.x + delta.y * delta.y);
    double minDistance = p.radius + other.radius;

    if(distance < minDistance) {

      // Are they overlapping
      if(minDistance - distance > 1) {
        // Move apart the particles from each other.
        // Move the lightest one on the edge of the heaviest one
        // final lightest = p.mass > other.mass ? other : p;
        // final heaviest = p.mass < other.mass ? other : p;
        if(_isOverlapping(p, other, 1)) {
          final resonatedPosition = _resonateOverlapping(p, other, 1, dt);
          p.position = resonatedPosition;
          // if(p.position == resonatedPosition) {
          //   return;
          // } else {
          //   p.position = resonatedPosition;
          // }
        }
        
      }

      // Particles are colliding. Let's resolve the collision by adjusting their velocities.
      // Calculate the normal vector
      final deltaVelocity = p.velocity - other.velocity;
      final squaredDistance = distance * distance;
      final totalMass = p.mass + other.mass;

      // Calculate the dot product component once
      double dotProd = deltaVelocity.dot(delta);
      

      // based on their respective opposing mass ratios.
      final pImpulseScaler = (2 * other.mass / totalMass) * (dotProd / squaredDistance);
      final otherImpulseScaler = (2 * p.mass / totalMass) * (dotProd / squaredDistance);

      p.velocity = p.velocity - delta * pImpulseScaler;
      other.velocity = other.velocity + delta * otherImpulseScaler;
    }
  }

  void _checkBoundaries(Particle2D p) {
    double restitution = 1; // Bounciness (0.0 to 1.0)

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
