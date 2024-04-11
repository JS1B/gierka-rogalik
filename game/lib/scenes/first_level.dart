import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';

import 'package:game/components/enemies/enemy_component.dart';
import 'package:game/components/player/player_component.dart';
import 'package:game/components/weapons/weapon.dart';
import 'package:game/components/weapons/weapon_component.dart';
import 'package:game/entities/enemies/enemy_factory.dart';
import 'package:game/scenes/scene.dart';

class FirstLevelScene extends Scene {
  SpriteComponent? background;

  late WeaponComponent weaponComponent;
  late List<EnemyComponent> enemyComponents;

  FirstLevelScene() : super();

  @override
  void onLoad() async {
    await super.onLoad();

    this.background = SpriteComponent(
      sprite: await this.gameRef.loadSprite('background.jpg'),
      size: this.gameRef.size,
    );
    this.add(this.background!);

    this.gameRef.playerComponent = PlayerComponent();
    this.add(this.gameRef.playerComponent);
    print("Player component added");
    this.addWeapon("gun");

    this.enemyComponents = [];
    await this.addEnemy('zombie');
  }

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    Vector2 direction = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      direction.add(Vector2(0, -1));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      direction.add(Vector2(0, 1));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      direction.add(Vector2(-1, 0));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      direction.add(Vector2(1, 0));
    }

    this.gameRef.playerComponent.setTargetDirection(direction);

    if (keysPressed.contains(LogicalKeyboardKey.keyK)) {
      this.addEnemy('zombie');
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyL)) {
      this.removeRandomEnemy();
    }
  }
  @override
  void onPointerMove(PointerMoveEvent event) {
    this.weaponComponent.updateWeaponPosition(
      Vector2(event.localPosition.x, event.localPosition.y));
  }

   Future<void> addWeapon(String type) async {
    var weaponStats = this.gameRef.configLoader.getWeaponStats(type);
    var bulletStats = this.gameRef.configLoader.getBulletStats(type);
    var weapon = Weapon(bulletStats);
    this.weaponComponent = WeaponComponent(this.gameRef.playerComponent, weapon, weaponStats);
    this.add(this.weaponComponent);
  }

  Future<void> addEnemy(String type) async {
    var enemyStats = this.gameRef.configLoader.getEntityStats(type);
    var enemy = EnemyFactory.createEnemy(type, enemyStats);

    var enemyComponent = await EnemyComponent(enemy);
    this.enemyComponents.add(enemyComponent);
    this.add(enemyComponent);
  }

  void removeRandomEnemy() {
    if (this.enemyComponents.isEmpty) return;

    var enemyComponent = this.enemyComponents[0];
    this.remove(enemyComponent);
    this.enemyComponents.remove(enemyComponent);
  }
}
