import 'package:flame/extensions.dart';

import 'package:game/entities/common/entity.dart';
import 'package:game/entities/common/entity_stats.dart';
import 'package:game/entities/common/pid_controller.dart';

class Enemy extends Entity {
  var movementPIDC = PIDController<Vector2>(
      kP: 200.0,
      kI: 0.0,
      kD: 0.0,
      integralLimit: 0.0,
      add: (a, b) => a + b,
      subtract: (a, b) => a - b,
      multiply: (a, b) => a * b,
      zero: () => Vector2.zero(),
      clampLength: (a, min, max) {
        a.clampLength(min, max);
        return a;
      },
      isSmall: (a) => a.length < 1,
      initialValue: Vector2.zero());

  Enemy(EntityStats stats) : super(stats);

  /// Perform all the actions for the enemy
  @override
  void update(double dt) {
    super.update(dt);
    if (this.canAttack()) {
      this.attack();
    }
  }

  /// Move using the configured pid controller
  @override
  void move(double dt) {
    Vector2 pidOutput = Vector2.zero();
    this.movementPIDC.update(this.target_distance, dt);
    this.movementPIDC.output.copyInto(pidOutput);

    // Limit velocity to max speed
    if (this.stats.maxSpeed > 0) pidOutput.clampLength(0, this.stats.maxSpeed);

    // Update the position
    this.position.add(pidOutput * dt);
  }

  /// Check if attack can be performed
  bool canAttack() {
    return this.target_distance.length < this.stats.attackRange;
  }

  /// Perform attack
  void attack() {
    // Attack the target
  }
}
