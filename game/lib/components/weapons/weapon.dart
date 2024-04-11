import 'package:game/components/common/bullet_stats.dart';
import 'package:game/components/common/weapon_stats.dart';
import 'package:game/components/weapons/bullets/bullet_component.dart';
import 'package:flame/components.dart';
class Weapon { 
  late WeaponStats stats;
  late BulletStats bulletStats;
  Weapon(this.bulletStats);
  double distanceFromPlayer = 5;
  List<BulletComponent> bullets = [];
  double lastBulletTime = 0;
  double currentTime = 0;
  double? weaponDirection;


  BulletComponent shoot(Vector2 playerPositon, double weaponDirection) {
      final bullet = BulletComponent(bulletStats);
      bullets.add(bullet);
      return bullet;
  }

}