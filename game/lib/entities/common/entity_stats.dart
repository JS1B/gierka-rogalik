class EntityStats {
  double maxAcceleration;
  double maxSpeed;
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

  double mass;

  EntityStats(
    this.maxAcceleration,
    this.maxSpeed,
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
    this.critMultiplier,
    this.mass,
  );

  // Add a factory constructor to create EnemyStats object from a map
  factory EntityStats.fromMap(Map<String, dynamic> map) {
    return EntityStats(
      map['maxAcceleration'] ?? 0.0,
      map['maxSpeed'] ?? 0.0,
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
      map['critMultiplier'] ?? 1.0,
      map['mass'] ?? 1.0,
    );
  }

  // Add a method to convert the object to a JSON
  Map<String, dynamic> toJson() {
    return {
      'maxAcceleration': this.maxAcceleration,
      'maxSpeed': this.maxSpeed,
      'deceleration': this.deceleration,
      'health': this.health,
      'regenRate': this.regenRate,
      'maxHealth': this.maxHealth,
      'armor': this.armor,
      'armorPenetration': this.armorPenetration,
      'attackRange': this.attackRange,
      'attackPower': this.attackPower,
      'attackCooldown': this.attackCooldown,
      'critChance': this.critChance,
      'critMultiplier': this.critMultiplier,
      'mass': this.mass,
    };
  }
}
