// models/user.dart

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;

  User({
    required this.id,
    required this.username,
  });

  @override
  List<Object> get props => [id, username];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
    );
  }
}
