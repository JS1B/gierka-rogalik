import 'package:flame/components.dart';
import 'package:game/game/rogalik_game.dart';
import 'package:game/components/player/player_component.dart';
import 'package:game/components/player/bullet_component.dart';
import 'dart:math' as math;

class Weapon extends SpriteComponent with HasGameRef<RogalikGame> {
  PlayerComponent? playerComponent;
  double distanceFromPlayer = 5;
  List<BulletComponent> bullets = [];
  double lastBulletTime = 0;
  double currentTime = 0;
  double? weaponDirection;

  Weapon(this.playerComponent);

  void shoot() {
    if (weaponDirection != null) {
      final bullet = BulletComponent(velocity: 1000)
        ..position = position.clone()
        ..lifetime = 1000 // example lifetime
        ..angle = weaponDirection!;

      bullets.add(bullet);
      gameRef.add(bullet);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final bullet in bullets) {
      bullet.update(dt);
    }

    bullets.removeWhere((bullet) => bullet.lifetime <= 0);
    currentTime += dt;
    if (currentTime - lastBulletTime > 1) {
      // example fire rate
      lastBulletTime = currentTime;
      shoot();
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('weapon-sprite.png');
  }

  void updateWeaponPosition(Vector2 mousePosition) {
    if (playerComponent != null) {
      final Vector2 direction = mousePosition - playerComponent!.position;
      direction.normalize();
      position = playerComponent!.position + direction * distanceFromPlayer;
      weaponDirection = math.atan2(direction.y, direction.x);
    }
  }
}
