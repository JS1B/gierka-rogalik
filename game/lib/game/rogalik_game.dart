import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:game/components/player/player_component.dart';
import 'package:game/components/player/weapon_component.dart';
import 'package:game/components/enemies/enemy_component.dart';
import 'package:game/config/game_config.dart';
import 'package:game/game/scene_manager.dart';
import 'package:game/scenes/main_menu.dart';

class RogalikGame extends FlameGame with KeyboardEvents, PointerMoveCallbacks {
  late Weapon weaponComponent;
  late PlayerComponent playerComponent;
  List<EnemyComponent> enemyComponents = [];
  SceneManager? sceneManager;

  final GameConfigLoader configLoader = GameConfigLoader();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await this.configLoader.load('assets/config.yaml');

    this.sceneManager = SceneManager();
    this.add(this.sceneManager!);
    await this.sceneManager!.setScene(MainMenuScene(this.sceneManager!));
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    if (this.sceneManager == null) return;
    this.sceneManager!.currentScene!.onGameResize(gameSize);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (this.sceneManager != null) {
      this.sceneManager!.passKeyEvent(event, keysPressed);
    }

    return KeyEventResult.handled;
  }
}
