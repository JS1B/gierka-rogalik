import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CustomButtonComponent extends PositionComponent
    with TapCallbacks, HoverCallbacks {
  late final Map<String, dynamic> config;
  late final String text;
  late TextPainter buttonPainter;
  late double textScaleModifier = 0.0;
  late final Function onTapFunction;
  FlameGame gameRef;

  CustomButtonComponent(
      this.text, this.gameRef, this.config, this.onTapFunction) {
    setTextStyle();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    buttonPainter.layout();
    buttonPainter.paint(canvas, Vector2.zero().toOffset());
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onTapUp(TapUpEvent event) {
    textScaleModifier = 0;
    onTapFunction();
    setTextStyle();
  }

  @override
  void onTapDown(TapDownEvent event) {
    textScaleModifier = -0.005;
    setTextStyle();
  }

  @override
  void onHoverEnter() {
    textScaleModifier = 0.005;
    setTextStyle();
  }

  @override
  void onHoverExit() {
    textScaleModifier = 0;
    setTextStyle();
  }

  void setTextStyle() {
    buttonPainter = TextPainter(
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
          fontSize: gameRef.size.x * (config['font_size'] + textScaleModifier),
          fontFamily: 'MainFont',
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    buttonPainter.layout();
    size = Vector2(buttonPainter.width, buttonPainter.height);
    anchor = Anchor.center;
    position = Vector2(gameRef.size.x / 2, gameRef.size.y * config['y_offset']);
  }
}
