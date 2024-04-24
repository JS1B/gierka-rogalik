import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import 'package:game/game/rogalik_game.dart';
import 'package:game/entities/enemies/enemy.dart';
import 'package:game/components/ui/healthbar_component.dart';
import 'package:game/components/player/player_component.dart';

class EnemyComponent extends ShapeComponent
    with HasGameRef<RogalikGame>, CollisionCallbacks {
  late Enemy enemy;
  late TextPainter nameTextPainter;
  late HealthBarComponent healthBarComponent;

  late Image image;
  late SpriteAnimationGroupComponent animations;

  EnemyComponent({required Enemy enemy, required Image image})
      : this.enemy = enemy,
        super(
            anchor: Anchor.center, size: enemy.size, position: enemy.position) {
    this.image = image;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var spriteSheet = SpriteSheet(
      image: this.image,
      srcSize: this.size,
    );
    var _walkingAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData([
        spriteSheet.createFrameDataFromId(0, stepTime: 0.2),
        spriteSheet.createFrameDataFromId(1, stepTime: 0.2),
        spriteSheet.createFrameDataFromId(2, stepTime: 0.2),
        spriteSheet.createFrameDataFromId(3, stepTime: 0.2),
        spriteSheet.createFrameDataFromId(4, stepTime: 0.2),
        spriteSheet.createFrameDataFromId(5, stepTime: 0.2),
      ], loop: true),
    );

    var _attackAnimation = this.createDummyAnimation(this.size);

    this.animations = SpriteAnimationGroupComponent<EnemyState>(
      animations: {
        EnemyState.moving: _walkingAnimation,
        EnemyState.attacking: _attackAnimation,
      },
      current: this.enemy.state,
    );

    this.animations.animationTickers?[EnemyState.attacking]?.onComplete = () {
      this.gameRef.playerComponent.player.getHit(this.enemy.stats);

      this.enemy.resetAttack();
    };
    this.add(this.animations);

    var healthBarConfig = this
        .gameRef
        .configLoader
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
    this.add(this.healthBarComponent);

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

    final hitbox = CircleHitbox.relative(
      0.9,
      position: this.size.scaled(0.5),
      parentSize: this.size,
      anchor: Anchor.center,
      isSolid: true,
    );
    this.add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.enemy.setTargetDistance(
        this.gameRef.playerComponent.player.position - this.enemy.position);
    this.enemy.update(dt);
    this.animations.current = this.enemy.state;

    if (this.enemy.stats.health <= 0) {
      this.removeFromParent();
    }

    this.healthBarComponent.updateHealth(this.enemy.stats.health.toInt());

    // Update the position of the component
    this.position = this.enemy.position;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render enemy name
    this.renderName(canvas);
  }

  void renderName(Canvas canvas) {
    this.nameTextPainter.paint(
        canvas, Offset((this.width - this.nameTextPainter.width) / 2, 0));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    Vector2 pushBackVector = (this.position - other.position).normalized();
    if (other is PlayerComponent) {
      this.enemy.attack();
      this.enemy.addPushBack(pushBackVector);
    } else if (other is EnemyComponent) {
      this.enemy.addPushBack(pushBackVector.scaled(1.2));
    }
  }

  // #TODO Replace those methods with actual animations
  SpriteAnimation createDummyAnimation(Vector2 size) {
    List<Sprite> sprites = [
      createDummySprite(Colors.red.shade100, size),
      createDummySprite(Colors.red.shade300, size),
      createDummySprite(Colors.red.shade500, size),
      createDummySprite(Colors.red.shade600, size),
      createDummySprite(Colors.red.shade800, size),
    ];
    return SpriteAnimation.spriteList(sprites,
        stepTime: this.enemy.stats.attackCooldown / (sprites.length + 1),
        loop: false);
  }

  Sprite createDummySprite(Color color, Vector2 size) {
    Paint paint = Paint()..color = color;
    final recorder = PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(Offset.zero, size.toOffset()));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    final picture = recorder.endRecording();
    final image = picture.toImageSync(size.x.toInt(), size.y.toInt());
    return Sprite(image);
  }
}
