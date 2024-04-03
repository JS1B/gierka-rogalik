import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flame/src/events/messages/pointer_move_event.dart' as flame;

import 'package:game/components/players/player_component.dart';
import 'package:game/components/weapon_component.dart';
import 'package:game/components/enemies/enemy_component.dart';
import 'package:game/components/enemies/enemy_factory.dart';
import 'package:game/config/game_config.dart';

class RogalikGame extends FlameGame with KeyboardEvents, PointerMoveCallbacks {
  late PlayerComponent playerComponent;
  late Weapon weaponComponent;
  late SpriteComponent background;
  List<EnemyComponent> enemyComponents = [];

  late GameConfigLoader _configLoader;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the background
    background = await loadBackground();
    this.add(background);

    // Initialize and add the player component
    playerComponent = PlayerComponent();
    await this.add(playerComponent);

    // Initialize and add the weapon component
    weaponComponent = Weapon(playerComponent);
    await this.add(weaponComponent);

    this._configLoader = GameConfigLoader();
    await this._configLoader.load('assets/config.yaml');
    await this.addEnemy('zombie');
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
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

    playerComponent.setTargetDirection(direction);

    if (keysPressed.contains(LogicalKeyboardKey.keyK)) {
      this.addEnemy('zombie');
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyL)) {
      this.removeRandomEnemy();
    }

    return KeyEventResult.handled;
  }

  Future<SpriteComponent> loadBackground() async {
    final sprite = await loadSprite('background.jpg');
    final size = this.size;

    // Create a paint with a color filter to darken the sprite
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(
        Colors.black.withOpacity(0.6),
        BlendMode.darken,
      );

    return SpriteComponent(
      sprite: sprite,
      size: size,
      paint: paint,
    );
  }

  // @override
  // void onPointerMove(flame.PointerMoveEvent event) {
  //   // Update weapon position based on mouse movement
  //   weaponComponent.updateWeaponPosition(
  //       Vector2(event.localPosition, event.localPosition.dy));
  // }

  Future<void> addEnemy(String type) async {
    var enemyStats = this._configLoader.getEntityStats(type);
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
