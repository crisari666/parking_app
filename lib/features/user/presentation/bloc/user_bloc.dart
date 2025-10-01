import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:quantum_parking_flutter/features/user/domain/services/user_service.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_event.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final UserService _userService;

  UserBloc({
    required UserRepository userRepository,
    required UserService userService,
  })  : _userRepository = userRepository,
        _userService = userService,
        super(const UserState()) {
    on<LoadUsers>(_onLoadUsers);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
    on<SelectUser>(_onSelectUser);
    on<ClearSelectedUser>(_onClearSelectedUser);
    on<ToggleUserStatus>(_onToggleUserStatus);
    on<ClearUserMessage>(_onClearUserMessage);
    on<UpdateUserWithCredentials>(_onUpdateUserWithCredentials);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final users = await _userRepository.getUsers();
      emit(state.copyWith(
        isLoading: false,
        users: users,
        message: 'Users loaded successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      await _userRepository.createUserWithCredentials(event.email, event.password);
      final updatedUsers = await _userRepository.getUsers();
      
      emit(state.copyWith(
        isLoading: false,
        users: updatedUsers,
        isUserCreated: true,
        message: 'User created successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final updatedUser = event.user.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _userRepository.updateUser(updatedUser);
      final updatedUsers = await _userRepository.getUsers();
      
      emit(state.copyWith(
        isLoading: false,
        users: updatedUsers,
        selectedUser: updatedUser,
        isUserUpdated: true,
        message: 'User updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateUserWithCredentials(UpdateUserWithCredentials event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedUser = await _userRepository.updateUserWithCredentials(event.userId, event.email, event.password);
      final updatedUsers = state.users.map((user) {
        if (user.id == event.userId) {
          return updatedUser;
        }
        return user;
      }).toList();
      emit(state.copyWith(
        isLoading: false,
        users: updatedUsers,
        selectedUser: updatedUser,
        isUserUpdated: true,
        message: 'User updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      await _userRepository.deleteUser(event.userId);
      final updatedUsers = await _userRepository.getUsers();
      
      emit(state.copyWith(
        isLoading: false,
        users: updatedUsers,
        selectedUser: null,
        isUserDeleted: true,
        message: 'User deleted successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onSelectUser(SelectUser event, Emitter<UserState> emit) {
    emit(state.copyWith(selectedUser: event.user));
  }

  void _onClearSelectedUser(ClearSelectedUser event, Emitter<UserState> emit) {
    emit(state.copyWith(selectedUser: null));
  }

  Future<void> _onToggleUserStatus(ToggleUserStatus event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      // Get current user ID to prevent self-disabling
      final currentUserId = await _userService.getCurrentUserId();
      
      // Check if user is trying to disable themselves
      if (currentUserId == event.userId && !event.isActive) {
        emit(state.copyWith(
          isLoading: false,
          error: 'You cannot disable your own account',
        ));
        return;
      }
      
      // Use the new API endpoint to toggle user status
      final updatedUser = await _userRepository.toggleUserStatus(event.userId, event.isActive);
      
      // Update the users list with the new user data
      final updatedUsers = state.users.map((user) {
        if (user.id == event.userId) {
          return updatedUser;
        }
        return user;
      }).toList();
      
      emit(state.copyWith(
        isLoading: false,
        users: updatedUsers,
        isUserUpdated: true,
        message: 'User status updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onClearUserMessage(ClearUserMessage event, Emitter<UserState> emit) {
    emit(state.copyWith(
      message: null,
      error: null,
      isUserCreated: false,
      isUserUpdated: false,
      isUserDeleted: false,
    ));
  }
} 