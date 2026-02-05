import 'package:conference_system/data/models/update_user_dto.dart';
import 'package:conference_system/data/models/users.dart';
import 'package:conference_system/data/repositories/user_repository.dart';

class UsersService {
  final UsersRepository repository;

  UsersService({required this.repository});

  Future<List<User>> getUsers() async {
    return await repository.getUsers();
  }

  Future<User> getSingleUser(int id) async {
    return await repository.getUserById(id);
  }

  Future<void> createUser(User user) async {
    final users = await repository.getUsers();
    if (users.any((u) => u.email == user.email)) {
      throw Exception('این ایمیل قبلاً ثبت شده است.');
    }
    await repository.createUser(user);
  }

  Future<void> updateUser(int userId, UpdateUserDto dto) async {
    await repository.updateUser(userId, dto);
  }

  Future<void> deleteUser(int id) async {
    await repository.deleteUser(id);
  }
}
