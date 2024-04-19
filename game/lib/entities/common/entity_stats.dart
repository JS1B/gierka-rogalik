class EntityStats {
  double maxSpeed;
  double turningSpeed;
  double deceleration;

  double health;
  double maxHealth;
  double regenRate;

  double armor;
  double armorPenetration;

  double attackRange;
  double attackPower;
  double attackCooldown;

  double critChance;
  double critMultiplier;

  EntityStats(
      this.maxSpeed,
      this.turningSpeed,
      this.deceleration,
      this.health,
      this.regenRate,
      this.maxHealth,
      this.armor,
      this.armorPenetration,
      this.attackRange,
      this.attackPower,
      this.attackCooldown,
      this.critChance,
      this.critMultiplier);

  // Add a factory constructor to create EnemyStats object from a map
  factory EntityStats.fromMap(Map<String, dynamic> map) {
    return EntityStats(
        map['maxSpeed'] ?? 0.0,
        map['turningSpeed'] ?? 0.0,
        map['deceleration'] ?? 0.0,
        map['health'] ?? 1,
        map['regenRate'] ?? 0,
        map['maxHealth'] ?? 1,
        map['armor'] ?? 0,
        map['armorPenetration'] ?? 0,
        map['attackRange'] ?? 1,
        map['attackPower'] ?? 1,
        map['attackCooldown'] ?? 1,
        map['critChance'] ?? 0.0,
        map['critMultiplier'] ?? 1.0);
  }
}
