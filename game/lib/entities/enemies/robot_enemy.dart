import 'package:flame/components.dart';

import 'package:game/entities/common/entity_stats.dart';
import 'package:game/entities/enemies/enemy.dart';

class Robot extends Enemy {
  Robot(EntityStats stats, {Vector2? position})
      // #TODO size should be changed
      : super(stats, Vector2.all(100), position: position) {
    this.movementPIDC.kP = 1.0;
    this.movementPIDC.kD = 0.2;
    this.movementPIDC.kI = 1.0;
    this.movementPIDC.integralLimit = 40.0;
  }
}
