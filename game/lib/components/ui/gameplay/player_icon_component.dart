import 'dart:ui';

import 'package:flame/components.dart';
import 'package:game/game/rogalik_game.dart';

class PlayerIconComponent extends PositionComponent
    with HasGameRef<RogalikGame> {
  late final Map<String, dynamic> _config;
  SpriteComponent? icon;

  PlayerIconComponent(this._config);

  @override
  void onLoad() async {
    super.onLoad();

    this.icon = SpriteComponent(
        sprite: await this.gameRef.loadSprite('player-frame.png'));
    this.add(this.icon!);
    this.updateIcon();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    this.updateIcon();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final barX = (this._config['position'].x + 0.015) * this.gameRef.size.x;
    final barY = (this._config['position'].y + 0.0275) * this.gameRef.size.y;
    final barWidth = (this._config['size'].x - 0.025) * this.gameRef.size.x;
    final barHeight = (this._config['size'].y - 0.065) * this.gameRef.size.y;

    final backgroundPaint = Paint()
      ..color = Color.fromARGB(255, 59, 55, 55)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(barX, barY, barWidth, barHeight),
            Radius.circular(25)),
        backgroundPaint);
  }

  void updateIcon() {
    this.icon?.size = Vector2(this._config['size'].x * this.gameRef.size.x,
        this._config['size'].y * this.gameRef.size.y);
    this.icon?.position = Vector2(
        this._config['position'].x * this.gameRef.size.x,
        this._config['position'].y * this.gameRef.size.y);
  }
}
