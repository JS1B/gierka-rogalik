import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/src/events/messages/pointer_move_event.dart' as flame;
import 'package:game/components/weapon_component.dart';

import 'components/player_component.dart';

class RogalikGame extends FlameGame with KeyboardEvents, PointerMoveCallbacks {
  late Player player;
  late Weapon weapon;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

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

@override
void onPointerMove(flame.PointerMoveEvent event) {
    // Update weapon position based on mouse movement
    weapon.updateWeaponPosition(Vector2(event.localPosition.x, event.localPosition.y));
  }
}