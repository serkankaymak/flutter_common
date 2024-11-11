// blocs/authentication_state.dart

import 'package:equatable/equatable.dart';
import '../models/user.dart';
import 'IState.dart';

abstract class AuthenticationState extends Equatable implements IState {
  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final User user;

  AuthenticationSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
