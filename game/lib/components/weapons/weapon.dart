import 'package:game/components/weapons/bullets/bullet_component.dart';
import 'package:flame/components.dart';
import 'package:game/entities/common/bullet_stats.dart';
import 'package:game/entities/common/weapon_stats.dart';
class Weapon { 
  late WeaponStats stats;
  late BulletStats bulletStats;
  Weapon(this.bulletStats);
  double distanceFromPlayer = 5;
  List<BulletComponent> bullets = [];
  double lastBulletTime = 0;
  double currentTime = 0;
  double? weaponDirection;

  void shoot(Vector2 playerPositon, double weaponDirection) {
      final bullet = BulletComponent(bulletStats);
      bullet.position = playerPositon;
      bullet.angle = weaponDirection;
      bullets.add(bullet);
  }

}