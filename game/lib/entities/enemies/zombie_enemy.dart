import 'package:flame/extensions.dart';

import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';

class Zombie extends Enemy {
  Zombie(EntityStats stats) : super(stats);

  @override
  void move(double dt, Vector2 target_position) {
    // Move towards the target - PI
    // #TODO
    super.move(dt, target_position);
  }
}
