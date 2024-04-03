import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:game/config/game_config.dart';
import 'package:game/rogalik_game.dart';
import 'package:game/components/enemies/enemy.dart';
import 'package:game/components/common/healthbar_component.dart';

class EnemyComponent extends SpriteComponent with HasGameRef<RogalikGame> {
  late Enemy enemy;
  late TextPainter nameTextPainter;
  late HealthBarComponent healthBarComponent;

  EnemyComponent(Enemy enemy)
      : this.enemy = enemy,
        super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    GameConfigLoader configLoader = GameConfigLoader();
    await configLoader.load('assets/config.yaml');
    this.sprite = await gameRef.loadSprite(configLoader
        .getSpritePath(this.enemy.runtimeType.toString().toLowerCase()));

    var healthBarConfig = configLoader
        .getHealthBarConfig(this.enemy.runtimeType.toString().toLowerCase());
    this.healthBarComponent = HealthBarComponent(
        this.enemy.stats.maxHealth.toInt(),
        this.width,
        healthBarConfig['height'],
        this.height,
        enableNumericDisplay: healthBarConfig['enableNumericDisplay'],
        padding: healthBarConfig['padding'],
        backgroundColor: Color(healthBarConfig['backgroundColor']),
        fillColor: Color(healthBarConfig['fillColor']));
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.enemy.update(dt, gameRef.playerComponent.player.position);

    this.healthBarComponent.updateHealth(this.enemy.stats.health.toInt());

    // Update the position of the component
    this.position = this.enemy.position;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render enemy name
    this.renderName(canvas);

    // Render the health bar
    this.healthBarComponent.render(canvas);
  }

  void renderName(Canvas canvas) {
    this.nameTextPainter = TextPainter(
      text: TextSpan(
        text: this.enemy.runtimeType.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    this.nameTextPainter.layout();
    this.nameTextPainter.paint(
        canvas, Offset((this.width - this.nameTextPainter.width) / 2, 0));
  }
}
