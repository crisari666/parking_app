import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final String email;
  final String password;
  
  const AuthState({
    this.email = '',
    this.password = '',
  });

  @override
  List<Object> get props => [email, password];
}

class AuthInitial extends AuthState {
  const AuthInitial({super.email, super.password});
}

class AuthLoading extends AuthState {
  const AuthLoading({super.email, super.password});
}

class AuthSuccess extends AuthState {
  const AuthSuccess({super.email, super.password});
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message, {super.email, super.password});

  @override
  List<Object> get props => [message, email, password];
} 