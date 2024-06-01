import 'dart:async' as dart_async;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game/game/rogalik_game.dart';

class CustomPopupComponent extends PositionComponent
    with TapCallbacks, HasGameRef<RogalikGame> {
  final Map<String, dynamic> _config;
  late TextPainter _textPainter;
  late Paint _backgroundPaint;
  late Paint _strokePaint;
  late dart_async.Timer _fadeTimer;
  Rect _displayRect = Rect.zero;
  Offset _textOffset = Offset.zero;
  double _opacity = 1.0;

  CustomPopupComponent(this._config)
      : this._backgroundPaint = Paint()..color = Colors.black,
        this._strokePaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    this._fadeTimer =
        dart_async.Timer.periodic(Duration(milliseconds: 25), (t) {
      this._opacity -= this._config['opacity_decay'];
      if (this._opacity <= 0) {
        this.removeFromParent();
      }
    });
  }

  @override
  void onRemove() {
    this._fadeTimer.cancel();
    super.onRemove();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    this._backgroundPaint.color = Colors.black.withOpacity(this._opacity);
    this._strokePaint.color = Colors.white.withOpacity(this._opacity);

    this._textPainter = TextPainter(
      text: TextSpan(
        text: this._config['text'],
        style: TextStyle(
          color: Colors.white.withOpacity(this._opacity),
          fontSize: this.gameRef.size.x * this._config['font_size'],
          fontFamily: 'MonoSpacePixel',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    this._textPainter.layout(maxWidth: this.size.x);

    this._textOffset = Offset(
      this._displayRect.left +
          (this._displayRect.width - this._textPainter.width) / 2,
      this._displayRect.top +
          (this._displayRect.height - this._textPainter.height) / 2,
    );

    final rrect =
        RRect.fromRectAndRadius(this._displayRect, Radius.circular(7));
    canvas.drawRRect(rrect, this._backgroundPaint);
    canvas.drawRRect(rrect, this._strokePaint);
    this._textPainter.paint(canvas, this._textOffset);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    this._updateStyle();
  }

  void _updateStyle() {
    this.position =
        Vector2(this.gameRef.size.x * 0.775, this.gameRef.size.y * 0.025);
    this.size =
        Vector2(this.gameRef.size.x * 0.215, this.gameRef.size.y * 0.125);
    this._displayRect = Rect.fromLTWH(0, 0, this.size.x, this.size.y);
  }
}
