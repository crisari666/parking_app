import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';

class UserState extends Equatable {
  final bool isLoading;
  final List<UserModel> users;
  final UserModel? selectedUser;
  final String? message;
  final String? error;
  final bool isUserCreated;
  final bool isUserUpdated;
  final bool isUserDeleted;

  const UserState({
    this.isLoading = false,
    this.users = const [],
    this.selectedUser,
    this.message,
    this.error,
    this.isUserCreated = false,
    this.isUserUpdated = false,
    this.isUserDeleted = false,
  });

  UserState copyWith({
    bool? isLoading,
    List<UserModel>? users,
    UserModel? selectedUser,
    String? message,
    String? error,
    bool? isUserCreated,
    bool? isUserUpdated,
    bool? isUserDeleted,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      message: message ?? this.message,
      error: error ?? this.error,
      isUserCreated: isUserCreated ?? this.isUserCreated,
      isUserUpdated: isUserUpdated ?? this.isUserUpdated,
      isUserDeleted: isUserDeleted ?? this.isUserDeleted,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        users,
        selectedUser,
        message,
        error,
        isUserCreated,
        isUserUpdated,
        isUserDeleted,
      ];
} 