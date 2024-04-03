import 'package:game/components/enemies/enemy.dart';
import 'package:game/components/common/entity_stats.dart';
import 'package:game/components/enemies/types/zombie_enemy.dart';

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
