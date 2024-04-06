import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CustomTextComponent extends PositionComponent {
  late final Map<String, dynamic> config;
  late TextPainter _textPainter;
  final String text;
  FlameGame gameRef;

  CustomTextComponent(this.text, this.gameRef, this.config) {
    this.setTextStyle();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    this._textPainter.layout();
    this._textPainter.paint(
        canvas,
        Offset((gameRef.size.x - this._textPainter.width) / 2,
            gameRef.size.y * config['y_offset']));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void setTextStyle() {
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
            fontSize: gameRef.size.x * config['font_size'],
            fontFamily: 'MainFont'),
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
