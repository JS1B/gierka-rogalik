import 'package:flame/components.dart';

import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';

class Goblin extends Enemy {
  Goblin(EntityStats stats, {Vector2? position})
      : super(stats, Vector2.all(64), position: position) {
    this.movementPIDC.kP = 1.8;
    this.movementPIDC.kD = 0.2;
    this.movementPIDC.kI = 10.0;
    this.movementPIDC.integralLimit = 4.0;
  }
}
