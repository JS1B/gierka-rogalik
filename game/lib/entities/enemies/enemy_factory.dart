import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';
import 'package:game/entities/enemies/zombie_enemy.dart';

class EnemyFactory {
  static Enemy createEnemy(String type, EntityStats stats) {
    switch (type) {
      case 'zombie':
        return Zombie(stats);
      default:
        return Enemy(stats);
    }
  }
}
