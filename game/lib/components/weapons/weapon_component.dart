import 'package:flame/components.dart';
import 'package:game/components/player/player_component.dart';
import 'package:game/weapons/weapon.dart';
import 'package:game/entities/common/weapon_stats.dart';
import 'dart:math' as math;

import 'package:game/game/rogalik_game.dart';
import 'package:game/scenes/first_level.dart';
import 'package:game/config/game_config.dart';

class WeaponComponent extends SpriteComponent with HasGameRef<RogalikGame> {
  final PlayerComponent? playerComponent;
  final Weapon weapon;
  final WeaponStats weaponStats;
  final FirstLevelScene scene;
  final String type;
  bool isOnRightSide = true;
  double distanceFromPlayer = 100;
  double lastBulletTime = 0;
  double currentTime = 0;
  double weaponDirection = 0;
  WeaponComponent(this.playerComponent, this.weapon, this.weaponStats,
      this.scene, this.type);

  @override
  void update(double dt) {
    super.update(dt);
    if (playerComponent != null) {
      this.x =
          playerComponent!.x + distanceFromPlayer * math.cos(weaponDirection);
      this.y =
          playerComponent!.y + distanceFromPlayer * math.sin(weaponDirection);
    }
    // Adjust the angle of the sprite to match weaponDirection
    // Adjust the angle of the sprite to match weaponDirection
    // Adjust the angle of the sprite to match weaponDirection
    this.angle =
        math.atan2(math.sin(weaponDirection), math.cos(weaponDirection));

    // Check if the weapon has changed sides
    bool currentlyOnRightSide =
        weaponDirection > -math.pi / 2 && weaponDirection < math.pi / 2;
    if (currentlyOnRightSide != this.isOnRightSide) {
      // Flip the sprite
      this.flipVertically();
      this.isOnRightSide = currentlyOnRightSide;
    }

    for (final bullet in weapon.bullets) {
      bullet.update(dt);
    }
    weapon.bullets.removeWhere((bullet) => bullet.bullet.stats.lifetime <= 0);
    currentTime += dt;
    if (currentTime - lastBulletTime > 1) {
      // example fire rate
      lastBulletTime = currentTime;
      weapon.shoot(position.clone(), weaponDirection, this.scene);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var configLoader = GameConfigLoader();
    await configLoader.load('assets/config.yaml');
    this.sprite =
        await gameRef.loadSprite(configLoader.getWeaponSpritePath(type));
    this.anchor = Anchor.center;
  }

  void updateWeaponPosition(Vector2 mousePosition) {
    if (playerComponent != null) {
      final Vector2 direction = mousePosition - playerComponent!.position;
      direction.normalize();
      position = playerComponent!.position + direction * distanceFromPlayer;
      weaponDirection = math.atan2(direction.y, direction.x);
    }
  }

  String getType() {
    return type;
  }
}
