import 'package:quantum_parking_flutter/core/network/api_client.dart';
import '../models/business_setup_model.dart';

abstract class BusinessRemoteDatasource {
  Future<BusinessSetupModel> createBusiness(BusinessSetupModel business);
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
}
