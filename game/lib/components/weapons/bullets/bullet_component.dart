import 'package:flame/components.dart';
import 'dart:math' as math;
import 'package:game/components/weapons/bullets/bullet.dart';
import 'package:game/entities/common/bullet_stats.dart';
import 'package:game/game/rogalik_game.dart';

class BulletComponent extends SpriteComponent with HasGameRef<RogalikGame>{
  late Bullet bullet;
  BulletComponent(BulletStats bulletStats) : this.bullet = Bullet(bulletStats);

   @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('bullet-sprite.png');
    
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update bullet position based on its velocity and angle
    this.position.add(Vector2(math.cos(angle), math.sin(angle)) * bullet.stats.velocity * dt);

    // Decrease lifetime
    bullet.stats.lifetime -= dt;
    if (bullet.stats.lifetime <= 0) {
      removeFromParent(); // Remove the bullet if its lifetime is over
    }
  }
}
