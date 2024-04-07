import 'dart:io';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:game/components/ui/main_menu/main_menu_button_component.dart';
import 'package:game/components/ui/main_menu/main_menu_text_component.dart';
import 'package:game/game/scene_manager.dart';
import 'package:game/scenes/first_level.dart';
import 'package:game/scenes/scene.dart';

class MainMenuScene extends Scene {
  SpriteComponent? background;
  CustomTextComponent? title;
  List<CustomButtonComponent>? buttons;

  MainMenuScene(SceneManager sceneManager) : super(sceneManager);

  @override
  void update(double dt) {
    super.update(dt);
    if (this.title != null) this.title!.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (this.title != null) this.title!.render(canvas);
  }

  @override
  void onEnter() async {
    this.background = SpriteComponent(
      sprite: await this.gameRef.loadSprite('main-menu-background.png'),
      size: this.gameRef.size,
    );
    this.add(this.background!);

    this.title = CustomTextComponent(
        'Mooncats', this.gameRef, {'y_offset': 0.1, 'font_size': 0.08});
    this.add(this.title!);

    this.buttons = [
      CustomButtonComponent(
          'Play', this.gameRef, {'y_offset': 0.5, 'font_size': 0.05}, () {
        this.sceneManager.setScene(FirstLevelScene(this.sceneManager));
      }),
      CustomButtonComponent('Settings', this.gameRef,
          {'y_offset': 0.65, 'font_size': 0.05}, () {}),
      CustomButtonComponent(
          'Exit', this.gameRef, {'y_offset': 0.8, 'font_size': 0.05}, () {
        exit(0);
      }),
    ];
    this.buttons!.forEach(this.add);
  }

  @override
  void onExit() {
    this.removeAll(this.children);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    if (this.background == null || this.title == null || this.buttons == null)
      return;

    final imgWidth = background!.sprite!.image.width.toDouble();
    final imgHeight = background!.sprite!.image.height.toDouble();

    final imageRatio = imgWidth / imgHeight;
    final canvasRatio = gameSize.x / gameSize.y;

    double drawWidth, drawHeight, dx, dy;

    if (imageRatio > canvasRatio) {
      drawHeight = gameSize.y;
      drawWidth = gameSize.y * imageRatio;
      dx = (gameSize.x - drawWidth) / 2;
      dy = 0;
    } else {
      drawWidth = gameSize.x;
      drawHeight = gameSize.x / imageRatio;
      dx = 0;
      dy = (gameSize.y - drawHeight) / 2;
    }

    this.background!.size = Vector2(drawWidth, drawHeight);
    this.background!.position = Vector2(dx, dy);

    this.title!.updateTextStyle();
  }

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {}
}
