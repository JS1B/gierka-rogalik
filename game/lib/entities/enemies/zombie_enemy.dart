import 'package:flame/components.dart';

import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';

class Zombie extends Enemy {
  Zombie(EntityStats stats, {Vector2? position})
      : super(stats, Vector2.all(92), position: position) {
    this.movementPIDC.kP = 0.02;
    this.movementPIDC.kI = 2.0;
    this.movementPIDC.integralLimit =
        this.stats.maxSpeed * 0.85 / this.movementPIDC.kI;
  }
}
