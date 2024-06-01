import 'dart:io';
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';

import 'package:game/components/ui/main_menu/custom_button_component.dart';
import 'package:game/components/ui/main_menu/custom_popup_component.dart';
import 'package:game/components/ui/main_menu/custom_text_component.dart';
import 'package:game/components/ui/main_menu/custom_text_input_component.dart';
import 'package:game/scenes/scene.dart';

class LoginFormScene extends Scene {
  late List<CustomTextInputComponent> text_inputs = [];
  late List<CustomButtonComponent> buttons = [];
  late CustomTextComponent title;

  LoginFormScene() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    this.background = SpriteComponent(
      sprite: await this.gameRef.loadSprite('main-menu-background.png'),
      size: this.gameRef.size,
    );

    this.title = CustomTextComponent(
      'Mooncats',
      {'y_offset': 0.1, 'font_size': 0.08},
    );

    this.buttons = [
      CustomButtonComponent('Login ', {'y_offset': 0.9, 'font_size': 0.025},
          () {
        this.gameRef.sceneManager.scenePushPop.last.signal({
          'type': 'login',
        });
      }),
    ];

    this.text_inputs = [
      CustomTextInputComponent({
        'y_offset': 0.275,
        'font_size': 0.0175,
        'label': 'email',
        'initial': 'Email',
        'regex': RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
      }),
      CustomTextInputComponent({
        'y_offset': 0.365,
        'font_size': 0.0175,
        'label': 'password',
        'initial': 'Password',
      })
    ];

    this.add(this.background!);
    this.add(this.title);
    this.addAll(this.buttons);
    this.addAll(this.text_inputs);
  }

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.enter)) {
      this.gameRef.sceneManager.scenePushPop.last.signal({
        'type': 'login',
      });
    } else if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      for (var input in this.text_inputs) {
        if (input.isFocused) {
          input.unFocus();
          return;
        }
      }
      this.gameRef.sceneManager.popScene();
    } else if (keysPressed.contains(LogicalKeyboardKey.tab)) {
      for (var i = 0; i < this.text_inputs.length; i++) {
        if (this.text_inputs[i].isFocused) {
          this.text_inputs[i].unFocus();
          this.text_inputs[(i + 1) % this.text_inputs.length].focus();
          return;
        }
      }
      this.text_inputs[0].focus();
    } else {
      this.text_inputs.forEach((element) {
        element.onKeyPress(event, keysPressed);
      });
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    this.unFocusAll();
  }

  @override
  void signal(Map<String, dynamic> data) {
    if (data['type'] == 'focus') {
      this.unFocusAll();
    } else if (data['type'] == 'login') {
      String possibleNotice = '';
      for (var input in this.text_inputs) {
        if (input.text.isEmpty && input.label != 'phone') {
          possibleNotice = 'Please fill in ${input.label}';
          break;
        } else if (!input.checkRegex() && input.label != 'phone') {
          possibleNotice = 'Invalid ${input.label}';
          break;
        }
      }

      if (possibleNotice.isNotEmpty) {
        this.add(CustomPopupComponent({
          'text': possibleNotice,
          'font_size': 0.015,
          'opacity_decay': 0.01,
        }));
        return;
      }

      Map<String, String> data = {
        'email': this.text_inputs[0].text,
        'password': BCrypt.hashpw(
            this.text_inputs[1].text, '\$2a\$14\$kNx1ptnDMHHlr85F87uhPa24sZz')
      };
      this.login(data);
    }
  }

  Future<void> login(Map<String, String> data) async {
    Map<String, dynamic> backend = this.gameRef.configLoader.getBackendConfig();
    http.Response? response;

    try {
      response = await http.post(
        Uri.parse('http://${backend['host']}:${backend['port']}/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        await File(backend['localUserLoginCache']).create(recursive: true)
          ..writeAsStringSync(jsonEncode(data));
        this.gameRef.sceneManager.popScene();
        this
            .gameRef
            .sceneManager
            .scenePushPop
            .last
            .signal({'type': 'logged_in'});
      } else {
        this.add(CustomPopupComponent({
          'text': 'Error: ${response.statusCode} - ${response.reasonPhrase}',
          'font_size': 0.015,
          'opacity_decay': 0.01,
        }));
      }
    } catch (e) {
      if (e is SocketException) {
        this.add(CustomPopupComponent({
          'text': 'Connection error. Please try again later.',
          'font_size': 0.015,
          'opacity_decay': 0.01,
        }));
      } else {
        this.add(CustomPopupComponent({
          'text': 'An unexpected error occurred.',
          'font_size': 0.015,
          'opacity_decay': 0.01,
        }));
      }
    }
  }

  void unFocusAll() {
    this.text_inputs.forEach((element) {
      element.unFocus();
    });
  }
}
