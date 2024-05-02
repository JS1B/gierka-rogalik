import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'package:game/components/enemies/enemy_component.dart';
import 'package:game/components/player/player_component.dart';
import 'package:game/components/ui/gameplay/background_component.dart';
import 'package:game/components/ui/gameplay/ui_component.dart';
import 'package:game/entities/enemies/enemy_factory.dart';
import 'package:game/scenes/in_game_pause.dart';
import 'package:game/scenes/scene.dart';

class FirstLevelScene extends Scene with HasCollisionDetection {
  late List<EnemyComponent> enemyComponents = [];
  late BackgroundComponent backgroundComponent;

  FirstLevelScene() : super();

  @override
  void onLoad() async {
    await super.onLoad();

    this.backgroundComponent = BackgroundComponent();
    this.gameRef.playerComponent = PlayerComponent();
    this.uiComponent = UIComponent()..priority = 1;

    this.currentWorld = await World(
        children: [this.backgroundComponent, this.gameRef.playerComponent]);

    this.gameRef.camera = CameraComponent(world: this.currentWorld);
    this.gameRef.camera.follow(this.gameRef.playerComponent);
    this.gameRef.camera.priority = 0;

    this.add(this.currentWorld!);
    await this.addEnemy(EnemyType.zombie, count: 6);
  }

  @override
  void onMount() {
    super.onMount();
    this.gameRef.add(this.uiComponent!);
  }

  @override
  void onKeyPress(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    Vector2 direction = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      direction.add(Vector2(0, -1));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      direction.add(Vector2(0, 1));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      direction.add(Vector2(-1, 0));
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      direction.add(Vector2(1, 0));
    }

    this.gameRef.playerComponent.setTargetDirection(direction.normalized());

    if (keysPressed.contains(LogicalKeyboardKey.keyK)) {
      this.addEnemy(EnemyType.zombie);
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyL)) {
      this.removeRandomEnemy();
    }

    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      this.gameRef.sceneManager.pushScene(InGamePauseScene());
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
  }

  Future<void> addEnemy(EnemyType type, {int count = 1}) async {
    var enemyStats = this.gameRef.configLoader.getEntityStats(type.name);

    var img = await this
        .gameRef
        .images
        .load(this.gameRef.configLoader.getSpritePath(type.name));

    for (var i = 0; i < count; i++) {
      var enemy = EnemyFactory.createEnemy(type, enemyStats);

      var enemyComponent = await EnemyComponent(enemy: enemy, image: img);
      this.enemyComponents.add(enemyComponent);
      this.currentWorld?.add(enemyComponent);
    }
  }

  void removeRandomEnemy() {
    if (this.enemyComponents.isEmpty) return;

    var enemyComponent = this.enemyComponents[0];
    this.currentWorld?.remove(enemyComponent);
    this.enemyComponents.remove(enemyComponent);
  }
}
