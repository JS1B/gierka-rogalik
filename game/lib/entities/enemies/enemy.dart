import 'package:flame/extensions.dart';

import 'package:game/entities/common/entity.dart';
import 'package:game/entities/common/entity_stats.dart';
import 'package:game/entities/common/pid_controller.dart';

enum EnemyState { moving, attacking }

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

  EnemyState _state = EnemyState.moving;
  EnemyState _commandState = EnemyState.moving;

  Enemy(EntityStats stats, Vector2 size, {Vector2? position})
      : super(stats, size, position: position);

  @override
  void update(double dt) {
    super.update(dt);
    this._state = this._commandState;
  }

  @override
  void calculateAcceleration(dt) {
    Vector2 pidOutput = Vector2.zero();
    this.movementPIDC.update(this.target_distance, dt);
    this.movementPIDC.output.copyInto(pidOutput);

    this.acceleration = pidOutput;
  }

  EnemyState get state => this._state;

  set state(EnemyState state) {
    this._commandState = state;
  }

  /// Check if attack can be performed
  bool canAttack() {
    return this.target_distance.length < this.stats.attackRange &&
        this._state != EnemyState.attacking;
  }

  /// Trigger the attack state
  void attack() {
    if (!this.canAttack()) return;

    this._commandState = EnemyState.attacking;
  }

  /// Reset the attack
  void resetAttack() {
    this._commandState = EnemyState.moving;
  }
}
