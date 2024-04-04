import 'package:game/entities/enemies/enemy.dart';
import 'package:game/entities/common/entity_stats.dart';

class Zombie extends Enemy {
  Zombie(EntityStats stats) : super(stats);

  /// Move towards the target - PI
  @override
  void move(double dt) {
    // #TODO
    super.move(dt);
  }
}
