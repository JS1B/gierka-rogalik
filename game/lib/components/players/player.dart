import 'package:flame/components.dart';

import 'package:game/components/common/entity_stats.dart';

class Player {
  EntityStats stats;
  Vector2 _targetDirection = Vector2.zero();
  Vector2 _currentDirection = Vector2.zero();

  Player(this.stats);

  void update(double dt) {
    bool isMoving = this._targetDirection.length2 > 0;
    if (isMoving) {
      this
          ._currentDirection
          .lerp(this._targetDirection, this.stats.turningSpeed * dt);
    } else {
      if (this._currentDirection.length2 > 0) {
        this
            ._currentDirection
            .scale((1 - this.stats.deceleration).clamp(0.0, 1.0));
      }
    }
    if (this._currentDirection.length2 > 1) {
      this._currentDirection.normalize();
    }
  }

  void setTargetDirection(Vector2 direction) {
    this._targetDirection = direction;
  }

  Vector2 get currentDirection => this._currentDirection;
  double get maxSpeed => this.stats.maxSpeed;
}
