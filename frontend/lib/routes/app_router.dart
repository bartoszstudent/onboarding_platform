import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_frontend/presentation/screens/companies/companies_list_screen.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/layouts/main_layout.dart';
import '../presentation/screens/courses/courses_list_screen.dart';
import '../presentation/screens/users/users_list_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/courses',
            builder: (context, state) =>
                const CoursesListScreen(role: 'employee'),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UsersListScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const Scaffold(
                body: Center(child: Text('Ustawienia - placeholder'))),
          ),
          GoRoute(
            path: '/companies',
            builder: (context, state) => const CompanyManagementScreen(),
                //body: Center(child: Text('Zarządzanie firmami - placeholder'))),
          ),
        ],
      ),
    ],
  );
}
