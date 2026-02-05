import 'package:conference_system/config/api_config.dart';
import 'package:conference_system/data/models/comments.dart';
import 'package:conference_system/enums/target_type.dart';
import 'package:conference_system/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:conference_system/data/models/comment_create_dto.dart';

class CommentRepository {
  CommentRepository();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${AuthProvider().token}',
  };

  Future<List<Comment>> getComments(CommentTargetType type, int targetId) async {
    final response = await http.get(GetUri.getComments(targetId, type), headers: _headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) => Comment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Comment> createComment(CommentCreateDto dto) async {
    final response = await http.post(
      GetUri.postComment,
      headers: _headers,
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<Comment> updateComment(int id, CommentCreateDto dto) async {
    final response = await http.put(
      GetUri.deleteOrUpdateComment(id),
      headers: _headers,
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update comment');
    }
  }

  Future<void> deleteComment(int id) async {
    final response = await http.delete(
      GetUri.deleteOrUpdateComment(id),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }
  }
}
