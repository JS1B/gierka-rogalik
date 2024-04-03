import 'package:flutter/services.dart' show rootBundle;
import 'package:game/entities/common/entity_stats.dart';
import 'package:yaml/yaml.dart';

class GameConfigLoader {
  final String defaultType = 'enemy';
  late Map<String, dynamic> _config;

  GameConfigLoader();

  Future<void> load(String configPath) async {
    String configFile = await rootBundle.loadString(configPath);
    YamlMap yamlMap = loadYaml(configFile);
    this._config = convertYamlMap(yamlMap);
  }

  Map<String, dynamic> convertYamlMap(YamlMap yamlMap) {
    return yamlMap.map((key, value) {
      if (value is YamlMap) {
        return MapEntry(key as String, convertYamlMap(value));
      } else {
        return MapEntry(key as String, value);
      }
    });
  }

  EntityStats getEntityStats(String type) {
    // Get the generic enemy stats
    var genericStats =
        this._config[this.defaultType]['stats'] as Map<String, dynamic>;
    // Get the specific type stats (if available)
    var typeSpecificStats =
        this._config[type]['stats'] as Map<String, dynamic>?;

    // Merge the configurations, with type-specific stats taking precedence
    Map<String, dynamic> mergedStats = {}
      ..addAll(genericStats)
      ..addAll(typeSpecificStats ?? {});

    return EntityStats.fromMap(mergedStats);
  }

  String getSpritePath(String type) {
    // Check if the type exists in the config
    if (!this._config.containsKey(type)) {
      type = this.defaultType;
    }
    // Check if the type has a sprite
    if (!this._config[type].containsKey('sprite')) {
      type = this.defaultType;
    }
    return this._config[type]['sprite'];
  }

  dynamic getHealthBarConfig(String type) {
    // Check if the type exists in the config
    if (!this._config.containsKey(type)) {
      type = this.defaultType;
    }
    // Check if the type has a sprite
    if (!this._config[type].containsKey('healthBar')) {
      type = this.defaultType;
    }
    return this._config[type]['healthBar'];
  }
}
