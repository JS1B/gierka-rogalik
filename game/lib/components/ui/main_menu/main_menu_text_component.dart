import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CustomTextComponent extends PositionComponent with HasGameRef<FlameGame> {
  late final Map<String, dynamic> config;
  late TextPainter _textPainter;
  final String text;

  CustomTextComponent(this.text, this.config) : super() {
    this.anchor = Anchor.center;
  }

  @override
  void onLoad() async {
    await super.onLoad();
    this.updateTextStyle();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    this._textPainter.paint(
        canvas,
        Offset((this.gameRef.size.x - this._textPainter.width) / 2,
            this.gameRef.size.y * this.config['y_offset']));
  }

  void updateTextStyle() {
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
            fontSize: this.gameRef.size.x * this.config['font_size'],
            fontFamily: 'MainFont'),
      ),
      textDirection: TextDirection.ltr,
    );
    this._textPainter.layout();
  }
}
