import 'package:hive/hive.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/user.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/login_response.dart';

abstract class AuthRepository {
  Future<void> saveUser(User user);
  Future<User?> getCurrentUser();
  Future<void> logout();
  Future<LoginResponse> login(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  static const String _boxName = 'authBox';
  static const String _userKey = 'currentUser';
  static const String _tokenKey = 'authToken';

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
    // TODO: Replace with actual API call
    // This is a mock response for now
    final response = LoginResponse(
      id: "681bf4474dbfaaa1abca777f",
      email: email,
      role: "user",
      name: "",
      lastName: "",
      token: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjEifQ.eyJ1dWlkIjoiNjgxYmY0NDc0ZGJmYWFhMWFiY2E3NzdmIiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NDY2NzE4MTksImV4cCI6MTc0NzI3NjYxOX0.ag4dWxEUjeRE_Wep36I_v-wb3_euz5PpB-XxfAMg7AxeHbDuBFFy6OayTe4tja1rJHAOkN01hboYuSrCWTAQG_w3YXSYLgJ1H9J-5LLxDo_14qnuWGcgXgmrlodWq9LJdxrtOU9fqgBuoVY6lfLgO4gA5L4SUBnugOjWD3r9vokGxgHFFfVOXSginxwdvZXkN1TtAnXdkcV2RbsmM6fbtQSPbkXEJjCQp1bTzWx_7dVMLRQPTi_zBhPsEg9fgdEIkev22rgoOrfn8cOF5yum61xiOkPHqOWY66QsF6XIYEIqJs9l3myAjto4blwf6eRhnOdm82oKMWr2460v7W7cdA"
    );

    // Save the token
    final box = await _box;
    await box.put(_tokenKey, response.token);

    return response;
  }
} 