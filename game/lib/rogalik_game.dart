import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'components/player_component.dart';

class RogalikGame extends FlameGame with KeyboardEvents {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

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
}
