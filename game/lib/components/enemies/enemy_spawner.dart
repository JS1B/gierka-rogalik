import 'package:flame/components.dart';

import 'package:game/entities/enemies/enemy_factory.dart';
import 'package:game/components/enemies/enemy_component.dart';
import 'package:game/game/rogalik_game.dart';

class EnemySpawner extends Component with HasGameRef<RogalikGame> {
  final EnemyType enemyType;
  final EnemyFactory enemyFactory = EnemyFactory();
  late final SpawnComponent spawnComponent;
  final int count;

  bool _isFinished = false;

  EnemySpawner(this.enemyType, {this.count = 0});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var img = await this
        .gameRef
        .images
        .load(this.gameRef.configLoader.getSpritePath(this.enemyType.name));

    var enemyStats = gameRef.configLoader.getEntityStats(this.enemyType.name);

    var enemy = EnemyFactory.createEnemy(this.enemyType, enemyStats);

    var enemyComponent = EnemyComponent(enemy: enemy, image: img);

    this.spawnComponent = SpawnComponent(
        factory: (_) {
          return enemyComponent;
        },
        period: 1);

    this.add(this.spawnComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (this.spawnComponent.amount >= this.count) {
      this.spawnComponent.timer.stop();
    }

    if (this.spawnComponent.amount >= this.count &&
        this.spawnComponent.parent?.children.isEmpty == true) {
      this._isFinished = true;
    }
  }

  bool get isFinished => this._isFinished;
}
