class EntityStats {
  double speed = 0;

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
  double attackSpeed;

  double critChance;
  double critMultiplier;

  EntityStats(
      {this.maxSpeed = 100,
      this.turningSpeed = 5.0,
      this.deceleration = 0.0,
      this.health = 1,
      this.regenRate = 0,
      this.maxHealth = 1,
      this.armor = 0,
      this.armorPenetration = 0,
      this.attackRange = 32,
      this.attackPower = 1,
      this.attackSpeed = 1,
      this.critChance = 0.0,
      this.critMultiplier = 2.0});

  // Add a factory constructor to create EnemyStats object from a map like YAML
  factory EntityStats.fromMap(Map<String, dynamic> map) {
    return EntityStats(
        maxSpeed: map['maxSpeed'] ?? 100,
        turningSpeed: map['turningSpeed'] ?? 5,
        deceleration: map['deceleration'] ?? 0,
        health: map['health'] ?? 1,
        regenRate: map['regenRate'] ?? 0,
        maxHealth: map['maxHealth'] ?? 1,
        armor: map['armor'] ?? 0,
        armorPenetration: map['armorPenetration'] ?? 0,
        attackRange: map['attackRange'] ?? 32,
        attackPower: map['attackPower'] ?? 1,
        attackSpeed: map['attackSpeed'] ?? 1,
        critChance: map['critChance'] ?? 0.0,
        critMultiplier: map['critMultiplier'] ?? 2.0);
  }
}
