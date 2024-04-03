import 'dart:math';
import 'package:flame/components.dart';

import 'package:game/components/common/entity_stats.dart';

class Enemy {
  EntityStats stats;
  Vector2 position = Vector2.zero();

  Enemy(this.stats);

  /// Perform all the actions for the enemy
  void update(double dt, Vector2 target_position) {
    this.move(dt, target_position);
    this.regenerate(dt);
    if (this.canAttack(target_position)) {
      this.attack();
    }
  }

  /// Move towards the target - P
  void move(double dt, Vector2 target_position) {
    // Calculate the direction from enemy to target
    Vector2 direction = target_position - this.position;
    direction.normalize();

    // Calculate the velocity and update the position
    Vector2 velocity = direction * this.stats.maxSpeed * dt;

    if (this.position.distanceTo(target_position) < 1) {
      velocity = Vector2.zero();
    }
    this.position += velocity;
  }

  /// Regenerate health
  void regenerate(double dt) {
    if (this.stats.health >= this.stats.maxHealth) return;

    var h = this.stats.health;
    this.stats.health =
        min(h + this.stats.regenRate * dt, this.stats.maxHealth);
  }

  /// Check if attack can be performed
  bool canAttack(Vector2 target_position) {
    double d = this.position.distanceTo(target_position);
    return d < this.stats.attackRange;
  }

  /// Perform attack
  void attack() {
    // Attack the target
  }
}
