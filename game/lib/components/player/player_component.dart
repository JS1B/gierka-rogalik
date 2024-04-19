import 'package:flame/components.dart';

import 'package:game/game/rogalik_game.dart';
import 'package:game/entities/player/player.dart';
import 'package:game/config/game_config.dart';

class PlayerComponent extends SpriteComponent with HasGameRef<RogalikGame> {
  late Player player;

  PlayerComponent() : super(size: Vector2(50, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    var configLoader = GameConfigLoader();
    await configLoader.load('assets/config.yaml');
    var playerStats = configLoader.getEntityStats('default');

    this.player = Player(playerStats);
    this.sprite =
        await gameRef.loadSprite(configLoader.getSpritePath('default'));
    this.position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.player.update(dt);

    this.position = this.player.position;
  }

  void setTargetDirection(Vector2 direction) {
    // Treat player target direction as entity's ditance from target
    this.player.setTargetDistance(direction);
  }
}
