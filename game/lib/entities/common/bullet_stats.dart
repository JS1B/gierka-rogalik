class BulletStats {
  double velocity;
  double lifetime;
  double radius;

  BulletStats(
      {this.velocity = 10,
      this.lifetime = 1,
      this.radius = 2.0});

  // Add a factory constructor to create EnemyStats object from a map like YAML
  factory BulletStats.fromMap(Map<String, dynamic> map) {
    return BulletStats(
        velocity: map['velocity'] ?? 100,
        lifetime: map['damage'] ?? 1,
        radius: map['radius'] ?? 2.0);
  }
}