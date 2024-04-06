import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/game/rogalik_game.dart';
import 'package:game/game/scene_manager.dart';

abstract class Scene extends Component with HasGameRef<RogalikGame> {
  Scene(this.sceneManager);

  SceneManager sceneManager;

  void render(Canvas canvas);
  void update(double dt);
  void onEnter();
  void onExit();
  void onGameResize(Vector2 gameSize);
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed);
}
