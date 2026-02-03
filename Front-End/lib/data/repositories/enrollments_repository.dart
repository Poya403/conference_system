import 'package:conference_system/config/api_config.dart';
import 'package:http/http.dart' as http;


class EnrollmentsRepository {
  EnrollmentsRepository();

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
}
