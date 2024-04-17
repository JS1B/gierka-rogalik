import 'dart:ui';

import 'package:flame/components.dart';
import 'package:game/game/rogalik_game.dart';

class PlayerHealthbarComponent extends PositionComponent
    with HasGameRef<RogalikGame> {
  late final Map<String, dynamic> _config;
  SpriteComponent? healthbar;

  PlayerHealthbarComponent(this._config);

  @override
  void onLoad() async {
    super.onLoad();

    this.healthbar = SpriteComponent(
        sprite: await this.gameRef.loadSprite('player-healthbar.png'));
    this.add(this.healthbar!);
    updateHealthbarSize();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    updateHealthbarSize();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    double healthProportion = 1.0;
    try {
      healthProportion = this.gameRef.playerComponent.player.stats.health /
          this.gameRef.playerComponent.player.stats.maxHealth;
    } catch (e) {
      print(e);
    }

    final barX = (this._config['position'].x + 0.015) * this.gameRef.size.x;
    final barY = this._config['position'].y * this.gameRef.size.y;
    final barWidth = (this._config['size'].x - 0.015) * this.gameRef.size.x;
    final barHeight = this._config['size'].y * this.gameRef.size.y;

    final backgroundPaint = Paint()
      ..color = Color.fromARGB(255, 59, 55, 55)
      ..style = PaintingStyle.fill;

    final barPaint = Paint()
      ..color = Color.fromARGB(255, 175, 2, 2)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(barX, barY, barWidth, barHeight),
            Radius.circular(15)),
        backgroundPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(barX, barY, barWidth * healthProportion, barHeight),
            Radius.circular(15)),
        barPaint);
  }

  void updateHealthbarSize() {
    this.healthbar?.size = Vector2(this._config['size'].x * this.gameRef.size.x,
        this._config['size'].y * this.gameRef.size.y);
    this.healthbar?.position = Vector2(
        this._config['position'].x * this.gameRef.size.x,
        this._config['position'].y * this.gameRef.size.y);
  }
}
