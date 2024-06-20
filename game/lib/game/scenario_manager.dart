import 'dart:ui';

import 'package:flame/components.dart';

import 'package:game/components/enemies/enemy_spawner.dart';
import 'package:game/entities/enemies/enemy_factory.dart';

class ScenarioManager extends Component with HasGameRef {
  List<Level> levels = [];
  int _currentLevelIndex = 0;

  ScenarioManager();

  @override
  void update(double dt) {
    super.update(dt);
    if (this._currentLevelIndex >= this.levels.length) return;

    if (this.currentLevel.isFinished) {
      this.nextLevel();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (this._currentLevelIndex >= this.levels.length) return;
  }

  void addLevel(Level level) {
    this.levels.add(level);
    if (this.levels.length == 1) {
      this.add(level);
    }
  }

  void nextLevel() {
    if (this._currentLevelIndex < this.levels.length - 1) {
      this.remove(this.currentLevel);
      this._currentLevelIndex++;
      this.add(this.currentLevel);
    } else {
      // Loop levels
      this.remove(this.currentLevel);
      this._currentLevelIndex = 0;
      this.add(this.currentLevel);
    }
  }

  Level get currentLevel => this.levels[this._currentLevelIndex];
}

class Level extends Component {
  List<Wave> waves = [];
  int _currentWaveIndex = 0;
  double waveDelay = 10.0; // Delay between waves in seconds
  double currentDelay = 0;

  Level();

  @override
  void update(double dt) {
    super.update(dt);
    if (this._currentWaveIndex >= this.waves.length) return;

    if (this.currentWave.isFinished) {
      this.currentDelay += dt;
      if (this.currentDelay >= this.waveDelay) {
        this.nextWave();
        this.currentDelay = 0;
      }
    } else {
      this.currentWave.update(dt);
    }
  }

  void addWave(Wave wave) {
    this.waves.add(wave);
    if (this.waves.length == 1) {
      this.add(this.currentWave);
    }
  }

  void addWaves(List<Wave> waves) {
    bool shouldInit = this.waves.isEmpty;

    this.waves.addAll(waves);
    if (shouldInit) {
      this.add(this.currentWave);
    }
  }

  void nextWave() {
    if (this._currentWaveIndex < this.waves.length - 1) {
      this.remove(this.currentWave);
      this._currentWaveIndex++;
      this.add(this.currentWave);
    } else {
      // Finish waves
      this.remove(this.currentWave);
    }
  }

  Wave get currentWave => this.waves[this._currentWaveIndex];

  bool get isFinished => this.waves.every((wave) => wave.isFinished);
}

class Wave extends Component {
  final List<EnemySpawner> enemySpawners;

  Wave(this.enemySpawners);

  @override
  void onLoad() {
    super.onLoad();
    this.addAll(this.enemySpawners);
  }

  bool get isFinished =>
      this.enemySpawners.every((spawner) => spawner.isFinished);
}

// Configuration of sample waves
class EasyWave extends Wave {
  EasyWave()
      : super([
          EnemySpawner(EnemyType.zombie, count: 10),
          EnemySpawner(EnemyType.goblin, count: 4),
          EnemySpawner(EnemyType.robot, count: 1)
        ]);
}

class MediumWave extends Wave {
  MediumWave()
      : super([
          EnemySpawner(EnemyType.zombie, count: 30),
          EnemySpawner(EnemyType.goblin, count: 20),
          EnemySpawner(EnemyType.robot, count: 2)
        ]);
}

class HardWave extends Wave {
  HardWave()
      : super([
          EnemySpawner(EnemyType.zombie, count: 10),
          EnemySpawner(EnemyType.goblin, count: 4),
          EnemySpawner(EnemyType.robot, count: 1)
        ]);
}

class BossWave extends Wave {
  BossWave()
      : super([
          EnemySpawner(EnemyType.robot, count: 1),
        ]);
}
