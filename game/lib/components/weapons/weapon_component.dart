import 'package:flame/components.dart';
import 'package:game/components/weapons/weapon.dart';
import 'package:game/rogalik_game.dart';
import 'package:game/components/players/player_component.dart';
import 'dart:math' as math;

class WeaponComponent extends SpriteComponent with HasGameRef<RogalikGame> {
  final PlayerComponent? playerComponent;
  late Weapon weapon;
  double distanceFromPlayer = 5;
  double lastBulletTime = 0;
  double currentTime = 0;
  double? weaponDirection;
  WeaponComponent(this.playerComponent, this.weapon);
    
  @override
  void update(double dt) {
    super.update(dt);

    weapon.bullets.removeWhere((bullet) => bullet.bullet.stats.lifetime <= 0);
    currentTime += dt;
    if (currentTime - lastBulletTime > 1) {
      // example fire rate
      lastBulletTime = currentTime;
      weapon.shoot(position.clone(), weaponDirection!);
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
