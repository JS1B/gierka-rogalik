import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealthBarComponent extends PositionComponent {
  late int health = 0;
  late int maxHealth;
  late bool enableNumericDisplay;

  final double y0;
  final double width;
  final double height;
  final double padding;

  final Paint backgroundColor;
  final Paint fillColor;

  HealthBarComponent(this.maxHealth, this.width, this.height, this.y0,
      {this.enableNumericDisplay = false,
      this.padding = 2.0,
      Color backgroundColor = const Color(0xFF000000), // Default black
      Color fillColor = const Color(0xFF00FF00)} // Default green
      )
      : this.backgroundColor = Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill,
        this.fillColor = Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  void updateHealth(int health) {
    this.health = health;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final double barFillWidth = this.width * (this.health / this.maxHealth);

    canvas.drawRect(
      Rect.fromLTWH(0, this.y0 + this.padding, this.width, this.height),
      this.backgroundColor,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, this.y0 + this.padding, barFillWidth, this.height),
      this.fillColor,
    );

    if (!this.enableNumericDisplay) return;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${this.health} / ${this.maxHealth}',
        style: TextStyle(
          color: Colors.white,
          fontSize: this.height - 1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((this.width - textPainter.width) / 2, this.y0 + this.padding),
    );
  }
}
