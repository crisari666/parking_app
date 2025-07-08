import 'package:quantum_parking_flutter/features/config/data/datasources/config_local_datasource.dart';
import 'package:quantum_parking_flutter/features/config/data/datasources/config_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/config/data/models/app_config_model.dart';

abstract class ConfigRepository {
  Future<List<AppConfigModel>> getAppConfig();
  Future<AppConfigModel?> getConfigByKey(String key);
  Future<String?> getConfigValue(String key);
  Future<void> refreshConfig();
}

class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigRemoteDatasource _remoteDatasource;
  final ConfigLocalDatasource _localDatasource;

  ConfigRepositoryImpl({
    required ConfigRemoteDatasource remoteDatasource,
    required ConfigLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  @override
  Future<List<AppConfigModel>> getAppConfig() async {
    try {
      // // Try to get from local storage first
      // final localConfigs = await _localDatasource.getAppConfig();
      // if (localConfigs.isNotEmpty) {
      //   return localConfigs;
      // }

      // If no local data, fetch from remote
      await refreshConfig();
      return await _localDatasource.getAppConfig();
    } catch (e) {
      // If remote fails, return empty list
      return [];
    }
  }

  @override
  Future<AppConfigModel?> getConfigByKey(String key) async {
    return await _localDatasource.getConfigByKey(key);
  }

  @override
  Future<String?> getConfigValue(String key) async {
    return await _localDatasource.getConfigValue(key);
  }

  @override
  Future<void> refreshConfig() async {
    try {
      final remoteConfigs = await _remoteDatasource.getAppConfig();
      await _localDatasource.saveAppConfig(remoteConfigs);
    } catch (e) {
      throw Exception('Failed to refresh config: $e');
    }
  }
} 