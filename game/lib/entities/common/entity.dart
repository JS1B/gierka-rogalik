import 'dart:math';
import 'package:flame/components.dart';

import 'package:game/entities/common/entity_stats.dart';

/// Base class for all entities in the game
/// Provides health regeneration
abstract class Entity {
  EntityStats stats;
  Vector2 position = Vector2.zero();

  Vector2 target_distance = Vector2.zero();

  Entity(EntityStats this.stats);

  /// Perform all the actions for the entity
  void update(double dt) {
    this.move(dt);
    this.regenerate(dt);
  }

  /// Move towards the target - implement this in the derived classes
  void move(double dt);

  /// Regenerate health
  void regenerate(double dt) {
    if (this.stats.health >= this.stats.maxHealth) return;

    var h = this.stats.health;
    this.stats.health =
        min(h + this.stats.regenRate * dt, this.stats.maxHealth);
  }

  void setTargetDistance(Vector2 distance) {
    this.target_distance = distance;
  }
}
