import 'package:flame/components.dart';

import 'package:game/components/ui/gameplay/player_weapon_icon_component.dart';
import 'package:game/components/ui/gameplay/player_ammunition_component.dart';
import 'package:game/components/ui/gameplay/player_healthbar_component.dart';
import 'package:game/components/ui/gameplay/player_currency_component.dart';
import 'package:game/components/ui/gameplay/player_icon_component.dart';
import 'package:game/game/rogalik_game.dart';

class UIComponent extends Component with HasGameRef<RogalikGame> {
  late PlayerWeaponIconComponent playerWeaponIconComponent;
  late PlayerAmmunitionComponent playerAmmunitionComponent;
  late PlayerHealthbarComponent playerHealthbarComponent;
  late PlayerCurrencyComponent playerCurrencyComponent;
  late PlayerIconComponent playerIconComponent;

  @override
  void onLoad() {
    this.playerHealthbarComponent = PlayerHealthbarComponent(
        {'position': Vector2(0.12, 0.08), 'size': Vector2(0.3, 0.1)});
    this.add(this.playerHealthbarComponent);

    this.playerIconComponent = PlayerIconComponent(
        {'position': Vector2(0.0, 0.01), 'size': Vector2(0.125, 0.25)});
    this.add(this.playerIconComponent);

    this.playerWeaponIconComponent = PlayerWeaponIconComponent(
        {'position': Vector2(0.01, 0.75), 'size': Vector2(0.2, 0.1)});
    this.add(this.playerWeaponIconComponent);

    this.playerAmmunitionComponent = PlayerAmmunitionComponent(
        {'position': Vector2(0.01, 0.88), 'size': Vector2(0.4, 0.1)});
    this.add(this.playerAmmunitionComponent);

    this.playerCurrencyComponent = PlayerCurrencyComponent(
        {'position': Vector2(0.125, 0.185), 'size': Vector2(0.035, 0.065)});
    this.add(this.playerCurrencyComponent);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
  }
}
