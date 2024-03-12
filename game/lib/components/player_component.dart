import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:game/rogalik_game.dart';

import 'package:yaml/yaml.dart';

class Player extends SpriteComponent with HasGameRef<RogalikGame> {
  Vector2 _targetDirection = Vector2.zero();
  Vector2 _currentDirection = Vector2.zero();

  late double speed;
  late double turningSpeed;
  late double deceleration;

  Player() : super(size: Vector2(50, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Load sprite
    sprite = await gameRef.loadSprite('player-sprite.png');
    position = gameRef.size / 2;

    // Load parameters from config file
    await loadConfig();
  }

  Future<void> loadConfig() async {
    String configFile = await rootBundle.loadString('assets/config.yaml');
    var config = loadYaml(configFile)['player'];

    speed = config['speed'];
    turningSpeed = config['turningSpeed'];
    deceleration = config['deceleration'];
  }

  @override
  void update(double dt) {
    super.update(dt);

    bool isMoving = _targetDirection.length2 > 0;
    if (isMoving) {
      _currentDirection.lerp(_targetDirection, turningSpeed * dt);
    } else {
      if (_currentDirection.length2 > 0) {
        _currentDirection.scale((1 - deceleration).clamp(0.0, 1.0));
      }
    }

    if (_currentDirection.length2 > 1) {
      _currentDirection.normalize();
    }

    Vector2 velocity = _currentDirection * speed * dt;
    position.add(velocity);
  }

  void setTargetDirection(Vector2 direction) {
    _targetDirection = direction;
  }
}
