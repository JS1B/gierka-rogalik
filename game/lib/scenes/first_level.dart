import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/components/enemies/enemy_component.dart';
import 'package:game/components/player/player_component.dart';
import 'package:game/components/player/weapon_component.dart';
import 'package:game/entities/enemies/enemy_factory.dart';
import 'package:game/game/scene_manager.dart';

import 'package:game/scenes/scene.dart';

class FirstLevelScene extends Scene {
  FirstLevelScene(SceneManager sceneManager) : super(sceneManager);
  SpriteComponent? background;

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {}

  @override
  void onEnter() async {
    this.background = SpriteComponent(
      sprite: await this.gameRef.loadSprite('background.jpg'),
      size: this.gameRef.size,
    );

    this.gameRef.playerComponent = PlayerComponent();
    this.gameRef.weaponComponent = Weapon(this.gameRef.playerComponent);

    this.add(this.background!);
    await this.add(this.gameRef.playerComponent);
    await this.add(this.gameRef.weaponComponent);
    await this.addEnemy('zombie');
  }

  @override
  void onExit() {
    this.remove(this.background!);
    this.remove(this.gameRef.playerComponent);
    this.remove(this.gameRef.weaponComponent);
    if (this.gameRef.enemyComponents.isNotEmpty) {
      for (var enemyComponent in this.gameRef.enemyComponents) {
        this.remove(enemyComponent);
      }
      this.gameRef.enemyComponents.clear();
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    if (this.background == null) return;

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
  }

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    Vector2 direction = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      direction.add(Vector2(0, -1));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      direction.add(Vector2(0, 1));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      direction.add(Vector2(-1, 0));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      direction.add(Vector2(1, 0));
    }

    this.gameRef.playerComponent.setTargetDirection(direction);

    if (keysPressed.contains(LogicalKeyboardKey.keyK)) {
      this.addEnemy('zombie');
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyL)) {
      this.removeRandomEnemy();
    }
  }

  Future<void> addEnemy(String type) async {
    var enemyStats = this.gameRef.configLoader.getEntityStats(type);
    var enemy = EnemyFactory.createEnemy(type, enemyStats);

    var enemyComponent = await EnemyComponent(enemy);
    this.gameRef.enemyComponents.add(enemyComponent);
    this.add(enemyComponent);
  }

  void removeRandomEnemy() {
    if (this.gameRef.enemyComponents.isEmpty) return;

    var enemyComponent = this.gameRef.enemyComponents[0];
    this.remove(enemyComponent);
    this.gameRef.enemyComponents.remove(enemyComponent);
  }
}
