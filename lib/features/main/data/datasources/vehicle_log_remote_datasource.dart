import 'package:quantum_parking_flutter/core/network/api_client.dart';
import '../models/vehicle_log_response_model.dart';

abstract class VehicleLogRemoteDatasource {
  Future<VehicleLogResponseModel> createVehicleLog(String plateNumber, String vehicleType);
  Future<VehicleLogResponseModel?> getLastVehicleLog(String plateNumber);
}

class VehicleLogRemoteDatasourceImpl implements VehicleLogRemoteDatasource {
  final ApiClient _apiClient;

  VehicleLogRemoteDatasourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<VehicleLogResponseModel> createVehicleLog(String plateNumber, String vehicleType) async {
    try {
      final response = await _apiClient.dio.post(
        '/vehicle-log',
        data: {
          'plateNumber': plateNumber,
          'vehicleType': vehicleType,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VehicleLogResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create vehicle log: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create vehicle log: $e');
    }
  }

  @override
  Future<VehicleLogResponseModel?> getLastVehicleLog(String plateNumber) async {
    try {
      final response = await _apiClient.dio.get(
        '/vehicle-log/vehicle/$plateNumber/last',
      );

      if (response.statusCode == 200) {
        return VehicleLogResponseModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return null; // No active parking found
      } else {
        throw Exception('Failed to get last vehicle log: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get last vehicle log: $e');
    }
  }
}
