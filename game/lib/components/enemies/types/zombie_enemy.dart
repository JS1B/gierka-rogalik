import 'package:game/components/enemies/enemy.dart';
import 'package:game/components/common/entity_stats.dart';

class ZombieEnemy extends Enemy {
  ZombieEnemy(EntityStats stats) : super(stats);

  @override
  void move() {
    // Move like an idiot (lore accurate)
    // #TODO
  }

  @override
  void attack() {
    // Attack whenever close
    // #TODO
  }

  void regenerate() {
    // #TODO
  }
}
