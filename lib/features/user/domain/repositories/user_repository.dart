import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> createUserWithCredentials(String email, String password);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
  Future<UserModel?> getUserById(String userId);
  Future<List<UserModel>> getUsersByRole(String role);
  Future<UserModel> toggleUserStatus(String userId, bool enabled);
} 