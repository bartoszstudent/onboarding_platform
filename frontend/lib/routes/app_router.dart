import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_frontend/presentation/screens/companies/companies_list_screen.dart';
import '../presentation/screens/login/login_screen_new.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/layouts/main_layout.dart';
import '../presentation/screens/courses/courses_list_screen.dart';
import '../presentation/screens/users/users_list_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/branding_settings/branding_settings_screen.dart';

import '../data/services/auth_service.dart';
import '../data/services/auth_state.dart';

class AppRouter {
  static final router = GoRouter(
    refreshListenable: AuthState.instance,
    redirect: (context, state) async {
      final loggedIn = await AuthService.isLoggedIn();
      final role = await AuthService.getRole();

      final goingToLogin = state.uri.toString() == '/';

      if (!loggedIn && !goingToLogin) {
        return '/';
      }

      if (loggedIn && goingToLogin) {
        return '/dashboard';
      }

      if (role == 'admin') {
        return null;
      }

      if (role == 'user') {
        if (state.uri.toString() == '/users' || state.uri.toString() == '/companies') {
          return '/dashboard';
        }
      }

      return null;
    },

    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreenNew(),
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
            path: '/branding_settings',
            builder: (context, state) => const BrandingSettingsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const OnboardingSettingsScreen(),
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
