import 'package:flutter_bloc/flutter_bloc.dart';
import 'users_event.dart';
import 'users_state.dart';
import 'package:conference_system/services/user_service.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersService service;

  UsersBloc({required this.service}) : super(UsersInitial()) {
    on<GetUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await service.getUsers();
        emit(UsersLoaded(users));
      } catch (e) {
        emit(UsersError(e.toString()));
      }
    });

    on<GetCurrentUser>((event, emit) async {
      emit(UsersLoading());
      try {
        final user = await service.getSingleUser(event.id);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UsersError(e.toString()));
      }
    });

    on<CreateUserEvent>((event, emit) async {
      try {
        await service.createUser(event.user);
        emit(UsersActionSuccess('حساب کاربری جدید با موفقیت ایجاد شد.'));
      } catch (e) {
        emit(UsersError(e.toString()));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      try {
        await service.updateUser(event.userId, event.dto);
        emit(UsersActionSuccess('بروزرسانی با موفقیت انجام شد.'));

        final updatedUser = await service.getSingleUser(event.userId);
        emit(UserLoaded(updatedUser));
      } catch (e) {
        emit(UsersError(e.toString()));
      }
    });

    on<DeleteUserEvent>((event, emit) async {
      try {
        await service.deleteUser(event.id);
        emit(UsersActionSuccess('کاربر با موفقیت حذف شد.'));
      } catch (e) {
        emit(UsersError(e.toString()));
      }
    });
  }
}
