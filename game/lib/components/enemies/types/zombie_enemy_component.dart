import 'package:flutter/widgets.dart';
import 'package:game/components/common/entity_stats.dart';
import 'package:game/components/enemies/enemy_component.dart';
import 'package:game/components/enemies/types/zombie_enemy.dart';
import 'package:game/config/game_config.dart';

class ZombieEnemyComponent extends EnemyComponent {
  late ZombieEnemy zombie;

  ZombieEnemyComponent() : super(EntityStats()) {}

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var configLoader = GameConfigLoader();
    await configLoader.load('assets/config.yaml');
    EntityStats zombieStats = configLoader.getEntityStats('zombie');
    this.zombie = ZombieEnemy(zombieStats);
    this.sprite =
        await gameRef.loadSprite(configLoader.getSpritePath('zombie'));
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.zombie.move();
    this.zombie.regenerate();
    this.zombie.attack();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // #TODO More
  }
}
