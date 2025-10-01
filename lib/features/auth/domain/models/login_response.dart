import 'package:hive/hive.dart';

part 'login_response.g.dart';

@HiveType(typeId: 5)
class LoginResponse {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String lastName;

  @HiveField(5)
  final String token;

  LoginResponse({
    required this.id,
    this.email,
    required this.role,
    required this.name,
    required this.lastName,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'] as String,
      email: json['email'] as String?,
      role: json['role'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'lastName': lastName,
      'token': token,
    };
  }
} 