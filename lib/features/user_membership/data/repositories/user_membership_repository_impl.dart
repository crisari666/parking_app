import 'package:quantum_parking_flutter/features/user_membership/data/datasources/user_membership_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/membership_model.dart';

abstract class UserMembershipRepository {
  Future<UserMembershipModel> createUserMembership(UserMembershipModel membership);
  Future<List<MembershipModel>> getActiveMemberships();
} 

class UserMembershipRepositoryImpl implements UserMembershipRepository {
  final UserMembershipRemoteDataSource _remoteDataSource;

  UserMembershipRepositoryImpl(this._remoteDataSource);


  @override
  Future<UserMembershipModel> createUserMembership(UserMembershipModel membership) async {
    try {
      return await _remoteDataSource.createUserMembership(membership);
    } catch (e) {
      throw Exception('Failed to create user membership: $e');
    }
  }

  

  @override
  Future<List<MembershipModel>> getActiveMemberships() async {
    try {
      return await _remoteDataSource.getActiveMemberships();
    } catch (e) {
      throw Exception('Failed to get active memberships: $e');
    }
  }
} 