import 'dart:io';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'package:game/scenes/scene.dart';

class SceneManager extends Component {
  List<Scene> scenePushPop = [];

  Future<void> pushScene(Scene scene) async {
    if (this.scenePushPop.isNotEmpty) {
      this.remove(this.scenePushPop.last);
    }
    this.scenePushPop.add(scene);
    this.add(scene);
  }

  Future<void> popScene({numberToPop = 1}) async {
    for (var i = 0; i < numberToPop; i++) {
      if (this.scenePushPop.isNotEmpty) {
        if (i == 0) this.remove(this.scenePushPop.last);
        this.scenePushPop.removeLast();
      }
    }

    if (this.scenePushPop.isNotEmpty) {
      this.add(this.scenePushPop.last);
    } else {
      exit(0);
    }
  }

  void passKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (this.scenePushPop.isNotEmpty) {
      this.scenePushPop.last.onKeyPress(event, keysPressed);
    }
  }
}
