import 'package:quantum_parking_flutter/core/network/api_client.dart';
import '../models/financial_resume_model.dart';

abstract class FinancialRemoteDatasource {
  Future<FinancialResumeModel> getFinancialResumeByDate(String date);
}

class FinancialRemoteDatasourceImpl implements FinancialRemoteDatasource {
  final ApiClient _apiClient;

  FinancialRemoteDatasourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<FinancialResumeModel> getFinancialResumeByDate(String date) async {
    try {
      final response = await _apiClient.dio.get('/financial/resume/date/$date');

      if (response.statusCode == 200) {
        return FinancialResumeModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get financial resume: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get financial resume: $e');
    }
  }
}
