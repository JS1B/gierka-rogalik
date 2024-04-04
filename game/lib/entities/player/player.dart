import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'package:game/entities/common/entity.dart';
import 'package:game/entities/common/entity_stats.dart';

class Player extends Entity {
  Player(EntityStats stats) : super(stats);

  /// Move in a given direction with max speed and turning speed
  @override
  void move(double dt) {
    bool moveCommand = this.target_direction.length > 0;
    if (moveCommand) {
      // Gradually adjust the current direction towards the desired direction
      // with a restricted turning rate
      this
          .current_direction
          .lerp(this.target_direction, this.stats.turningSpeed * dt);
    } else {
      this.decelerate(dt);
    }

    if (this.current_direction.length > 1) {
      this.current_direction.normalize();
    }

    Vector2 velocity = this.current_direction * this.stats.maxSpeed;
    this.position.add(velocity * dt);
  }

  void decelerate(double dt) {
    this
        .current_direction
        .scale((1 - this.stats.deceleration * dt).clamp(0.0, 1.0));
  }
}
