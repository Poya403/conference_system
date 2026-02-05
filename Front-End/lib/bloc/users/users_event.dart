import 'package:conference_system/data/models/update_user_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:conference_system/data/models/users.dart';

abstract class UsersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUsers extends UsersEvent {}

class GetCurrentUser extends UsersEvent {
  final int id;
  GetCurrentUser(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateUserEvent extends UsersEvent {
  final User user;
  CreateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserEvent extends UsersEvent {
  final UpdateUserDto dto;
  final int userId;

  UpdateUserEvent({
    required this.userId,
    required this.dto
  });

  @override
  List<Object?> get props => [dto];
}

class DeleteUserEvent extends UsersEvent {
  final int id;
  DeleteUserEvent(this.id);

  @override
  List<Object?> get props => [id];
}
