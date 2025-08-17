import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/data/repositories/user_membership_repository_impl.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/user_membership_model.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_event.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_state.dart';

class UserMembershipBloc extends Bloc<UserMembershipEvent, UserMembershipState> {
  final UserMembershipRepository _userMembershipRepository;

  UserMembershipBloc({
    required UserMembershipRepository userMembershipRepository,
  })  : _userMembershipRepository = userMembershipRepository,
        super(const UserMembershipState()) {
    on<LoadActiveMemberships>(_onLoadActiveMemberships);
    on<CreateUserMembership>(_onCreateUserMembership);
    on<SelectUserMembership>(_onSelectUserMembership);
    on<ClearSelectedUserMembership>(_onClearSelectedUserMembership);
    on<ClearUserMembershipMessage>(_onClearUserMembershipMessage);
  }

  Future<void> _onLoadActiveMemberships(LoadActiveMemberships event, Emitter<UserMembershipState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final activeMemberships = await _userMembershipRepository.getActiveMemberships();
      emit(state.copyWith(
        isLoading: false,
        activeMemberships: activeMemberships,
        message: 'Active memberships loaded successfully', // This will be localized in the UI
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCreateUserMembership(CreateUserMembership event, Emitter<UserMembershipState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final membership = UserMembershipModel(
        name: event.name,
        email: event.email,
        phoneNumber: event.phoneNumber,
      );
      
      await _userMembershipRepository.createUserMembership(membership);
      
      emit(state.copyWith(
        isLoading: false,
        isMembershipCreated: true,
        message: 'User membership created successfully', // This will be localized in the UI
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onSelectUserMembership(SelectUserMembership event, Emitter<UserMembershipState> emit) {
    emit(state.copyWith(selectedMembership: event.membership));
  }

  void _onClearSelectedUserMembership(ClearSelectedUserMembership event, Emitter<UserMembershipState> emit) {
    emit(state.copyWith(selectedMembership: null));
  }

  void _onClearUserMembershipMessage(ClearUserMembershipMessage event, Emitter<UserMembershipState> emit) {
    emit(state.copyWith(
      message: null,
      error: null,
      isMembershipCreated: false,
      isMembershipUpdated: false,
      isMembershipDeleted: false,
    ));
  }
} 