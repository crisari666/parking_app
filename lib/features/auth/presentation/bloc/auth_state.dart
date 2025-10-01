import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final String email;
  final String password;
  final String? userRole;
  
  const AuthState({
    this.email = '',
    this.password = '',
    this.userRole,
  });

  @override
  List<Object?> get props => [email, password, userRole];
}

class AuthInitial extends AuthState {
  const AuthInitial({super.email, super.password, super.userRole});
}

class AuthLoading extends AuthState {
  const AuthLoading({super.email, super.password, super.userRole});
}

class AuthSuccess extends AuthState {
  const AuthSuccess({super.email, super.password, super.userRole});
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message, {super.email, super.password, super.userRole});

  @override
  List<Object?> get props => [message, email, password, userRole];
} 