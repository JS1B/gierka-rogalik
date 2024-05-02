import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/components/ui/gameplay/ui_component.dart';

import 'package:game/game/rogalik_game.dart';

abstract class Scene extends Component with HasGameRef<RogalikGame> {
  SpriteComponent? background;
  UIComponent? uiComponent;
  World? currentWorld;

  Scene() : super();

  @override
  void onRemove() {
    this.uiComponent?.removeFromParent();
    super.onRemove();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    if (this.background == null) return;

    final imgWidth = this.background!.sprite!.image.width.toDouble();
    final imgHeight = this.background!.sprite!.image.height.toDouble();

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

  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed);
}
