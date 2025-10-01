import 'package:quantum_parking_flutter/features/auth/data/repositories/auth_repository.dart';

class UserService {
  final AuthRepository _authRepository;

  UserService(this._authRepository);

  Future<String?> getCurrentUserRole() async {
    try {
      final loginResponse = await _authRepository.getCurrentLoginResponse();
      return loginResponse?.role;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isAdmin() async {
    final role = await getCurrentUserRole();
    return role == 'admin';
  }

  Future<bool> isUser() async {
    final role = await getCurrentUserRole();
    return role == 'user';
  }

  Future<bool> isAdminOrUser() async {
    final role = await getCurrentUserRole();
    return role == 'admin' || role == 'user';
  }

  Future<bool> hasRole(String requiredRole) async {
    final role = await getCurrentUserRole();
    return role == requiredRole;
  }

  Future<bool> hasAnyRole(List<String> requiredRoles) async {
    final role = await getCurrentUserRole();
    return requiredRoles.contains(role);
  }

  Future<String?> getCurrentUserId() async {
    try {
      final loginResponse = await _authRepository.getCurrentLoginResponse();
      return loginResponse?.id;
    } catch (e) {
      return null;
    }
  }
} 