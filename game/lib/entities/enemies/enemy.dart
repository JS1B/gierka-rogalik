import 'package:flame/extensions.dart';

import 'package:game/entities/common/entity.dart';
import 'package:game/entities/common/entity_stats.dart';

class Enemy extends Entity {
  Enemy(EntityStats stats) : super(stats);

  /// Perform all the actions for the enemy
  @override
  void update(double dt) {
    super.update(dt);
    if (this.canAttack()) {
      this.attack();
    }
  }

  @override
  void move(double dt) {
    // If the distance to the target is very small, stop moving
    if (this.target_direction.length < 1) {
      this.current_direction = Vector2.zero();
      return;
    }
    // Gradually adjust the current direction towards the desired direction
    this
        .current_direction
        .lerp(this.target_direction, this.stats.turningSpeed * dt);

    // Calculate the velocity based on the current direction and max speed
    this.current_direction.normalize();
    Vector2 velocity = this.current_direction * this.stats.maxSpeed;

    // Update the position
    this.position.add(velocity * dt);
  }

  /// Check if attack can be performed
  bool canAttack() {
    return this.target_direction.length < this.stats.attackRange;
  }

  /// Perform attack
  void attack() {
    // Attack the target
  }
}
