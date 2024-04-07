import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CustomButtonComponent extends PositionComponent
    with TapCallbacks, HoverCallbacks {
  final Map<String, dynamic> _config;
  final String text;
  final Function onTapFunction;
  final FlameGame _gameRef;
  late TextPainter _buttonPainter;
  double _textScaleModifier = 0.0;

  CustomButtonComponent(
      this.text, this._gameRef, this._config, this.onTapFunction) {
    this.anchor = Anchor.center;
    this._updateTextStyle();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    this._buttonPainter.layout();
    this._buttonPainter.paint(canvas, Vector2.zero().toOffset());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    this._updateTextStyle();
  }

  @override
  void onTapUp(TapUpEvent event) {
    this._textScaleModifier = 0.0;
    this._updateTextStyle();
    this.onTapFunction();
  }

  @override
  void onTapDown(TapDownEvent event) {
    this._textScaleModifier = -0.005;
    this._updateTextStyle();
  }

  @override
  void onHoverEnter() {
    this._textScaleModifier = 0.005;
    this._updateTextStyle();
  }

  @override
  void onHoverExit() {
    this._textScaleModifier = 0.0;
    this._updateTextStyle();
  }

  void _updateTextStyle() {
    this._buttonPainter = TextPainter(
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
          fontSize: this._gameRef.size.length *
              (this._config['font_size'] + this._textScaleModifier),
          fontFamily: 'MainFont',
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    this._buttonPainter.layout();
    this.size = Vector2(this._buttonPainter.width, this._buttonPainter.height);
    this.position = Vector2(this._gameRef.size.x / 2,
        this._gameRef.size.y * this._config['y_offset']);
  }
}
