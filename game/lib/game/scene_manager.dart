import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/game/rogalik_game.dart';
import 'package:game/scenes/scene.dart';

class SceneManager extends Component with HasGameRef<RogalikGame> {
  Scene? currentScene;

  Future<void> setScene(Scene scene) async {
    if (this.currentScene != null) {
      this.game.remove(this.currentScene!);
      this.currentScene!.onExit();
    }
    this.game.add(scene);
    this.currentScene = scene;
    this.currentScene!.onEnter();
  }

  void render(Canvas canvas) {
    this.currentScene?.render(canvas);
  }

  void update(double dt) {
    this.currentScene?.update(dt);
  }

  void passKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    this.currentScene?.onKeyPress(event, keysPressed);
  }
}
