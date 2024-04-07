import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';

class Goblin extends Enemy {
  Goblin(EntityStats stats) : super(stats) {
    this.movementPIDC.kP = 1.8;
    this.movementPIDC.kD = 0.5;
    this.movementPIDC.kI = 1.0;
    this.movementPIDC.integralLimit = 4.0;
  }
}
