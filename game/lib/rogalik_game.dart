import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player_component.dart';

class RogalikGame extends FlameGame with KeyboardEvents {
  late Player player;
  late SpriteComponent background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the background
    background = await loadBackground();
    add(background);

    // Load the player
    player = Player();
    await add(player);
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
}
