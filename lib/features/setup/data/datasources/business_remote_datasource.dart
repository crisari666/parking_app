import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/business_setup_model.dart';

abstract class BusinessRemoteDatasource {
  Future<BusinessSetupModel> createBusiness(BusinessSetupModel business);
}

class BusinessRemoteDatasourceImpl implements BusinessRemoteDatasource {
  final http.Client client;
  final String baseUrl;

  BusinessRemoteDatasourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<BusinessSetupModel> createBusiness(BusinessSetupModel business) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/business'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(business.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BusinessSetupModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create business: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create business: $e');
    }
  }
}
