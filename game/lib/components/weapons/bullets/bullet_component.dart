import 'dart:math' as math;
import 'package:flame/components.dart';

import 'package:game/weapons/bullets/bullet.dart';
import 'package:game/entities/common/bullet_stats.dart';
import 'package:game/game/rogalik_game.dart';

class BulletComponent extends SpriteComponent with HasGameRef<RogalikGame> {
  late Bullet bullet;
  late String type;
  BulletComponent(BulletStats bulletStats, this.type, )
      : this.bullet = Bullet(bulletStats);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var configLoader = this.gameRef.configLoader;
    await configLoader.load('assets/config.yaml');
    this.sprite =
        await gameRef.loadSprite(configLoader.getBulletSpritePath(type));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update bullet position based on its velocity and angle
    this.position.add(
        Vector2(math.cos(this.angle), math.sin(this.angle)) * this.bullet.stats.velocity * dt);

    // Decrease lifetime
    this.bullet.stats.lifetime -= dt;
    if (this.bullet.stats.lifetime <= 0) {
      removeFromParent(); // Remove the bullet if its lifetime is over
    }
  }
}
