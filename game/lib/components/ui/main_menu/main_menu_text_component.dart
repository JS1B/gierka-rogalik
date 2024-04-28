import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CustomTextComponent extends PositionComponent with HasGameRef<FlameGame> {
  late final Map<String, dynamic> _config;
  late TextPainter _textPainter;
  final String text;

  CustomTextComponent(this.text, this._config) : super() {
    this.anchor = Anchor.center;
  }

  @override
  void onLoad() async {
    await super.onLoad();
    this._updateTextStyle();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    this._textPainter.layout();
    this._textPainter.paint(
        canvas,
        Offset((this.gameRef.size.x - this._textPainter.width) / 2,
            this.gameRef.size.y * this._config['y_offset']));
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    _updateTextStyle();
  }

  void _updateTextStyle() {
    this._textPainter = TextPainter(
      text: TextSpan(
        text: this.text,
        style: TextStyle(
            shadows: [
              Shadow(offset: Offset(5, 5), color: Colors.white),
              Shadow(offset: Offset(-5, -5), color: Colors.white),
              Shadow(offset: Offset(5, -5), color: Colors.white),
              Shadow(offset: Offset(-5, 5), color: Colors.white),
            ],
            color: Colors.black,
            fontSize: this.gameRef.size.x * this._config['font_size'],
            fontFamily: 'MainFont'),
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
