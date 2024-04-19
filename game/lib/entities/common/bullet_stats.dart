class BulletStats {
  double velocity;
  double lifetime;
  double width;
  double height;

  BulletStats(
      {this.velocity = 10,
      this.lifetime = 1,
      this.width = 2.0,
      this.height = 2.0});

  BulletStats copy() {
    return BulletStats(
      velocity: this.velocity,
      lifetime: this.lifetime,
      width: this.width,
      height: this.height,
    );
  }

  // Add a factory constructor to create EnemyStats object from a map like YAML
  factory BulletStats.fromMap(Map<String, dynamic> map) {
    return BulletStats(
        velocity: map['speed'] ?? 5,
        lifetime: map['lifetime'] ?? 1,
        width: map['width'] ?? 2.0,
        height: map['height'] ?? 2.0);
  }
}
