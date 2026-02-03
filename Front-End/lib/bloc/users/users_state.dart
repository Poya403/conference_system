import 'package:equatable/equatable.dart';
import 'package:conference_system/data/models/users.dart';

abstract class UsersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserLoaded extends UsersState {
  final User user;
  UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);

  @override
  List<Object?> get props => [message];
}

class UsersActionSuccess extends UsersState {
  final String message;
  UsersActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
