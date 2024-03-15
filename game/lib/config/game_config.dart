import 'package:flutter/services.dart' show rootBundle;
import 'package:game/components/common/entity_stats.dart';
import 'package:yaml/yaml.dart';

class GameConfigLoader {
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
    var configStats = this._config[type]['stats'] as Map<String, dynamic>;
    return EntityStats.fromMap(configStats);
  }

  String getSpritePath(String type) {
    return this._config[type]['sprite'];
  }
}
