import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';

abstract class UserMembershipEvent extends Equatable {
  const UserMembershipEvent();

  @override
  List<Object> get props => [];
}


class LoadActiveMemberships extends UserMembershipEvent {}

class CreateUserMembership extends UserMembershipEvent {
  final String name;
  final String email;
  final String phoneNumber;

  const CreateUserMembership({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [name, email, phoneNumber];
}

class SelectUserMembership extends UserMembershipEvent {
  final UserMembershipModel membership;

  const SelectUserMembership(this.membership);

  @override
  List<Object> get props => [membership];
}

class ClearSelectedUserMembership extends UserMembershipEvent {}

class ClearUserMembershipMessage extends UserMembershipEvent {} 