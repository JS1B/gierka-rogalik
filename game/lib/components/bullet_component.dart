import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Bullet extends PositionComponent {
  double ?velocity; // Bullet velocity
  double lifetime = 10; // Maximum lifetime of the bullet
  double ?radius = 5; // Bullet radius
  double angle = 0; // Bullet angle

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.red;
    canvas.drawCircle(position.toOffset(), radius!, paint);
  }
  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(velocity! * dt * math.cos(angle), velocity! * dt * math.sin(angle));
  
    if (velocity != null) {
      lifetime -= velocity! * dt;
    }
  }
}