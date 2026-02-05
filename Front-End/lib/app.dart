import 'package:conference_system/bloc/courses/courses_bloc.dart';
import 'package:conference_system/bloc/hall/hall_bloc.dart';
import 'package:conference_system/bloc/reservations/reservation_bloc.dart';
import 'package:conference_system/bloc/users/users_bloc.dart';
import 'package:conference_system/data/repositories/user_repository.dart';
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
      ],
      child: MaterialApp(
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
    );
  }
}

