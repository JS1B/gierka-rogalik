class WeaponStats {
  double speed;

  double armorPenetration;

  double damage;
  double range;
  double firerate;

  double critChance;
  double critMultiplier;

  WeaponStats(
      {this.speed = 10,
      this.damage = 1,
      this.range = 32,
      this.armorPenetration = 0,
      this.firerate = 1,
      this.critChance = 0.0,
      this.critMultiplier = 2.0});

  // Add a factory constructor to create EnemyStats object from a map like YAML
  factory WeaponStats.fromMap(Map<String, dynamic> map) {
    return WeaponStats(
        speed: map['speed'] ?? 100,
        armorPenetration: map['armorPenetration'] ?? 0,
        range: map['range'] ?? 32,
        damage: map['damage'] ?? 1,
        firerate: map['firerate'] ?? 1,
        critChance: map['critChance'] ?? 0.0,
        critMultiplier: map['critMultiplier'] ?? 2.0);
  }
}