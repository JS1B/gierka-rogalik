import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'package:game/entities/common/entity.dart';
import 'package:game/entities/common/entity_stats.dart';

class Player extends Entity {
  Player(EntityStats stats, Vector2 size,
      {Vector2? position, Vector2? velocity, Vector2? acceleration})
      : super(stats, size,
            position: position, velocity: velocity, acceleration: acceleration);

  Player.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  @override
  void calculateAcceleration(dt) {
    this.acceleration = this.target_distance.scaled(this.stats.maxAcceleration);
  }
}
