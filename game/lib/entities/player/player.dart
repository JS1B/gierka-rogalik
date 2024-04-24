import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'package:game/entities/common/entity.dart';
import 'package:game/entities/common/entity_stats.dart';

class Player extends Entity {
  Player(EntityStats stats)
      : super(stats, Vector2.all(64), position: Vector2.all(100));

  @override
  void calculateAcceleration(dt) {
    this.acceleration = this.target_distance.scaled(this.stats.maxAcceleration);
  }
}
