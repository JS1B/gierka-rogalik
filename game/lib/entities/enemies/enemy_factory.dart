import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';
import 'package:game/entities/enemies/goblin_enemy.dart';
import 'package:game/entities/enemies/robot_enemy.dart';
import 'package:game/entities/enemies/zombie_enemy.dart';

class EnemyFactory {
  static Enemy createEnemy(String type, EntityStats stats) {
    switch (type.toLowerCase()) {
      case 'zombie':
        return Zombie(stats);
      case 'goblin':
        return Goblin(stats);
      case 'robot':
        return Robot(stats);
      default:
        return Enemy(stats);
    }
  }
}
