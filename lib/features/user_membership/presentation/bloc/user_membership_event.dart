import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';

abstract class UserMembershipEvent extends Equatable {
  const UserMembershipEvent();

  @override
  List<Object> get props => [];
}


class LoadActiveMemberships extends UserMembershipEvent {}

class CreateUserMembership extends UserMembershipEvent {
  final String dateStart;
  final String dateEnd;
  final int value;
  final String businessId;
  final bool enable;
  final String plateNumber;
  final String userName;
  final String phone;
  final String vehicleType;

  const CreateUserMembership({
    required this.dateStart,
    required this.dateEnd,
    required this.value,
    required this.businessId,
    required this.enable,
    required this.plateNumber,
    required this.userName,
    required this.phone,
    required this.vehicleType,
  });

  @override
  List<Object> get props => [
    dateStart,
    dateEnd,
    value,
    businessId,
    enable,
    plateNumber,
    userName,
    phone,
    vehicleType,
  ];
}

class SelectUserMembership extends UserMembershipEvent {
  final UserMembershipModel membership;

  const SelectUserMembership(this.membership);

  @override
  List<Object> get props => [membership];
}

class ClearSelectedUserMembership extends UserMembershipEvent {}

class ClearUserMembershipMessage extends UserMembershipEvent {}

class FindVehicleByPlate extends UserMembershipEvent {
  final String plateNumber;

  const FindVehicleByPlate(this.plateNumber);

  @override
  List<Object> get props => [plateNumber];
} 