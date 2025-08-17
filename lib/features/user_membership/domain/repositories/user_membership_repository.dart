import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';

abstract class UserMembershipRepository {
  Future<List<UserMembershipModel>> getUserMemberships();
  Future<UserMembershipModel> createUserMembership(UserMembershipModel membership);
  Future<UserMembershipModel> updateUserMembership(UserMembershipModel membership);
  Future<void> deleteUserMembership(String membershipId);
  Future<UserMembershipModel?> getUserMembershipById(String membershipId);
} 