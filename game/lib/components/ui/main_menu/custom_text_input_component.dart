import 'dart:async' as dart_async;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/game/rogalik_game.dart';

class CustomTextInputComponent extends PositionComponent
    with TapCallbacks, HasGameRef<RogalikGame> {
  late final Map<String, dynamic> _config;
  final Paint _cursorPaint;
  final Paint _strokePaint;
  late Paint _backgroundPaint;
  late TextPainter _textPainter;
  late dart_async.Timer _cursorTimer;
  String _text = "";
  int _cursorPos = 0;
  bool _cursorVisible = true;
  bool _isFocused = false;
  Rect _inputRect = Rect.zero;
  Offset _textOffset = Offset.zero;

  CustomTextInputComponent(this._config)
      : this._cursorPaint = Paint()..color = Colors.white,
        this._backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5),
        this._strokePaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 {}

  get text => this._text;
  get label => this._config['label'];
  get isFocused => this._isFocused;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    this._cursorTimer = dart_async.Timer.periodic(Duration(milliseconds: 500),
        (dart_async.Timer t) {
      this._cursorVisible = !this._cursorVisible;
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    String temp_text = this._text;
    Color temp_color = Colors.white;

    if (this._text.isEmpty) {
      temp_text = this._config['initial'];
      temp_color = Colors.grey;
    } else if (this._config['label'].contains('password')) {
      temp_text = '*' * this._text.length;
    }

    if (!this.checkRegex()) {
      this._backgroundPaint = Paint()..color = Colors.red.withOpacity(0.5);
    } else {
      this._backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);
    }

    this._textPainter = TextPainter(
        text: TextSpan(
          text: temp_text,
          style: TextStyle(
              color: temp_color,
              fontSize: this.gameRef.size.x * this._config['font_size'],
              fontFamily: 'MonoSpacePixel'),
        ),
        textDirection: TextDirection.ltr);
    this._textPainter.layout();

    this._textOffset = Offset(
      this._inputRect.left + 0.01 * this._inputRect.width,
      this._inputRect.top + 0.15 * this._inputRect.height,
    );

    canvas.drawRRect(
        RRect.fromRectAndRadius(this._inputRect, Radius.circular(7)),
        this._backgroundPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(this._inputRect, Radius.circular(7)),
        this._strokePaint);
    this._textPainter.paint(canvas, this._textOffset);

    if (this._isFocused && this._cursorVisible) {
      double cursorX = this._textOffset.dx;
      if (this._cursorPos != 0) {
        cursorX = this._textOffset.dx +
            this._cursorPos * (this._textPainter.width / this._text.length);
      }
      canvas.drawLine(
        Offset(cursorX, this._textOffset.dy),
        Offset(cursorX, this._textOffset.dy + this._inputRect.height * 0.7),
        this._cursorPaint,
      );
    }
  }

  @override
  void onRemove() {
    this._cursorTimer.cancel();
    super.onRemove();
  }

  bool onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (!this._isFocused) return false;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          this._cursorPos < this._text.length) {
        this._cursorPos++;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          this._cursorPos > 0) {
        this._cursorPos--;
      } else if (event.logicalKey == LogicalKeyboardKey.backspace &&
          this._cursorPos > 0) {
        this._text = this._text.substring(0, this._cursorPos - 1) +
            this._text.substring(this._cursorPos);
        this._cursorPos--;
      } else if (event.character != null &&
          event.logicalKey.keyId != LogicalKeyboardKey.backspace.keyId &&
          event.character!.trim().isNotEmpty &&
          this._text.length < 46) {
        this._text = this._text.substring(0, this._cursorPos) +
            event.character! +
            this._text.substring(this._cursorPos);
        this._cursorPos++;
      }
    }

    return true;
  }

  @override
  void onTapDown(TapDownEvent event) {
    this.gameRef.sceneManager.scenePushPop.last.signal({
      'type': 'focus',
    });
    this.focus();

    if (this._text.isNotEmpty) {
      if (event.localPosition.x >
          this._textOffset.dx + this._textPainter.width) {
        this._cursorPos = this._text.length;
      } else {
        this._cursorPos = (event.localPosition.x /
                (this._textPainter.width / this._text.length))
            .floor();
      }
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    this._updateTextStyle();
  }

  void _updateTextStyle() {
    this.position = Vector2(this.gameRef.size.x / 2 - this.gameRef.size.x / 4,
        this.gameRef.size.y * this._config['y_offset']);
    this.size = Vector2(this.gameRef.size.x / 2, this.gameRef.size.y * 0.06);
    this._inputRect = Rect.fromLTWH(0, 0, this.size.x, this.size.y);
  }

  bool checkRegex() {
    if (!this._config.keys.contains('regex')) {
      return true;
    }

    return this._config['regex'].hasMatch(this._text);
  }

  void focus() {
    this._isFocused = true;
    this._cursorVisible = true;
  }

  void unFocus() {
    this._isFocused = false;
    this._cursorVisible = false;
  }
}
