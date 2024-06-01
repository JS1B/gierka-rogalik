import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:game/components/player/player_component.dart';
import 'package:game/config/game_config.dart';
import 'package:game/game/scene_manager.dart';
import 'package:game/scenes/main_menu.dart';

class RogalikGame extends FlameGame with KeyboardEvents, PointerMoveCallbacks {
  late PlayerComponent playerComponent;
  late SceneManager sceneManager;
  FpsTextComponent? fpsComponent;

  final GameConfigLoader configLoader = GameConfigLoader();

  RogalikGame({bool? debugMode}) : super() {
    this.debugMode = debugMode ?? false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await this.configLoader.load('assets/config.yaml');

    this.sceneManager = SceneManager();
    this.add(this.sceneManager);
    await this.sceneManager.pushScene(MainMenuScene());

    this.fpsComponent = FpsTextComponent(
        anchor: Anchor.topRight, position: Vector2(this.size.x, 0));

    if (!this.debugMode) return;
    this.add(this.fpsComponent!);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.f1)) {
      this.debugMode = !this.debugMode;
      if (this.debugMode) {
        this.add(this.fpsComponent!);
      } else {
        this.remove(this.fpsComponent!);
      }

      void enableDebugMode(Component component) {
        component.debugMode = this.debugMode;
        component.children.forEach((element) {
          enableDebugMode(element);
        });
      }

      enableDebugMode(this);
    }

    bool shouldExit = false;
    if (keysPressed.length == 2 &&
        keysPressed.contains(LogicalKeyboardKey.controlLeft) &&
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      shouldExit = true;
    }
    this.sceneManager.passKeyEvent(event, keysPressed);

    if (shouldExit) {
      exit(0);
    }

    return KeyEventResult.handled;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    this.fpsComponent?.position = Vector2(this.size.x, 0);
  }

  @override
  void onRemove() {
    print("Game removed");
    Flame.images.clearCache();
    Flame.assets.clearCache();
  }
}
