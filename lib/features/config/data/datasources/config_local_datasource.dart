import 'package:hive/hive.dart';
import 'package:quantum_parking_flutter/core/contants/hive_constants.dart';
import '../models/app_config_model.dart';

abstract class ConfigLocalDatasource {
  Future<void> saveAppConfig(List<AppConfigModel> configs);
  Future<List<AppConfigModel>> getAppConfig();
  Future<AppConfigModel?> getConfigByKey(String key);
  Future<String?> getConfigValue(String key);
  Future<void> clear();
}

class ConfigLocalDatasourceImpl implements ConfigLocalDatasource {
  static const String configBoxName = HiveConstants.configBox;
  static const String configKey = HiveConstants.configKey;

  late final Box<AppConfigModel> _configBox;

  Future<void> init() async {
    _configBox = await Hive.openBox<AppConfigModel>(configBoxName);
  }

  @override
  Future<void> saveAppConfig(List<AppConfigModel> configs) async {
    await _configBox.clear();
    for (final config in configs) {
      await _configBox.put(config.key, config);
    }
  }

  @override
  Future<List<AppConfigModel>> getAppConfig() async {
    return _configBox.values.toList();
  }

  @override
  Future<AppConfigModel?> getConfigByKey(String key) async {
    return _configBox.get(key);
  }

  @override
  Future<String?> getConfigValue(String key) async {
    final config = await getConfigByKey(key);
    return config?.value;
  }

  @override
  Future<void> clear() async {
    await _configBox.clear();
  }
} 