import 'package:conference_system/enums/target_type.dart';

class GetUri {
  static const String baseUrl = 'http://localhost:5067';

  //users
  static Uri get users => Uri.parse('$baseUrl/api/Users');
  static Uri getSingleUser(int id) { return Uri.parse('$baseUrl/api/Users/$id'); }

  //courses
  static Uri get courses => Uri.parse('$baseUrl/api/courses');
  static Uri get getCoursesList => Uri.parse('$baseUrl/api/courses/list');

  //halls
  static Uri get halls => Uri.parse('$baseUrl/api/hall');
  static Uri singleHall(int hid) => Uri.parse('$baseUrl/api/hall/$hid');
  // enrollments
  static Uri getPaymentStatus(int uid, int cid) {
    return Uri.parse('$baseUrl/api/Enrollment/payment-status/$uid/$cid');
  }
  static Uri getBasketCourses(int uid) {
    return Uri.parse('$baseUrl/api/enrollment/basket-courses/$uid');
  }
  static Uri addToBasket(int uid, int cid){
    return Uri.parse('$baseUrl/api/enrollment/add-to-basket?uid=$uid&cid=$cid');
  }
  static Uri removeFromBasket(int uid, int cid){
    return Uri.parse('$baseUrl/api/enrollment/remove-from-basket?uid=$uid&cid=$cid');
  }

  // reservations
  static Uri get reservations => Uri.parse('$baseUrl/api/reservation');
  static Uri reservationOfHalls(int hid) => Uri.parse('$baseUrl/api/Reservation/api/v1/halls/$hid/reservations');
  
  //comments
  static Uri getComments(int targetId, CommentTargetType type) =>
      Uri.parse('$baseUrl/api/comments/?targetType=${type.name}&targetId=$targetId');
  static Uri get postComment => Uri.parse('$baseUrl/api/comments');
  static Uri deleteOrUpdateComment(int id) => Uri.parse('$baseUrl/api/comments/$id');
  // auth
  static Uri get login => Uri.parse('$baseUrl/api/login');
  static Uri get register => Uri.parse('$baseUrl/api/register');
}
