import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BulletComponent extends PositionComponent {
  double velocity; // Bullet velocity
  double lifetime; // Maximum lifetime of the bullet
  double radius; // Bullet radius
  double angle; // Bullet angle

  BulletComponent({
    required this.velocity,
    this.lifetime = 10,
    this.radius = 5,
    this.angle = 0,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update bullet position based on its velocity and angle
    position.add(Vector2(math.cos(angle), math.sin(angle)) * velocity * dt);

    // Decrease lifetime
    lifetime -= dt;
    if (lifetime <= 0) {
      removeFromParent(); // Remove the bullet if its lifetime is over
    }
  }
}
