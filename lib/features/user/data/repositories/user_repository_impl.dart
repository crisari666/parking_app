import 'package:quantum_parking_flutter/features/user/data/datasources/user_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/user/data/models/user_data_model.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';
import 'package:quantum_parking_flutter/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final userDataModels = await _remoteDataSource.getUsers();
      return userDataModels.map((dataModel) => dataModel.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final userDataModel = UserDataModel.fromDomain(user);
      final createdUserDataModel = await _remoteDataSource.createUser(userDataModel);
      return createdUserDataModel.toDomain();
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<UserModel> createUserWithCredentials(String email, String password) async {
    try {
      final createdUserDataModel = await _remoteDataSource.createUserWithCredentials(email, password);
      return createdUserDataModel.toDomain();
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final userDataModel = UserDataModel.fromDomain(user);
      final updatedUserDataModel = await _remoteDataSource.updateUser(userDataModel);
      return updatedUserDataModel.toDomain();
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _remoteDataSource.deleteUser(userId);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      final userDataModel = await _remoteDataSource.getUserById(userId);
      return userDataModel?.toDomain();
    } catch (e) {
      throw Exception('Failed to get user by id: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final allUsers = await getUsers();
      return allUsers.where((user) => user.role == role).toList();
    } catch (e) {
      throw Exception('Failed to get users by role: $e');
    }
  }
} 