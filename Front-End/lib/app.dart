import 'package:conference_system/bloc/auth/auth_state.dart';
import 'package:conference_system/bloc/comments/bloc/comment_bloc.dart';
import 'package:conference_system/bloc/courses/courses_bloc.dart';
import 'package:conference_system/bloc/enrollments/enrollments_bloc.dart';
import 'package:conference_system/bloc/hall/hall_bloc.dart';
import 'package:conference_system/bloc/reservations/reservation_bloc.dart';
import 'package:conference_system/bloc/users/users_bloc.dart';
import 'package:conference_system/data/repositories/comment_repository.dart';
import 'package:conference_system/data/repositories/enrollments_repository.dart';
import 'package:conference_system/data/repositories/user_repository.dart';
import 'package:conference_system/features/course_panel/panels/enrollment_list.dart';
import 'package:conference_system/services/courses_service.dart';
import 'package:conference_system/services/hall_service.dart';
import 'package:conference_system/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/features/auth/auth_screen.dart';
import 'package:conference_system/main_wrapper.dart';
import 'package:conference_system/bloc/auth/auth_bloc.dart';
import 'package:conference_system/data/repositories/auth_repository.dart';
import 'auth_gate.dart';
import 'package:conference_system/data/repositories/reservations_repository.dart';
import 'package:conference_system/providers/auth_provider.dart';
import 'package:conference_system/bloc/users/users_event.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
        ),
        BlocProvider(
            create: (context) => HallBloc(hallService: HallService())
        ),
        BlocProvider(
            create: (context) => UsersBloc(
                service:  UsersService(repository: UsersRepository()))
        ),
        BlocProvider(
            create: (context) => CourseBloc(courseService: CourseService())
        ),
        BlocProvider(
            create: (context) => ReservationBloc(repository: ReservationRepository())),
        BlocProvider(
            create: (context) => CommentBloc(repository: CommentRepository())),
        BlocProvider(
            create: (context) => EnrollmentsBloc(repository: EnrollmentsRepository()))
      ],
      child: BlocListener<AuthBloc,AuthState>(
        listener: (context, state){
          if(state is AuthSuccess){
            AuthProvider().setToken(state.authResponse.token!);
            context.read<UsersBloc>().add(
                GetCurrentUser(state.authResponse.userId ?? 1)
            );
          } else if(state is AuthUnauthenticated || state is AuthFailure){
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/auth',
                  (_) => false,
            );
            AuthProvider().clearToken();
          }
        },
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Farsi'),
          home: const AuthGate(),
          routes: {
            '/auth': (_) => const AuthScreen(),
            '/profile': (_) => const MainWrapper(page: PageType.controlPanel),
            '/home': (_) => const MainWrapper(page: PageType.home),
            '/halls': (_) => const MainWrapper(page: PageType.halls),
            '/courses': (_) => const MainWrapper(page: PageType.courses),
            '/aboutUs': (_) => const MainWrapper(page: PageType.aboutUs),
          },
        ),
      ),
    );
  }
}

