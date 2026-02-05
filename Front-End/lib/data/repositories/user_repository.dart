import 'dart:convert';
import 'package:conference_system/data/models/update_user_dto.dart';
import 'package:http/http.dart' as http;
import 'package:conference_system/data/models/users.dart';
import 'package:conference_system/config/api_config.dart';

class UsersRepository {
  Future<List<User>> getUsers() async {
    final res = await http.get(GetUri.users);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<User> getUserById(int id) async {
    final res = await http.get(GetUri.getSingleUser(id));
    if (res.statusCode == 200) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> createUser(User user) async {
    final res = await http.post(
      GetUri.users,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Failed to create user');
  }

  Future<void> updateUser(int userId, UpdateUserDto dto) async {
    final res = await http.put(
      GetUri.getSingleUser(userId),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Failed to update user');
  }

  Future<void> deleteUser(int id) async {
    final res = await http.delete(GetUri.getSingleUser(id));
    if (res.statusCode != 200) throw Exception('Failed to delete user');
  }
}

