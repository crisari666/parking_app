import 'package:quantum_parking_flutter/core/network/api_client.dart';
import 'package:quantum_parking_flutter/features/user/data/models/user_data_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserDataModel>> getUsers();
  Future<UserDataModel> createUser(UserDataModel user);
  Future<UserDataModel> createUserWithCredentials(String email, String password);
  Future<UserDataModel> updateUser(UserDataModel user);
  Future<void> deleteUser(String userId);
  Future<UserDataModel?> getUserById(String userId);
  Future<UserDataModel> toggleUserStatus(String userId, bool enabled);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<UserDataModel>> getUsers() async {
    try {
      final response = await _apiClient.dio.get('/users/my-business');
      final List<dynamic> usersJson = response.data;
      
      return usersJson
          .map((json) => UserDataModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Future<UserDataModel> createUser(UserDataModel user) async {
    try {
      final response = await _apiClient.dio.post('/users/create-by-user', data: user.toCreateUserJson());
      return UserDataModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<UserDataModel> createUserWithCredentials(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/users/create-by-user', 
        data: UserDataModel.createUserRequest(email, password)
      );
      return UserDataModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<UserDataModel> updateUser(UserDataModel user) async {
    try {
      final response = await _apiClient.dio.put('/users/${user.id}', data: user.toJson());
      return UserDataModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _apiClient.dio.delete('/users/$userId');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<UserDataModel?> getUserById(String userId) async {
    try {
      final response = await _apiClient.dio.get('/users/$userId');
      return UserDataModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<UserDataModel> toggleUserStatus(String userId, bool enabled) async {
    try {
      final response = await _apiClient.dio.patch(
        '/users/$userId/status',
        data: {'enabled': enabled},
      );
      return UserDataModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to toggle user status: $e');
    }
  }
} 