import 'package:hive/hive.dart';
import 'package:quantum_parking_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/user.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/login_response.dart';

abstract class AuthRepository {
  Future<void> saveUser(User user);
  Future<User?> getCurrentUser();
  Future<void> logout();
  Future<LoginResponse> login(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  
  static const String _boxName = 'authBox';
  static const String _userKey = 'currentUser';
  static const String _tokenKey = 'authToken';

  AuthRepositoryImpl(this._remoteDataSource);

  Future<Box> get _box async => await Hive.openBox(_boxName);

  @override
  Future<void> saveUser(User user) async {
    final box = await _box;
    await box.put(_userKey, user);
  }

  @override
  Future<User?> getCurrentUser() async {
    final box = await _box;
    return box.get(_userKey);
  }

  @override
  Future<void> logout() async {
    final box = await _box;
    await box.delete(_userKey);
    await box.delete(_tokenKey);
  }

  @override
  Future<LoginResponse> login(String email, String password) async {
    final response = await _remoteDataSource.login(email, password);

    // Save the token
    await _remoteDataSource.setAuthToken(response.token);

    return response;
  }

  
} 