import 'dart:math' as math;
import 'package:flame/components.dart';

import 'package:game/weapons/weapon.dart';
import 'package:game/entities/common/weapon_stats.dart';
import 'package:game/game/rogalik_game.dart';
import 'package:game/scenes/first_level.dart';

class WeaponComponent extends SpriteComponent with HasGameRef<RogalikGame> {
  final Weapon weapon;
  final WeaponStats weaponStats;
  final FirstLevelScene scene;
  final String type;
  bool isOnRightSide = true;
  double distanceFromPlayer = 100;
  double lastBulletTime = 0;
  double currentTime = 0;
  double weaponDirection = 0;
  
  WeaponComponent(this.weapon, this.weaponStats,
      this.scene, this.type,);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    var configLoader = this.gameRef.configLoader;
    await configLoader.load('assets/config.yaml');
    this.sprite =
        await gameRef.loadSprite(configLoader.getWeaponSpritePath(type));
    this.anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.x =
        this.gameRef.playerComponent.position.x + this.distanceFromPlayer * math.cos(this.weaponDirection);
    this.y =
        this.gameRef.playerComponent.position.y + this.distanceFromPlayer * math.sin(this.weaponDirection);
      // Adjust the angle of the sprite to match weaponDirection
    
    this.angle =
        math.atan2(math.sin(this.weaponDirection), math.cos(this.weaponDirection));

    // Check if the weapon has changed sides
    bool currentlyOnRightSide =
        this.weaponDirection > -math.pi / 2 && this.weaponDirection < math.pi / 2;
    if (currentlyOnRightSide != this.isOnRightSide) {
      // Flip the sprite
      this.flipVertically();
      this.isOnRightSide = currentlyOnRightSide;
    }

    weapon.bullets.removeWhere((bullet) => bullet.bullet.stats.lifetime <= 0);
    currentTime += dt;
    if (currentTime - lastBulletTime > 1) {
      // example fire rate
      lastBulletTime = currentTime;
      weapon.shoot(position.clone(), weaponDirection, this.scene);
    }
  }

  void updateWeaponPosition(Vector2 mousePosition) {
    final Vector2 direction = mousePosition - this.gameRef.playerComponent.position;
    direction.normalize();
    position = this.gameRef.playerComponent.position + direction * distanceFromPlayer;
    weaponDirection = math.atan2(direction.y, direction.x);
    }

  //A very temporary solution untill we implement character classes.
  //At that point each weapon will be exclusive to a class and writing type will not be neceserry.
  String getType() { 
    return type;
  }
}
