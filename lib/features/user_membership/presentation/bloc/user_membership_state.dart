import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/vehicle_model.dart';

class UserMembershipState extends Equatable {
  final bool isLoading;
  final List<UserMembershipModel> memberships;
  final List<MembershipModel> activeMemberships;
  final UserMembershipModel? selectedMembership;
  final MembershipModel? selectedActiveMembership;
  final VehicleModel? foundVehicle;
  final String? message;
  final String? error;
  final bool isMembershipCreated;
  final bool isMembershipUpdated;
  final bool isMembershipDeleted;

  const UserMembershipState({
    this.isLoading = false,
    this.memberships = const [],
    this.activeMemberships = const [],
    this.selectedMembership,
    this.selectedActiveMembership,
    this.foundVehicle,
    this.message,
    this.error,
    this.isMembershipCreated = false,
    this.isMembershipUpdated = false,
    this.isMembershipDeleted = false,
  });

  UserMembershipState copyWith({
    bool? isLoading,
    List<UserMembershipModel>? memberships,
    List<MembershipModel>? activeMemberships,
    UserMembershipModel? selectedMembership,
    MembershipModel? selectedActiveMembership,
    VehicleModel? foundVehicle,
    String? message,
    String? error,
    bool? isMembershipCreated,
    bool? isMembershipUpdated,
    bool? isMembershipDeleted,
  }) {
    return UserMembershipState(
      isLoading: isLoading ?? this.isLoading,
      memberships: memberships ?? this.memberships,
      activeMemberships: activeMemberships ?? this.activeMemberships,
      selectedMembership: selectedMembership ?? this.selectedMembership,
      selectedActiveMembership: selectedActiveMembership ?? this.selectedActiveMembership,
      foundVehicle: foundVehicle ?? this.foundVehicle,
      message: message ?? this.message,
      error: error ?? this.error,
      isMembershipCreated: isMembershipCreated ?? this.isMembershipCreated,
      isMembershipUpdated: isMembershipUpdated ?? this.isMembershipUpdated,
      isMembershipDeleted: isMembershipDeleted ?? this.isMembershipDeleted,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        memberships,
        activeMemberships,
        selectedMembership,
        selectedActiveMembership,
        foundVehicle,
        message,
        error,
        isMembershipCreated,
        isMembershipUpdated,
        isMembershipDeleted,
      ];
} 