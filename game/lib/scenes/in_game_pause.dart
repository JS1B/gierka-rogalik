import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/components/ui/main_menu/main_menu_button_component.dart';

import 'package:game/scenes/scene.dart';

class InGamePauseScene extends Scene {
  late List<CustomButtonComponent> buttons;

  InGamePauseScene() : super();

  @override
  void onLoad() async {
    await super.onLoad();

    this.background = SpriteComponent(
        sprite: await this.gameRef.loadSprite('in-game-pause.png'),
        size: this.gameRef.size);
    this.buttons = [
      CustomButtonComponent(
          'Save', {'y_offset': 0.3, 'font_size': 0.05}, () async {}),
      CustomButtonComponent(
          'Load', {'y_offset': 0.45, 'font_size': 0.05}, () {}),
      CustomButtonComponent(
          'Settings', {'y_offset': 0.6, 'font_size': 0.05}, () {}),
      CustomButtonComponent('Main Menu', {'y_offset': 0.75, 'font_size': 0.05},
          () {
        this.gameRef.sceneManager.popScene(numberToPop: 2);
      }),
    ];

    this.add(this.background!);
    this.addAll(this.buttons);
  }

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      this.gameRef.sceneManager.popScene();
    }
  }
}
