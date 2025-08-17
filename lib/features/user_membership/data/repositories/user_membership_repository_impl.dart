import 'package:quantum_parking_flutter/features/user_membership/data/datasources/user_membership_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/repositories/user_membership_repository.dart';

class UserMembershipRepositoryImpl implements UserMembershipRepository {
  final UserMembershipRemoteDataSource _remoteDataSource;

  UserMembershipRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<UserMembershipModel>> getUserMemberships() async {
    try {
      return await _remoteDataSource.getUserMemberships();
    } catch (e) {
      throw Exception('Failed to get user memberships: $e');
    }
  }

  @override
  Future<UserMembershipModel> createUserMembership(UserMembershipModel membership) async {
    try {
      return await _remoteDataSource.createUserMembership(membership);
    } catch (e) {
      throw Exception('Failed to create user membership: $e');
    }
  }

  @override
  Future<UserMembershipModel> updateUserMembership(UserMembershipModel membership) async {
    try {
      return await _remoteDataSource.updateUserMembership(membership);
    } catch (e) {
      throw Exception('Failed to update user membership: $e');
    }
  }

  @override
  Future<void> deleteUserMembership(String membershipId) async {
    try {
      await _remoteDataSource.deleteUserMembership(membershipId);
    } catch (e) {
      throw Exception('Failed to delete user membership: $e');
    }
  }

  @override
  Future<UserMembershipModel?> getUserMembershipById(String membershipId) async {
    try {
      return await _remoteDataSource.getUserMembershipById(membershipId);
    } catch (e) {
      throw Exception('Failed to get user membership: $e');
    }
  }
} 