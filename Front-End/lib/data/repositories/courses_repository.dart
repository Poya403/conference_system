import 'package:http/http.dart' as http;
import 'package:conference_system/data/models/courses.dart';
import 'dart:convert';
import 'package:conference_system/config/api_config.dart';
import 'package:conference_system/data/DTOs/course_filter.dart';

class CoursesRepository {
  Future<List<Course>> getCoursesList({
    required int uid,
    required String category,
    CourseFilterDTO? filter,
  }) async {
    try {
      final queryParams = {
        'uid': uid.toString(),
        'category': category,
      };

      if (filter != null) {
        final filterMap = filter.toJson();
        queryParams.addAll(filterMap.map((key, value) => MapEntry(key, value.toString())));
      }

      final uri = GetUri.getCoursesList.replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => Course.fromJson(e)).toList();
      } else {
        throw Exception('خطا در دریافت لیست دوره‌ها');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Course> getSingleCourse(int cid) async {
    final url = GetUri.getSingleCourse(cid);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Course.fromJson(data);
    }

    throw Exception('خطا در دریافت اطلاعات دوره (کد: ${response.statusCode})');
  }
}




