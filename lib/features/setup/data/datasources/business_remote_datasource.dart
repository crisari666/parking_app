import 'package:quantum_parking_flutter/core/network/api_client.dart';
import '../models/business_setup_model.dart';

abstract class BusinessRemoteDatasource {
  Future<BusinessSetupModel> createBusiness(BusinessSetupModel business);
  Future<BusinessSetupModel?> getBusiness();
  Future<BusinessSetupModel> updateBusiness(String id, BusinessSetupModel business);
}

class BusinessRemoteDatasourceImpl implements BusinessRemoteDatasource {
  final ApiClient _apiClient;

  BusinessRemoteDatasourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<BusinessSetupModel> createBusiness(BusinessSetupModel business) async {
    try {
      final response = await _apiClient.dio.post(
        '/business',
        data: business.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BusinessSetupModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create business: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create business: $e');
    }
  }

  @override
  Future<BusinessSetupModel?> getBusiness() async {
    try {
      final response = await _apiClient.dio.get('/business');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final business = data.map((json) => BusinessSetupModel.fromJson(json)).toList();
        if (business.isNotEmpty) {
          return business.first;
        } else {
          return null;
        }
      } else {
        throw Exception('Failed to get businesses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get businesses: $e');
    }
  }

  @override
  Future<BusinessSetupModel> updateBusiness(String id, BusinessSetupModel business) async {
    try {
      final response = await _apiClient.dio.patch(
        '/business/$id',
        data: business.toJson(),
      );

      if (response.statusCode == 200) {
        return BusinessSetupModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update business: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update business: $e');
    }
  }
}
