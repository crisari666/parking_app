import 'package:hive/hive.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/user.dart';

class AuthRepository {
  static const String _boxName = 'authBox';
  static const String _userKey = 'currentUser';

  Future<Box> get _box async => await Hive.openBox(_boxName);

  Future<void> saveUser(User user) async {
    final box = await _box;
    await box.put(_userKey, user);
  }

  Future<User?> getCurrentUser() async {
    final box = await _box;
    return box.get(_userKey);
  }

  Future<void> logout() async {
    final box = await _box;
    await box.delete(_userKey);
  }
} 