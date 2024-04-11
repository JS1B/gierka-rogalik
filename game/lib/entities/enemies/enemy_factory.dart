import 'dart:math';

import 'package:flame/components.dart';
import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';
import 'package:game/entities/enemies/goblin_enemy.dart';
import 'package:game/entities/enemies/robot_enemy.dart';
import 'package:game/entities/enemies/zombie_enemy.dart';

class EnemyFactory {
  static Enemy createEnemy(EnemyType type, EntityStats stats) {
    // Randomize the position
    var position =
        Vector2(100.0 + Random().nextInt(200), 100.0 + Random().nextInt(500));
    switch (type) {
      case EnemyType.zombie:
        return Zombie(stats, position: position);
      case EnemyType.goblin:
        return Goblin(stats, position: position);
      case EnemyType.robot:
        return Robot(stats, position: position);
    }
  }
}

enum EnemyType { zombie, goblin, robot }
