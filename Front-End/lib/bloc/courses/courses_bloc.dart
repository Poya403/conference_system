import 'package:conference_system/data/repositories/enrollments_repository.dart';
import 'package:conference_system/enums/course_category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'courses_event.dart';
import 'courses_state.dart';
import 'package:conference_system/services/courses_service.dart';

class CourseBloc extends Bloc<CoursesEvent, CoursesState> {
  final CourseService _courseService;

  CourseBloc({required CourseService courseService})
      : _courseService = courseService,
        super(CourseInitial()) {
    on<GetSingleCourse>(_onGetSingleCourse);
    on<GetCoursesList>(_onGetCoursesList);
    on<ToggleBasket>(_onToggleBasket);
    on<SearchCourses>(_onSearchCourses);
  }

  Future<void> _onGetCoursesList(
      GetCoursesList event,
      Emitter<CoursesState> emit,
      ) async {
    emit(CourseLoading());

    try {
      final courses = await _courseService.getCoursesList(
        uid: event.uid,
        category: event.category.apiValue
      );

      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CoursesError(
        e is Exception ? e.toString() : 'خطای ناشناخته در دریافت لیست دوره‌ها',
      ));
    }
  }

  Future<void> _onGetSingleCourse(GetSingleCourse event,
      Emitter<CoursesState> emit) async {
    emit(CourseLoading());

    try {
      final course = await _courseService.getSingleCourse(event.cid);

      emit(SingleCourseLoaded(course));
    } catch (e) {
      emit(CoursesError(
        e is Exception ? e.toString() : 'خطای ناشناخته در دریافت اطلاعات دوره‌',
      ));
    }
  }

  Future<void> _onToggleBasket(
      ToggleBasket event, Emitter<CoursesState> emit) async {
    final currentState = state;
    if (currentState is! CoursesLoaded) return;

    try {
      final repo = EnrollmentsRepository();
      final targetCourse = currentState.courses.firstWhere((c) => c.id == event.cid);

      final isInBasket = targetCourse.isInBasket;

      if (isInBasket) {
        await repo.removeFromBasket(event.uid, event.cid);
      } else {
        await repo.addToBasket(event.uid, event.cid);
      }

      final updatedCourses = await _courseService.getCoursesList(
          uid: event.uid,
          category: event.category.apiValue
      );

      emit(CoursesActionSuccess(
        isInBasket
            ? "با موفقیت از سبد خرید حذف شد."
            : "با موفقیت به سبد خرید اضافه شد.",
      ));

      emit(CoursesLoaded(updatedCourses));


    } catch (e) {
      emit(CoursesError("خطا در عملیات سبد خرید: ${e.toString()}"));
    }
  }

  Future<void> _onSearchCourses(SearchCourses event, Emitter<CoursesState> emit) async {
    emit(CourseLoading());
    try {
      final courses = await _courseService.getCoursesList(
        uid: event.uid,
        category: event.category.apiValue,
        filter: event.filterDTO,
      );

      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CoursesError("خطا در جستجو دوره‌ها"));
    }
  }
}
