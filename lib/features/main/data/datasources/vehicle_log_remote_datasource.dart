import 'package:dio/dio.dart';
import 'package:quantum_parking_flutter/core/network/api_client.dart';
import '../models/vehicle_log_response_model.dart';
import '../models/active_vehicle_log_model.dart';

abstract class VehicleLogRemoteDatasource {
  Future<VehicleLogResponseModel> createVehicleLog(String plateNumber, String vehicleType);
  Future<VehicleLogResponseModel?> getLastVehicleLog(String plateNumber);
  Future<List<ActiveVehicleLogModel>> getActiveVehicles();
  Future<List<VehicleLogResponseModel>> getVehicleLogs(String plateNumber);
  Future<VehicleLogResponseModel> checkoutVehicle(String plateNumber, int cost);
  Future<List<ActiveVehicleLogModel>> getVehicleLogsByDate(String date);
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
      if(e is DioException){
        if(e.response?.statusCode == 400 && e.response?.data['message'] == 'Vehicle is already in parking'){
          throw Exception('El Vehiculo ya esta en el parqueadero');
        }
      }
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

  @override
  Future<List<ActiveVehicleLogModel>> getActiveVehicles() async {
    try {
      final response = await _apiClient.dio.get('/vehicle-log/active',);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ActiveVehicleLogModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get active vehicles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get active vehicles: $e');
    }
  }

  @override
  Future<List<VehicleLogResponseModel>> getVehicleLogs(String plateNumber) async {
    try {
      final response = await _apiClient.dio.get(
        '/vehicle-log/vehicle/$plateNumber/logs',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => VehicleLogResponseModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get vehicle logs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get vehicle logs: $e');
    }
  }

  @override
  Future<VehicleLogResponseModel> checkoutVehicle(String plateNumber, int cost) async {
    try {
      final response = await _apiClient.dio.patch(
        '/vehicle-log/vehicle/$plateNumber/checkout',
        data: {
          'cost': cost,
        },
      );

      if (response.statusCode == 200) {
        return VehicleLogResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to checkout vehicle: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404 && e.response?.data['message'] == 'No active vehicle log found') {
          throw Exception('No active vehicle log found');
        }
      }
      throw Exception('Failed to checkout vehicle: $e');
    }
  }

  @override
  Future<List<ActiveVehicleLogModel>> getVehicleLogsByDate(String date) async {
    try {
      final response = await _apiClient.dio.get(
        '/vehicle-log/date/$date',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ActiveVehicleLogModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get vehicle logs by date: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get vehicle logs by date: $e');
    }
  }
}