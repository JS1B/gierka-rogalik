import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game/game/rogalik_game.dart';

class PlayerCurrencyComponent extends PositionComponent
    with HasGameRef<RogalikGame> {
  late final Map<String, dynamic> _config;
  late TextPainter _textPainter;
  SpriteComponent? coin;

  PlayerCurrencyComponent(this._config);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    this.coin =
        SpriteComponent(sprite: await this.gameRef.loadSprite('coin.png'));
    this.add(this.coin!);
    this.updateCoin();
    this._updateTextStyle();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    this.updateCoin();
    this._updateTextStyle();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    this._textPainter.paint(
        canvas,
        Offset(
            this._config['size'].x * this.gameRef.size.x +
                this._config['position'].x * this.gameRef.size.x,
            this.gameRef.size.y * (this._config['position'].y)));
  }

  void _updateTextStyle() {
    this._textPainter = TextPainter(
      text: TextSpan(
        text: "000000",
        style: TextStyle(
            shadows: [
              Shadow(offset: Offset(2, 2), color: Colors.black),
              Shadow(offset: Offset(-2, -2), color: Colors.black),
              Shadow(offset: Offset(2, -2), color: Colors.black),
              Shadow(offset: Offset(-2, 2), color: Colors.black),
            ],
            color: Colors.white,
            fontSize: this.gameRef.size.x * 0.025,
            fontFamily: 'InGameFont'),
      ),
      textDirection: TextDirection.ltr,
    );
    this._textPainter.layout();
  }

  void updateCoin() {
    this.coin?.size = Vector2(this._config['size'].x * this.gameRef.size.x,
        this._config['size'].y * this.gameRef.size.y);
    this.coin?.position = Vector2(
        this._config['position'].x * this.gameRef.size.x,
        this._config['position'].y * this.gameRef.size.y);
  }
}
