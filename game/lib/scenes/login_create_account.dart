import 'dart:convert';
import 'dart:io' as io;
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'package:game/components/ui/main_menu/custom_button_component.dart';
import 'package:game/components/ui/main_menu/custom_popup_component.dart';
import 'package:game/components/ui/main_menu/custom_text_component.dart';
import 'package:game/scenes/first_level.dart';
import 'package:game/scenes/login_form.dart';
import 'package:game/scenes/register_form.dart';
import 'package:game/scenes/scene.dart';

class LoginCreateAccountScene extends Scene {
  late final CustomTextComponent title;
  late final List<CustomButtonComponent> playButtons;
  late final List<CustomButtonComponent> loginButtons;
  late Map<String, dynamic> user_data;

  LoginCreateAccountScene() : super();

  @override
  void onLoad() async {
    await super.onLoad();

    this.background = SpriteComponent(
        sprite: await this.gameRef.loadSprite('main-menu-background.png'),
        size: this.gameRef.size);

    this.title =
        CustomTextComponent('Mooncats', {'y_offset': 0.1, 'font_size': 0.08});

    this.playButtons = [
      CustomButtonComponent('Play', {'y_offset': 0.5, 'font_size': 0.05}, () {
        this.gameRef.sceneManager.pushScene(FirstLevelScene());
      }),
      CustomButtonComponent('Logout', {'y_offset': 0.65, 'font_size': 0.05},
          () async {
        Map<String, dynamic> config =
            this.gameRef.configLoader.getBackendConfig();
        io.File userLoginCache = await io.File(config['localUserLoginCache']);

        await userLoginCache.delete();
        this.gameRef.sceneManager.popScene();
      })
    ];

    this.loginButtons = [
      CustomButtonComponent('Login', {'y_offset': 0.5, 'font_size': 0.05}, () {
        this.gameRef.sceneManager.pushScene(LoginFormScene());
        this.removeAll(this.loginButtons);
      }),
      CustomButtonComponent(
          'Create Account', {'y_offset': 0.65, 'font_size': 0.05}, () {
        this.gameRef.sceneManager.pushScene(RegisterFormScene());
      })
    ];

    this.add(this.background!);
    this.add(this.title);
    this.add(CustomButtonComponent(
        'Main Menu', {'y_offset': 0.8, 'font_size': 0.05}, () {
      this.gameRef.sceneManager.popScene();
    }));
  }

  @override
  void onMount() async {
    super.onMount();
    this.user_data = await this.checkIfLoggedIn();

    if (this.user_data.isNotEmpty) {
      this.add(CustomPopupComponent({
        'text': 'Logged in as ${this.user_data['email']}',
        'font_size': 0.01,
        'opacity_decay': 0.005,
      }));
      this.addAll(this.playButtons);
    } else {
      this.addAll(this.loginButtons);
    }
  }

  Future<Map<String, dynamic>> checkIfLoggedIn() async {
    Map<String, dynamic> config = this.gameRef.configLoader.getBackendConfig();
    io.File userLoginCache = await io.File(config['localUserLoginCache']);

    if (await userLoginCache.exists()) {
      return await userLoginCache.readAsString().then((String contents) {
        return jsonDecode(contents);
      });
    }

    return Map<String, dynamic>();
  }

  @override
  void signal(Map<String, dynamic> data) {
    if (data['type'] == 'created') {
      this.add(CustomPopupComponent({
        'text': 'User created successfully!',
        'font_size': 0.015,
        'opacity_decay': 0.01,
      }));
    } else if (data['type'] == 'logged_in') {
      this.add(CustomPopupComponent({
        'text': 'User logged in successfully!',
        'font_size': 0.015,
        'opacity_decay': 0.01,
      }));
    }
  }

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      this.gameRef.sceneManager.popScene();
    }
  }
}
