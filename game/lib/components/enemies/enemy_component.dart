import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:game/config/game_config.dart';
import 'package:game/rogalik_game.dart';

import '../common/entity_stats.dart';
import 'enemy.dart';

abstract class EnemyComponent extends SpriteComponent
    with HasGameRef<RogalikGame> {
  final Enemy enemy;

  EnemyComponent(EntityStats stats) : enemy = Enemy(stats);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var configLoader = GameConfigLoader();
    await configLoader.load('assets/config.yaml');

    enemy.stats = configLoader.getEntityStats('enemy');
    sprite = await gameRef.loadSprite(configLoader.getSpritePath('enemy'));
  }

  @override
  void update(double dt) {
    super.update(dt);
    enemy.move();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
