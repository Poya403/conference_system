import 'package:conference_system/enums/target_type.dart';

class GetUri {
  static const String baseUrl = 'http://localhost:5067';

  //users
  static Uri get users => Uri.parse('$baseUrl/api/v1/Users');
  static Uri getSingleUser(int id) { return Uri.parse('$baseUrl/api/v1/Users/$id'); }

  //courses
  static Uri get courses => Uri.parse('$baseUrl/api/v1/courses');
  static Uri get getCoursesList => Uri.parse('$baseUrl/api/v1/courses/list');
  static Uri getSingleCourse(int cid) => Uri.parse('$baseUrl/api/v1/courses/$cid');
  //halls
  static Uri get halls => Uri.parse('$baseUrl/api/v1/hall');
  static Uri singleHall(int hid) => Uri.parse('$baseUrl/api/v1/hall/$hid');
  // enrollments
  static Uri getPaymentStatus(int uid, int cid) {
    return Uri.parse('$baseUrl/api/v1/Enrollment/payment-status/$uid/$cid');
  }
  static Uri getBasketCourses(int uid) {
    return Uri.parse('$baseUrl/api/v1/enrollment/basket-courses/$uid');
  }
  static Uri addToBasket(int uid, int cid){
    return Uri.parse('$baseUrl/api/v1/enrollment/add-to-basket?uid=$uid&cid=$cid');
  }
  static Uri removeFromBasket(int uid, int cid){
    return Uri.parse('$baseUrl/api/v1/enrollment/remove-from-basket?uid=$uid&cid=$cid');
  }

  // reservations
  static Uri get reservations => Uri.parse('$baseUrl/api/v1/reservation');
  static Uri reservationOfHalls(int hid) => Uri.parse('$baseUrl/api/v1/Reservation/api/v1/halls/$hid/reservations');
  
  // enrollments
  static Uri getEnrollments(int cid) => Uri.parse('$baseUrl/api/v1/Enrollment/$cid');
  static Uri finalizeEnrollment(int cid,int uid) => Uri.parse('$baseUrl/api/v1/enrollment/finalize');
  //comments
  static Uri getComments(int targetId, CommentTargetType type) =>
      Uri.parse('$baseUrl/api/v1/comments/?targetType=${type.name}&targetId=$targetId');
  static Uri get postComment => Uri.parse('$baseUrl/api/v1/comments');
  static Uri deleteOrUpdateComment(int id) => Uri.parse('$baseUrl/api/v1/comments/$id');
  // auth
  static Uri get login => Uri.parse('$baseUrl/api/v1/login');
  static Uri get register => Uri.parse('$baseUrl/api/v1/register');
}
