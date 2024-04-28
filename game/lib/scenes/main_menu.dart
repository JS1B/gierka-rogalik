import 'dart:io';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'package:game/components/ui/main_menu/main_menu_button_component.dart';
import 'package:game/components/ui/main_menu/main_menu_text_component.dart';
import 'package:game/scenes/first_level.dart';
import 'package:game/scenes/scene.dart';

class MainMenuScene extends Scene {
  late List<CustomButtonComponent> buttons;
  late CustomTextComponent title;

  MainMenuScene() : super();

  @override
  void onLoad() async {
    await super.onLoad();

    this.background = SpriteComponent(
        sprite: await this.gameRef.loadSprite('main-menu-background.png'),
        size: this.gameRef.size);

    this.title =
        CustomTextComponent('Mooncats', {'y_offset': 0.1, 'font_size': 0.08});

    this.buttons = [
      CustomButtonComponent('Play', {'y_offset': 0.5, 'font_size': 0.05},
          () async {
        await this.gameRef.sceneManager.pushScene(FirstLevelScene());
      }),
      CustomButtonComponent('Settings', {'y_offset': 0.65, 'font_size': 0.05},
          () {
        // #TODO
      }),
      CustomButtonComponent('Exit', {'y_offset': 0.8, 'font_size': 0.05}, () {
        exit(0);
      }),
    ];

    this.add(this.background!);
    this.add(this.title);
    this.addAll(this.buttons);
  }

  @override
  void onReload() {}

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {}
}
