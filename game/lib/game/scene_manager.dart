import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';

import 'package:game/scenes/scene.dart';

class SceneManager extends Component {
  Scene? currentScene;

  Future<void> setScene(Scene scene) async {
    if (this.currentScene != null) {
      this.remove(this.currentScene!);
    }
    this.add(scene);
    this.currentScene = scene;
  }

  void passKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    this.currentScene?.onKeyPress(event, keysPressed);
  }

  void passPointerMoveEvent(PointerMoveEvent event) {
    this.currentScene?.onPointerMove(event);
  }
}
