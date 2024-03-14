import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/src/events/messages/pointer_move_event.dart' as flame;
import 'package:game/components/weapon_component.dart';

import 'components/player_component.dart';

class RogalikGame extends FlameGame with KeyboardEvents, PointerMoveCallbacks {
  late Player player;
  late SpriteComponent background;
  late Weapon weapon;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the background
    background = await loadBackground();
    add(background);

    // Load the player
    player = Player();
    weapon = Weapon(); // Example initial position
    weapon.position = Vector2(100, 100);
    weapon.player = player; // Set the player reference
    await add(player);
    await add(weapon);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
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

    player.setTargetDirection(direction);

    return KeyEventResult.handled;
  }

  Future<SpriteComponent> loadBackground() async {
    final sprite = await loadSprite('background.jpg');
    final size = this.size;

    // Create a paint with a color filter to darken the sprite
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(
        Colors.black.withOpacity(0.6),
        BlendMode.darken, // Use the darken blend mode
      );

    return SpriteComponent(
      sprite: sprite,
      size: size,
      paint: paint, // Apply the custom paint
    );
  }

@override
void onPointerMove(flame.PointerMoveEvent event) {
    // Update weapon position based on mouse movement
    weapon.updateWeaponPosition(Vector2(event.localPosition.x, event.localPosition.y));
  }
}