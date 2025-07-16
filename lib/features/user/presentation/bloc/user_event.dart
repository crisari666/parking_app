import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class CreateUser extends UserEvent {
  final String name;
  final String email;
  final String role;

  const CreateUser({
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  List<Object> get props => [name, email, role];
}

class UpdateUser extends UserEvent {
  final UserModel user;

  const UpdateUser(this.user);

  @override
  List<Object> get props => [user];
}

class DeleteUser extends UserEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class SelectUser extends UserEvent {
  final UserModel user;

  const SelectUser(this.user);

  @override
  List<Object> get props => [user];
}

class ClearSelectedUser extends UserEvent {}

class ToggleUserStatus extends UserEvent {
  final String userId;
  final bool isActive;

  const ToggleUserStatus(this.userId, this.isActive);

  @override
  List<Object> get props => [userId, isActive];
}

class ClearUserMessage extends UserEvent {} 