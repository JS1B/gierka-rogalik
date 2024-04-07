import 'package:game/entities/common/entity_stats.dart';
import 'package:game/entities/enemies/enemy.dart';

class Robot extends Enemy {
  Robot(EntityStats stats) : super(stats) {
    this.movementPIDC.kP = 1.0;
    this.movementPIDC.kD = 0.6;
    this.movementPIDC.kI = 1.0;
    this.movementPIDC.integralLimit = 40.0;
  }
}
