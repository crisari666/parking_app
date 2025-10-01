import 'package:dio/dio.dart';
import 'package:quantum_parking_flutter/core/network/api_client.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String user, String password);
  Future<void> setAuthToken(String token);
  Future<void> loadAuthToken();
  Future<bool> validateSession();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponse> login(String user, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {
          'user': user,
          'password': password,
        },
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  @override
  Future<void> setAuthToken(String token) async {
    await _apiClient.setAuthToken(token);
  }

  @override
  Future<void> loadAuthToken() async {
    await _apiClient.loadAuthToken();
  }

  @override
  Future<bool> validateSession() async {
    try {
      final response = await _apiClient.dio.get('/auth/validate');
      return response.data['valid'] == true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return false;
      }
      throw Exception(e.response?.data['message'] ?? 'Session validation failed');
    }
  }
} 