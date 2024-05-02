import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:game/components/enemies/enemy_component.dart';
import 'package:game/game/rogalik_game.dart';
import 'package:game/entities/player/player.dart';
import 'package:game/config/game_config.dart';

class PlayerComponent extends SpriteComponent
    with HasGameRef<RogalikGame>, CollisionCallbacks {
  late Player player;

  PlayerComponent() : super(size: Vector2(50, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    var configLoader = GameConfigLoader();
    await configLoader.load('assets/config.yaml');
    var playerStats = configLoader.getEntityStats('player');

    this.player =
        Player(playerStats, this.size, position: this.gameRef.size / 2);

    this.sprite =
        await this.gameRef.loadSprite(configLoader.getSpritePath('player'));

    // Build a capsule / tictac hitbox
    final double radius =
        max(this.size.x / 2, this.size.y / 2); // Radius of the circles
    final double yDistance =
        radius / 2; // Distance from the center to position the circles
    final hitbox = CompositeHitbox(
      position: Vector2(0, 0),
      // anchor: Anchor.center,
      children: [
        RectangleHitbox.relative(
          Vector2(1.0, 0.5), // Rectangle covering the central part
          parentSize: this.size,
          anchor: Anchor.center,
          position: this.size.scaled(0.5), // Positioned in the center
        ),
        CircleHitbox.relative(
          1.0, // Circle size relative to the rectangle's height
          position: Vector2(
              this.size.x / 2,
              this.size.y / 2 -
                  yDistance), // Positioned at the top of the rectangle
          anchor: Anchor.center,
          parentSize: this.size,
        ),
        CircleHitbox.relative(
          1.0, // Same size as the top circle
          position: Vector2(
              this.size.x * 0.5,
              this.size.y * 0.5 +
                  yDistance), // Positioned at the bottom of the rectangle
          anchor: Anchor.center,
          parentSize: this.size,
        ),
      ],
    );
    this.add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.player.update(dt);

    this.position = this.player.position;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    Vector2 pushBackVector = (this.position - other.position).normalized();

    if (other is EnemyComponent) {
      this.player.addPushBack(pushBackVector);
    }
  }

  void setTargetDirection(Vector2 direction) {
    // Treat player target direction as entity's ditance from target
    this.player.setTargetDistance(direction);
  }
}
