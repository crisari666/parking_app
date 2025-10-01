import 'package:quantum_parking_flutter/core/network/api_client.dart';
import '../models/app_config_model.dart';

abstract class ConfigRemoteDatasource {
  Future<List<AppConfigModel>> getAppConfig();
}

class ConfigRemoteDatasourceImpl implements ConfigRemoteDatasource {
  final ApiClient _apiClient;

  ConfigRemoteDatasourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<AppConfigModel>> getAppConfig() async {
    try {
      final response = await _apiClient.dio.get('/config');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => AppConfigModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get app config: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get app config: $e');
    }
  }
} 