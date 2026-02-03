import 'package:conference_system/data/repositories/enrollments_repository.dart';

class EnrollmentsService {
  final EnrollmentsRepository repository;

  EnrollmentsService({required this.repository});

  Future<void> addEnrollmentToBasket(int uid, int cid) async {
    await repository.addToBasket(uid, cid);
  }

  Future<void> removeEnrollmentFromBasket(int uid, int cid) async {
    await repository.removeFromBasket(uid, cid);
  }
}
