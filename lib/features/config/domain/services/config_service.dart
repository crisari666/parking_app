import 'package:quantum_parking_flutter/features/config/data/repositories/config_repository.dart';

class ConfigService {
  final ConfigRepository _configRepository;

  ConfigService(this._configRepository);

  /// Get a configuration value by key
  Future<String?> getConfigValue(String key) async {
    return await _configRepository.getConfigValue(key);
  }

  /// Get the minimum required build number
  Future<int?> getMinBuildNumber() async {
    final value = await getConfigValue('min_build_number');
    return int.tryParse(value ?? '');
  }

  /// Get the app name from config
  Future<String?> getAppName() async {
    return await getConfigValue('app_name');
  }

  /// Check if app version update is required
  Future<bool> isUpdateRequired(int currentBuildNumber) async {
    final minBuildNumber = await getMinBuildNumber();
    if (minBuildNumber == null) return false;
    return currentBuildNumber < minBuildNumber;
  }

  /// Refresh configuration from backend
  Future<void> refreshConfig() async {
    await _configRepository.refreshConfig();
  }
} 