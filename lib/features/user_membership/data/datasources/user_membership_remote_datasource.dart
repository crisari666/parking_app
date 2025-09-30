import 'package:quantum_parking_flutter/core/network/api_client.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/vehicle_model.dart';

abstract class UserMembershipRemoteDataSource {
  Future<UserMembershipModel> createUserMembership(UserMembershipModel membership);
  Future<List<MembershipModel>> getActiveMemberships();
  Future<VehicleModel?> getVehicleByPlate(String plateNumber);
}

class UserMembershipRemoteDataSourceImpl implements UserMembershipRemoteDataSource {
  final ApiClient _apiClient;

  UserMembershipRemoteDataSourceImpl(this._apiClient);


  @override
  Future<UserMembershipModel> createUserMembership(UserMembershipModel membership) async {
    try {
      final response = await _apiClient.dio.post('/membership', data: membership.toJson());
      return UserMembershipModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user membership: $e');
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

  @override
  Future<VehicleModel?> getVehicleByPlate(String plateNumber) async {
    try {
      final response = await _apiClient.dio.get('/vehicle/plate/$plateNumber');
      if (response.data == null || response.data.isEmpty) {
        return null;
      }
      return VehicleModel.fromJson(response.data);
    } catch (e) {
      // Return null if vehicle not found or any error occurs
      return null;
    }
  }
} 