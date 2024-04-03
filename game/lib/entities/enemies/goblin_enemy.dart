import 'package:flame/extensions.dart';

import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';

class Goblin extends Enemy {
  Goblin(EntityStats stats) : super(stats);

  @override
  void move(double dt, Vector2 target_position) {
    // Move towards the target - PD
    // #TODO
    super.move(dt, target_position);
  }
}
