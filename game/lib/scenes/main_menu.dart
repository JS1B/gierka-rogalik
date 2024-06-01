import 'dart:io';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'package:game/components/ui/main_menu/custom_button_component.dart';
import 'package:game/components/ui/main_menu/custom_text_component.dart';
import 'package:game/scenes/login_create_account.dart';
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
        await this.gameRef.sceneManager.pushScene(LoginCreateAccountScene());
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
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {}
}
