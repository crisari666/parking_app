import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String user;
  final String name;
  final String lastName;
  final String? email;
  final String role;
  final String business;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.user,
    required this.name,
    required this.lastName,
    this.email,
    required this.role,
    required this.business,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? user,
    String? name,
    String? lastName,
    String? email,
    String? role,
    String? business,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      user: user ?? this.user,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      business: business ?? this.business,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'name': name,
      'lastName': lastName,
      'email': email,
      'role': role,
      'business': business,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      user: json['user'] as String,
      name: json['name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String?,
      role: json['role'] as String,
      business: json['business'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        name,
        lastName,
        email,
        role,
        business,
        isActive,
        createdAt,
        updatedAt,
      ];
} 