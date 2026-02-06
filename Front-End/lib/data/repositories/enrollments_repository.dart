import 'package:conference_system/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:conference_system/data/DTOs/enrollment_dto.dart';
import 'dart:convert';

class EnrollmentsRepository {
  EnrollmentsRepository();

  Future<List<EnrollmentDto>> getEnrollmentsByCourse(int cid) async {
    final response = await http.get(GetUri.getEnrollments(cid));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => EnrollmentDto.fromJson(e)).toList();
    } else {
      throw Exception('خطا در دریافت لیست ثبت‌نام‌ها');
    }
  }

  Future<void> addToBasket(int uid, int cid) async {
    final res = await http.post(GetUri.addToBasket(uid, cid));

    if (res.statusCode != 200) {
      throw Exception('خطا در درخواست افزودن دوره از سبد خرید');
    }
  }

  Future<void> removeFromBasket(int uid, int cid) async {
    final res = await http.delete(GetUri.removeFromBasket(uid, cid));

    if (res.statusCode != 200) {
      throw Exception('خطا در درخواست حذف دوره از سبد خرید');
    }
  }

  Future<bool> finalizeSingleEnrollment({
    required int uid,
    required int cid,
  }) async {
    final response = await http.post(GetUri.finalizeEnrollment(cid, uid),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': uid,
        'courseId': cid,
      }),
    );

    final data = jsonDecode(response.body);
    return response.statusCode == 200 && data['success'] == true;
  }

}
