import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/events.dart' as flame;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:game/components/player/player_component.dart';
import 'package:game/config/game_config.dart';
import 'package:game/game/scene_manager.dart';
import 'package:game/scenes/main_menu.dart';

class RogalikGame extends FlameGame with flame.KeyboardEvents, flame.PointerMoveCallbacks {
  late PlayerComponent playerComponent;
  late SceneManager sceneManager;

  final GameConfigLoader configLoader = GameConfigLoader();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await this.configLoader.load('assets/config.yaml');

    this.sceneManager = SceneManager();
    this.add(this.sceneManager);
    await this.sceneManager.setScene(MainMenuScene());
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    this.sceneManager.passKeyEvent(event, keysPressed);

    return KeyEventResult.handled;
  }

  @override
  void onPointerMove(flame.PointerMoveEvent event) {
    this.sceneManager.passPointerMoveEvent(event);
  }

  @override
  void onRemove() {
    print("Game removed");
    Flame.images.clearCache();
    Flame.assets.clearCache();
  }
}
