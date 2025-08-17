import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';

class UserMembershipState extends Equatable {
  final bool isLoading;
  final List<UserMembershipModel> memberships;
  final UserMembershipModel? selectedMembership;
  final String? message;
  final String? error;
  final bool isMembershipCreated;
  final bool isMembershipUpdated;
  final bool isMembershipDeleted;

  const UserMembershipState({
    this.isLoading = false,
    this.memberships = const [],
    this.selectedMembership,
    this.message,
    this.error,
    this.isMembershipCreated = false,
    this.isMembershipUpdated = false,
    this.isMembershipDeleted = false,
  });

  UserMembershipState copyWith({
    bool? isLoading,
    List<UserMembershipModel>? memberships,
    UserMembershipModel? selectedMembership,
    String? message,
    String? error,
    bool? isMembershipCreated,
    bool? isMembershipUpdated,
    bool? isMembershipDeleted,
  }) {
    return UserMembershipState(
      isLoading: isLoading ?? this.isLoading,
      memberships: memberships ?? this.memberships,
      selectedMembership: selectedMembership ?? this.selectedMembership,
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
        selectedMembership,
        message,
        error,
        isMembershipCreated,
        isMembershipUpdated,
        isMembershipDeleted,
      ];
} 