import 'package:flame/components.dart';
import 'package:game/rogalik_game.dart';
import 'player_component.dart'; // Import the PlayerComponent file
import 'bullet_component.dart'; // Import the BulletComponent file
import 'dart:math' as math;

class Weapon extends SpriteComponent with HasGameRef<RogalikGame> {
  Player? player; 
  double distanceFromPlayer = 5; 
  List<Bullet> bullets = [];
  double lastBulletTime = 0; 
  double currentTime = 0;
  double? weaponDirection; 

  void shoot() {
      if (weaponDirection != null ) {
        final bullet = Bullet();
        bullet.position = position.clone(); 
        bullet.velocity = 1000;
        bullet.lifetime = 1000;
        bullet.angle = weaponDirection!; 
        bullets.add(bullet);
        gameRef.add(bullet);
        print("Shooting" );
        print(player!.position);
        print(position);
        print(weaponDirection);
        }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final bullet in bullets) {
      bullet.update(dt);
    }

    bullets.removeWhere((bullet) => bullet.lifetime <= 0);
    currentTime += dt; // Convert 
    if(currentTime - lastBulletTime > 1){
      lastBulletTime = currentTime;
      shoot();
    }
  }
  @override
  Future<void> onLoad() async {
    print("Loading weapon sprite");
    sprite = await gameRef.loadSprite('weapon-sprite.png');
  }

  void updateWeaponPosition(Vector2 mousePosition) {
    if (player != null) {
    final Vector2 direction = mousePosition - player!.position;
    direction.normalize();
    position = player!.position + direction * distanceFromPlayer;
    weaponDirection = math.atan2(direction.y, direction.x);
  }
  }
}
  