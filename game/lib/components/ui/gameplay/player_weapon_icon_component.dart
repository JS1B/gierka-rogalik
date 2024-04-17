import 'dart:ui';

import 'package:flame/components.dart';
import 'package:game/game/rogalik_game.dart';

class PlayerWeaponIconComponent extends PositionComponent
    with HasGameRef<RogalikGame> {
  late final Map<String, dynamic> _config;

  PlayerWeaponIconComponent(this._config);

  @override
  void onLoad() {
    super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final barX = this._config['position'].x * this.gameRef.size.x;
    final barY = this._config['position'].y * this.gameRef.size.y;
    final barWidth = this._config['size'].x * this.gameRef.size.x;
    final barHeight = this._config['size'].y * this.gameRef.size.y;

    final barPaint = Paint()
      ..color = Color(0xFF00FF00)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(barX, barY, barWidth, barHeight), barPaint);
  }
}
