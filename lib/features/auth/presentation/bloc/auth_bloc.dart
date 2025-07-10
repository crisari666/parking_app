import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/user.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';


// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SetupLocalDatasource _setupLocalDatasource;
  String _email = '';
  String _password = '';

    AuthBloc({
    required AuthRepository authRepository,
    required SetupLocalDatasource setupLocalDatasource,
  })  : _authRepository = authRepository,
        _setupLocalDatasource = setupLocalDatasource,
        super(const AuthInitial()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onEmailChanged(EmailChanged event, Emitter<AuthState> emit) {
    _email = event.email;
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<AuthState> emit) {
    _password = event.password;
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading(email: _email, password: _password));
    try {
      final loginResponse = await _authRepository.login(_email, _password);
      final user = User(
        email: loginResponse.email ?? '',
        password: _password,
      );
      await _authRepository.saveUser(user);
      emit(AuthSuccess(email: _email, password: _password));
    } catch (e) {
      emit(AuthError(e.toString(), email: _email, password: _password));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading(email: _email, password: _password));
    try {
      final user = User(email: _email, password: _password);
      await _authRepository.saveUser(user);
      emit(AuthSuccess(email: _email, password: _password));
    } catch (e) {
      emit(AuthError(e.toString(), email: _email, password: _password));
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(email: _email, password: _password));
      } else {
        emit(AuthInitial(email: _email, password: _password));
      }
    } catch (e) {
      emit(AuthError(e.toString(), email: _email, password: _password));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.logout();
      await _setupLocalDatasource.clear();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString(), email: _email, password: _password));
    }
  }
} 