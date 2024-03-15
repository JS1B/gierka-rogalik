import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flame/src/events/messages/pointer_move_event.dart' as flame;

import 'package:game/components/players/player_component.dart';
import 'package:game/components/weapon_component.dart';
import 'package:game/components/enemies/types/zombie_enemy_component.dart';

class RogalikGame extends FlameGame with KeyboardEvents, PointerMoveCallbacks {
  late PlayerComponent playerComponent;
  late Weapon weaponComponent;
  late SpriteComponent background;
  late ZombieEnemyComponent zombieEnemy;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the background
    background = await loadBackground();
    add(background);

    // Initialize and add the player component
    playerComponent = PlayerComponent();
    await add(playerComponent);

    // Initialize and add the weapon component
    weaponComponent = Weapon(playerComponent);
    await add(weaponComponent);

    this.zombieEnemy = ZombieEnemyComponent();
    await this.add(zombieEnemy);
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
}
