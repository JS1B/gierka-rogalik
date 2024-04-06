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
  MainMenuScene(SceneManager sceneManager) : super(sceneManager);
  SpriteComponent? background;
  CustomTextComponent? Title;
  List<CustomButtonComponent>? buttons;

  @override
  void update(double dt) {
    if (this.Title == null) return;
    this.Title!.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (this.Title == null) return;
    this.Title!.render(canvas);
  }

  @override
  void onEnter() async {
    this.background = SpriteComponent(
      sprite: await this.gameRef.loadSprite('main-menu-background.png'),
      size: this.gameRef.size,
    );
    this.Title = CustomTextComponent(
        'Mooncats', this.gameRef, {'y_offset': 0.1, 'font_size': 0.08});
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

    this.add(this.background!);
    this.add(Title!);
    for (var button in buttons!) {
      this.add(button);
    }
  }

  @override
  void onExit() {
    this.remove(this.background!);
    this.remove(this.Title!);
    for (var button in buttons!) {
      this.remove(button);
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    if (this.background == null || this.Title == null || this.buttons == null)
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

    this.Title!.setTextStyle();
    for (var button in this.buttons!) {
      button.setTextStyle();
    }
  }

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {}
}
