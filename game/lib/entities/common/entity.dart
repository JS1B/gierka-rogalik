import 'dart:math';

import 'package:flame/components.dart';

import 'package:game/entities/common/entity_stats.dart';

/// Base class for all entities in the game
/// Provides health regeneration
abstract class Entity {
  EntityStats stats;
  Vector2 position;
  Vector2 velocity = Vector2.zero();
  Vector2 acceleration = Vector2.zero();

  Vector2 size;

  Vector2 target_distance = Vector2.zero();

  Entity(this.stats, this.size, {Vector2? position})
      : this.position = position ?? Vector2.zero();

  /// Perform all the actions for the entity
  void update(double dt) {
    this.move(dt);
    this.regenerate(dt);
  }

  /// Move towards the target
  void move(double dt) {
    // Calculate the ideal acceleration towards the target
    this.calculateAcceleration(dt);

    // Apply drag to reduce the velocity
    Vector2 drag = this.velocity.normalized() * this.stats.deceleration * dt;
    Vector2 reducedVelocity = this.velocity - drag;
    if (reducedVelocity.dot(this.velocity) < 0) {
      // Ensures that drag does not reverse the direction of the velocity
      reducedVelocity = Vector2.zero();
    }

    // Adjust the velocity according to the new acceleration
    this.velocity = reducedVelocity;
    this.velocity += this.acceleration.scaled(dt);

    // Ensure the velocity does not exceed max speed and snap to zero
    if (this.velocity.length < 0.1) {
      this.velocity = Vector2.zero();
    } else if (this.stats.maxSpeed > 0) {
      this.velocity.clampLength(0, this.stats.maxSpeed);
    }

    // Update position
    this.position += this.velocity.scaled(dt);
  }

  /// Regenerate health
  void regenerate(double dt) {
    if (this.stats.health >= this.stats.maxHealth) return;

    var h = this.stats.health;
    this.stats.health =
        min(h + this.stats.regenRate * dt, this.stats.maxHealth);
  }

  /// Calculate the acceleration based the needs of the entity
  void calculateAcceleration(double dt) {}

  void getHit(EntityStats stats) {
    // Calculate the damage based on the attack power, critical chance and armor
    // #TODO
    this.stats.health =
        max(this.stats.health - (stats.attackPower - this.stats.armor), 0.0);
  }

  void setTargetDistance(Vector2 distance) {
    this.target_distance = distance.clone();
  }

  void addPushBack(Vector2 pushback) {
    final double intensity = 30;
    this.velocity.add(pushback.scaled(intensity / this.stats.mass));
  }
}
