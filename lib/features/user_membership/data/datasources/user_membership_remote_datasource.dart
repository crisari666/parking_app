import 'package:quantum_parking_flutter/core/network/api_client.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/membership_model.dart';

abstract class UserMembershipRemoteDataSource {
  Future<List<UserMembershipModel>> getUserMemberships();
  Future<UserMembershipModel> createUserMembership(UserMembershipModel membership);
  Future<UserMembershipModel> updateUserMembership(UserMembershipModel membership);
  Future<void> deleteUserMembership(String membershipId);
  Future<UserMembershipModel?> getUserMembershipById(String membershipId);
  Future<List<MembershipModel>> getActiveMemberships();
}

class UserMembershipRemoteDataSourceImpl implements UserMembershipRemoteDataSource {
  final ApiClient _apiClient;

  UserMembershipRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<UserMembershipModel>> getUserMemberships() async {
    try {
      final response = await _apiClient.dio.get('/user-memberships');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => UserMembershipModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load user memberships: $e');
    }
  }

  @override
  Future<UserMembershipModel> createUserMembership(UserMembershipModel membership) async {
    try {
      final response = await _apiClient.dio.post('/user-memberships', data: membership.toJson());
      return UserMembershipModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create user membership: $e');
    }
  }

  @override
  Future<UserMembershipModel> updateUserMembership(UserMembershipModel membership) async {
    try {
      final response = await _apiClient.dio.put('/user-memberships/${membership.id}', data: membership.toJson());
      return UserMembershipModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update user membership: $e');
    }
  }

  @override
  Future<void> deleteUserMembership(String membershipId) async {
    try {
      await _apiClient.dio.delete('/user-memberships/$membershipId');
    } catch (e) {
      throw Exception('Failed to delete user membership: $e');
    }
  }

  @override
  Future<UserMembershipModel?> getUserMembershipById(String membershipId) async {
    try {
      final response = await _apiClient.dio.get('/user-memberships/$membershipId');
      return UserMembershipModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to get user membership: $e');
    }
  }

  @override
  Future<List<MembershipModel>> getActiveMemberships() async {
    try {
      final response = await _apiClient.dio.get('/membership/active');
      final List<dynamic> data = response.data;
      return data.map((json) => MembershipModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load active memberships: $e');
    }
  }
} 