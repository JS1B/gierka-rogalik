import 'package:flame/components.dart';
import 'package:game/components/player/player_component.dart';
import 'package:game/components/weapons/weapon.dart';
import 'package:game/entities/common/weapon_stats.dart';
import 'dart:math' as math;

import 'package:game/game/rogalik_game.dart';

class WeaponComponent extends SpriteComponent with HasGameRef<RogalikGame> {
  final PlayerComponent? playerComponent;
  final Weapon weapon;
  final WeaponStats weaponStats;
  double distanceFromPlayer = 50;
  double lastBulletTime = 0;
  double currentTime = 0;
  double weaponDirection = 0;
  WeaponComponent(this.playerComponent, this.weapon, this.weaponStats);
    
  @override
  void update(double dt) {
    super.update(dt);
    for (final bullet in weapon.bullets) {
      bullet.update(dt);
    }
    weapon.bullets.removeWhere((bullet) => bullet.bullet.stats.lifetime <= 0);
    currentTime += dt;
    if (currentTime - lastBulletTime > 1) {
      // example fire rate
      lastBulletTime = currentTime;
      weapon.shoot(position.clone(), weaponDirection);
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
